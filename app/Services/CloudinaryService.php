<?php

namespace App\Services;

use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
use Illuminate\Http\UploadedFile;

class CloudinaryService
{
    /**
     * Upload file to Cloudinary
     *
     * @return array ['url' => string, 'public_id' => string]
     */
    public static function upload(UploadedFile $file, string $folder = 'general'): array
    {
        $result = Cloudinary::uploadApi()->upload($file->getRealPath(), [
            'folder' => 'pimasjid/'.$folder,
            'resource_type' => 'auto',
        ]);

        return [
            'url' => $result['secure_url'],
            'public_id' => $result['public_id'],
        ];
    }

    /**
     * Delete file from Cloudinary
     */
    public static function delete(string $publicId): bool
    {
        try {
            Cloudinary::uploadApi()->destroy($publicId);

            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * Get optimized URL with transformations
     */
    public static function getUrl(string $publicId, array $options = []): string
    {
        $defaultOptions = [
            'quality' => 'auto',
            'fetch_format' => 'auto',
        ];

        return Cloudinary::image($publicId)
            ->addTransformation(array_merge($defaultOptions, $options))
            ->toUrl();
    }
}
