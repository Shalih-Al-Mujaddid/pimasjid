<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Wishlist;
use App\Models\WishlistContribution;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class WishlistTest extends TestCase
{
    use RefreshDatabase;

    private User $superAdmin;

    private User $bendahara;

    private User $marbot;

    private User $sekretaris;

    protected function setUp(): void
    {
        parent::setUp();

        $this->superAdmin = User::factory()->create([
            'role' => 'super_admin',
        ]);

        $this->bendahara = User::factory()->create([
            'role' => 'bendahara',
        ]);

        $this->marbot = User::factory()->create([
            'role' => 'marbot',
        ]);

        $this->sekretaris = User::factory()->create([
            'role' => 'sekretaris',
        ]);
    }

    public function test_public_can_view_wishlist_catalog(): void
    {
        Wishlist::create([
            'item_name' => 'Sound System Masjid',
            'target_qty' => 2,
            'fulfilled_qty' => 1,
            'unit_price' => 5000000,
            'status' => 'active',
            'description' => 'Sound system untuk ruang utama',
        ]);

        $response = $this->get(route('public.wishlist.index'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Public/Wishlist/Index')
            ->has('wishlists.data', 1)
            ->has('stats')
        );
    }

    public function test_public_can_view_wishlist_detail(): void
    {
        $wishlist = Wishlist::create([
            'item_name' => 'Karpet Saf Masjid',
            'target_qty' => 10,
            'fulfilled_qty' => 2,
            'unit_price' => 1500000,
            'status' => 'active',
            'description' => 'Karpet kualitas premium turki',
        ]);

        $response = $this->get(route('public.wishlist.show', $wishlist->id));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Public/Wishlist/Show')
            ->where('wishlist.item_name', 'Karpet Saf Masjid')
            ->has('bankInfo')
        );
    }

    public function test_public_can_submit_wishlist_contribution(): void
    {
        Storage::fake('public');

        $wishlist = Wishlist::create([
            'item_name' => 'Genset Cadangan Listrik',
            'target_qty' => 1,
            'fulfilled_qty' => 0,
            'unit_price' => 10000000,
            'status' => 'active',
        ]);

        $file = UploadedFile::fake()->image('bukti_transfer.jpg');

        $response = $this->post(route('public.wishlist.contribute', $wishlist->id), [
            'donor_name' => 'H. Abdullah',
            'donor_phone' => '082346719219',
            'donor_email' => 'abdullah@example.com',
            'quantity' => 1,
            'type' => 'dana',
            'amount' => 10000000,
            'notes' => 'Semoga berkah untuk jamaah masjid',
            'is_anonymous' => true,
            'proof_image' => $file,
        ]);

        $response->assertRedirect();
        $response->assertSessionHas('success');

        $this->assertDatabaseHas('wishlist_contributions', [
            'wishlist_id' => $wishlist->id,
            'donor_name' => 'H. Abdullah',
            'quantity' => 1,
            'type' => 'dana',
            'amount' => 10000000,
            'is_anonymous' => 1,
            'status' => 'pending',
        ]);
    }

    public function test_admin_can_view_wishlist_management_page(): void
    {
        $response = $this->actingAs($this->superAdmin)
            ->get(route('admin.wishlist.index'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Wishlist/Index')
            ->has('wishlists')
            ->has('pendingContributions')
            ->has('stats')
        );
    }

    public function test_unauthorized_user_cannot_access_admin_wishlist(): void
    {
        $response = $this->actingAs($this->sekretaris)
            ->get(route('admin.wishlist.index'));

        $response->assertStatus(403);
    }

    public function test_admin_can_create_wishlist(): void
    {
        $response = $this->actingAs($this->superAdmin)
            ->post(route('admin.wishlist.store'), [
                'item_name' => 'AC Ruang Sholat 2 PK',
                'target_qty' => 4,
                'fulfilled_qty' => 0,
                'unit_price' => 6000000,
                'status' => 'active',
                'description' => 'AC pendingin ruangan lantai 1',
            ]);

        $response->assertRedirect(route('admin.wishlist.index'));
        $this->assertDatabaseHas('wishlists', [
            'item_name' => 'AC Ruang Sholat 2 PK',
            'target_qty' => 4,
            'unit_price' => 6000000,
        ]);
    }

    public function test_admin_can_update_wishlist(): void
    {
        $wishlist = Wishlist::create([
            'item_name' => 'Vacuum Cleaner',
            'target_qty' => 2,
            'fulfilled_qty' => 1,
            'unit_price' => 2000000,
            'status' => 'active',
        ]);

        $response = $this->actingAs($this->bendahara)
            ->put(route('admin.wishlist.update', $wishlist->id), [
                'item_name' => 'Vacuum Cleaner Heavy Duty',
                'target_qty' => 3,
                'fulfilled_qty' => 1,
                'unit_price' => 2500000,
                'status' => 'active',
                'description' => 'Vacuum cleaner daya hisap tinggi',
            ]);

        $response->assertRedirect(route('admin.wishlist.index'));
        $this->assertDatabaseHas('wishlists', [
            'id' => $wishlist->id,
            'item_name' => 'Vacuum Cleaner Heavy Duty',
            'target_qty' => 3,
        ]);
    }

    public function test_admin_can_delete_wishlist(): void
    {
        $wishlist = Wishlist::create([
            'item_name' => 'Item Dihapus',
            'target_qty' => 1,
            'fulfilled_qty' => 0,
            'unit_price' => 500000,
            'status' => 'active',
        ]);

        $response = $this->actingAs($this->marbot)
            ->delete(route('admin.wishlist.destroy', $wishlist->id));

        $response->assertRedirect(route('admin.wishlist.index'));
        $this->assertDatabaseMissing('wishlists', [
            'id' => $wishlist->id,
        ]);
    }

    public function test_admin_can_verify_contribution_and_auto_increment_fulfilled_qty(): void
    {
        $wishlist = Wishlist::create([
            'item_name' => 'Lampu Sorot Menara',
            'target_qty' => 2,
            'fulfilled_qty' => 0,
            'unit_price' => 1500000,
            'status' => 'active',
        ]);

        $contribution = WishlistContribution::create([
            'wishlist_id' => $wishlist->id,
            'donor_name' => 'Ahmad Fauzi',
            'donor_phone' => '08111111111',
            'quantity' => 2,
            'type' => 'barang',
            'status' => 'pending',
        ]);

        $response = $this->actingAs($this->superAdmin)
            ->patch(route('admin.wishlist.contribution.verify', $contribution->id));

        $response->assertRedirect();
        $this->assertDatabaseHas('wishlist_contributions', [
            'id' => $contribution->id,
            'status' => 'verified',
            'verified_by' => $this->superAdmin->id,
        ]);

        $wishlist->refresh();
        $this->assertEquals(2, $wishlist->fulfilled_qty);
        $this->assertEquals('completed', $wishlist->status);
    }

    public function test_admin_can_reject_contribution(): void
    {
        $wishlist = Wishlist::create([
            'item_name' => 'Mimbar Khutbah',
            'target_qty' => 1,
            'fulfilled_qty' => 0,
            'unit_price' => 5000000,
            'status' => 'active',
        ]);

        $contribution = WishlistContribution::create([
            'wishlist_id' => $wishlist->id,
            'donor_name' => 'Fulan',
            'quantity' => 1,
            'type' => 'dana',
            'amount' => 5000000,
            'status' => 'pending',
        ]);

        $response = $this->actingAs($this->bendahara)
            ->patch(route('admin.wishlist.contribution.reject', $contribution->id), [
                'admin_notes' => 'Bukti mutasi transfer belum masuk ke rekening',
            ]);

        $response->assertRedirect();
        $this->assertDatabaseHas('wishlist_contributions', [
            'id' => $contribution->id,
            'status' => 'rejected',
            'admin_notes' => 'Bukti mutasi transfer belum masuk ke rekening',
        ]);

        $wishlist->refresh();
        $this->assertEquals(0, $wishlist->fulfilled_qty);
    }

    public function test_admin_can_store_manual_offline_contribution(): void
    {
        $wishlist = Wishlist::create([
            'item_name' => 'Al-Quran Terjemah Per Juz',
            'target_qty' => 50,
            'fulfilled_qty' => 10,
            'unit_price' => 100000,
            'status' => 'active',
        ]);

        $response = $this->actingAs($this->superAdmin)
            ->post(route('admin.wishlist.contribution.store', $wishlist->id), [
                'donor_name' => 'Ibu Siti Aminah',
                'donor_phone' => '08123456700',
                'quantity' => 15,
                'type' => 'barang',
                'notes' => 'Diserahkan langsung ke marbot',
                'is_anonymous' => false,
            ]);

        $response->assertRedirect();
        $this->assertDatabaseHas('wishlist_contributions', [
            'wishlist_id' => $wishlist->id,
            'donor_name' => 'Ibu Siti Aminah',
            'quantity' => 15,
            'status' => 'verified',
            'verified_by' => $this->superAdmin->id,
        ]);

        $wishlist->refresh();
        $this->assertEquals(25, $wishlist->fulfilled_qty);
    }
}
