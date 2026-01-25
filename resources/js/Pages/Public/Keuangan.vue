<script setup>
import { ref } from 'vue';
import { Head, Link } from '@inertiajs/vue3';
import { Dialog, DialogPanel, TransitionChild, TransitionRoot } from '@headlessui/vue';
import PublicLayout from '@/Layouts/PublicLayout.vue';

const props = defineProps({
    transactions: Array,
    summary: Object,
});

const selectedProof = ref(null);
const showProofModal = ref(false);

const viewProof = (transaction) => {
    if (transaction.proof_url) {
        selectedProof.value = transaction;
        showProofModal.value = true;
    }
};
</script>

<template>
    <Head :title="`Transparansi Keuangan - ${$page.props.settings?.site_name || 'Masjid'}`" />

    <PublicLayout>

        <!-- Hero Section -->
        <div class="bg-gradient-to-r from-emerald-600 to-emerald-700 text-white pt-28 pb-16">
            <div class="max-w-7xl mx-auto px-4 text-center">
                <div class="text-5xl mb-4">💰</div>
                <h1 class="text-4xl md:text-5xl font-bold mb-3">Transparansi Keuangan</h1>
                <p class="text-xl text-emerald-100">Laporan lengkap pemasukan & pengeluaran masjid</p>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="max-w-7xl mx-auto px-4 -mt-12 mb-12">
            <div class="grid md:grid-cols-3 gap-6">
                <div class="bg-white rounded-2xl p-6 shadow-xl border-t-4 border-emerald-500">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-sm font-semibold text-slate-600">Total Pemasukan</span>
                        <span class="text-3xl">📈</span>
                    </div>
                    <div class="text-3xl font-bold text-emerald-600">{{ summary.formatted_income }}</div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-xl border-t-4 border-rose-500">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-sm font-semibold text-slate-600">Total Pengeluaran</span>
                        <span class="text-3xl">📉</span>
                    </div>
                    <div class="text-3xl font-bold text-rose-600">{{ summary.formatted_expense }}</div>
                </div>

                <div class="bg-white rounded-2xl p-6 shadow-xl border-t-4 border-amber-500">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-sm font-semibold text-slate-600">Saldo Saat Ini</span>
                        <span class="text-3xl">💎</span>
                    </div>
                    <div class="text-3xl font-bold text-amber-600">{{ summary.formatted_balance }}</div>
                </div>
            </div>
        </div>

        <!-- Transactions Table -->
        <div class="max-w-7xl mx-auto px-4 pb-16">
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                <div class="px-6 py-4 border-b border-slate-200">
                    <h2 class="text-2xl font-bold text-slate-800">📋 Riwayat Transaksi (50 Terbaru)</h2>
                    <p class="text-sm text-slate-600 mt-1">Semua transaksi yang telah disetujui</p>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-slate-50 border-b border-slate-200">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-bold text-slate-700 uppercase">Tanggal</th>
                                <th class="px-6 py-3 text-left text-xs font-bold text-slate-700 uppercase">Kategori</th>
                                <th class="px-6 py-3 text-left text-xs font-bold text-slate-700 uppercase">Keterangan</th>
                                <th class="px-6 py-3 text-right text-xs font-bold text-slate-700 uppercase">Jumlah</th>
                                <th class="px-6 py-3 text-center text-xs font-bold text-slate-700 uppercase">Bukti</th>
                                <th class="px-6 py-3 text-left text-xs font-bold text-slate-700 uppercase">Dicatat Oleh</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <tr v-for="transaction in transactions" :key="transaction.id" class="hover:bg-slate-50">
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-600">{{ transaction.date }}</td>
                                <td class="px-6 py-4 text-sm">
                                    <span :class="transaction.type === 'income' ? 'bg-emerald-100 text-emerald-700' : 'bg-rose-100 text-rose-700'" class="px-2 py-1 rounded-full text-xs font-semibold">
                                        {{ transaction.category }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-sm text-slate-700">{{ transaction.description || '-' }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-right">
                                    <span :class="transaction.type === 'income' ? 'text-emerald-600' : 'text-rose-600'" class="font-bold">
                                        {{ transaction.formatted_amount }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <button
                                        v-if="transaction.proof_url"
                                        @click="viewProof(transaction)"
                                        class="text-primary-600 hover:text-primary-700 text-sm font-medium hover:underline"
                                    >
                                        📷 Lihat
                                    </button>
                                    <span v-else class="text-slate-400 text-sm">-</span>
                                </td>
                                <td class="px-6 py-4 text-sm text-slate-600">{{ transaction.verified_by_name || '-' }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Proof Modal -->
        <TransitionRoot as="template" :show="showProofModal">
            <Dialog as="div" class="relative z-50" @close="showProofModal = false">
                <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0" enter-to="opacity-100" leave="ease-in duration-200" leave-from="opacity-100" leave-to="opacity-0">
                    <div class="fixed inset-0 bg-slate-900/75" />
                </TransitionChild>
                <div class="fixed inset-0 z-10 overflow-y-auto">
                    <div class="flex min-h-full items-center justify-center p-4">
                        <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0 scale-95" enter-to="opacity-100 scale-100" leave="ease-in duration-200" leave-from="opacity-100 scale-100" leave-to="opacity-0 scale-95">
                            <DialogPanel class="relative transform overflow-hidden rounded-2xl bg-white shadow-2xl w-full max-w-2xl">
                                <div class="p-6">
                                    <h3 class="text-lg font-bold text-slate-800 mb-4">Bukti Transaksi</h3>
                                    <div v-if="selectedProof">
                                        <div class="mb-3">
                                            <div class="text-sm text-slate-600">{{ selectedProof.category }} - {{ selectedProof.date }}</div>
                                            <div class="font-bold text-lg">{{ selectedProof.formatted_amount }}</div>
                                        </div>
                                        <img :src="selectedProof.proof_url" alt="Bukti" class="w-full rounded-lg" />
                                    </div>
                                    <button
                                        @click="showProofModal = false"
                                        class="mt-4 w-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold py-2 rounded-lg"
                                    >
                                        Tutup
                                    </button>
                                </div>
                            </DialogPanel>
                        </TransitionChild>
                    </div>
                </div>
            </Dialog>
        </TransitionRoot>

        <!-- Footer CTA -->
        <div class="bg-emerald-50 py-12">
            <div class="max-w-4xl mx-auto px-4 text-center">
                <h3 class="text-2xl font-bold text-slate-800 mb-3">💡 Informasi</h3>
                <p class="text-slate-600 mb-6">
                    Semua transaksi telah diverifikasi dan disetujui oleh pengurus masjid.
                    Data diperbarui secara real-time untuk transparansi penuh.
                </p>
                <Link href="/" class="inline-block bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3 px-8 rounded-lg">
                    ← Kembali ke Beranda
                </Link>
            </div>
        </div>
    </PublicLayout>
</template>
