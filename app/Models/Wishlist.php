<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Wishlist extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'item_name',
        'target_qty',
        'fulfilled_qty',
        'unit_price',
        'status',
        'description',
    ];

    /**
     * The accessors to append to the model's array form.
     *
     * @var array<int, string>
     */
    protected $appends = [
        'total_target',
        'total_fulfilled',
        'remaining_qty',
        'progress_percentage',
        'formatted_unit_price',
        'formatted_total_target',
        'formatted_total_fulfilled',
        'status_label',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'target_qty' => 'integer',
            'fulfilled_qty' => 'integer',
            'unit_price' => 'decimal:2',
        ];
    }

    /**
     * Get all contributions for this wishlist.
     */
    public function contributions(): HasMany
    {
        return $this->hasMany(WishlistContribution::class);
    }

    /**
     * Get verified contributions for this wishlist.
     */
    public function verifiedContributions(): HasMany
    {
        return $this->hasMany(WishlistContribution::class)->where('status', 'verified');
    }

    /**
     * Recalculate fulfilled_qty based on verified contributions.
     */
    public function recalculateProgress(): void
    {
        $verifiedQty = (int) $this->verifiedContributions()->sum('quantity');
        $this->fulfilled_qty = max(0, $verifiedQty);

        if ($this->fulfilled_qty >= $this->target_qty && $this->status === 'active') {
            $this->status = 'completed';
        } elseif ($this->fulfilled_qty < $this->target_qty && $this->status === 'completed') {
            $this->status = 'active';
        }

        $this->save();
    }

    /**
     * Get total target amount accessor.
     */
    protected function totalTarget(): Attribute
    {
        return Attribute::make(
            get: fn () => (float) ($this->target_qty * $this->unit_price),
        );
    }

    /**
     * Get total fulfilled amount accessor.
     */
    protected function totalFulfilled(): Attribute
    {
        return Attribute::make(
            get: fn () => (float) ($this->fulfilled_qty * $this->unit_price),
        );
    }

    /**
     * Get remaining quantity accessor.
     */
    protected function remainingQty(): Attribute
    {
        return Attribute::make(
            get: fn () => max(0, $this->target_qty - $this->fulfilled_qty),
        );
    }

    /**
     * Get progress percentage accessor.
     */
    protected function progressPercentage(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->target_qty > 0
                ? min(100, round(($this->fulfilled_qty / $this->target_qty) * 100, 1))
                : 0,
        );
    }

    /**
     * Get formatted unit price accessor.
     */
    protected function formattedUnitPrice(): Attribute
    {
        return Attribute::make(
            get: fn () => 'Rp '.number_format((float) $this->unit_price, 0, ',', '.'),
        );
    }

    /**
     * Get formatted total target accessor.
     */
    protected function formattedTotalTarget(): Attribute
    {
        return Attribute::make(
            get: fn () => 'Rp '.number_format((float) $this->total_target, 0, ',', '.'),
        );
    }

    /**
     * Get formatted total fulfilled accessor.
     */
    protected function formattedTotalFulfilled(): Attribute
    {
        return Attribute::make(
            get: fn () => 'Rp '.number_format((float) $this->total_fulfilled, 0, ',', '.'),
        );
    }

    /**
     * Get status label accessor.
     */
    protected function statusLabel(): Attribute
    {
        return Attribute::make(
            get: fn () => match ($this->status) {
                'active' => 'Aktif',
                'pending' => 'Menunggu',
                'completed' => 'Selesai',
                'cancelled' => 'Dibatalkan',
                default => 'Unknown',
            },
        );
    }

    /**
     * Scope to filter active wishlists.
     */
    public function scopeActive(Builder $query): void
    {
        $query->where('status', 'active');
    }

    /**
     * Scope to filter completed wishlists.
     */
    public function scopeCompleted(Builder $query): void
    {
        $query->where('status', 'completed');
    }

    /**
     * Scope to filter pending wishlists.
     */
    public function scopePending(Builder $query): void
    {
        $query->where('status', 'pending');
    }

    /**
     * Scope to order by creation date descending.
     */
    public function scopeLatest(Builder $query): void
    {
        $query->orderBy('created_at', 'desc');
    }
}
