<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class OpponentSeeder extends Seeder
{
    public function run(): void
    {
        $opponents = [
            [
                'id' => 1,
                'team_name' => 'Real Madrid',
                'logo_url' => 'real_madrid.png',
                'attacking_strength' => 92,
                'defensive_strength' => 86,
                'pressing_vulnerability' => 42,
                'counter_attack_threat' => 94,
                'key_player_name' => 'Kylian Mbappé',
                'key_player_pace' => 95,
                'scouting_notes' => 'Sangat mematikan dalam transisi balik langsung melalui kecepatan eksplosif Kylian Mbappé dan Vinícius Jr. Garis pertahanan tinggi Barcelona harus didukung pressing ekstrem atau ditarik sedikit lebih dalam untuk mencegah jebolnya perangkap offside.'
            ],
            [
                'id' => 2,
                'team_name' => 'Bayern München',
                'logo_url' => 'bayern.png',
                'attacking_strength' => 91,
                'defensive_strength' => 84,
                'pressing_vulnerability' => 48,
                'counter_attack_threat' => 83,
                'key_player_name' => 'Harry Kane',
                'key_player_pace' => 78,
                'scouting_notes' => 'Bermain dengan pressing intens dan lini serang sangat tajam. Harry Kane kerap mundur sebagai playmaker semu (false nine). Membutuhkan duel lini tengah yang dominan dan pemanfaatan ruang sayap via Lamine Yamal dan Raphinha.'
            ],
            [
                'id' => 3,
                'team_name' => 'Atlético Madrid',
                'logo_url' => 'atletico.png',
                'attacking_strength' => 83,
                'defensive_strength' => 89,
                'pressing_vulnerability' => 52,
                'counter_attack_threat' => 80,
                'key_player_name' => 'Antoine Griezmann',
                'key_player_pace' => 80,
                'scouting_notes' => 'Blok pertahanan rapat dan agresifitas duel fisik tinggi. Griezmann menjadi otak transisi serang. Butuh sirkulasi bola sabar dan rotasi half-space untuk memancing bek mereka keluar dari formasi.'
            ],
            [
                'id' => 4,
                'team_name' => 'Getafe CF',
                'logo_url' => 'getafe.png',
                'attacking_strength' => 64,
                'defensive_strength' => 85,
                'pressing_vulnerability' => 68,
                'counter_attack_threat' => 48,
                'key_player_name' => 'Borja Mayoral',
                'key_player_pace' => 72,
                'scouting_notes' => 'Khas low block ultra defensif dengan 5 bek dan 4 gelandang. Menyerahkan penguasaan bola total. Barcelona harus mempercepat tempo sirkulasi dan memaksimalkan pergerakan tanpa bola untuk memecah kebuntuan.'
            ],
            [
                'id' => 5,
                'team_name' => 'Borussia Dortmund',
                'logo_url' => 'dortmund.png',
                'attacking_strength' => 85,
                'defensive_strength' => 80,
                'pressing_vulnerability' => 62,
                'counter_attack_threat' => 84,
                'key_player_name' => 'Karim Adeyemi',
                'key_player_pace' => 96,
                'scouting_notes' => 'Transisi vertikal cepat dengan penyerang sayap berkecepatan tinggi. Rentan terhadap pressing tinggi Barcelona di sepertiga pertahanan mereka sendiri.'
            ],
            [
                'id' => 6,
                'team_name' => 'AS Monaco',
                'logo_url' => 'monaco.png',
                'attacking_strength' => 81,
                'defensive_strength' => 79,
                'pressing_vulnerability' => 58,
                'counter_attack_threat' => 82,
                'key_player_name' => 'Breel Embolo',
                'key_player_pace' => 82,
                'scouting_notes' => 'Struktur fisik kuat dan pressing agresif di lini tengah. Butuh operan satu-dua sentuhan cepat untuk lolos dari kepungan mereka.'
            ]
        ];

        foreach ($opponents as $opp) {
            DB::table('opponents')->updateOrInsert(
                ['id' => $opp['id']],
                array_merge($opp, [
                    'created_at' => now(),
                    'updated_at' => now()
                ])
            );
        }
    }
}
