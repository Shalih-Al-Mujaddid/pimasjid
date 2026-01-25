<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class DonationSettingsSeeder extends Seeder
{
    public function run(): void
    {
        $settings = [
            [
                'group' => 'donation',
                'key' => 'donation_qris_image',
                'value' => null,
                'type' => 'image',
                'label' => 'QRIS Code Image',
            ],
            [
                'group' => 'donation',
                'key' => 'donation_bank_info',
                'value' => "Bank Syariah Indonesia (BSI)\nNo. Rek: 1234567890\nA.n Masjid Al-Hidayah",
                'type' => 'textarea',
                'label' => 'Informasi Rekening & NMID',
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
