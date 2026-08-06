<?php

namespace App\Http\Controllers;

use App\Http\Resources\TpaStudentPublicResource;
use App\Models\TpaRegistration;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Inertia\Inertia;

class TpaRegistrationController extends Controller
{
    /**
     * Display the public TPA registration and student bulletin page.
     */
    public function publicIndex()
    {
        $students = TpaRegistration::where('status', 'approved')
            ->orderBy('nama_anak', 'asc')
            ->get();

        // Menggunakan API Resource untuk transformasi data yang lebih bersih
        return Inertia::render('Public/TpaRegister', [
            'students' => TpaStudentPublicResource::collection($students),
        ]);
    }

    /**
     * Store a newly created registration in storage (Public submission).
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_anak' => 'required|string|max:255',
            'tempat_lahir' => 'required|string|max:100',
            'tanggal_lahir' => 'required|date',
            'jenis_kelamin' => 'required|in:L,P',
            'tingkat_sekolah' => 'required|string',
            'nama_ortu' => 'required|string|max:255',
            'no_wa' => 'required|string|max:20',
            'alamat' => 'required|string',
        ]);

        TpaRegistration::create($validated);

        return back()->with('success', 'Pendaftaran berhasil dikirim!');
    }

    /**
     * Display a listing of registrations for admin.
     */
    public function index()
    {
        Gate::authorize('manage_operations');

        // Tidak perlu mapping manual, properti model (termasuk accessors) akan otomatis tersedia di Inertia
        $registrations = TpaRegistration::orderBy('created_at', 'desc')->get();

        return Inertia::render('Admin/Tpa/Index', [
            'registrations' => $registrations,
        ]);
    }

    /**
     * Update the specified student resource (Admin edit).
     */
    public function update(Request $request, TpaRegistration $tpa)
    {
        Gate::authorize('manage_operations');

        $validated = $request->validate([
            'nama_anak' => 'required|string|max:255',
            'tempat_lahir' => 'required|string|max:100',
            'tanggal_lahir' => 'required|date',
            'jenis_kelamin' => 'required|in:L,P',
            'tingkat_sekolah' => 'required|string',
            'nama_ortu' => 'required|string|max:255',
            'no_wa' => 'required|string|max:20',
            'alamat' => 'required|string',
            'kelas' => 'nullable|string|max:50',
            'ustadz' => 'nullable|string|max:100',
            'progres' => 'nullable|string',
        ]);

        $tpa->update($validated);

        return back()->with('success', 'Data santri berhasil diperbarui!');
    }

    /**
     * Update the status of the specified registration (Approve/Reject).
     */
    public function updateStatus(Request $request, TpaRegistration $tpa)
    {
        Gate::authorize('manage_operations');

        $validated = $request->validate([
            'status' => 'required|in:pending,approved,rejected',
        ]);

        $updateData = $validated;

        // Set approved_at jika status berubah menjadi 'approved' dan sebelumnya bukan 'approved'
        if ($validated['status'] === 'approved' && $tpa->status !== 'approved') {
            $updateData['approved_at'] = now();
        }
        // Jika status diubah kembali ke pending/rejected, approved_at akan di-set null di model.

        $tpa->update($updateData);

        return back()->with('success', 'Status pendaftaran berhasil diubah!');
    }

    /**
     * Remove the specified registration from storage.
     */
    public function destroy(TpaRegistration $tpa)
    {
        Gate::authorize('manage_operations');

        $tpa->delete();

        return back()->with('success', 'Data pendaftaran/santri berhasil dihapus!');
    }
}
