<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class SettingController extends Controller
{
    public function index()
    {
        $settings = Setting::all()->groupBy('group');

        return Inertia::render('Settings/Index', [
            'settings' => $settings,
        ]);
    }

    public function update(Request $request)
    {
        $data = $request->validate([
            'settings' => 'required|array',
            'settings.*.key' => 'required|exists:settings,key',
            'settings.*.value' => 'nullable',
        ]);

        foreach ($request->settings as $item) {
            $setting = Setting::where('key', $item['key'])->first();

            // Handle Image Upload to Local Storage
            if ($setting->type === 'image' && isset($item['file']) && $item['file'] instanceof \Illuminate\Http\UploadedFile) {
                if ($setting->value && ! str_starts_with($setting->value, 'http')) {
                    Storage::disk('public')->delete($setting->value);
                }
                $setting->value = $item['file']->store('settings', 'public');
            } elseif ($setting->type !== 'image') {
                $setting->value = $item['value'];
            }

            $setting->save();
        }

        // Clear caches
        \Illuminate\Support\Facades\Cache::forget('global_settings');
        \Illuminate\Support\Facades\Cache::forget('global_favicon');

        return redirect()->back()->with('success', 'Pengaturan berhasil diperbarui.');
    }
}
