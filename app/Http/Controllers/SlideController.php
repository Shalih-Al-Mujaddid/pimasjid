<?php

namespace App\Http\Controllers;

use App\Models\Slide;
use App\Services\CloudinaryService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Inertia\Inertia;

class SlideController extends Controller
{
    public function index()
    {
        Gate::authorize('manage_operations');

        $slides = Slide::orderBy('order')->get()->map(fn ($slide) => [
            'id' => $slide->id,
            'title' => $slide->title,
            'image_url' => $slide->image_url,
            'order' => $slide->order,
            'is_active' => $slide->is_active,
            'created_at' => $slide->created_at,
            'formatted_date' => $slide->created_at ? $slide->created_at->translatedFormat('d F Y') : 'Baru saja',
        ]);

        return Inertia::render('Slides/Index', [
            'slides' => $slides,
        ]);
    }

    public function store(Request $request)
    {
        Gate::authorize('manage_operations');

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'image' => 'required|image|max:5120',
            'order' => 'nullable|integer',
        ]);

        $imagePath = null;
        $cloudinaryPublicId = null;

        if (env('CLOUDINARY_URL')) {
            $result = CloudinaryService::upload($request->file('image'), 'slides');
            $imagePath = $result['url'];
            $cloudinaryPublicId = $result['public_id'];
        } else {
            $imagePath = $request->file('image')->store('slides', 'public');
        }

        Slide::create([
            'title' => $validated['title'],
            'image_path' => $imagePath,
            'cloudinary_public_id' => $cloudinaryPublicId,
            'order' => $validated['order'] ?? Slide::max('order') + 1,
            'is_active' => true,
        ]);

        return redirect()->back()->with('success', 'Slide ditambahkan!');
    }

    public function toggleActive(Slide $slide)
    {
        Gate::authorize('manage_operations');

        $slide->update(['is_active' => ! $slide->is_active]);

        return redirect()->back();
    }

    public function update(Request $request, Slide $slide)
    {
        Gate::authorize('manage_operations');

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'image' => 'nullable|image|max:5120',
            'order' => 'nullable|integer',
        ]);

        $data = [
            'title' => $validated['title'],
            'order' => $validated['order'] ?? $slide->order,
        ];

        if ($request->hasFile('image')) {
            if (env('CLOUDINARY_URL')) {
                // Delete old image from Cloudinary
                if ($slide->cloudinary_public_id) {
                    CloudinaryService::delete($slide->cloudinary_public_id);
                }
                // Upload new image
                $result = CloudinaryService::upload($request->file('image'), 'slides');
                $data['image_path'] = $result['url'];
                $data['cloudinary_public_id'] = $result['public_id'];
            } else {
                if ($slide->image_path && ! str_starts_with($slide->image_path, 'http')) {
                    \Illuminate\Support\Facades\Storage::disk('public')->delete($slide->image_path);
                }
                $data['image_path'] = $request->file('image')->store('slides', 'public');
            }
        }

        $slide->update($data);

        return redirect()->back()->with('success', 'Slide diperbarui!');
    }

    public function destroy(Slide $slide)
    {
        Gate::authorize('manage_operations');

        if (env('CLOUDINARY_URL')) {
            if ($slide->cloudinary_public_id) {
                CloudinaryService::delete($slide->cloudinary_public_id);
            }
        } else {
            // Delete local file
            if ($slide->image_path) \Illuminate\Support\Facades\Storage::disk('public')->delete($slide->image_path);
        }

        $slide->delete();

        return redirect()->back()->with('success', 'Slide dihapus!');
    }
}
