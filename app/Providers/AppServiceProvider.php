<?php

namespace App\Providers;

use Illuminate\Support\Facades\Vite;
use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Artisan; // <-- 1. TAMBAHKAN INI DI SINI

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Vite::prefetch(concurrency: 3);

        // Register Transaction Observer
        \App\Models\Transaction::observe(\App\Observers\TransactionObserver::class);

        // Define Authorization Gates
        \Illuminate\Support\Facades\Gate::define('manage_finance', function ($user) {
            return in_array($user->role, ['super_admin', 'bendahara']);
        });

        \Illuminate\Support\Facades\Gate::define('manage_operations', function ($user) {
            return in_array($user->role, ['super_admin', 'marbot']);
        });

        \Illuminate\Support\Facades\Gate::define('approve_transaction', function ($user) {
            return in_array($user->role, ['super_admin', 'ketua']);
        });

        \Illuminate\Support\Facades\Gate::define('view_dashboard_executive', function ($user) {
            return in_array($user->role, ['super_admin', 'ketua']);
        });

        \Illuminate\Support\Facades\Gate::define('impersonate_user', function ($user) {
            return $user->role === 'super_admin';
        });

        \Illuminate\Support\Facades\Gate::define('manage_users', function ($user) {
            return $user->role === 'super_admin';
        });

        \Illuminate\Support\Facades\Gate::define('manage_posts', function ($user) {
            return in_array($user->role, ['super_admin', 'ketua']);
        });

        // <-- 2. TAMBAHKAN BLOK MIGRASI OTOMATIS INI DI PALING BAWAH SEBELUM TUTUP KURUNG
        if (config('app.env') === 'production') {
            try {
                Artisan::call('migrate', ['--force' => true]);
            } catch (\Exception $e) {
                // Abaikan jika tabel sudah terbuat
            }
        }
    }
}
