<?php

namespace App\Services;

class HeuristicFallbackService
{
    /**
     * Fallback Engine lokal berbasis aturan jika layanan Python FastAPI mengalami timeout/gangguan.
     */
    public function generateFallbackResult(array $tactics, array $opponent, array $teamAggregates, int $matchId): array
    {
        $ppda = (float)$tactics['ppda_intensity'];
        $line = (float)$tactics['defensive_line_height'];
        $tempo = (float)$tactics['build_up_tempo'];
        $oppPace = (int)($opponent['key_player_pace'] ?? 80);
        $oppThreat = (int)($opponent['counter_attack_threat'] ?? 70);

        $win = 0.58;
        $draw = 0.22;
        $loss = 0.20;

        $feedback = [];

        // Evaluasi High Line vs Pace
        if ($line >= 8.5 && $oppPace >= 85) {
            if ($ppda > 8.0) {
                $loss += 0.25;
                $win -= 0.20;
                $feedback[] = [
                    'type' => 'WARNING',
                    'rule_id' => 'FALLBACK_RULE_01',
                    'text' => 'Garis pertahanan sangat tinggi tanpa pressing agresif memberi peluang bagi pemain sayap cepat lawan.'
                ];
            } else {
                $win += 0.08;
                $feedback[] = [
                    'type' => 'RECOMMENDATION',
                    'rule_id' => 'FALLBACK_RULE_02',
                    'text' => 'Pressing ketat berhasil membatasi operan ke pemain kunci lawan.'
                ];
            }
        } else {
            $win += 0.10;
            $loss -= 0.08;
            $feedback[] = [
                'type' => 'STRENGTH',
                'rule_id' => 'FALLBACK_RULE_03',
                'text' => 'Struktur pertahanan dan intensitas pressing seimbang.'
            ];
        }

        $sum = $win + $draw + $loss;
        $win = round($win / $sum, 2);
        $draw = round($draw / $sum, 2);
        $loss = round(1.0 - ($win + $draw), 2);

        $grade = $win >= 0.65 ? 'A' : ($win >= 0.50 ? 'B+' : 'B');

        return [
            'status' => 'success (fallback_mode)',
            'match_id' => $matchId,
            'probabilities' => [
                'win' => $win,
                'draw' => $draw,
                'loss' => $loss
            ],
            'tactical_grade' => $grade,
            'projected_stats' => [
                'possession_pct' => round(58.0 + (10.0 - $ppda) * 0.8, 1),
                'expected_goals_barca' => round(1.8 + ($tempo - 5.0) * 0.1, 2),
                'expected_goals_opponent' => round(0.9 + ($line >= 8.5 ? 0.4 : 0.0), 2),
                'offside_traps_projected' => round(2.0 + ($line / 10.0) * 4.0, 1),
            ],
            'assistant_feedback' => $feedback,
            'simulation_id' => null
        ];
    }
}
