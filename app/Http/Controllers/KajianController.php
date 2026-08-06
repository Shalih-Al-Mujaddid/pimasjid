<?php

namespace App\Http\Controllers;

use App\Models\Kajian;
use App\Services\CloudinaryService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Inertia\Inertia;

class KajianController extends Controller
{
    // Public Endpoints
    public function publicIndex(Request $request)
    {
        $query = Kajian::query();

        // Search by title or ustaz_name
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('ustaz_name', 'like', "%{$search}%");
            });
        }

        // Filter by status
        if ($request->filled('status') && $request->status !== 'semua') {
            $query->where('status', $request->status);
        }

        // Order by date and time
        $query->orderBy('date', 'desc')->orderBy('time', 'desc');

        $kajians = $query->paginate(9)->withQueryString()->through(fn ($kajian) => [
            'id' => $kajian->id,
            'title' => $kajian->title,
            'theme' => $kajian->theme,
            'ustaz_name' => $kajian->ustaz_name,
            'date' => $kajian->date,
            'time' => $kajian->time,
            'location' => $kajian->location,
            'banner' => $kajian->banner,
            'status' => $kajian->status,
            'formatted_date' => \Carbon\Carbon::parse($kajian->date)->translatedFormat('l, d F Y'),
        ]);

        return Inertia::render('Public/Kajian/Index', [
            'kajians' => $kajians,
            'filters' => $request->only(['search', 'status']),
        ]);
    }

    public function publicShow(Kajian $kajian)
    {
        return Inertia::render('Public/Kajian/Show', [
            'kajian' => [
                'id' => $kajian->id,
                'title' => $kajian->title,
                'theme' => $kajian->theme,
                'ustaz_name' => $kajian->ustaz_name,
                'ustaz_photo' => $kajian->ustaz_photo,
                'ustaz_topic' => $kajian->ustaz_topic,
                'ustaz_bio' => $kajian->ustaz_bio,
                'date' => $kajian->date,
                'time' => $kajian->time,
                'location' => $kajian->location,
                'description' => $kajian->description,
                'banner' => $kajian->banner,
                'video_url' => $kajian->video_url,
                'status' => $kajian->status,
                'formatted_date' => \Carbon\Carbon::parse($kajian->date)->translatedFormat('l, d F Y'),
            ],
        ]);
    }

    // Admin Endpoints
    public function index()
    {
        Gate::authorize('manage_operations');

        $kajians = Kajian::orderBy('date', 'desc')->orderBy('time', 'desc')->paginate(10);

        return Inertia::render('Admin/Kajian/Index', [
            'kajians' => $kajians,
        ]);
    }

    public function store(Request $request)
{
    dd([
        'all' => $request->all(),
        'files' => $request->allFiles(),
        'banner' => $request->file('banner_image'),
        'ustaz' => $request->file('ustaz_image'),
    ]);

    Gate::authorize('manage_operations');

    $validated = $request->validate([
            'title' => 'required|string|max:255',
            'theme' => 'nullable|string|max:255',
            'ustaz_name' => 'required|string|max:255',
            'ustaz_topic' => 'nullable|string|max:255',
            'ustaz_bio' => 'nullable|string',
            'date' => 'required|date',
            'time' => 'required',
            'location' => 'required|string|max:255',
            'description' => 'nullable|string',
            'video_url' => 'nullable|url',
            'status' => 'required|in:akan_datang,berlangsung,selesai',
            'banner_image' => 'nullable|image|max:5120',
            'ustaz_image' => 'nullable|image|max:5120',
        ]);

        $data = collect($validated)->except(['banner_image', 'ustaz_image'])->toArray();

        if ($request->hasFile('banner_image')) {
            if (env('CLOUDINARY_URL')) {
                $result = CloudinaryService::upload($request->file('banner_image'), 'kajian_banners');
                $data['banner'] = $result['url'];
                $data['banner_public_id'] = $result['public_id'];
            } else {
                $data['banner'] = $request->file('banner_image')->store('kajian_banners', 'public');
            }
        }

        if ($request->hasFile('ustaz_image')) {
            if (env('CLOUDINARY_URL')) {
                $result = CloudinaryService::upload($request->file('ustaz_image'), 'kajian_ustaz');
                $data['ustaz_photo'] = $result['url'];
                $data['ustaz_photo_public_id'] = $result['public_id'];
            } else {
                $data['ustaz_photo'] = $request->file('ustaz_image')->store('kajian_ustaz', 'public');
            }
        }

        Kajian::create($data);

        return redirect()->back()->with('success', 'Kajian berhasil ditambahkan!');
    }

    public function update(Request $request, Kajian $kajian)
    {
        Gate::authorize('manage_operations');

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'theme' => 'nullable|string|max:255',
            'ustaz_name' => 'required|string|max:255',
            'ustaz_topic' => 'nullable|string|max:255',
            'ustaz_bio' => 'nullable|string',
            'date' => 'required|date',
            'time' => 'required',
            'location' => 'required|string|max:255',
            'description' => 'nullable|string',
            'video_url' => 'nullable|url',
            'status' => 'required|in:akan_datang,berlangsung,selesai',
            'banner_image' => 'nullable|image|max:5120',
            'ustaz_image' => 'nullable|image|max:5120',
        ]);

        $data = collect($validated)->except(['banner_image', 'ustaz_image'])->toArray();

        if ($request->hasFile('banner_image')) {
            if (env('CLOUDINARY_URL')) {
                if ($kajian->banner_public_id) {
                    CloudinaryService::delete($kajian->banner_public_id);
                }
                $result = CloudinaryService::upload($request->file('banner_image'), 'kajian_banners');
                $data['banner'] = $result['url'];
                $data['banner_public_id'] = $result['public_id'];
            } else {
                if ($kajian->banner && ! str_starts_with($kajian->banner, 'http')) {
                    \Illuminate\Support\Facades\Storage::disk('public')->delete($kajian->banner);
                }
                $data['banner'] = $request->file('banner_image')->store('kajian_banners', 'public');
            }
        }

        if ($request->hasFile('ustaz_image')) {
            if (env('CLOUDINARY_URL')) {
                if ($kajian->ustaz_photo_public_id) {
                    CloudinaryService::delete($kajian->ustaz_photo_public_id);
                }
                $result = CloudinaryService::upload($request->file('ustaz_image'), 'kajian_ustaz');
                $data['ustaz_photo'] = $result['url'];
                $data['ustaz_photo_public_id'] = $result['public_id'];
            } else {
                if ($kajian->ustaz_photo && ! str_starts_with($kajian->ustaz_photo, 'http')) {
                    \Illuminate\Support\Facades\Storage::disk('public')->delete($kajian->ustaz_photo);
                }
                $data['ustaz_photo'] = $request->file('ustaz_image')->store('kajian_ustaz', 'public');
            }
        }

        $kajian->update($data);

        return redirect()->back()->with('success', 'Kajian berhasil diperbarui!');
    }

    public function destroy(Kajian $kajian)
    {
        Gate::authorize('manage_operations');

        if (env('CLOUDINARY_URL')) {
            if ($kajian->banner_public_id) {
                CloudinaryService::delete($kajian->banner_public_id);
            }
            if ($kajian->ustaz_photo_public_id) {
                CloudinaryService::delete($kajian->ustaz_photo_public_id);
            }
        } else {
            // Hapus file lokal
            if ($kajian->banner) \Illuminate\Support\Facades\Storage::disk('public')->delete($kajian->banner);
            if ($kajian->ustaz_photo) \Illuminate\Support\Facades\Storage::disk('public')->delete($kajian->ustaz_photo);
        }

        $kajian->delete();

        return redirect()->back()->with('success', 'Kajian berhasil dihapus!');
    }
}
