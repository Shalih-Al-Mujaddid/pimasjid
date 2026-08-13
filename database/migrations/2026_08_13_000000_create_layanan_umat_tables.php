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
        Schema::create('services', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('slug')->unique();
            $table->string('category')->default('sosial'); // sosial, kesehatan, pendidikan, jenazah, zakat, qurban, tpa, fasilitas
            $table->string('icon')->nullable(); // HeartIcon, AcademicCapIcon, TruckIcon, etc.
            $table->text('short_description')->nullable();
            $table->longText('description')->nullable();
            $table->longText('terms')->nullable(); // Syarat & Ketentuan
            $table->longText('how_to_apply')->nullable(); // Alur Pengajuan
            $table->string('external_link')->nullable(); // Optional link to existing modules (/info/zakat, /info/qurban, /tpa/daftar)
            $table->boolean('is_active')->default(true);
            $table->boolean('is_featured')->default(false);
            $table->timestamps();
        });

        Schema::create('service_applications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('service_id')->nullable()->constrained('services')->onDelete('cascade');
            $table->string('tracking_code')->unique(); // e.g. LU-20260813-9812
            $table->string('applicant_name');
            $table->string('nik')->nullable();
            $table->string('phone');
            $table->text('address')->nullable();
            $table->string('service_name');
            $table->text('notes')->nullable();
            $table->string('document_path')->nullable();
            $table->enum('status', ['pending', 'approved', 'rejected', 'completed'])->default('pending');
            $table->text('admin_notes')->nullable();
            $table->foreignId('processed_by')->nullable()->constrained('users')->onDelete('set null');
            $table->timestamp('processed_at')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('service_applications');
        Schema::dropIfExists('services');
    }
};
