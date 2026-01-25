<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeder.
     */
    public function run(): void
    {
        // Super Admin
        User::create([
            'name' => 'Super Admin',
            'email' => 'dev@masjid.com',
            'password' => Hash::make('password'),
            'role' => 'super_admin',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        // Pak Ketua
        User::create([
            'name' => 'Pak Ketua',
            'email' => 'ketua@masjid.com',
            'password' => Hash::make('password'),
            'role' => 'ketua',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        // Pak Bendahara
        User::create([
            'name' => 'Pak Bendahara',
            'email' => 'bendahara@masjid.com',
            'password' => Hash::make('password'),
            'role' => 'bendahara',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        // Pak Sekretaris
        User::create([
            'name' => 'Pak Sekretaris',
            'email' => 'sekretaris@masjid.com',
            'password' => Hash::make('password'),
            'role' => 'sekretaris',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        // Kang Marbot
        User::create([
            'name' => 'Kang Marbot',
            'email' => 'marbot@masjid.com',
            'password' => Hash::make('password'),
            'role' => 'marbot',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);
    }
}
