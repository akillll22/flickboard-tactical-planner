<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Buat User Analis Default
        DB::table('users')->updateOrInsert(
            ['email' => 'analyst@fcbarcelona.cat'],
            [
                'name' => 'Hansi Flick Tactical Analyst',
                'password' => Hash::make('visca_barca_2026'),
                'role' => 'tactical_analyst',
                'created_at' => now(),
                'updated_at' => now()
            ]
        );

        // 2. Jalankan Seeder Pemain, Lawan, dan Laga
        $this->call([
            BarcaPlayerSeeder::class,
            OpponentSeeder::class,
            MatchSeeder::class,
        ]);
    }
}
