<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Opponent extends Model
{
    use HasFactory;

    protected $fillable = [
        'team_name',
        'logo_url',
        'attacking_strength',
        'defensive_strength',
        'pressing_vulnerability',
        'counter_attack_threat',
        'key_player_name',
        'key_player_pace',
        'scouting_notes',
    ];

    protected $casts = [
        'attacking_strength' => 'integer',
        'defensive_strength' => 'integer',
        'pressing_vulnerability' => 'integer',
        'counter_attack_threat' => 'integer',
        'key_player_pace' => 'integer',
    ];

    public function matches()
    {
        return $this->hasMany(MatchGame::class, 'opponent_id');
    }
}
