<script setup>
import { ref } from 'vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import Card from '@/Components/Card.vue';
import StatCard from '@/Components/StatCard.vue';
import Badge from '@/Components/Badge.vue';
import ModernTable from '@/Components/ModernTable.vue';
import { Head } from '@inertiajs/vue3';
import { 
    BanknotesIcon, 
    ArrowTrendingUpIcon, 
    UsersIcon,
    ChartBarIcon,
} from '@heroicons/vue/24/outline';

// Sample table data
const columns = ref([
    { key: 'id', label: 'ID', sortable: true },
    { key: 'date', label: 'Tanggal', sortable: true },
    { key: 'category', label: 'Kategori', sortable: false },
    { key: 'amount', label: 'Jumlah', sortable: true },
    { key: 'status', label: 'Status', sortable: false },
]);

const transactions = ref([
    { id: 1, date: '2026-01-20', category: 'Kotak Jumat', amount: 'Rp 1.500.000', status: 'verified' },
    { id: 2, date: '2026-01-19', category: 'Infaq', amount: 'Rp 500.000', status: 'verified' },
    { id: 3, date: '2026-01-18', category: 'Operasional', amount: 'Rp 750.000', status: 'pending' },
    { id: 4, date: '2026-01-17', category: 'Renovasi', amount: 'Rp 2.000.000', status: 'verified' },
]);

const loading = ref(false);
</script>

<template>
    <Head title="Component Showcase" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-2xl text-slate-800 leading-tight">
                🎨 MasjidVision - UI Component Showcase
            </h2>
        </template>

        <div class="py-12 bg-pattern-islamic">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-12">
                
                <!-- Design System Overview -->
                <Card padding="lg" variant="islamic">
                    <div class="text-center space-y-4">
                        <h1 class="text-4xl font-bold text-gradient-islamic">Modern Islamic Design System</h1>
                        <p class="text-lg text-slate-600">Professional, Trustworthy, and Modern UI Components</p>
                        <div class="flex items-center justify-center gap-4 pt-4">
                            <div class="flex items-center gap-2">
                                <div class="w-8 h-8 rounded-full bg-primary-600"></div>
                                <span class="text-sm font-medium">Emerald Primary</span>
                            </div>
                            <div class="flex items-center gap-2">
                                <div class="w-8 h-8 rounded-full bg-secondary-500"></div>
                                <span class="text-sm font-medium">Amber Secondary</span>
                            </div>
                        </div>
                    </div>
                </Card>

                <!-- StatCard Component Showcase -->
                <div>
                    <h3 class="text-2xl font-bold text-slate-800 mb-6">📊 StatCard Components</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <StatCard
                            title="Total Pemasukan"
                            value="Rp 5.2M"
                            trend="up"
                            percentage="12.5"
                            color="emerald"
                            subtitle="Bulan ini"
                        >
                            <template #icon>
                                <BanknotesIcon class="w-full h-full" />
                            </template>
                            <template #footer>
                                <p class="text-xs text-slate-500">+Rp 500k dari bulan lalu</p>
                            </template>
                        </StatCard>

                        <StatCard
                            title="Total Pengeluaran"
                            value="Rp 3.8M"
                            trend="down"
                            percentage="5.2"
                            color="amber"
                            subtitle="Bulan ini"
                        >
                            <template #icon>
                                <ArrowTrendingUpIcon class="w-full h-full" />
                            </template>
                        </StatCard>

                        <StatCard
                            title="Jamaah Aktif"
                            value="1,234"
                            trend="up"
                            percentage="8.1"
                            color="blue"
                            subtitle="Minggu ini"
                        >
                            <template #icon>
                                <UsersIcon class="w-full h-full" />
                            </template>
                        </StatCard>

                        <StatCard
                            title="Saldo Tersisa"
                            value="Rp 1.4M"
                            trend="neutral"
                            color="slate"
                            subtitle="Dana operasional"
                        >
                            <template #icon>
                                <ChartBarIcon class="w-full h-full" />
                            </template>
                        </StatCard>
                    </div>
                </div>

                <!-- Card Component Showcase -->
                <div>
                    <h3 class="text-2xl font-bold text-slate-800 mb-6">🃏 Card Components</h3>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <Card padding="md" hoverable>
                            <h4 class="font-semibold text-lg text-slate-800 mb-2">Default Card</h4>
                            <p class="text-slate-600">This is a default card with medium padding and hover effect.</p>
                        </Card>

                        <Card padding="lg" variant="islamic" clickable>
                            <h4 class="font-semibold text-lg text-primary-700 mb-2">Islamic Variant</h4>
                            <p class="text-slate-600">Card with emerald green gradient background.</p>
                        </Card>

                        <Card padding="md" variant="gold" hoverable>
                            <h4 class="font-semibold text-lg text-secondary-700 mb-2">Gold Variant</h4>
                            <p class="text-slate-600">Premium card with amber gold gradient.</p>
                        </Card>
                    </div>
                </div>

                <!-- Badge Component Showcase -->
                <div>
                    <h3 class="text-2xl font-bold text-slate-800 mb-6">🏷️ Badge Components</h3>
                    <Card padding="lg">
                        <div class="space-y-6">
                            <div>
                                <h4 class="font-medium text-slate-700 mb-3">Variants</h4>
                                <div class="flex flex-wrap gap-3">
                                    <Badge variant="success">Verified</Badge>
                                    <Badge variant="warning">Pending</Badge>
                                    <Badge variant="danger">Dibatalkan</Badge>
                                    <Badge variant="info">Proses</Badge>
                                    <Badge variant="neutral">Draft</Badge>
                                    <Badge variant="primary">Active</Badge>
                                </div>
                            </div>

                            <div>
                                <h4 class="font-medium text-slate-700 mb-3">Sizes</h4>
                                <div class="flex flex-wrap items-center gap-3">
                                    <Badge variant="success" size="sm">Small</Badge>
                                    <Badge variant="success" size="md">Medium</Badge>
                                    <Badge variant="success" size="lg">Large</Badge>
                                </div>
                            </div>

                            <div>
                                <h4 class="font-medium text-slate-700 mb-3">With Dots</h4>
                                <div class="flex flex-wrap gap-3">
                                    <Badge variant="success" dot>Lunas</Badge>
                                    <Badge variant="warning" dot>Menunggu Verifikasi</Badge>
                                    <Badge variant="danger" dot>Gagal</Badge>
                                    <Badge variant="info" dot>Dalam Proses</Badge>
                                </div>
                            </div>
                        </div>
                    </Card>
                </div>

                <!-- ModernTable Component Showcase -->
                <div>
                    <h3 class="text-2xl font-bold text-slate-800 mb-6">📋 ModernTable Component</h3>
                    <Card padding="sm">
                        <ModernTable
                            :columns="columns"
                            :data="transactions"
                            :loading="loading"
                            hoverable
                            sticky-header
                        >
                            <template #cell-status="{ value }">
                                <Badge 
                                    :variant="value === 'verified' ? 'success' : 'warning'"
                                    dot
                                    size="sm"
                                >
                                    {{ value === 'verified' ? 'Terverifikasi' : 'Pending' }}
                                </Badge>
                            </template>

                            <template #pagination>
                                <div class="flex items-center justify-between">
                                    <p class="text-sm text-slate-600">
                                        Menampilkan <span class="font-medium">1-4</span> dari <span class="font-medium">4</span> transaksi
                                    </p>
                                    <div class="flex gap-2">
                                        <button class="px-3 py-1 text-sm border border-slate-300 rounded-md hover:bg-slate-50">
                                            Previous
                                        </button>
                                        <button class="px-3 py-1 text-sm border border-slate-300 rounded-md hover:bg-slate-50">
                                            Next
                                        </button>
                                    </div>
                                </div>
                            </template>
                        </ModernTable>
                    </Card>
                </div>

                <!-- Typography & Colors -->
                <div>
                    <h3 class="text-2xl font-bold text-slate-800 mb-6">🎨 Typography & Colors</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <Card padding="lg">
                            <h4 class="font-semibold text-lg mb-4">Font Families</h4>
                            <div class="space-y-3">
                                <p class="font-sans">Inter Font - Modern UI Text</p>
                                <p class="font-arabic text-2xl">خط عربي - Amiri Arabic</p>
                            </div>
                        </Card>

                        <Card padding="lg">
                            <h4 class="font-semibold text-lg mb-4">Text Gradients</h4>
                            <div class="space-y-3">
                                <p class="text-3xl font-bold text-gradient-islamic">Islamic Gradient</p>
                                <p class="text-3xl font-bold text-gradient-gold">Gold Gradient</p>
                            </div>
                        </Card>
                    </div>
                </div>

            </div>
        </div>
    </AuthenticatedLayout>
</template>
