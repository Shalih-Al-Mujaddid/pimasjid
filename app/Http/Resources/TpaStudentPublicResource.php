<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TpaStudentPublicResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nama_anak' => $this->nama_anak,
            'jenis_kelamin' => $this->jenis_kelamin,
            'tingkat_sekolah' => $this->tingkat_sekolah,
            'photo_path' => $this->photo_path,
            'status' => $this->status,
            'kelas' => $this->kelas,
            'ustadz' => $this->ustadz,
            'progres' => $this->progres,
        ];
    }
}
