<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('matches', function (Blueprint $table) {
            $table->id();
            $table->foreignId('opponent_id')->constrained('opponents')->onDelete('cascade');
            $table->dateTime('match_date');
            $table->enum('venue', ['HOME', 'AWAY', 'NEUTRAL'])->default('HOME');
            $table->string('competition', 100)->default('La Liga EA Sports');
            $table->text('context_description');
            $table->enum('status', ['UPCOMING', 'SIMULATED', 'ARCHIVED'])->default('UPCOMING');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('matches');
    }
};
