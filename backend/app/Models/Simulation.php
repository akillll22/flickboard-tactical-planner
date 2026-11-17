<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Simulation extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'match_id',
        'formation_used',
        'starting_xi_json',
        'ppda_intensity',
        'defensive_line_height',
        'tempo_value',
        'win_probability',
        'draw_probability',
        'loss_probability',
        'tactical_grade',
        'simulation_result_json',
    ];

    protected $casts = [
        'starting_xi_json' => 'array',
        'simulation_result_json' => 'array',
        'ppda_intensity' => 'float',
        'defensive_line_height' => 'float',
        'tempo_value' => 'float',
        'win_probability' => 'float',
        'draw_probability' => 'float',
        'loss_probability' => 'float',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function match()
    {
        return $this->belongsTo(MatchGame::class, 'match_id');
    }
}
