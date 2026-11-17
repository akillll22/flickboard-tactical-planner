<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BarcaPlayer extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'shirt_number',
        'position',
        'overall_rating',
        'pace',
        'passing',
        'defending',
        'photo_url',
        'is_active',
    ];

    protected $casts = [
        'shirt_number' => 'integer',
        'overall_rating' => 'integer',
        'pace' => 'integer',
        'passing' => 'integer',
        'defending' => 'integer',
        'is_active' => 'boolean',
    ];
}
