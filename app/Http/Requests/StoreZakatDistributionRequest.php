<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreZakatDistributionRequest extends FormRequest
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
            'mustahik_name' => 'required|string|max:255',
            'mustahik_category' => 'required|in:fakir,miskin,amil,muallaf,riqab,gharim,sabilillah,ibnu_sabil',
            'amount' => 'required|numeric|min:0',
            'type' => 'required|in:uang,beras',
            'rice_kg' => 'nullable|numeric|min:0',
            'year' => 'required|integer',
            'date' => 'required|date',
            'notes' => 'nullable|string',
        ];
    }
}
