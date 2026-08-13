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
            get: fn () => asset('storage/' . $this->banner),
        );
    }

    protected function ustazPhotoUrl(): Attribute
    {
        return Attribute::make(
            get: fn () => asset('storage/' . $this->ustaz_photo),
        );
    }
}
