<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('barca_players', function (Blueprint $table) {
            $table->id();
            $table->string('name', 150);
            $table->unsignedSmallInteger('shirt_number');
            $table->string('position', 10); // GK, CB, LB, RB, DM, CM, AM, RW, LW, CF
            $table->unsignedTinyInteger('overall_rating'); // 1 - 100
            $table->unsignedTinyInteger('pace'); // 1 - 100
            $table->unsignedTinyInteger('passing'); // 1 - 100
            $table->unsignedTinyInteger('defending'); // 1 - 100
            $table->string('photo_url')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('barca_players');
    }
};
