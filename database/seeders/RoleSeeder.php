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
            'email' => 'admin@pimasjid.com',
            'password' => Hash::make('admin123'),
            'role' => 'super_admin',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        // Pak Ketua
        User::create([
            'name' => 'Pak Ketua',
            'email' => 'ketua@pimasjid.com',
            'password' => Hash::make('admin123'),
            'role' => 'ketua',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        // Pak Bendahara
        User::create([
            'name' => 'Pak Bendahara',
            'email' => 'bendahara@pimasjid.com',
            'password' => Hash::make('admin123'),
            'role' => 'bendahara',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        // Pak Sekretaris
        User::create([
            'name' => 'Pak Sekretaris',
            'email' => 'sekretaris@pimasjid.com',
            'password' => Hash::make('admin123'),
            'role' => 'sekretaris',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);

        // Kang Marbot
        User::create([
            'name' => 'Kang Marbot',
            'email' => 'marbot@pimasjid.com',
            'password' => Hash::make('admin123'),
            'role' => 'marbot',
            'is_active' => true,
            'email_verified_at' => now(),
        ]);
    }
}
