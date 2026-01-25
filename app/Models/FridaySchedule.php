<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FridaySchedule extends Model
{
    protected $fillable = [
        'date',
        'khatib',
        'imam',
        'muadzin',
        'bilal',
        'time',
        'title',
    ];

    protected $casts = [
        'date' => 'date',
    ];
}
