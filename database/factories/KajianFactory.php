<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Kajian>
 */
class KajianFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'title' => fake()->sentence(4),
            'theme' => fake()->word(),
            'ustaz_name' => 'Ustadz '.fake()->name('male'),
            'ustaz_photo' => null,
            'ustaz_topic' => fake()->word(),
            'ustaz_bio' => fake()->paragraph(),
            'date' => fake()->dateTimeBetween('-1 month', '+1 month')->format('Y-m-d'),
            'time' => fake()->time('H:i'),
            'location' => fake()->randomElement(['Ruang Utama Masjid', 'Aula Serbaguna', 'Halaman Masjid']),
            'description' => fake()->paragraphs(3, true),
            'banner' => null,
            'video_url' => fake()->boolean(30) ? 'https://youtube.com/watch?v=dQw4w9WgXcQ' : null,
            'status' => fake()->randomElement(['akan_datang', 'berlangsung', 'selesai']),
        ];
    }
}
