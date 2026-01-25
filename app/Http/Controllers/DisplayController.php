<?php

namespace App\Http\Controllers;

use App\Models\Transaction;
use App\Models\Slide;
use App\Models\Wishlist;
use Carbon\Carbon;
use Illuminate\Support\Facades\Http;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class DisplayController extends Controller
{
    /**
     * Display the TV digital signage page.
     */
    public function index(): Response
    {
        $now = now();
        
        // Get today's prayer times from API
        $todayPrayerTimes = $this->getPrayerTimes();
        
        // Calculate next prayer
        $nextPrayer = $this->getNextPrayer($todayPrayerTimes, $now);
        
        // Check if today is Friday
        $isFriday = $now->isFriday();
        $fridaySchedule = null;
        
        if ($isFriday) {
            // Get Friday prayer schedule (mock for now, can be replaced with DB)
            $fridaySchedule = [
                'date' => $this->getNextFriday(),
                'khatib' => 'Ustadz Ahmad Dahlan, Lc',
                'imam' => 'H. Muhammad Ridwan',
                'muadzin' => 'Sdr. Ali Rahman',
            ];
        }
        
        // Get active slides ordered by sequence
        $slides = Slide::active()
            ->ordered()
            ->get()
            ->map(fn($slide) => [
                'id' => $slide->id,
                'title' => $slide->title,
                'content' => $slide->content,
                'image_url' => $slide->image_url,
            ]);
        
        // Get recent verified donations (last 10)
        $recentDonations = Transaction::income()
            ->latest()
            ->take(10)
            ->get()
            ->map(fn($transaction) => [
                'id' => $transaction->id,
                'category' => $transaction->category,
                'amount' => $transaction->formatted_amount,
                'date' => $transaction->date->format('d M Y'),
            ]);
        
        // Monthly financial stats
        $monthlyIncome = Transaction::income()->thisMonth()->sum('amount');
        $monthlyExpense = Transaction::expense()->thisMonth()->sum('amount');
        
        // Active wishlists with progress
        $wishlists = Wishlist::active()
            ->latest()
            ->take(3)
            ->get()
            ->map(fn($wishlist) => [
                'id' => $wishlist->id,
                'item_name' => $wishlist->item_name,
                'target_qty' => $wishlist->target_qty,
                'fulfilled_qty' => $wishlist->fulfilled_qty,
                'progress_percentage' => $wishlist->progress_percentage,
                'formatted_total_target' => $wishlist->formatted_total_target,
                'formatted_total_fulfilled' => $wishlist->formatted_total_fulfilled,
            ]);
        
        return Inertia::render('Display/Index', [
            'currentTime' => $now->toIso8601String(),
            'todayPrayerTimes' => $todayPrayerTimes ? [
                'date' => $now->translatedFormat('l, d F Y'),
                'hijri_date' => null, // Can be enhanced later with Hijri API
                'subuh' => $todayPrayerTimes['Subuh'] ?? '04:30',
                'sunrise' => $todayPrayerTimes['Sunrise'] ?? '05:45',
                'dhuhr' => $todayPrayerTimes['Dzuhur'] ?? '12:05',
                'asr' => $todayPrayerTimes['Ashar'] ?? '15:20',
                'maghrib' => $todayPrayerTimes['Maghrib'] ?? '18:10',
                'isha' => $todayPrayerTimes['Isya'] ?? '19:25',
            ] : null,
            'nextPrayer' => $nextPrayer,
            'isFriday' => $isFriday,
            'fridaySchedule' => $fridaySchedule,
            'slides' => $slides,
            'recentDonations' => $recentDonations,
            'monthlyStats' => [
                'income' => number_format($monthlyIncome, 0, ',', '.'),
                'expense' => number_format($monthlyExpense, 0, ',', '.'),
                'balance' => number_format($monthlyIncome - $monthlyExpense, 0, ',', '.'),
            ],
            'wishlists' => $wishlists,
        ]);
    }
    
    /**
     * Get prayer times from API with fallback
     */
    private function getPrayerTimes()
    {
        try {
            // Get location from settings
            $latitude = setting('location_latitude', '-6.200000');
            $longitude = setting('location_longitude', '106.816666');
            
            $date = now()->format('d-m-Y');
            $response = Http::timeout(3)->get("http://api.aladhan.com/v1/timings/$date", [
                'latitude' => $latitude,
                'longitude' => $longitude,
                'method' => 11, //  Majlis Ugama Islam Singapura
            ]);

            if ($response->successful()) {
                $timings = $response->json('data.timings');
                return [
                    'Subuh' => $timings['Fajr'],
                    'Sunrise' => $timings['Sunrise'],
                    'Dzuhur' => $timings['Dhuhr'],
                    'Ashar' => $timings['Asr'],
                    'Maghrib' => $timings['Maghrib'],
                    'Isya' => $timings['Isha'],
                    'date' => now()->translatedFormat('l, d F Y')
                ];
            }
        } catch (\Exception $e) {
            // Fallback below
        }

        // Static fallback
        return [
            'Subuh' => '04:30',
            'Sunrise' => '05:45',
            'Dzuhur' => '12:05',
            'Ashar' => '15:20',
            'Maghrib' => '18:10',
            'Isya' => '19:25',
            'date' => now()->translatedFormat('l, d F Y')
        ];
    }
    
    /**
     * Calculate the next prayer from current time.
     */
    private function getNextPrayer(?array $prayerTimes, Carbon $now): ?array
    {
        if (!$prayerTimes) {
            return null;
        }
        
        $prayers = [
            'Subuh' => $prayerTimes['Subuh'],
            'Dhuhr' => $prayerTimes['Dzuhur'],
            'Asr' => $prayerTimes['Ashar'],
            'Maghrib' => $prayerTimes['Maghrib'],
            'Isha' => $prayerTimes['Isya'],
        ];
        
        $today = $now->format('Y-m-d');
        
        foreach ($prayers as $name => $time) {
            // Create Carbon instance for prayer time today
            $prayerDateTime = Carbon::parse("$today $time");
            
            // If prayer time is in the future
            if ($now->lt($prayerDateTime)) {
                return [
                    'name' => $name,
                    'time' => $prayerDateTime->format('H:i'),
                    'tomorrow' => false,
                ];
            }
        }
        
        // If all prayers have passed, next prayer is tomorrow's Subuh
        return [
            'name' => 'Subuh',
            'time' => Carbon::parse($prayerTimes['Subuh'])->format('H:i'),
            'tomorrow' => true,
        ];
    }
    
    private function getNextFriday()
    {
        $now = now();
        if ($now->dayOfWeek === Carbon::FRIDAY) {
            return $now->translatedFormat('d F Y');
        }
        return $now->next(Carbon::FRIDAY)->translatedFormat('d F Y');
    }
}
