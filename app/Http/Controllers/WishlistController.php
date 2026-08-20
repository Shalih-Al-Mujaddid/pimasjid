<?php

namespace App\Http\Controllers;

use App\Models\Setting;
use App\Models\Wishlist;
use App\Models\WishlistContribution;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Inertia\Response;

class WishlistController extends Controller
{
    /**
     * Display public catalog of mosque wishlists / needs.
     */
    public function publicIndex(Request $request): Response
    {
        $query = Wishlist::query();

        // Search
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('item_name', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%");
            });
        }

        // Filter status
        $status = $request->query('status', 'semua');
        if ($status && $status !== 'semua') {
            $query->where('status', $status);
        }

        $wishlists = $query->latest()->paginate(9)->withQueryString();

        // Aggregate statistics for header summary
        $totalItems = Wishlist::count();
        $activeItems = Wishlist::where('status', 'active')->count();
        $completedItems = Wishlist::where('status', 'completed')->count();

        $totalTargetAmount = (float) Wishlist::selectRaw('SUM(target_qty * unit_price) as total')->value('total') ?? 0;
        $totalFulfilledAmount = (float) Wishlist::selectRaw('SUM(fulfilled_qty * unit_price) as total')->value('total') ?? 0;

        return Inertia::render('Public/Wishlist/Index', [
            'wishlists' => $wishlists,
            'filters' => [
                'search' => $request->search ?? '',
                'status' => $status,
            ],
            'stats' => [
                'total_items' => $totalItems,
                'active_items' => $activeItems,
                'completed_items' => $completedItems,
                'total_target_amount' => $totalTargetAmount,
                'total_fulfilled_amount' => $totalFulfilledAmount,
                'overall_percentage' => $totalTargetAmount > 0
                    ? round(($totalFulfilledAmount / $totalTargetAmount) * 100, 1)
                    : 0,
            ],
        ]);
    }

    /**
     * Display detailed single wishlist page with contribution history & donation form.
     */
    public function publicShow(Wishlist $wishlist): Response
    {
        $wishlist->load(['verifiedContributions' => function ($q) {
            $q->latest();
        }]);

        // Get bank and QRIS donation settings
        $settings = Setting::all()->pluck('value', 'key')->toArray();

        return Inertia::render('Public/Wishlist/Show', [
            'wishlist' => $wishlist,
            'contributions' => $wishlist->verifiedContributions,
            'bankInfo' => [
                'bank_name' => $settings['bank_name'] ?? 'Bank Syariah Indonesia (BSI)',
                'bank_account' => $settings['bank_account'] ?? $settings['bank_number'] ?? '-',
                'bank_holder' => $settings['bank_holder'] ?? 'DKM Masjid',
                'donation_bank_info' => $settings['donation_bank_info'] ?? null,
                'qris_image' => isset($settings['donation_qris_image']) ? storage_url($settings['donation_qris_image']) : null,
            ],
        ]);
    }

    /**
     * Submit contribution from public website.
     */
    public function publicContribute(Request $request, Wishlist $wishlist): RedirectResponse
    {
        $validated = $request->validate([
            'donor_name' => 'required|string|max:255',
            'donor_phone' => 'required|string|max:25',
            'donor_email' => 'nullable|email|max:255',
            'quantity' => 'required|integer|min:1',
            'type' => 'required|in:barang,dana',
            'amount' => 'nullable|numeric|min:0',
            'notes' => 'nullable|string|max:1000',
            'is_anonymous' => 'nullable|boolean',
            'proof_image' => 'nullable|image|max:5120',
        ]);

        $proofImagePath = null;
        if ($request->hasFile('proof_image')) {
            $proofImagePath = $request->file('proof_image')->store('wishlist_proofs', 'public');
        }

        // Calculate amount if type is dana and amount is empty
        $amount = $validated['amount'] ?? null;
        if ($validated['type'] === 'dana' && empty($amount)) {
            $amount = $validated['quantity'] * $wishlist->unit_price;
        }

        $wishlist->contributions()->create([
            'donor_name' => $validated['donor_name'],
            'donor_phone' => $validated['donor_phone'],
            'donor_email' => $validated['donor_email'] ?? null,
            'quantity' => $validated['quantity'],
            'type' => $validated['type'],
            'amount' => $amount,
            'notes' => $validated['notes'] ?? null,
            'is_anonymous' => (bool) ($validated['is_anonymous'] ?? false),
            'proof_image_path' => $proofImagePath,
            'status' => 'pending',
        ]);

        return redirect()->back()->with('success', 'Jazakallahu Khairan! Niat donasi / kontribusi Anda telah kami terima dan akan segera diverifikasi oleh pengurus masjid.');
    }

    /**
     * Admin: Display listing of wishlists & pending contributions.
     */
    public function index(Request $request): Response
    {
        $this->authorizeAccess();

        $query = Wishlist::withCount([
            'contributions',
            'contributions as pending_contributions_count' => function ($q) {
                $q->where('status', 'pending');
            },
        ]);

        // Search
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('item_name', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%");
            });
        }

        // Filter status
        if ($request->filled('status') && $request->status !== 'semua') {
            $query->where('status', $request->status);
        }

        $wishlists = $query->latest()->paginate(10)->withQueryString();

        // Pending contributions list for verification tab
        $pendingContributions = WishlistContribution::with('wishlist')
            ->where('status', 'pending')
            ->latest()
            ->get();

        // Stats for admin KPI cards
        $totalItems = Wishlist::count();
        $activeItems = Wishlist::where('status', 'active')->count();
        $completedItems = Wishlist::where('status', 'completed')->count();
        $pendingContributionsCount = WishlistContribution::where('status', 'pending')->count();

        $totalTargetAmount = (float) Wishlist::selectRaw('SUM(target_qty * unit_price) as total')->value('total') ?? 0;
        $totalFulfilledAmount = (float) Wishlist::selectRaw('SUM(fulfilled_qty * unit_price) as total')->value('total') ?? 0;

        return Inertia::render('Admin/Wishlist/Index', [
            'wishlists' => $wishlists,
            'pendingContributions' => $pendingContributions,
            'filters' => $request->only(['search', 'status']),
            'stats' => [
                'total_items' => $totalItems,
                'active_items' => $activeItems,
                'completed_items' => $completedItems,
                'pending_contributions' => $pendingContributionsCount,
                'total_target_amount' => $totalTargetAmount,
                'total_fulfilled_amount' => $totalFulfilledAmount,
            ],
        ]);
    }

    /**
     * Admin: Store new wishlist item.
     */
    public function store(Request $request): RedirectResponse
    {
        $this->authorizeAccess();

        $validated = $request->validate([
            'item_name' => 'required|string|max:200',
            'target_qty' => 'required|integer|min:1',
            'fulfilled_qty' => 'nullable|integer|min:0',
            'unit_price' => 'required|numeric|min:0',
            'status' => 'required|in:active,pending,completed,cancelled',
            'description' => 'nullable|string',
        ]);

        $fulfilledQty = $validated['fulfilled_qty'] ?? 0;
        $status = $validated['status'];

        // Auto-complete if target met
        if ($fulfilledQty >= $validated['target_qty'] && $status === 'active') {
            $status = 'completed';
        }

        Wishlist::create([
            'item_name' => $validated['item_name'],
            'target_qty' => $validated['target_qty'],
            'fulfilled_qty' => $fulfilledQty,
            'unit_price' => $validated['unit_price'],
            'status' => $status,
            'description' => $validated['description'] ?? null,
        ]);

        return redirect()->route('admin.wishlist.index')->with('success', 'Kebutuhan masjid (wishlist) berhasil ditambahkan!');
    }

    /**
     * Admin: Update existing wishlist item.
     */
    public function update(Request $request, Wishlist $wishlist): RedirectResponse
    {
        $this->authorizeAccess();

        $validated = $request->validate([
            'item_name' => 'required|string|max:200',
            'target_qty' => 'required|integer|min:1',
            'fulfilled_qty' => 'required|integer|min:0',
            'unit_price' => 'required|numeric|min:0',
            'status' => 'required|in:active,pending,completed,cancelled',
            'description' => 'nullable|string',
        ]);

        $status = $validated['status'];
        if ($validated['fulfilled_qty'] >= $validated['target_qty'] && $status === 'active') {
            $status = 'completed';
        }

        $wishlist->update([
            'item_name' => $validated['item_name'],
            'target_qty' => $validated['target_qty'],
            'fulfilled_qty' => $validated['fulfilled_qty'],
            'unit_price' => $validated['unit_price'],
            'status' => $status,
            'description' => $validated['description'] ?? null,
        ]);

        return redirect()->route('admin.wishlist.index')->with('success', 'Kebutuhan masjid berhasil diperbarui!');
    }

    /**
     * Admin: Delete wishlist item.
     */
    public function destroy(Wishlist $wishlist): RedirectResponse
    {
        $this->authorizeAccess();

        // Delete proof images of contributions if any
        foreach ($wishlist->contributions as $contribution) {
            if ($contribution->proof_image_path) {
                Storage::disk('public')->delete($contribution->proof_image_path);
            }
        }

        $wishlist->delete();

        return redirect()->route('admin.wishlist.index')->with('success', 'Kebutuhan masjid berhasil dihapus!');
    }

    /**
     * Admin: Record manual/offline contribution.
     */
    public function storeManualContribution(Request $request, Wishlist $wishlist): RedirectResponse
    {
        $this->authorizeAccess();

        $validated = $request->validate([
            'donor_name' => 'required|string|max:255',
            'donor_phone' => 'nullable|string|max:25',
            'donor_email' => 'nullable|email|max:255',
            'quantity' => 'required|integer|min:1',
            'type' => 'required|in:barang,dana',
            'amount' => 'nullable|numeric|min:0',
            'notes' => 'nullable|string|max:1000',
            'is_anonymous' => 'nullable|boolean',
            'proof_image' => 'nullable|image|max:5120',
        ]);

        $proofImagePath = null;
        if ($request->hasFile('proof_image')) {
            $proofImagePath = $request->file('proof_image')->store('wishlist_proofs', 'public');
        }

        $amount = $validated['amount'] ?? null;
        if ($validated['type'] === 'dana' && empty($amount)) {
            $amount = $validated['quantity'] * $wishlist->unit_price;
        }

        $wishlist->contributions()->create([
            'donor_name' => $validated['donor_name'],
            'donor_phone' => $validated['donor_phone'] ?? '-',
            'donor_email' => $validated['donor_email'] ?? null,
            'quantity' => $validated['quantity'],
            'type' => $validated['type'],
            'amount' => $amount,
            'notes' => ($validated['notes'] ?? '').' [INPUT MANUAL OLEH PENGURUS]',
            'is_anonymous' => (bool) ($validated['is_anonymous'] ?? false),
            'proof_image_path' => $proofImagePath,
            'status' => 'verified',
            'verified_by' => Auth::id(),
            'verified_at' => now(),
        ]);

        // Auto increment fulfilled qty on parent wishlist
        $wishlist->increment('fulfilled_qty', (int) $validated['quantity']);
        if ($wishlist->fulfilled_qty >= $wishlist->target_qty && $wishlist->status === 'active') {
            $wishlist->update(['status' => 'completed']);
        }

        return redirect()->back()->with('success', 'Kontribusi donatur berhasil dicatat dan progress wishlist telah diperbarui!');
    }

    /**
     * Admin: Verify / Approve pending contribution.
     */
    public function verifyContribution(Request $request, WishlistContribution $contribution): RedirectResponse
    {
        $this->authorizeAccess();

        $contribution->update([
            'status' => 'verified',
            'verified_by' => Auth::id(),
            'verified_at' => now(),
            'admin_notes' => $request->admin_notes,
        ]);

        // Increment fulfilled quantity in wishlist
        $wishlist = $contribution->wishlist;
        if ($wishlist) {
            $wishlist->increment('fulfilled_qty', (int) $contribution->quantity);
            if ($wishlist->fulfilled_qty >= $wishlist->target_qty && $wishlist->status === 'active') {
                $wishlist->update(['status' => 'completed']);
            }
        }

        return redirect()->back()->with('success', 'Kontribusi donasi berhasil disetujui & diverifikasi!');
    }

    /**
     * Admin: Reject pending contribution.
     */
    public function rejectContribution(Request $request, WishlistContribution $contribution): RedirectResponse
    {
        $this->authorizeAccess();

        $contribution->update([
            'status' => 'rejected',
            'verified_by' => Auth::id(),
            'verified_at' => now(),
            'admin_notes' => $request->admin_notes ?? 'Tidak memenuhi kriteria / bukti tidak valid',
        ]);

        return redirect()->back()->with('success', 'Kontribusi donasi telah ditolak.');
    }

    /**
     * Check authorization gate.
     */
    private function authorizeAccess(): void
    {
        if (! Gate::allows('manage_operations') && ! Gate::allows('manage_finance')) {
            abort(403, 'Anda tidak memiliki hak akses untuk mengelola kebutuhan masjid.');
        }
    }
}
