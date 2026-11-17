<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\v1\AuthController;
use App\Http\Controllers\Api\v1\MatchController;
use App\Http\Controllers\Api\v1\OpponentController;
use App\Http\Controllers\Api\v1\PlayerController;
use App\Http\Controllers\Api\v1\SimulationController;

Route::prefix('v1')->group(function () {
    // 1. Auth Endpoints
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);

    // 2. Public / Master Data Endpoints
    Route::get('/matches/upcoming', [MatchController::class, 'upcoming']);
    Route::get('/matches/{id}', [MatchController::class, 'show']);
    Route::get('/opponents', [OpponentController::class, 'index']);
    Route::get('/opponents/{id}', [OpponentController::class, 'show']);
    Route::get('/players/barca', [PlayerController::class, 'index']);
    Route::get('/players/barca/{id}', [PlayerController::class, 'show']);

    // 3. Tactical Simulation (Bisa diakses dengan auth Sanctum maupun publik/demo mode)
    Route::post('/simulations/run', [SimulationController::class, 'run']);
    Route::get('/simulations/history', [SimulationController::class, 'history']);
    Route::get('/simulations/{id}', [SimulationController::class, 'show']);
    Route::delete('/simulations/{id}', [SimulationController::class, 'destroy']);

    // 4. Protected Routes
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/auth/me', [AuthController::class, 'me']);
        Route::post('/auth/logout', [AuthController::class, 'logout']);
    });
});
