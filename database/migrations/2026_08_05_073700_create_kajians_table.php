<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('kajians', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('theme')->nullable();
            $table->string('ustaz_name');
            $table->string('ustaz_photo')->nullable();
            $table->string('ustaz_photo_public_id')->nullable();
            $table->string('ustaz_topic')->nullable();
            $table->text('ustaz_bio')->nullable();
            $table->date('date');
            $table->time('time');
            $table->string('location');
            $table->text('description')->nullable();
            $table->string('banner')->nullable();
            $table->string('banner_public_id')->nullable();
            $table->string('video_url')->nullable();
            $table->string('status')->default('akan_datang'); // akan_datang, berlangsung, selesai
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('kajians');
    }
};
