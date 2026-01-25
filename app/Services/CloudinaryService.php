<?php

namespace App\Services;

use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
use Illuminate\Http\UploadedFile;

class CloudinaryService
{
    /**
     * Upload file to Cloudinary
     *
     * @param UploadedFile $file
     * @param string $folder
     * @return array ['url' => string, 'public_id' => string]
     */
    public static function upload(UploadedFile $file, string $folder = 'general'): array
    {
        $result = Cloudinary::upload($file->getRealPath(), [
            'folder' => 'pimasjid/' . $folder,
            'resource_type' => 'auto',
        ]);

        return [
            'url' => $result->getSecurePath(),
            'public_id' => $result->getPublicId(),
        ];
    }

    /**
     * Delete file from Cloudinary
     *
     * @param string $publicId
     * @return bool
     */
    public static function delete(string $publicId): bool
    {
        try {
            Cloudinary::destroy($publicId);
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * Get optimized URL with transformations
     *
     * @param string $publicId
     * @param array $options
     * @return string
     */
    public static function getUrl(string $publicId, array $options = []): string
    {
        $defaultOptions = [
            'quality' => 'auto',
            'fetch_format' => 'auto',
        ];

        return Cloudinary::getUrl($publicId, array_merge($defaultOptions, $options));
    }
}
