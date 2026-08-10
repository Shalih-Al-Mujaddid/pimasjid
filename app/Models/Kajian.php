<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Kajian extends Model
{
    use HasFactory;

    protected $guarded = ['id'];

    protected $appends = ['banner_url', 'ustaz_photo_url'];

    protected function bannerUrl(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->banner
                ? (str_starts_with($this->banner, 'http') ? $this->banner : asset('storage/'.$this->banner))
                : null,
        );
    }

    protected function ustazPhotoUrl(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->ustaz_photo
                ? (str_starts_with($this->ustaz_photo, 'http') ? $this->ustaz_photo : asset('storage/'.$this->ustaz_photo))
                : null,
        );
    }
}
