<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MatchSeeder extends Seeder
{
    public function run(): void
    {
        $matches = [
            [
                'id' => 101,
                'opponent_id' => 1, // Real Madrid
                'match_date' => now()->addDays(5)->setTime(21, 0),
                'venue' => 'AWAY',
                'competition' => 'La Liga EA Sports (El Clásico)',
                'context_description' => 'Duel penentu puncak klasemen di Santiago Bernabéu. Menghadapi lini depan Madrid yang diisi Mbappé dan Vinícius Jr.',
                'status' => 'UPCOMING'
            ],
            [
                'id' => 102,
                'opponent_id' => 2, // Bayern München
                'match_date' => now()->addDays(12)->setTime(20, 0),
                'venue' => 'HOME',
                'competition' => 'UEFA Champions League',
                'context_description' => 'Laga akbar Liga Champions di Estadi Olímpic Lluís Companys. Reuni Hansi Flick menghadapi mantan klub asuhannya.',
                'status' => 'UPCOMING'
            ],
            [
                'id' => 103,
                'opponent_id' => 4, // Getafe CF
                'match_date' => now()->addDays(19)->setTime(16, 15),
                'venue' => 'HOME',
                'competition' => 'La Liga EA Sports',
                'context_description' => 'Ujian membongkar blok pertahanan rendah (low block) paling disiplin di La Liga.',
                'status' => 'UPCOMING'
            ]
        ];

        foreach ($matches as $m) {
            DB::table('matches')->updateOrInsert(
                ['id' => $m['id']],
                array_merge($m, [
                    'created_at' => now(),
                    'updated_at' => now()
                ])
            );
        }
    }
}
