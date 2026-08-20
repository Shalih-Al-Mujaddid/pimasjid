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
        Schema::create('wishlist_contributions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('wishlist_id')->constrained('wishlists')->cascadeOnDelete();
            $table->string('donor_name');
            $table->string('donor_phone', 25)->nullable();
            $table->string('donor_email')->nullable();
            $table->integer('quantity')->default(1)->comment('Jumlah unit barang yang disumbangkan');
            $table->decimal('amount', 15, 2)->nullable()->comment('Nominal uang tunai jika berupa transfer dana');
            $table->enum('type', ['barang', 'dana'])->default('barang')->comment('Tipe donasi: barang fisik atau dana');
            $table->string('proof_image_path')->nullable()->comment('Bukti transfer atau foto barang');
            $table->text('notes')->nullable()->comment('Doa atau catatan dari donatur');
            $table->boolean('is_anonymous')->default(false)->comment('Apakah donatur ingin tampil sebagai Hamba Allah');
            $table->enum('status', ['pending', 'verified', 'rejected'])->default('pending')->comment('Status verifikasi');
            $table->foreignId('verified_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('verified_at')->nullable();
            $table->text('admin_notes')->nullable();
            $table->timestamps();

            // Indexes
            $table->index('status');
            $table->index('type');
            $table->index(['wishlist_id', 'status']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('wishlist_contributions');
    }
};
