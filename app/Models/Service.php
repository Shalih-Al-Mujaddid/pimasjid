<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Service extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'slug',
        'category',
        'icon',
        'short_description',
        'description',
        'terms',
        'how_to_apply',
        'external_link',
        'is_active',
        'is_featured',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'is_featured' => 'boolean',
    ];

    public function applications()
    {
        return $this->hasMany(ServiceApplication::class);
    }
}
