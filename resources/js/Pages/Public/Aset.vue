<script setup>
import { Head } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';

const props = defineProps({
    assets: Array
});
</script>

<template>
    <Head title="Daftar Aset & Wakaf" />

    <PublicLayout>

        <div class="bg-emerald-700 pt-32 pb-16 text-center text-white">
            <h1 class="text-4xl font-bold mb-4">Daftar Aset & Wakaf</h1>
            <p class="text-emerald-100">Transparansi pengelolaan aset milik umat</p>
        </div>

        <div class="max-w-7xl mx-auto px-4 py-12">
            <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead class="bg-slate-50 border-b border-slate-200">
                            <tr>
                                <th class="px-6 py-4 text-sm font-bold text-slate-600 uppercase">Nama Aset</th>
                                <th class="px-6 py-4 text-sm font-bold text-slate-600 uppercase">Kondisi</th>
                                <th class="px-6 py-4 text-sm font-bold text-slate-600 uppercase text-center">Jumlah</th>
                                <th class="px-6 py-4 text-sm font-bold text-slate-600 uppercase">Tanggal Perolehan</th>
                                <th class="px-6 py-4 text-sm font-bold text-slate-600 uppercase">Keterangan</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <tr v-for="asset in assets" :key="asset.id" class="hover:bg-slate-50 transition-colors">
                                <td class="px-6 py-4">
                                    <div class="font-bold text-slate-800">{{ asset.name }}</div>
                                </td>
                                <td class="px-6 py-4">
                                    <span :class="{
                                        'bg-emerald-100 text-emerald-700': asset.condition === 'Baik',
                                        'bg-amber-100 text-amber-700': asset.condition === 'Rusak Ringan',
                                        'bg-rose-100 text-rose-700': asset.condition === 'Rusak Berat' || asset.condition === 'Hilang'
                                    }" class="px-2 py-1 rounded text-xs font-bold uppercase">
                                        {{ asset.condition }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-center font-mono font-bold text-slate-700">
                                    {{ asset.quantity }}
                                </td>
                                <td class="px-6 py-4 text-sm text-slate-600">
                                    {{ asset.purchase_date || '-' }}
                                </td>
                                <td class="px-6 py-4 text-sm text-slate-500 italic">
                                    {{ asset.notes || '-' }}
                                </td>
                            </tr>
                            <tr v-if="assets.length === 0">
                                <td colspan="5" class="px-6 py-12 text-center text-slate-500">
                                    Belum ada data aset yang tercatat.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>
