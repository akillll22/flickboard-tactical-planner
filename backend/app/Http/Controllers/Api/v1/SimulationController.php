<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
use App\Models\Simulation;
use App\Services\DataBrokerService;
use Illuminate\Http\Request;

class SimulationController extends Controller
{
    protected DataBrokerService $dataBroker;

    public function __construct(DataBrokerService $dataBroker)
    {
        $this->dataBroker = $dataBroker;
    }

    public function run(Request $request)
    {
        $validated = $request->validate([
            'match_id' => 'required|exists:matches,id',
            'formation_used' => 'required|string',
            'starting_xi' => 'required|array|size:11',
            'starting_xi.*' => 'integer|exists:barca_players,id',
            'tactical_parameters' => 'required|array',
            'tactical_parameters.ppda_intensity' => 'required|numeric|between:2.0,15.0',
            'tactical_parameters.defensive_line_height' => 'required|numeric|between:1.0,10.0',
            'tactical_parameters.build_up_tempo' => 'required|numeric|between:1.0,10.0',
        ]);

        $userId = $request->user() ? $request->user()->id : 1;

        $result = $this->dataBroker->executeSimulation(
            $userId,
            $validated['match_id'],
            $validated['formation_used'],
            $validated['starting_xi'],
            $validated['tactical_parameters']
        );

        return response()->json($result);
    }

    public function history(Request $request)
    {
        $userId = $request->user() ? $request->user()->id : 1;

        $simulations = Simulation::with('match.opponent')
            ->where('user_id', $userId)
            ->latest()
            ->paginate(15);

        return response()->json([
            'status' => 'success',
            'data' => $simulations,
        ]);
    }

    public function show($id)
    {
        $simulation = Simulation::with('match.opponent')->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $simulation,
        ]);
    }

    public function destroy($id)
    {
        $simulation = Simulation::findOrFail($id);
        $simulation->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Riwayat simulasi berhasil dihapus.',
        ]);
    }
}
