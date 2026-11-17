<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MatchGame extends Model
{
    use HasFactory;

    protected $table = 'matches';

    protected $fillable = [
        'opponent_id',
        'match_date',
        'venue',
        'competition',
        'context_description',
        'status',
    ];

    protected $casts = [
        'match_date' => 'datetime',
    ];

    public function opponent()
    {
        return $this->belongsTo(Opponent::class, 'opponent_id');
    }

    public function simulations()
    {
        return $this->hasMany(Simulation::class, 'match_id');
    }
}
