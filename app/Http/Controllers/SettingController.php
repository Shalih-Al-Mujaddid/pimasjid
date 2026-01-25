<?php

namespace App\Http\Controllers;

use App\Models\Setting;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

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
                // Delete old image if exists (from public folder)
                if ($setting->value) {
                    $oldPath = public_path(ltrim($setting->value, '/'));
                    if (file_exists($oldPath)) {
                        unlink($oldPath);
                    }
                }
                
                // Generate unique filename
                $filename = Str::random(40) . '.' . $item['file']->getClientOriginalExtension();
                $destinationPath = public_path('storage/settings');
                
                // Ensure directory exists
                if (!file_exists($destinationPath)) {
                    mkdir($destinationPath, 0755, true);
                }
                
                // Move file directly to public folder
                $item['file']->move($destinationPath, $filename);
                
                // Also copy to storage/app/public for consistency
                $storagePath = storage_path('app/public/settings');
                if (!file_exists($storagePath)) {
                    mkdir($storagePath, 0755, true);
                }
                copy($destinationPath . '/' . $filename, $storagePath . '/' . $filename);
                
                $setting->value = '/storage/settings/' . $filename;
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
