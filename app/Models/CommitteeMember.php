<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CommitteeMember extends Model
{
    protected $fillable = [
        'name',
        'position',
        'division',
        'photo_path',
        'cloudinary_public_id',
        'order',
        'is_active',
    ];

    protected $appends = ['photo_url'];

    protected function casts(): array
    {
        return [
            'is_active' => 'boolean',
        ];
    }

    public function getPhotoUrlAttribute()
    {
        $fallback = 'https://ui-avatars.com/api/?name='.urlencode($this->name).'&size=200&background=059669&color=fff';

        return storage_url($this->photo_path, $fallback);
    }
}
