<?php

namespace App\Http\Controllers;

use App\Models\Asset;
use App\Models\PerformanceLog;
use App\Models\Slide;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class DashboardController extends Controller
{
    public function index(): Response
    {
        $user = auth()->user();
        $role = $user->role;
        $dashboardType = $this->getDashboardType($role);

        $stats = $this->getStatsByRole($role);
        $recentTransactions = $this->getRecentTransactions($role);
        $chartData = $this->getChartDataByRole($role);

        return Inertia::render('Dashboard', [
            'userRole' => $role,
            'dashboardType' => $dashboardType,
            'stats' => $stats,
            'recentTransactions' => $recentTransactions,
            'chartData' => $chartData,
            // Additional data specific to roles can be pushed here
        ]);
    }

    private function getDashboardType($role)
    {
        return match ($role) {
            'super_admin' => 'admin',
            'ketua' => 'executive',
            'bendahara' => 'finance',
            'sekretaris' => 'sekretaris',
            'marbot' => 'operations',
            default => 'default',
        };
    }

    private function getStatsByRole($role)
    {
        // Common Financial Stats
        $totalIncome = Transaction::income()->approved()->sum('amount');
        $totalExpense = Transaction::expense()->approved()->sum('amount');
        $balance = $totalIncome - $totalExpense;

        $baseStats = [
            'formattedBalance' => 'Rp ' . number_format($balance, 0, ',', '.'),
            'balance' => $balance,
        ];

        switch ($role) {
            case 'super_admin':
                return array_merge($baseStats, [
                    'totalUsers' => User::count(),
                    'totalTransactions' => Transaction::count(),
                    'pendingApprovals' => Transaction::pending()->count(),
                    'systemHealth' => 'Online',
                    'monthlyIncome' => $this->getMonthlySum('income'),
                    'monthlyExpense' => $this->getMonthlySum('expense'),
                ]);

            case 'ketua':
                return array_merge($baseStats, [
                    'pendingApprovals' => Transaction::pending()->count(),
                    'totalAssets' => Asset::count(),
                    'monthlyIncome' => $this->getMonthlySum('income'),
                    'monthlyExpense' => $this->getMonthlySum('expense'),
                ]);

            case 'bendahara':
                return array_merge($baseStats, [
                    'formattedMonthlyIncome' => 'Rp ' . number_format($this->getMonthlySum('income'), 0, ',', '.'),
                    'formattedMonthlyExpense' => 'Rp ' . number_format($this->getMonthlySum('expense'), 0, ',', '.'),
                ]);

            case 'sekretaris':
                return array_merge($baseStats, [
                    'totalTransactions' => Transaction::count(),
                    'monthlyIncome' => $this->getMonthlySum('income'),
                    'monthlyExpense' => $this->getMonthlySum('expense'),
                ]);

            case 'marbot':
                $activeSlides = Slide::where('is_active', true)->count();
                $brokenAssets = Asset::where('condition', '!=', 'Baik')->count();
                return [
                    'activeSlides' => $activeSlides,
                    'brokenAssets' => $brokenAssets,
                    'message' => 'Sistem TV Online',
                    'description' => "Saat ini ada $activeSlides slide aktif yang ditampilkan.",
                ];

            default:
                return [];
        }
    }

    private function getRecentTransactions($role)
    {
        if ($role === 'marbot') return [];

        $query = Transaction::with('user');
        
        if ($role === 'ketua') {
            // For Chairperson, prioritize Pending items
            $query->orderByRaw("CASE status 
                WHEN 'pending' THEN 1 
                WHEN 'approved' THEN 2 
                WHEN 'rejected' THEN 3 
                ELSE 4 END");
        }
        
        return $query->latest()
            ->take(10)
            ->get()
            ->map(fn($t) => [
                'id' => $t->id,
                'type' => $t->type,
                'category' => $t->category,
                'amount' => $t->amount,
                'formatted_amount' => $t->formatted_amount,
                'description' => $t->description,
                'status' => $t->status,
                'date' => $t->date->format('d M Y'),
                'user_name' => $t->user->name ?? 'System',
            ]);
    }

    private function getMonthlySum($type)
    {
        return Transaction::where('type', $type)
            ->approved()
            ->whereMonth('date', now()->month)
            ->whereYear('date', now()->year)
            ->sum('amount');
    }

    /**
     * Get chart data based on user role.
     */
    private function getChartDataByRole($role)
    {
        return match ($role) {
            'super_admin' => [
                'financialTrend' => $this->getMonthlyTrends(12),
                'performanceMetrics' => $this->getPerformanceMetrics(),
            ],
            'ketua' => [
                'monthlyTrend' => $this->getMonthlyTrends(6),
                'categoryBreakdown' => $this->getCategoryBreakdown('income'),
            ],
            'sekretaris' => [
                'recentActivities' => $this->getRecentActivities(),
            ],
            'bendahara' => [
                'monthlyComparison' => $this->getMonthlyTrends(6),
                'expenseBreakdown' => $this->getCategoryBreakdown('expense'),
            ],
            default => [],
        };
    }

    /**
     * Get monthly income/expense trends for the last N months.
     */
    private function getMonthlyTrends($months = 12)
    {
        return Cache::remember("dashboard.monthly_trends.{$months}", 300, function () use ($months) {
            $labels = [];
            $income = [];
            $expense = [];

            for ($i = $months - 1; $i >= 0; $i--) {
                $date = now()->subMonths($i);
                $labels[] = $date->format('M Y');

                $monthlyIncome = Transaction::income()
                    ->approved()
                    ->whereYear('date', $date->year)
                    ->whereMonth('date', $date->month)
                    ->sum('amount');

                $monthlyExpense = Transaction::expense()
                    ->approved()
                    ->whereYear('date', $date->year)
                    ->whereMonth('date', $date->month)
                    ->sum('amount');

                $income[] = (float) $monthlyIncome;
                $expense[] = (float) $monthlyExpense;
            }

            return [
                'labels' => $labels,
                'income' => $income,
                'expense' => $expense,
            ];
        });
    }

    /**
     * Get category-wise breakdown for income or expense.
     */
    private function getCategoryBreakdown($type)
    {
        return Cache::remember("dashboard.category_breakdown.{$type}", 300, function () use ($type) {
            $transactions = Transaction::where('type', $type)
                ->approved()
                ->thisMonth()
                ->selectRaw('category, SUM(amount) as total')
                ->groupBy('category')
                ->orderByDesc('total')
                ->get();

            if ($transactions->isEmpty()) {
                return [
                    'labels' => ['Tidak Ada Data'],
                    'amounts' => [0],
                ];
            }

            return [
                'labels' => $transactions->pluck('category')->toArray(),
                'amounts' => $transactions->pluck('total')->map(fn($t) => (float) $t)->toArray(),
            ];
        });
    }

    /**
     * Get recent activities for the secretary dashboard.
     */
    private function getRecentActivities()
    {
        $activities = [];

        // Transaction activities
        $recentTransactions = Transaction::with('user')
            ->approved()
            ->latest()
            ->take(5)
            ->get();

        foreach ($recentTransactions as $tx) {
            $activities[] = [
                'id' => 'tx_' . $tx->id,
                'category' => $tx->type === 'income' ? 'Keuangan' : 'Keuangan',
                'description' => $tx->description,
                'user_name' => $tx->user->name ?? 'System',
                'created_at' => $tx->created_at->format('d M Y, H:i'),
                'icon' => $tx->type === 'income' ? 'BanknotesIcon' : 'BanknotesIcon',
            ];
        }

        // TODO: Add zakat, qurban, and system activities as needed
        // These are placeholder dummy data for UI development

        return $activities;
    }

    /**
     * Get performance metrics for the last 7 days (Super Admin only).
     */
    private function getPerformanceMetrics()
    {
        return Cache::remember('dashboard.performance_metrics', 300, function () {
            $labels = [];
            $responseTime = [];
            $memoryUsage = [];
            $queryCount = [];

            for ($i = 6; $i >= 0; $i--) {
                $date = now()->subDays($i);
                $labels[] = $date->format('D');

                $dailyLogs = PerformanceLog::whereDate('created_at', $date->toDateString())->get();

                $responseTime[] = $dailyLogs->isEmpty() ? 0 : round($dailyLogs->avg('response_time_ms'), 2);
                $memoryUsage[] = $dailyLogs->isEmpty() ? 0 : round($dailyLogs->avg('memory_usage_mb'), 2);
                $queryCount[] = $dailyLogs->isEmpty() ? 0 : round($dailyLogs->avg('query_count'), 2);
            }

            return [
                'labels' => $labels,
                'responseTime' => $responseTime,
                'memoryUsage' => $memoryUsage,
                'queryCount' => $queryCount,
            ];
        });
    }
}
