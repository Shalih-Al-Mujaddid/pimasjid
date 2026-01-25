<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreQurbanRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return auth()->check();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'participant_name' => 'required|string|max:255',
            'participant_nik' => 'nullable|string|max:20',
            'participant_phone' => 'required|string|max:20',
            'participant_address' => 'nullable|string',
            'animal_type' => 'required|in:kambing,domba,sapi,kerbau,unta',
            'animal_weight' => 'nullable|numeric|min:0',
            'animal_price' => 'required|numeric|min:0',
            'is_shared' => 'required|boolean',
            'share_count' => 'nullable|integer|min:1|max:7',
            'share_position' => 'nullable|integer|min:1',
            'share_group_id' => 'nullable|string',
            'year' => 'required|integer',
            'registration_date' => 'required|date',
            'notes' => 'nullable|string',
        ];
    }
}
