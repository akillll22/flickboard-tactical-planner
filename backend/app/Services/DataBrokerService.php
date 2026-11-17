<?php

namespace App\Services;

use App\Models\BarcaPlayer;
use App\Models\MatchGame;
use App\Models\Simulation;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class DataBrokerService
{
    protected HeuristicFallbackService $fallbackService;

    public function __construct(HeuristicFallbackService $fallbackService)
    {
        $this->fallbackService = $fallbackService;
    }

    /**
     * Menjalankan orkestrasi simulasi taktis.
     */
    public function executeSimulation(int $userId, int $matchId, string $formation, array $startingXiIds, array $tactics): array
    {
        // 1. Cek Caching: Apakah konfigurasi identik pernah disimulasikan sebelumnya?
        sort($startingXiIds);
        $cachedSimulation = Simulation::where('match_id', $matchId)
            ->where('formation_used', $formation)
            ->where('ppda_intensity', $tactics['ppda_intensity'])
            ->where('defensive_line_height', $tactics['defensive_line_height'])
            ->where('tempo_value', $tactics['build_up_tempo'])
            ->whereJsonContains('starting_xi_json', $startingXiIds)
            ->latest()
            ->first();

        if ($cachedSimulation) {
            $cachedResult = $cachedSimulation->simulation_result_json;
            $cachedResult['simulation_id'] = $cachedSimulation->id;
            $cachedResult['from_cache'] = true;
            return $cachedResult;
        }

        // 2. Ambil data Match & Opponent
        $match = MatchGame::with('opponent')->findOrFail($matchId);
        $opponent = $match->opponent;

        // 3. Ambil data Starting XI dan hitung agregat
        $players = BarcaPlayer::whereIn('id', $startingXiIds)->get();
        if ($players->count() !== 11) {
            throw new \InvalidArgumentException('Starting XI harus terdiri dari tepat 11 pemain aktif.');
        }

        $teamAvgPace = round($players->avg('pace'), 1);
        $teamAvgPassing = round($players->avg('passing'), 1);
        $teamAvgDefending = round($players->avg('defending'), 1);

        $defenders = $players->filter(fn($p) => in_array($p->position, ['CB', 'LB', 'RB']));
        $defenseAvgPace = $defenders->isNotEmpty() ? round($defenders->avg('pace'), 1) : 75.0;

        $midfielders = $players->filter(fn($p) => in_array($p->position, ['DM', 'CM']));
        $pivotPower = $midfielders->isNotEmpty() ? round($midfielders->avg('defending'), 1) : 75.0;

        $aiPayload = [
            'user_id' => $userId,
            'match_id' => $matchId,
            'opponent_id' => $opponent->id,
            'formation_used' => $formation,
            'starting_xi' => $startingXiIds,
            'tactical_parameters' => [
                'ppda_intensity' => (float)$tactics['ppda_intensity'],
                'defensive_line_height' => (float)$tactics['defensive_line_height'],
                'build_up_tempo' => (float)$tactics['build_up_tempo'],
            ],
            'opponent' => [
                'id' => $opponent->id,
                'team_name' => $opponent->team_name,
                'attacking_strength' => $opponent->attacking_strength,
                'defensive_strength' => $opponent->defensive_strength,
                'pressing_vulnerability' => $opponent->pressing_vulnerability,
                'counter_attack_threat' => $opponent->counter_attack_threat,
                'key_player_name' => $opponent->key_player_name,
                'key_player_pace' => $opponent->key_player_pace,
            ],
            'team_aggregates' => [
                'team_avg_pace' => $teamAvgPace,
                'team_avg_passing' => $teamAvgPassing,
                'team_avg_defending' => $teamAvgDefending,
                'defense_avg_pace' => $defenseAvgPace,
                'pivot_defensive_power' => $pivotPower,
            ]
        ];

        // 4. Panggil Python FastAPI Microservice
        $fastApiUrl = env('FASTAPI_AI_URL', 'http://127.0.0.1:8080') . '/api/v1/predict';
        $result = null;

        try {
            $response = Http::timeout(2.5)->post($fastApiUrl, $aiPayload);
            if ($response->successful()) {
                $result = $response->json();
            } else {
                Log::warning('FastAPI returned non-200 status: ' . $response->status());
            }
        } catch (\Exception $e) {
            Log::error('FastAPI connection failed, activating fallback: ' . $e->getMessage());
        }

        // 5. Jika AI service tidak merespons, gunakan Heuristic Fallback
        if (!$result) {
            $result = $this->fallbackService->generateFallbackResult(
                $tactics,
                $opponent->toArray(),
                $aiPayload['team_aggregates'],
                $matchId
            );
        }

        // 6. Simpan hasil ke tabel `simulations` sebagai riwayat & cache
        $simulation = Simulation::create([
            'user_id' => $userId,
            'match_id' => $matchId,
            'formation_used' => $formation,
            'starting_xi_json' => $startingXiIds,
            'ppda_intensity' => $tactics['ppda_intensity'],
            'defensive_line_height' => $tactics['defensive_line_height'],
            'tempo_value' => $tactics['build_up_tempo'],
            'win_probability' => $result['probabilities']['win'],
            'draw_probability' => $result['probabilities']['draw'],
            'loss_probability' => $result['probabilities']['loss'],
            'tactical_grade' => $result['tactical_grade'],
            'simulation_result_json' => $result,
        ]);

        $result['simulation_id'] = $simulation->id;
        $result['from_cache'] = false;

        return $result;
    }
}
