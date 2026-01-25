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
        Schema::create('performance_logs', function (Blueprint $table) {
            $table->id();
            $table->string('request_path');
            $table->integer('response_time_ms'); // Response time in milliseconds
            $table->decimal('memory_usage_mb', 8, 2); // Memory usage in MB
            $table->integer('query_count')->default(0); // Number of DB queries executed
            $table->foreignId('user_id')->nullable()->constrained()->onDelete('set null');
            $table->string('ip_address', 45)->nullable(); // IPv4 and IPv6 support
            $table->string('user_agent', 500)->nullable();
            $table->timestamps();

            // Indexes for efficient querying
            $table->index('created_at'); // For time-based queries
            $table->index(['request_path', 'created_at']); // For path-specific analysis
            $table->index('user_id'); // For user-specific analysis
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('performance_logs');
    }
};
