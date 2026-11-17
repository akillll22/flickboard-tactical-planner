<?php

namespace App\Http\Controllers\Api\v1;

use App\Http\Controllers\Controller;
use App\Models\MatchGame;
use Illuminate\Http\Request;

class MatchController extends Controller
{
    public function upcoming()
    {
        $matches = MatchGame::with('opponent')
            ->where('status', 'UPCOMING')
            ->orderBy('match_date', 'asc')
            ->get();

        return response()->json([
            'status' => 'success',
            'data' => $matches,
        ]);
    }

    public function show($id)
    {
        $match = MatchGame::with('opponent')->findOrFail($id);

        return response()->json([
            'status' => 'success',
            'data' => $match,
        ]);
    }
}
