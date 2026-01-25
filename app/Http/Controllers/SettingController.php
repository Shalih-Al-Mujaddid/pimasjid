<?php

namespace App\Http\Controllers;

use App\Models\Setting;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Storage;

class SettingController extends Controller
{
    public function index()
    {
        $settings = Setting::all()->groupBy('group');
        
        return Inertia::render('Settings/Index', [
            'settings' => $settings
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
            
            // Handle Image Upload
            if ($setting->type === 'image' && isset($item['file']) && $item['file'] instanceof \Illuminate\Http\UploadedFile) {
                // Delete old image if exists
                if ($setting->value && Storage::disk('public')->exists($setting->value)) {
                    Storage::disk('public')->delete($setting->value);
                }
                
                $path = $item['file']->store('settings', 'public');
                $setting->value = '/storage/' . $path;
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
