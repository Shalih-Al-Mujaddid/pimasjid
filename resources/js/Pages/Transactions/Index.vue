<script setup>
import { ref, watch, computed } from 'vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import Card from '@/Components/Card.vue';
import Modal from '@/Components/Modal.vue';
import ModernTable from '@/Components/ModernTable.vue';
import Pagination from '@/Components/Pagination.vue';
import Badge from '@/Components/Badge.vue';
import { useToast } from '@/Composables/useToast';
import { 
    PlusIcon, 
    FunnelIcon, 
    ArrowDownTrayIcon, 
    DocumentTextIcon, 
    TableCellsIcon,
    TrashIcon,
    MagnifyingGlassIcon,
    BanknotesIcon,
    XMarkIcon,
    PhotoIcon,
    CheckCircleIcon,
    ArrowUpTrayIcon
} from '@heroicons/vue/24/outline';

const props = defineProps({
    transactions: Object,
    filters: Object,
});

const toast = useToast();
const showCreateModal = ref(false);

// Filters State
const filterForm = useForm({
    start_date: props.filters?.start_date || '',
    end_date: props.filters?.end_date || '',
});

// Watch filters and reload
const applyFilters = () => {
    filterForm.get(route('transactions.index'), {
        preserveState: true,
        preserveScroll: true,
    });
};

const resetFilters = () => {
    filterForm.start_date = '';
    filterForm.end_date = '';
    applyFilters();
};

// Quick date helpers
const setToday = () => {
    const today = new Date().toISOString().split('T')[0];
    filterForm.start_date = today;
    filterForm.end_date = today;
    applyFilters();
};

const setThisMonth = () => {
    const today = new Date();
    const firstDay = new Date(today.getFullYear(), today.getMonth(), 1).toISOString().split('T')[0];
    const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0).toISOString().split('T')[0];
    filterForm.start_date = firstDay;
    filterForm.end_date = lastDay;
    applyFilters();
};

// Export
const exportData = (format) => {
    const params = new URLSearchParams({
        start_date: filterForm.start_date,
        end_date: filterForm.end_date,
        format: format,
    });
    window.location.href = `${route('transactions.export')}?${params.toString()}`;
};

// --- CREATE FORM LOGIC ---
const form = useForm({
    type: 'income',
    category: '',
    amount: '',
    description: '',
    date: new Date().toISOString().split('T')[0],
    proof_image: null,
});

const fileInput = ref(null);
const imagePreview = ref(null);

watch(() => form.type, (newType) => {
    if (newType === 'income') {
        form.proof_image = null;
        imagePreview.value = null;
        if (fileInput.value) fileInput.value.value = '';
    }
});

const handleFileChange = (event) => {
    const file = event.target.files[0];
    if (file) {
        form.proof_image = file;
        const reader = new FileReader();
        reader.onload = (e) => { imagePreview.value = e.target.result; };
        reader.readAsDataURL(file);
    }
};

const submitCreate = () => {
    form.post(route('transactions.store'), {
        forceFormData: true,
        onSuccess: () => {
            toast.success('Transaksi berhasil disimpan!');
            form.reset();
            imagePreview.value = null;
            showCreateModal.value = false;
        },
        onError: (errors) => {
            const firstError = Object.values(errors)[0];
            toast.error(firstError || 'Gagal menyimpan transaksi');
        },
    });
};

// Delete
const deleteTransaction = (id) => {
    if (confirm('Apakah Anda yakin ingin menghapus transaksi ini?')) {
        router.delete(route('transactions.destroy', id), {
            onSuccess: () => toast.success('Data berhasil dihapus'),
        });
    }
};

const categories = {
    income: ['Kotak Jumat', 'Infaq', 'Sedekah', 'Wakaf', 'Donasi', 'Lainnya'],
    expense: ['Operasional', 'Listrik & Air', 'Renovasi', 'Gaji Marbot', 'Kebersihan', 'Lainnya'],
};

// Table Columns
const columns = [
    { key: 'date', label: 'Tanggal' },
    { key: 'details', label: 'Rincian Transaksi' },
    { key: 'amount', label: 'Jumlah (Rp)' },
    { key: 'status', label: 'Verifikasi' },
    { key: 'actions', label: 'Aksi' },
];

const formatCurrency = (val) => {
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(val);
};
</script>

<template>
    <Head title="Manajemen Keuangan" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex flex-col md:flex-row justify-between md:items-center gap-4">
                <div class="flex items-center gap-3">
                    <div class="p-2 bg-emerald-100 rounded-xl">
                        <BanknotesIcon class="w-6 h-6 text-emerald-600" />
                    </div>
                    <h2 class="font-black text-2xl text-slate-800 leading-tight">Keuangan Masjid</h2>
                </div>
                <button 
                    @click="showCreateModal = true"
                    class="bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-2.5 rounded-xl font-bold flex items-center gap-2 transition-all shadow-lg shadow-emerald-100 active:scale-95"
                >
                    <PlusIcon class="w-5 h-5 stroke-2" />
                    <span>Catat Transaksi</span>
                </button>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-8">
                
                <!-- Filters & Export -->
                <div class="bg-white rounded-2xl p-4 sm:p-5 border border-slate-200/80 shadow-xs">
                    <div class="flex flex-col lg:flex-row gap-4 justify-between items-start lg:items-center">
                        <!-- Filters Group -->
                        <div class="flex flex-wrap items-center gap-3 w-full lg:w-auto">
                            <!-- Dari Tanggal -->
                            <div class="flex items-center gap-2 bg-slate-50 border border-slate-200 rounded-xl px-3 py-1.5 focus-within:ring-2 focus-within:ring-emerald-500/20 focus-within:border-emerald-500 transition-all">
                                <label class="text-xs font-bold text-slate-500 shrink-0">Dari:</label>
                                <input 
                                    v-model="filterForm.start_date" 
                                    type="date" 
                                    class="bg-transparent border-0 p-0 text-xs font-bold text-slate-700 focus:ring-0 cursor-pointer"
                                    @change="applyFilters"
                                />
                            </div>

                            <!-- Sampai Tanggal -->
                            <div class="flex items-center gap-2 bg-slate-50 border border-slate-200 rounded-xl px-3 py-1.5 focus-within:ring-2 focus-within:ring-emerald-500/20 focus-within:border-emerald-500 transition-all">
                                <label class="text-xs font-bold text-slate-500 shrink-0">Sampai:</label>
                                <input 
                                    v-model="filterForm.end_date" 
                                    type="date" 
                                    class="bg-transparent border-0 p-0 text-xs font-bold text-slate-700 focus:ring-0 cursor-pointer"
                                    @change="applyFilters"
                                />
                            </div>

                            <!-- Quick Preset & Reset Group -->
                            <div class="inline-flex items-center p-1 bg-slate-100/90 rounded-xl gap-1 border border-slate-200/60">
                                <button type="button" @click="setToday" class="px-3 py-1 bg-white hover:bg-emerald-600 hover:text-white text-slate-700 rounded-lg text-xs font-bold transition-all shadow-2xs">Hari Ini</button>
                                <button type="button" @click="setThisMonth" class="px-3 py-1 bg-white hover:bg-emerald-600 hover:text-white text-slate-700 rounded-lg text-xs font-bold transition-all shadow-2xs">Bulan Ini</button>
                                <button type="button" @click="resetFilters" class="px-2.5 py-1 text-rose-600 hover:bg-rose-50 rounded-lg text-xs font-bold transition-all">Reset</button>
                            </div>
                        </div>

                        <!-- Exports Group -->
                        <div class="flex items-center gap-2 w-full sm:w-auto justify-end">
                            <button 
                                @click="exportData('pdf')"
                                class="inline-flex items-center justify-center gap-1.5 px-3.5 py-1.5 bg-white border border-slate-200 hover:border-rose-200 hover:bg-rose-50 text-rose-600 rounded-xl text-xs font-bold transition-all shadow-2xs"
                            >
                                <DocumentTextIcon class="w-4 h-4" />
                                <span>PDF</span>
                            </button>
                            <button 
                                @click="exportData('excel')"
                                class="inline-flex items-center justify-center gap-1.5 px-3.5 py-1.5 bg-white border border-slate-200 hover:border-emerald-200 hover:bg-emerald-50 text-emerald-600 rounded-xl text-xs font-bold transition-all shadow-2xs"
                            >
                                <TableCellsIcon class="w-4 h-4" />
                                <span>Excel</span>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Transactions Table -->
                <div class="bg-white overflow-hidden shadow-xl shadow-slate-200/50 rounded-[2.5rem] border border-slate-100">
                    <div class="p-8">
                        <ModernTable
                            :columns="columns"
                            :data="transactions.data"
                        >
                            <template #cell-date="{ row }">
                                <div class="flex flex-col">
                                    <span class="font-black text-slate-800 text-sm whitespace-nowrap">{{ new Date(row.date).toLocaleDateString('id-ID', { day: 'numeric', month: 'long' }) }}</span>
                                    <span class="text-[10px] text-slate-400 font-bold uppercase tracking-widest">{{ new Date(row.date).getFullYear() }}</span>
                                </div>
                            </template>
                            
                            <template #cell-details="{ row }">
                                <div class="flex items-center gap-3">
                                    <div :class="row.type === 'income' ? 'bg-emerald-50 text-emerald-600' : 'bg-rose-50 text-rose-600'" class="p-2 rounded-xl">
                                        <BanknotesIcon class="w-5 h-5" />
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="font-black text-slate-800 leading-tight">{{ row.category }}</span>
                                        <span class="text-xs text-slate-400 font-medium italic truncate max-w-[200px]">{{ row.description || '-' }}</span>
                                    </div>
                                </div>
                            </template>
                            
                            <template #cell-amount="{ row }">
                                <div class="flex flex-col items-end">
                                    <span :class="['font-black text-md', row.type === 'income' ? 'text-emerald-600' : 'text-rose-600']">
                                        {{ row.type === 'income' ? '+' : '-' }} {{ formatCurrency(row.amount).replace('Rp', '').trim() }}
                                    </span>
                                    <span class="text-[9px] font-black uppercase tracking-tighter text-slate-300">RUPIAH INDONESIA</span>
                                </div>
                            </template>

                            <template #cell-status="{ row }">
                                <div class="flex items-center gap-2">
                                    <div class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></div>
                                    <span class="text-xs text-slate-500 font-bold italic">{{ row.verified_by?.name || 'Sistem' }}</span>
                                </div>
                            </template>
                            
                            <template #cell-actions="{ row }">
                                <button 
                                    @click="deleteTransaction(row.id)"
                                    class="p-2.5 text-rose-500 hover:bg-rose-50 rounded-xl transition-all"
                                    title="Hapus"
                                >
                                    <TrashIcon class="w-5 h-5" />
                                </button>
                            </template>

                             <template #empty>
                                <div class="flex flex-col items-center justify-center py-16 text-slate-400">
                                    <div class="p-6 bg-slate-50 rounded-full mb-4">
                                        <MagnifyingGlassIcon class="w-12 h-12 opacity-20" />
                                    </div>
                                    <p class="text-xl font-black text-slate-800">Tidak ada transaksi</p>
                                    <p class="text-slate-400 font-medium max-w-xs text-center mt-2">Belum ada catatan keuangan untuk periode ini.</p>
                                </div>
                            </template>

                            <template #pagination>
                                <div class="pt-6">
                                    <Pagination :links="transactions.links" />
                                </div>
                            </template>
                        </ModernTable>
                    </div>
                </div>

            </div>
        </div>

        <!-- Create Modal -->
        <Modal :show="showCreateModal" maxWidth="2xl" @close="showCreateModal = false">
            <div class="bg-white rounded-[2.5rem] overflow-hidden shadow-2xl">
                <!-- Modal Header -->
                <div class="px-8 py-6 border-b border-slate-50 flex justify-between items-center bg-slate-50/50">
                    <div class="flex items-center gap-4">
                        <div class="bg-emerald-100 text-emerald-600 p-3 rounded-2xl">
                            <BanknotesIcon class="w-6 h-6" />
                        </div>
                        <div>
                            <h2 class="text-xl font-black text-slate-900 leading-none">Catat Transaksi Baru</h2>
                            <p class="text-sm text-slate-500 font-medium mt-1">Input data pemasukan atau pengeluaran masjid.</p>
                        </div>
                    </div>
                    <button @click="showCreateModal = false" class="p-2 hover:bg-slate-100 rounded-xl transition-colors">
                        <XMarkIcon class="w-6 h-6 text-slate-400" />
                    </button>
                </div>

                 <form @submit.prevent="submitCreate" class="p-8 space-y-8">
                        <!-- Type Selection -->
                        <div class="space-y-2">
                            <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Tipe Transaksi</label>
                            <div class="flex gap-4">
                                <label class="flex-1 flex items-center justify-center gap-3 cursor-pointer p-5 border-2 rounded-[2rem] transition-all group" :class="form.type === 'income' ? 'border-emerald-500 bg-emerald-50 shadow-lg shadow-emerald-50' : 'border-slate-100 bg-slate-50/50 hover:bg-white'">
                                    <input v-model="form.type" type="radio" value="income" class="hidden" />
                                    <div :class="form.type === 'income' ? 'bg-emerald-500' : 'bg-slate-200'" class="w-5 h-5 rounded-full flex items-center justify-center p-1 transition-all">
                                        <div class="w-full h-full bg-white rounded-full"></div>
                                    </div>
                                    <span class="font-black text-sm uppercase tracking-widest" :class="form.type === 'income' ? 'text-emerald-700': 'text-slate-400'">Pemasukan</span>
                                </label>
                                <label class="flex-1 flex items-center justify-center gap-3 cursor-pointer p-5 border-2 rounded-[2rem] transition-all group" :class="form.type === 'expense' ? 'border-rose-500 bg-rose-50 shadow-lg shadow-rose-50' : 'border-slate-100 bg-slate-50/50 hover:bg-white'">
                                    <input v-model="form.type" type="radio" value="expense" class="hidden" />
                                    <div :class="form.type === 'expense' ? 'bg-rose-500' : 'bg-slate-200'" class="w-5 h-5 rounded-full flex items-center justify-center p-1 transition-all">
                                        <div class="w-full h-full bg-white rounded-full"></div>
                                    </div>
                                    <span class="font-black text-sm uppercase tracking-widest" :class="form.type === 'expense' ? 'text-rose-700': 'text-slate-400'">Pengeluaran</span>
                                </label>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                            <div class="space-y-6">
                                <!-- Category -->
                                <div class="space-y-1.5">
                                    <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Kategori</label>
                                    <select v-model="form.category" class="w-full rounded-2xl border-slate-200 py-3.5 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 transition-all">
                                        <option value="">Pilih Kategori</option>
                                        <option v-for="cat in categories[form.type]" :key="cat" :value="cat">{{ cat }}</option>
                                    </select>
                                    <p v-if="form.errors.category" class="text-rose-500 text-[10px] font-bold">{{ form.errors.category }}</p>
                                </div>

                                <!-- Amount -->
                                <div class="space-y-1.5">
                                    <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Jumlah (Rp)</label>
                                    <div class="relative">
                                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 font-black text-sm">Rp</div>
                                        <input v-model="form.amount" type="number" min="0" class="w-full rounded-2xl border-slate-200 py-3.5 pl-12 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-black bg-slate-50/50 hover:bg-white transition-all text-lg" placeholder="100.000" />
                                    </div>
                                    <p v-if="form.errors.amount" class="text-rose-500 text-[10px] font-bold">{{ form.errors.amount }}</p>
                                </div>

                                <!-- Date -->
                                <div class="space-y-1.5">
                                    <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Tanggal</label>
                                    <input v-model="form.date" type="date" class="w-full rounded-2xl border-slate-200 py-3.5 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 hover:bg-white transition-all" />
                                    <p v-if="form.errors.date" class="text-rose-500 text-[10px] font-bold">{{ form.errors.date }}</p>
                                </div>
                            </div>

                            <div class="space-y-6">
                                <!-- Description -->
                                <div class="space-y-1.5">
                                    <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Keterangan</label>
                                    <textarea v-model="form.description" rows="4" class="w-full rounded-2xl border-slate-200 py-3 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 hover:bg-white transition-all" placeholder="Catatan tambahan..."></textarea>
                                    <p v-if="form.errors.description" class="text-rose-500 text-[10px] font-bold">{{ form.errors.description }}</p>
                                </div>

                                <!-- Proof Image -->
                                <div v-if="form.type === 'expense'" class="space-y-2">
                                    <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Bukti Nota/Kuitansi</label>
                                    <div class="relative group aspect-video bg-slate-50 rounded-[2rem] overflow-hidden border-2 border-dashed border-slate-200 hover:border-emerald-400 transition-all flex items-center justify-center">
                                        <img v-if="imagePreview" :src="imagePreview" class="w-full h-full object-cover" />
                                        <div v-if="imagePreview" class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                                            <button type="button" @click="$refs.proofInput.click()" class="bg-white h-10 w-10 rounded-full shadow-lg flex items-center justify-center text-slate-600 hover:scale-110 transition-transform">
                                                <ArrowUpTrayIcon class="w-5 h-5" />
                                            </button>
                                        </div>
                                        <label v-else @click="$refs.proofInput.click()" class="flex flex-col items-center justify-center cursor-pointer gap-2">
                                            <div class="p-3 bg-white rounded-xl shadow-sm text-slate-300 group-hover:text-emerald-500 transition-colors">
                                                <PhotoIcon class="w-8 h-8" />
                                            </div>
                                            <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Unggah Bukti</span>
                                        </label>
                                        <input ref="proofInput" type="file" @change="handleFileChange" accept="image/*,.pdf" class="hidden">
                                    </div>
                                    <p v-if="form.errors.proof_image" class="text-rose-500 text-[10px] font-bold">{{ form.errors.proof_image }}</p>
                                </div>
                            </div>
                        </div>

                        <!-- Modal Footer -->
                        <div class="pt-8 border-t border-slate-100 flex justify-end gap-4">
                            <button type="button" @click="showCreateModal = false" class="px-8 py-3.5 bg-slate-100 text-slate-600 font-black rounded-2xl hover:bg-slate-200 transition-all active:scale-95">
                                Batal
                            </button>
                            <button type="submit" :disabled="form.processing" class="px-10 py-3.5 bg-emerald-600 text-white font-black rounded-2xl shadow-xl shadow-emerald-100 hover:bg-emerald-700 disabled:opacity-50 transition-all active:scale-95 flex items-center gap-2">
                                <span v-if="form.processing" class="animate-spin h-5 w-5 border-2 border-white border-t-transparent rounded-full"></span>
                                <CheckCircleIcon class="w-5 h-5 stroke-2" />
                                Simpan Transaksi
                            </button>
                        </div>
                 </form>
            </div>
        </Modal>

        <!-- Toast -->
        <Transition name="fade">
            <div v-if="toast.show.value" :class="['fixed bottom-8 right-8 z-50 px-8 py-5 rounded-[2rem] shadow-2xl max-w-sm flex items-center gap-4 transform transition-all', toast.type.value === 'success' ? 'bg-slate-900 text-white' : 'bg-rose-600 text-white']">
                <div :class="toast.type.value === 'success' ? 'bg-emerald-500' : 'bg-white/20'" class="p-2 rounded-xl">
                    <CheckCircleIcon v-if="toast.type.value === 'success'" class="w-6 h-6 text-white" />
                    <XMarkIcon v-else class="w-6 h-6 text-white" />
                </div>
                <div>
                    <p class="font-black text-sm tracking-tight leading-tight">{{ toast.message.value }}</p>
                </div>
            </div>
        </Transition>

    </AuthenticatedLayout>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1); }
.fade-enter-from, .fade-leave-to { opacity: 0; transform: translateY(2rem) scale(0.95); }
</style>
