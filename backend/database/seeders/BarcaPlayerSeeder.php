<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class BarcaPlayerSeeder extends Seeder
{
    public function run(): void
    {
        $players = [
            // Goalkeepers
            ['name' => 'Marc-André ter Stegen', 'shirt_number' => 1, 'position' => 'GK', 'overall_rating' => 89, 'pace' => 50, 'passing' => 88, 'defending' => 89, 'photo_url' => 'ter_stegen.png'],
            ['name' => 'Iñaki Peña', 'shirt_number' => 13, 'position' => 'GK', 'overall_rating' => 78, 'pace' => 52, 'passing' => 77, 'defending' => 78, 'photo_url' => 'inaki_pena.png'],
            ['name' => 'Wojciech Szczęsny', 'shirt_number' => 25, 'position' => 'GK', 'overall_rating' => 84, 'pace' => 48, 'passing' => 76, 'defending' => 85, 'photo_url' => 'szczesny.png'],

            // Defenders (CB, LB, RB)
            ['name' => 'Pau Cubarsí', 'shirt_number' => 2, 'position' => 'CB', 'overall_rating' => 83, 'pace' => 74, 'passing' => 86, 'defending' => 84, 'photo_url' => 'cubarsi.png'],
            ['name' => 'Alejandro Balde', 'shirt_number' => 3, 'position' => 'LB', 'overall_rating' => 83, 'pace' => 93, 'passing' => 78, 'defending' => 77, 'photo_url' => 'balde.png'],
            ['name' => 'Ronald Araújo', 'shirt_number' => 4, 'position' => 'CB', 'overall_rating' => 86, 'pace' => 81, 'passing' => 72, 'defending' => 87, 'photo_url' => 'araujo.png'],
            ['name' => 'Íñigo Martínez', 'shirt_number' => 5, 'position' => 'CB', 'overall_rating' => 84, 'pace' => 71, 'passing' => 81, 'defending' => 85, 'photo_url' => 'inigo_martinez.png'],
            ['name' => 'Andreas Christensen', 'shirt_number' => 15, 'position' => 'CB', 'overall_rating' => 82, 'pace' => 69, 'passing' => 80, 'defending' => 83, 'photo_url' => 'christensen.png'],
            ['name' => 'Jules Koundé', 'shirt_number' => 23, 'position' => 'RB', 'overall_rating' => 86, 'pace' => 84, 'passing' => 79, 'defending' => 86, 'photo_url' => 'kounde.png'],
            ['name' => 'Eric García', 'shirt_number' => 24, 'position' => 'CB', 'overall_rating' => 79, 'pace' => 70, 'passing' => 82, 'defending' => 79, 'photo_url' => 'eric_garcia.png'],
            ['name' => 'Gerard Martín', 'shirt_number' => 35, 'position' => 'LB', 'overall_rating' => 74, 'pace' => 79, 'passing' => 72, 'defending' => 74, 'photo_url' => 'gerard_martin.png'],
            ['name' => 'Sergi Domínguez', 'shirt_number' => 36, 'position' => 'CB', 'overall_rating' => 73, 'pace' => 72, 'passing' => 71, 'defending' => 74, 'photo_url' => 'sergi_dominguez.png'],

            // Midfielders (DM, CM, AM)
            ['name' => 'Gavi', 'shirt_number' => 6, 'position' => 'CM', 'overall_rating' => 84, 'pace' => 78, 'passing' => 83, 'defending' => 80, 'photo_url' => 'gavi.png'],
            ['name' => 'Pedri', 'shirt_number' => 8, 'position' => 'CM', 'overall_rating' => 88, 'pace' => 80, 'passing' => 90, 'defending' => 74, 'photo_url' => 'pedri.png'],
            ['name' => 'Pablo Torre', 'shirt_number' => 14, 'position' => 'AM', 'overall_rating' => 77, 'pace' => 75, 'passing' => 81, 'defending' => 60, 'photo_url' => 'pablo_torre.png'],
            ['name' => 'Fermín López', 'shirt_number' => 16, 'position' => 'AM', 'overall_rating' => 81, 'pace' => 82, 'passing' => 79, 'defending' => 70, 'photo_url' => 'fermin.png'],
            ['name' => 'Marc Casadó', 'shirt_number' => 17, 'position' => 'DM', 'overall_rating' => 82, 'pace' => 77, 'passing' => 84, 'defending' => 83, 'photo_url' => 'casado.png'],
            ['name' => 'Dani Olmo', 'shirt_number' => 20, 'position' => 'AM', 'overall_rating' => 86, 'pace' => 82, 'passing' => 87, 'defending' => 62, 'photo_url' => 'olmo.png'],
            ['name' => 'Frenkie de Jong', 'shirt_number' => 21, 'position' => 'CM', 'overall_rating' => 87, 'pace' => 82, 'passing' => 89, 'defending' => 79, 'photo_url' => 'frenkie.png'],
            ['name' => 'Marc Bernal', 'shirt_number' => 28, 'position' => 'DM', 'overall_rating' => 76, 'pace' => 73, 'passing' => 80, 'defending' => 77, 'photo_url' => 'bernal.png'],

            // Attackers (RW, LW, CF)
            ['name' => 'Ferran Torres', 'shirt_number' => 7, 'position' => 'LW', 'overall_rating' => 81, 'pace' => 83, 'passing' => 78, 'defending' => 45, 'photo_url' => 'ferran.png'],
            ['name' => 'Robert Lewandowski', 'shirt_number' => 9, 'position' => 'CF', 'overall_rating' => 89, 'pace' => 75, 'passing' => 80, 'defending' => 44, 'photo_url' => 'lewandowski.png'],
            ['name' => 'Ansu Fati', 'shirt_number' => 10, 'position' => 'LW', 'overall_rating' => 78, 'pace' => 84, 'passing' => 75, 'defending' => 38, 'photo_url' => 'ansu_fati.png'],
            ['name' => 'Raphinha', 'shirt_number' => 11, 'position' => 'LW', 'overall_rating' => 87, 'pace' => 91, 'passing' => 85, 'defending' => 58, 'photo_url' => 'raphinha.png'],
            ['name' => 'Pau Víctor', 'shirt_number' => 18, 'position' => 'CF', 'overall_rating' => 76, 'pace' => 81, 'passing' => 72, 'defending' => 40, 'photo_url' => 'pau_victor.png'],
            ['name' => 'Lamine Yamal', 'shirt_number' => 19, 'position' => 'RW', 'overall_rating' => 87, 'pace' => 90, 'passing' => 86, 'defending' => 48, 'photo_url' => 'lamine_yamal.png'],
        ];

        foreach ($players as $p) {
            DB::table('barca_players')->updateOrInsert(
                ['name' => $p['name']],
                array_merge($p, [
                    'is_active' => true,
                    'created_at' => now(),
                    'updated_at' => now()
                ])
            );
        }
    }
}
