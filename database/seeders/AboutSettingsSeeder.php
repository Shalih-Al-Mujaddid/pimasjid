<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class AboutSettingsSeeder extends Seeder
{
    public function run(): void
    {
        $settings = [
            [
                'group' => 'about',
                'key' => 'about_hero_title',
                'value' => 'Tentang Kami',
                'type' => 'text',
                'label' => 'Judul Hero',
            ],
            [
                'group' => 'about',
                'key' => 'about_hero_subtitle',
                'value' => 'Sejarah dan visi misi Masjid Al-Hidayah dalam melayani umat.',
                'type' => 'textarea',
                'label' => 'Subjudul Hero',
            ],
            [
                'group' => 'about',
                'key' => 'about_vision',
                'value' => 'Menjadi pusat peradaban umat yang mandiri, transparan, dan rahmatan lil \'alamin.',
                'type' => 'textarea',
                'label' => 'Visi',
            ],
            [
                'group' => 'about',
                'key' => 'about_mission',
                'value' => "1. Menyelenggarakan ibadah yang khusyuk dan nyaman.\n2. Mengelola dana umat secara transparan dan akuntabel.\n3. Memberdayakan ekonomi umat melalui program sosial.",
                'type' => 'textarea',
                'label' => 'Misi (Pisahkan dengan baris baru)',
            ],
            [
                'group' => 'about',
                'key' => 'about_history',
                'value' => 'Masjid Al-Hidayah didirikan pada tahun 1990 di atas tanah wakaf seluas 500m2. Seiring berjalannya waktu, masjid ini mengalami renovasi besar pada tahun 2005 untuk menampung jamaah yang semakin banyak. Kini, kami terus berinovasi dengan menerapkan sistem manajemen modern untuk transparansi dan kenyamanan umat.',
                'type' => 'textarea',
                'label' => 'Sejarah Singkat',
            ],
            [
                'group' => 'about',
                'key' => 'about_image',
                'value' => null,
                'type' => 'image',
                'label' => 'Gambar Utama (Tentang)',
            ],
        ];

        foreach ($settings as $setting) {
            Setting::updateOrCreate(
                ['key' => $setting['key']],
                $setting
            );
        }
    }
}
