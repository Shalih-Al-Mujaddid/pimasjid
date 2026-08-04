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
        Schema::create('tpa_registrations', function (Blueprint $table) {
            $table->id();
            $table->string('nama_anak');
            $table->string('tempat_lahir');
            $table->date('tanggal_lahir');
            $table->char('jenis_kelamin', 1);
            $table->string('tingkat_sekolah');
            $table->string('nama_ortu');
            $table->string('no_wa');
            $table->text('alamat');
            $table->string('photo_path')->nullable();
            $table->string('status')->default('pending');
            $table->timestamp('approved_at')->nullable();
            $table->string('kelas')->nullable()->default('Iqro 1-3');
            $table->string('ustadz')->nullable();
            $table->text('progres')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tpa_registrations');
    }
};
