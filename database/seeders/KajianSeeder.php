<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class KajianSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \App\Models\Kajian::factory(10)->create();
    }
}
