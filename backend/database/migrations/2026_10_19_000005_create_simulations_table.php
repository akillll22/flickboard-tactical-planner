<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('simulations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('match_id')->constrained('matches')->onDelete('cascade');
            $table->string('formation_used', 20)->default('4-2-3-1');
            $table->json('starting_xi_json');
            $table->decimal('ppda_intensity', 4, 2);
            $table->decimal('defensive_line_height', 3, 1);
            $table->decimal('tempo_value', 3, 1)->default(5.0);
            $table->decimal('win_probability', 5, 4);
            $table->decimal('draw_probability', 5, 4);
            $table->decimal('loss_probability', 5, 4);
            $table->string('tactical_grade', 5);
            $table->json('simulation_result_json');
            $table->timestamps();

            $table->index(['user_id', 'match_id'], 'idx_user_match');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('simulations');
    }
};
