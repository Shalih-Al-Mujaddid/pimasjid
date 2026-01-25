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
        // Add cloudinary_public_id to slides table
        Schema::table('slides', function (Blueprint $table) {
            $table->string('cloudinary_public_id')->nullable()->after('image_path');
        });

        // Add cloudinary_public_id to posts table
        Schema::table('posts', function (Blueprint $table) {
            $table->string('cloudinary_public_id')->nullable()->after('image_path');
        });

        // Add cloudinary_public_id to committee_members table
        Schema::table('committee_members', function (Blueprint $table) {
            $table->string('cloudinary_public_id')->nullable()->after('photo_path');
        });

        // Add cloudinary_public_id to transactions table
        Schema::table('transactions', function (Blueprint $table) {
            $table->string('cloudinary_public_id')->nullable()->after('proof_image_path');
        });

        // Add cloudinary_public_id to settings table
        Schema::table('settings', function (Blueprint $table) {
            $table->string('cloudinary_public_id')->nullable()->after('value');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('slides', function (Blueprint $table) {
            $table->dropColumn('cloudinary_public_id');
        });

        Schema::table('posts', function (Blueprint $table) {
            $table->dropColumn('cloudinary_public_id');
        });

        Schema::table('committee_members', function (Blueprint $table) {
            $table->dropColumn('cloudinary_public_id');
        });

        Schema::table('transactions', function (Blueprint $table) {
            $table->dropColumn('cloudinary_public_id');
        });

        Schema::table('settings', function (Blueprint $table) {
            $table->dropColumn('cloudinary_public_id');
        });
    }
};
