<?php

if (! function_exists('setting')) {
    /**
     * Get a setting value by key with optional default
     */
    function setting(string $key, mixed $default = null): mixed
    {
        $setting = \App\Models\Setting::where('key', $key)->first();

        return $setting ? $setting->value : $default;
    }
}

if (! function_exists('storage_url')) {
    /**
     * Format an image or file path to a valid storage URL.
     */
    function storage_url(?string $path, ?string $fallback = null): ?string
    {
        if (empty($path)) {
            return $fallback;
        }

        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) {
            return $path;
        }

        if (str_starts_with($path, '/storage/')) {
            return $path;
        }

        if (str_starts_with($path, 'storage/')) {
            return '/'.$path;
        }

        return '/storage/'.ltrim($path, '/');
    }
}
