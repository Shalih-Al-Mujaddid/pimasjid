<?php

namespace App\Http\Controllers;

use App\Models\Service;
use App\Models\ServiceApplication;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;
use Inertia\Response;

class LayananUmatController extends Controller
{
    /**
     * Display public Layanan Umat portal with services list & tracking.
     */
    public function publicIndex(Request $request): Response
    {
        $category = $request->query('category');
        $search = $request->query('search');

        $query = Service::where('is_active', true);

        if ($category && $category !== 'semua') {
            $query->where('category', $category);
        }

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('short_description', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%");
            });
        }

        $services = $query->orderBy('is_featured', 'desc')->orderBy('created_at', 'desc')->get();
        $categories = [
            ['key' => 'semua', 'label' => 'Semua Layanan', 'icon' => 'SparklesIcon'],
            ['key' => 'sosial', 'label' => 'Bantuan Sosial', 'icon' => 'HeartIcon'],
            ['key' => 'kesehatan', 'label' => 'Kesehatan & Ambulans', 'icon' => 'TruckIcon'],
            ['key' => 'jenazah', 'label' => 'Pengurusan Jenazah', 'icon' => 'UserGroupIcon'],
            ['key' => 'pendidikan', 'label' => 'Pendidikan & Beasiswa', 'icon' => 'AcademicCapIcon'],
            ['key' => 'fasilitas', 'label' => 'Fasilitas Masjid', 'icon' => 'BuildingLibraryIcon'],
            ['key' => 'zakat', 'label' => 'Mustahik Zakat', 'icon' => 'GiftIcon'],
            ['key' => 'qurban', 'label' => 'Layanan Qurban', 'icon' => 'CakeIcon'],
            ['key' => 'tpa', 'label' => 'Pendaftaran TPA', 'icon' => 'BookOpenIcon'],
        ];

        return Inertia::render('Public/LayananUmat/Index', [
            'services' => $services,
            'categories' => $categories,
            'filters' => [
                'category' => $category ?? 'semua',
                'search' => $search ?? '',
            ],
        ]);
    }

    /**
     * Display detailed page for a single service.
     */
    public function publicShow(string $slug): Response
    {
        $service = Service::where('slug', $slug)->where('is_active', true)->firstOrFail();

        return Inertia::render('Public/LayananUmat/Show', [
            'service' => $service,
        ]);
    }

    /**
     * Submit an application for a mosque service.
     */
    public function storeApplication(Request $request)
    {
        $validated = $request->validate([
            'service_id' => 'nullable|exists:services,id',
            'service_name' => 'required|string|max:255',
            'applicant_name' => 'required|string|max:255',
            'nik' => 'nullable|string|max:20',
            'phone' => 'required|string|max:20',
            'address' => 'required|string',
            'notes' => 'required|string',
            'document' => 'nullable|file|mimes:jpeg,jpg,png,pdf|max:5120', // Max 5MB
        ], [
            'applicant_name.required' => 'Nama lengkap pemohon wajib diisi.',
            'phone.required' => 'Nomor WhatsApp / telepon wajib diisi.',
            'address.required' => 'Alamat lengkap wajib diisi.',
            'notes.required' => 'Detail / alasan pengajuan wajib diisi.',
            'document.mimes' => 'Lampiran dokumen harus format JPG, PNG, atau PDF.',
            'document.max' => 'Ukuran file lampiran maksimal 5MB.',
        ]);

        $documentPath = null;
        if ($request->hasFile('document')) {
            $documentPath = $request->file('document')->store('layanan_umat', 'public');
        }

        // Generate unique tracking code (LU-YYYYMMDD-XXXX)
        $trackingCode = 'LU-'.now()->format('Ymd').'-'.strtoupper(Str::random(5));

        $application = ServiceApplication::create([
            'service_id' => $validated['service_id'] ?? null,
            'tracking_code' => $trackingCode,
            'applicant_name' => $validated['applicant_name'],
            'nik' => $validated['nik'] ?? null,
            'phone' => $validated['phone'],
            'address' => $validated['address'],
            'service_name' => $validated['service_name'],
            'notes' => $validated['notes'],
            'document_path' => $documentPath ? '/storage/'.$documentPath : null,
            'status' => 'pending',
        ]);

        return back()->with([
            'flash' => [
                'message' => 'Pengajuan berhasil dikirim! Simpan Kode Resi Tracking Anda: '.$trackingCode,
                'tracking_code' => $trackingCode,
                'status' => 'pending',
            ],
        ]);
    }

    /**
     * API Tracking status check by tracking code or phone number.
     */
    public function trackApplication(Request $request)
    {
        $query = $request->input('q');

        if (! $query) {
            return response()->json(['success' => false, 'message' => 'Masukkan Kode Resi Tracking atau Nomor WhatsApp.'], 400);
        }

        $results = ServiceApplication::where('tracking_code', $query)
            ->orWhere('phone', $query)
            ->orWhere('nik', $query)
            ->orderBy('created_at', 'desc')
            ->get();

        if ($results->isEmpty()) {
            return response()->json([
                'success' => false,
                'message' => 'Data pengajuan dengan Kode Resi / Nomor WA tersebut belum ditemukan di PIMASJID.',
            ], 44);
        }

        return response()->json([
            'success' => true,
            'applications' => $results->map(function ($app) {
                return [
                    'tracking_code' => $app->tracking_code,
                    'applicant_name' => $app->applicant_name,
                    'service_name' => $app->service_name,
                    'status' => $app->status,
                    'status_label' => match ($app->status) {
                        'pending' => 'Menunggu Verifikasi DKM',
                        'approved' => 'Disetujui / Dalam Proses',
                        'rejected' => 'Ditolak / Belum Memenuhi Syarat',
                        'completed' => 'Selesai',
                        default => $app->status,
                    },
                    'admin_notes' => $app->admin_notes,
                    'created_at' => $app->created_at ? $app->created_at->translatedFormat('d F Y, H:i') : '-',
                    'processed_at' => $app->processed_at ? $app->processed_at->translatedFormat('d F Y, H:i') : null,
                ];
            }),
        ]);
    }

    /**
     * Display Admin dashboard to manage Layanan Umat & applications.
     */
    public function adminIndex(Request $request): Response
    {
        $services = Service::withCount('applications')->orderBy('created_at', 'desc')->get();
        $applications = ServiceApplication::with('service')
            ->orderBy('created_at', 'desc')
            ->paginate(15)
            ->through(fn ($app) => [
                'id' => $app->id,
                'tracking_code' => $app->tracking_code,
                'applicant_name' => $app->applicant_name,
                'nik' => $app->nik,
                'phone' => $app->phone,
                'address' => $app->address,
                'service_name' => $app->service_name,
                'notes' => $app->notes,
                'document_path' => $app->document_path,
                'status' => $app->status,
                'admin_notes' => $app->admin_notes,
                'created_at' => $app->created_at ? $app->created_at->format('d M Y H:i') : '-',
                'processed_at' => $app->processed_at ? $app->processed_at->format('d M Y H:i') : null,
            ]);

        return Inertia::render('Admin/LayananUmat/Index', [
            'services' => $services,
            'applications' => $applications,
        ]);
    }

    /**
     * Admin store new service.
     */
    public function storeService(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'category' => 'required|string|max:50',
            'icon' => 'nullable|string|max:100',
            'short_description' => 'nullable|string',
            'description' => 'nullable|string',
            'terms' => 'nullable|string',
            'how_to_apply' => 'nullable|string',
            'external_link' => 'nullable|string|max:255',
            'is_active' => 'boolean',
            'is_featured' => 'boolean',
        ]);

        $validated['slug'] = Str::slug($validated['title']).'-'.Str::random(4);

        Service::create($validated);

        return back()->with('success', 'Master Layanan Umat berhasil ditambahkan!');
    }

    /**
     * Admin update existing service.
     */
    public function updateService(Request $request, Service $service)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'category' => 'required|string|max:50',
            'icon' => 'nullable|string|max:100',
            'short_description' => 'nullable|string',
            'description' => 'nullable|string',
            'terms' => 'nullable|string',
            'how_to_apply' => 'nullable|string',
            'external_link' => 'nullable|string|max:255',
            'is_active' => 'boolean',
            'is_featured' => 'boolean',
        ]);

        if ($service->title !== $validated['title']) {
            $validated['slug'] = Str::slug($validated['title']).'-'.Str::random(4);
        }

        $service->update($validated);

        return back()->with('success', 'Layanan Umat berhasil diperbarui!');
    }

    /**
     * Admin delete service.
     */
    public function deleteService(Service $service)
    {
        $service->delete();

        return back()->with('success', 'Layanan Umat berhasil dihapus!');
    }

    /**
     * Admin process applicant submission status (approve/reject/complete).
     */
    public function updateApplicationStatus(Request $request, ServiceApplication $application)
    {
        $validated = $request->validate([
            'status' => 'required|in:pending,approved,rejected,completed',
            'admin_notes' => 'nullable|string',
        ]);

        $application->update([
            'status' => $validated['status'],
            'admin_notes' => $validated['admin_notes'] ?? null,
            'processed_by' => auth()->id(),
            'processed_at' => now(),
        ]);

        return back()->with('success', 'Status pengajuan '.$application->tracking_code.' berhasil diperbarui!');
    }
}
