<?php

namespace Database\Seeders;

use App\Models\CommitteeMember;
use Illuminate\Database\Seeder;

class CommitteeMemberSeeder extends Seeder
{
    public function run(): void
    {
        $members = [
            // Core Leadership (Inti)
            [
                'name' => 'H. Ahmad Dahlan',
                'position' => 'Ketua DKM',
                'division' => 'Inti',
                'order' => 1,
                'is_active' => true,
            ],
            [
                'name' => 'Muhammad Ridwan, S.Pd',
                'position' => 'Sekretaris',
                'division' => 'Inti',
                'order' => 2,
                'is_active' => true,
            ],
            [
                'name' => 'Budi Santoso, S.E',
                'position' => 'Bendahara',
                'division' => 'Inti',
                'order' => 3,
                'is_active' => true,
            ],
            
            // Divisions (Seksi)
            [
                'name' => 'Umar Bakri',
                'position' => 'Kepala Seksi Ibadah',
                'division' => 'Ibadah',
                'order' => 1,
                'is_active' => true,
            ],
            [
                'name' => 'Ali Rahman',
                'position' => 'Kepala Seksi Pembangunan',
                'division' => 'Pembangunan',
                'order' => 1,
                'is_active' => true,
            ],
            [
                'name' => 'Hasan Abdullah',
                'position' => 'Kepala Seksi Pendidikan',
                'division' => 'Pendidikan',
                'order' => 1,
                'is_active' => true,
            ],
            [
                'name' => 'Ibrahim Malik',
                'position' => 'Kepala Seksi Sosial',
                'division' => 'Sosial',
                'order' => 1,
                'is_active' => true,
            ],
        ];

        foreach ($members as $member) {
            CommitteeMember::create($member);
        }
    }
}
