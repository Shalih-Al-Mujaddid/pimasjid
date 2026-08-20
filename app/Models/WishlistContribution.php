<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class WishlistContribution extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'wishlist_id',
        'donor_name',
        'donor_phone',
        'donor_email',
        'quantity',
        'amount',
        'type',
        'proof_image_path',
        'notes',
        'is_anonymous',
        'status',
        'verified_by',
        'verified_at',
        'admin_notes',
    ];

    /**
     * The accessors to append to the model's array form.
     *
     * @var array<int, string>
     */
    protected $appends = [
        'display_donor_name',
        'proof_image_url',
        'formatted_amount',
        'status_label',
        'type_label',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'quantity' => 'integer',
            'amount' => 'decimal:2',
            'is_anonymous' => 'boolean',
            'verified_at' => 'datetime',
        ];
    }

    /**
     * Get the wishlist associated with the contribution.
     */
    public function wishlist(): BelongsTo
    {
        return $this->belongsTo(Wishlist::class);
    }

    /**
     * Get the user who verified the contribution.
     */
    public function verifiedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'verified_by');
    }

    /**
     * Display donor name honoring anonymity for public view.
     */
    protected function displayDonorName(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->is_anonymous ? 'Hamba Allah' : $this->donor_name,
        );
    }

    /**
     * Get proof image URL with storage fallback.
     */
    protected function proofImageUrl(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->proof_image_path ? storage_url($this->proof_image_path) : null,
        );
    }

    /**
     * Formatted amount accessor.
     */
    protected function formattedAmount(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->amount ? 'Rp '.number_format((float) $this->amount, 0, ',', '.') : '-',
        );
    }

    /**
     * Status label accessor.
     */
    protected function statusLabel(): Attribute
    {
        return Attribute::make(
            get: fn () => match ($this->status) {
                'verified' => 'Terverifikasi',
                'pending' => 'Menunggu Verifikasi',
                'rejected' => 'Ditolak',
                default => ucfirst($this->status),
            },
        );
    }

    /**
     * Type label accessor.
     */
    protected function typeLabel(): Attribute
    {
        return Attribute::make(
            get: fn () => match ($this->type) {
                'barang' => 'Barang Fisik',
                'dana' => 'Transfer Dana',
                default => ucfirst($this->type),
            },
        );
    }

    /**
     * Scope pending contributions.
     */
    public function scopePending(Builder $query): void
    {
        $query->where('status', 'pending');
    }

    /**
     * Scope verified contributions.
     */
    public function scopeVerified(Builder $query): void
    {
        $query->where('status', 'verified');
    }

    /**
     * Scope rejected contributions.
     */
    public function scopeRejected(Builder $query): void
    {
        $query->where('status', 'rejected');
    }
}
