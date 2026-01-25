<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class PostController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $posts = Post::with('author')
            ->latest('published_at')
            ->get(); // Pagination can be added later if needed

        return Inertia::render('Posts/Index', [
            'posts' => $posts
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'excerpt' => 'nullable|string',
            'content' => 'required|string',
            'photo' => 'nullable|image|max:2048', // 2MB Max
            'is_published' => 'boolean',
            'published_at' => 'nullable|date',
        ]);

        $path = null;
        if ($request->hasFile('photo')) {
            $path = $request->file('photo')->store('posts', 'public');
        }

        Post::create([
            'title' => $validated['title'],
            'excerpt' => $validated['excerpt'],
            'content' => $validated['content'],
            'image_path' => $path,
            'is_published' => $validated['is_published'] ?? false,
            'published_at' => $validated['published_at'] ?? (($validated['is_published'] ?? false) ? now() : null),
            'author_id' => auth()->id(),
        ]);

        return redirect()->back()->with('success', 'Berita berhasil ditambahkan.');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Post $post)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'excerpt' => 'nullable|string',
            'content' => 'required|string',
            'photo' => 'nullable|image|max:2048',
            'is_published' => 'boolean',
            'published_at' => 'nullable|date',
        ]);

        if ($request->hasFile('photo')) {
            // Delete old
            if ($post->image_path && Storage::disk('public')->exists($post->image_path)) {
                Storage::disk('public')->delete($post->image_path);
            }
            $post->image_path = $request->file('photo')->store('posts', 'public');
        }

        $post->title = $validated['title']; // Mutator creates slug automatically if needed, but we might want to keep slug stable... actually Mutator runs on set.
        // Let's rely on mutator for slug update or keep it simple.
        
        $post->excerpt = $validated['excerpt'];
        $post->content = $validated['content'];
        $post->is_published = $validated['is_published'];
        
        // Update published_at: use custom value if provided, otherwise set to now if publishing
        if (isset($validated['published_at'])) {
            $post->published_at = $validated['published_at'];
        } elseif ($post->is_published && !$post->published_at) {
            $post->published_at = now();
        }
        
        $post->save();

        return redirect()->back()->with('success', 'Berita berhasil diperbarui.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Post $post)
    {
        if ($post->image_path && Storage::disk('public')->exists($post->image_path)) {
            Storage::disk('public')->delete($post->image_path);
        }
        
        $post->delete();

        return redirect()->back()->with('success', 'Berita berhasil dihapus.');
    }
}
