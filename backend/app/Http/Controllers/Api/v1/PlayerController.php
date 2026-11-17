<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
use App\Models\BarcaPlayer;
use Illuminate\Http\Request;

class PlayerController extends Controller
{
    public function index(Request $request)
    {
        $query = BarcaPlayer::where('is_active', true);

        if ($request->has('position')) {
            $query->where('position', $request->query('position'));
        }

        $players = $query->orderBy('shirt_number', 'asc')->get();

        return response()->json([
            'status' => 'success',
            'data' => $players,
        ]);
    }

    public function show($id)
    {
        $player = BarcaPlayer::findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $player,
        ]);
    }
}
