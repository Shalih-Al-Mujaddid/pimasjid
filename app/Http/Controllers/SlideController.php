<?php

namespace App\Http\Controllers;

use App\Models\Slide;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class SlideController extends Controller
{
    public function index()
    {
        Gate::authorize('manage_operations');
        
        $slides = Slide::orderBy('order')->get()->map(fn($slide) => [
            'id' => $slide->id,
            'title' => $slide->title,
            'image_url' => $slide->image_url,
            'order' => $slide->order,
            'is_active' => $slide->is_active,
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
        
        $path = $request->file('image')->store('slides', 'public');
        
        Slide::create([
            'title' => $validated['title'],
            'image_path' => $path,
            'order' => $validated['order'] ?? Slide::max('order') + 1,
            'is_active' => true,
        ]);
        
        return redirect()->back()->with('success', 'Slide ditambahkan!');
    }
    
    public function toggleActive(Slide $slide)
    {
        Gate::authorize('manage_operations');
        
        $slide->update(['is_active' => !$slide->is_active]);
        
        return redirect()->back();
    }
    
    public function destroy(Slide $slide)
    {
        Gate::authorize('manage_operations');
        
        if ($slide->image_path) {
            Storage::disk('public')->delete($slide->image_path);
        }
        
        $slide->delete();
        
        return redirect()->back()->with('success', 'Slide dihapus!');
    }
}
