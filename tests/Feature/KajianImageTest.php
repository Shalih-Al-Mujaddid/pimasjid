<?php

namespace Tests\Feature;

use App\Models\Kajian;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class KajianImageTest extends TestCase
{
    use RefreshDatabase;

    public function test_kajian_model_appends_image_urls(): void
    {
        $kajian = Kajian::factory()->create([
            'banner' => 'kajian_banners/test_banner.png',
            'ustaz_photo' => 'kajian_ustaz/test_ustaz.jpg',
        ]);

        $this->assertNotNull($kajian->banner_url);
        $this->assertNotNull($kajian->ustaz_photo_url);
        $this->assertStringContainsString('/storage/kajian_banners/test_banner.png', $kajian->banner_url);
        $this->assertStringContainsString('/storage/kajian_ustaz/test_ustaz.jpg', $kajian->ustaz_photo_url);
    }

    public function test_public_kajian_index_returns_accessor_urls(): void
    {
        Kajian::factory()->create([
            'banner' => 'kajian_banners/test_banner.png',
            'ustaz_photo' => 'kajian_ustaz/test_ustaz.jpg',
            'status' => 'akan_datang',
        ]);

        $response = $this->get(route('public.kajian.index'));

        $response->assertOk();

        $response->assertInertia(fn ($page) => $page
            ->component('Public/Kajian/Index')
            ->has('kajians.data', 1, fn ($page) => $page
                ->where('banner', asset('storage/kajian_banners/test_banner.png'))
                ->etc()
            )
        );
    }

    public function test_public_kajian_show_returns_accessor_urls(): void
    {
        $kajian = Kajian::factory()->create([
            'banner' => 'kajian_banners/test_banner.png',
            'ustaz_photo' => 'kajian_ustaz/test_ustaz.jpg',
            'status' => 'akan_datang',
        ]);

        $response = $this->get(route('public.kajian.show', $kajian->id));

        $response->assertOk();

        $response->assertInertia(fn ($page) => $page
            ->component('Public/Kajian/Show')
            ->has('kajian', fn ($page) => $page
                ->where('banner', asset('storage/kajian_banners/test_banner.png'))
                ->where('ustaz_photo', asset('storage/kajian_ustaz/test_ustaz.jpg'))
                ->etc()
            )
        );
    }

    public function test_admin_kajian_index_has_appended_urls(): void
    {
        $user = User::factory()->create([
            'role' => 'super_admin',
        ]);

        Kajian::factory()->create([
            'banner' => 'kajian_banners/test_banner.png',
            'ustaz_photo' => 'kajian_ustaz/test_ustaz.jpg',
            'status' => 'akan_datang',
        ]);

        $response = $this->actingAs($user)->get(route('admin.kajian.index'));

        $response->assertOk();

        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Kajian/Index')
            ->has('kajians.data', 1, fn ($page) => $page
                ->where('banner_url', asset('storage/kajian_banners/test_banner.png'))
                ->where('ustaz_photo_url', asset('storage/kajian_ustaz/test_ustaz.jpg'))
                ->etc()
            )
        );
    }
}
