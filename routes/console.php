<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

use Illuminate\Support\Facades\Route;

// Rute darurat khusus bypass total sistem middleware Inertia
Route::get('/migrasi-final-pimasjid', function () {
    try {
        // Hapus cache agar setingan database PostgreSQL terbaca segar oleh server
        Artisan::call('config:clear');
        Artisan::call('cache:clear');

        // Eksekusi paksa migrasi database masjid
        Artisan::call('migrate', ['--force' => true]);

        return 'SANGAT SUKSES: Seluruh tabel database masjid berhasil dibuat!';
    } catch (\Exception $e) {
        return 'Gagal total. Kesalahan database: '.$e->getMessage();
    }
})->withoutMiddleware([\App\Http\Middleware\HandleInertiaRequests::class]);
