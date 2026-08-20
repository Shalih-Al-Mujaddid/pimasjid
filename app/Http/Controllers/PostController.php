<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class PostController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $posts = Post::with('author')
            ->latest('published_at')
            ->get();

        return Inertia::render('Posts/Index', [
            'posts' => $posts,
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
            'photo' => 'nullable|image|max:2048',
            'is_published' => 'boolean',
            'published_at' => 'nullable|date',
        ]);

        $imagePath = null;

        if ($request->hasFile('photo')) {
            $imagePath = $request->file('photo')->store('posts', 'public');
        }

        $excerpt = $validated['excerpt'];
        if (empty($excerpt)) {
            $excerpt = strip_tags($validated['content']);
            $excerpt = mb_substr($excerpt, 0, 160).(mb_strlen($excerpt) > 160 ? '...' : '');
        }

        Post::create([
            'title' => $validated['title'],
            'excerpt' => $excerpt,
            'content' => $validated['content'],
            'image_path' => $imagePath,
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
            if ($post->image_path && ! str_starts_with($post->image_path, 'http')) {
                Storage::disk('public')->delete($post->image_path);
            }
            $post->image_path = $request->file('photo')->store('posts', 'public');
        }

        $post->title = $validated['title'];
        $post->excerpt = $validated['excerpt'];

        if (empty($post->excerpt)) {
            $excerpt = strip_tags($validated['content']);
            $post->excerpt = mb_substr($excerpt, 0, 160).(mb_strlen($excerpt) > 160 ? '...' : '');
        }

        $post->content = $validated['content'];
        $post->is_published = $validated['is_published'];

        if (isset($validated['published_at'])) {
            $post->published_at = $validated['published_at'];
        } elseif ($post->is_published && ! $post->published_at) {
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
        if ($post->image_path && ! str_starts_with($post->image_path, 'http')) {
            Storage::disk('public')->delete($post->image_path);
        }

        $post->delete();

        return redirect()->back()->with('success', 'Berita berhasil dihapus.');
    }
}
