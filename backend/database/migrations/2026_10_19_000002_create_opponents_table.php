<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('opponents', function (Blueprint $table) {
            $table->id();
            $table->string('team_name', 150);
            $table->string('logo_url')->nullable();
            $table->unsignedTinyInteger('attacking_strength'); // 1 - 100
            $table->unsignedTinyInteger('defensive_strength'); // 1 - 100
            $table->unsignedTinyInteger('pressing_vulnerability'); // 1 - 100
            $table->unsignedTinyInteger('counter_attack_threat'); // 1 - 100
            $table->string('key_player_name', 150);
            $table->unsignedTinyInteger('key_player_pace'); // 1 - 100
            $table->text('scouting_notes')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('opponents');
    }
};
