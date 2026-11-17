<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
use App\Models\Opponent;
use Illuminate\Http\Request;

class OpponentController extends Controller
{
    public function index()
    {
        $opponents = Opponent::all();

        return response()->json([
            'status' => 'success',
            'data' => $opponents,
        ]);
    }

    public function show($id)
    {
        $opponent = Opponent::findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => [
                'opponent' => $opponent,
                'radar_metrics' => [
                    'attacking' => $opponent->attacking_strength,
                    'defending' => $opponent->defensive_strength,
                    'counter_threat' => $opponent->counter_attack_threat,
                    'pressing_vulnerability' => $opponent->pressing_vulnerability,
                    'pace_threat' => $opponent->key_player_pace,
                ]
            ],
        ]);
    }
}
