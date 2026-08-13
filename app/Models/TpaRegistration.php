<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TpaRegistration extends Model
{
    protected $fillable = [
        'nama_anak',
        'tempat_lahir',
        'tanggal_lahir',
        'jenis_kelamin',
        'tingkat_sekolah',
        'nama_ortu',
        'no_wa',
        'alamat',
        'photo_path',
        'status',
        'approved_at',
        'kelas',
        'ustadz',
        'progres',
    ];

    protected $appends = ['photo_url'];

    protected $casts = [
        'tanggal_lahir' => 'date',
        'approved_at' => 'datetime',
    ];

    protected static function booted(): void
    {
        static::updating(function (TpaRegistration $registration) {
            if ($registration->isDirty('status') && $registration->getOriginal('status') === 'approved' && $registration->status !== 'approved') {
                $registration->approved_at = null;
            }
        });
    }

    public function getPhotoUrlAttribute()
    {
        $fallback = 'https://ui-avatars.com/api/?name='.urlencode($this->nama_anak).'&size=200&background=059669&color=fff';

        return storage_url($this->photo_path, $fallback);
    }
}
