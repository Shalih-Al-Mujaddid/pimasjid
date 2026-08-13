<?php

namespace Tests\Feature;

use App\Models\Service;
use App\Models\ServiceApplication;
use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;

class LayananUmatTest extends TestCase
{
    use DatabaseTransactions;

    protected function setUp(): void
    {
        parent::setUp();

        $this->seed(\Database\Seeders\ServiceSeeder::class);
    }

    public function test_public_layanan_umat_index_can_be_rendered(): void
    {
        $response = $this->get('/layanan-umat');

        $response->assertStatus(200);
    }

    public function test_public_layanan_umat_show_can_be_rendered(): void
    {
        $service = Service::where('slug', 'bantuan-santunan-dhuafa-yatim')->first();

        $response = $this->get('/layanan-umat/'.$service->slug);

        $response->assertStatus(200);
    }

    public function test_jamaah_can_submit_service_application(): void
    {
        $service = Service::where('slug', 'bantuan-santunan-dhuafa-yatim')->first();

        $response = $this->post('/layanan-umat/'.$service->slug.'/ajukan', [
            'service_id' => $service->id,
            'service_name' => $service->title,
            'applicant_name' => 'Ahmad Test',
            'phone' => '081299998888',
            'address' => 'Jl. Test No 123',
            'notes' => 'Permohonan bantuan biaya sekolah anak yatim.',
        ]);

        $response->assertSessionHas('flash');
        $this->assertDatabaseHas('service_applications', [
            'applicant_name' => 'Ahmad Test',
            'phone' => '081299998888',
            'status' => 'pending',
        ]);
    }

    public function test_tracking_api_returns_status(): void
    {
        $app = ServiceApplication::create([
            'tracking_code' => 'LU-20260813-TEST1',
            'applicant_name' => 'Budi Test',
            'phone' => '081277776666',
            'address' => 'Jl. Merdeka',
            'service_name' => 'Layanan Ambulans',
            'notes' => 'Darurat penjemputan',
            'status' => 'pending',
        ]);

        $response = $this->get('/layanan-umat/tracking?q=LU-20260813-TEST1');

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
            ]);
    }

    public function test_admin_can_access_layanan_umat_management(): void
    {
        $admin = User::factory()->create([
            'role' => 'super_admin',
        ]);

        $response = $this->actingAs($admin)->get('/admin/layanan-umat');

        $response->assertStatus(200);
    }
}
