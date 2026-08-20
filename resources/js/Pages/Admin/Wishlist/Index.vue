<script setup>
import { ref, computed } from 'vue';
import { Head, Link, useForm, router, usePage } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import {
    GiftIcon,
    PlusIcon,
    PencilSquareIcon,
    TrashIcon,
    MagnifyingGlassIcon,
    CheckCircleIcon,
    ClockIcon,
    BanknotesIcon,
    ShoppingBagIcon,
    UserGroupIcon,
    XMarkIcon,
    CheckIcon,
    EyeIcon,
    PhotoIcon,
    DocumentCheckIcon,
    ExclamationTriangleIcon,
    ArrowPathIcon
} from '@heroicons/vue/24/outline';
import { Dialog, DialogPanel, DialogTitle, TransitionChild, TransitionRoot } from '@headlessui/vue';

const props = defineProps({
    wishlists: Object,
    pendingContributions: Array,
    filters: Object,
    stats: Object,
});

const page = usePage();
const flashSuccess = computed(() => page.props.flash?.success);

// Active Tab: 'items' or 'contributions'
const activeTab = ref(props.pendingContributions?.length > 0 && props.filters?.tab === 'contributions' ? 'contributions' : 'items');

// Filter state
const search = ref(props.filters.search || '');
const statusFilter = ref(props.filters.status || 'semua');

let searchTimeout = null;
const handleSearch = () => {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        applyFilters();
    }, 400);
};

const applyFilters = () => {
    router.get(
        route('admin.wishlist.index'),
        {
            search: search.value || undefined,
            status: statusFilter.value !== 'semua' ? statusFilter.value : undefined,
        },
        {
            preserveState: true,
            preserveScroll: true,
            replace: true,
        }
    );
};

// Wishlist Modal State
const showWishlistModal = ref(false);
const editingWishlist = ref(null);

const wishlistForm = useForm({
    item_name: '',
    target_qty: 1,
    fulfilled_qty: 0,
    unit_price: 0,
    status: 'active',
    description: '',
});

const openWishlistModal = (wishlist = null) => {
    editingWishlist.value = wishlist;
    if (wishlist) {
        wishlistForm.item_name = wishlist.item_name;
        wishlistForm.target_qty = wishlist.target_qty;
        wishlistForm.fulfilled_qty = wishlist.fulfilled_qty;
        wishlistForm.unit_price = wishlist.unit_price;
        wishlistForm.status = wishlist.status;
        wishlistForm.description = wishlist.description || '';
    } else {
        wishlistForm.reset();
        wishlistForm.target_qty = 1;
        wishlistForm.fulfilled_qty = 0;
        wishlistForm.status = 'active';
    }
    showWishlistModal.value = true;
};

const closeWishlistModal = () => {
    showWishlistModal.value = false;
    editingWishlist.value = null;
    wishlistForm.reset();
};

const submitWishlist = () => {
    if (editingWishlist.value) {
        wishlistForm.put(route('admin.wishlist.update', editingWishlist.value.id), {
            preserveScroll: true,
            onSuccess: () => closeWishlistModal(),
        });
    } else {
        wishlistForm.post(route('admin.wishlist.store'), {
            preserveScroll: true,
            onSuccess: () => closeWishlistModal(),
        });
    }
};

const deleteWishlist = (wishlist) => {
    if (confirm(`Apakah Anda yakin ingin menghapus kebutuhan "${wishlist.item_name}"? Riwayat kontribusi terkait juga akan dihapus.`)) {
        router.delete(route('admin.wishlist.destroy', wishlist.id), {
            preserveScroll: true,
        });
    }
};

// Manual Contribution Modal State
const showManualContributionModal = ref(false);
const targetWishlistForContribution = ref(null);

const manualContributionForm = useForm({
    donor_name: '',
    donor_phone: '',
    donor_email: '',
    quantity: 1,
    type: 'barang',
    amount: null,
    notes: '',
    is_anonymous: false,
    proof_image: null,
});

const openManualContributionModal = (wishlist) => {
    targetWishlistForContribution.value = wishlist;
    manualContributionForm.reset();
    manualContributionForm.quantity = 1;
    manualContributionForm.type = 'barang';
    manualContributionForm.amount = null;
    showManualContributionModal.value = true;
};

const closeManualContributionModal = () => {
    showManualContributionModal.value = false;
    targetWishlistForContribution.value = null;
    manualContributionForm.reset();
};

const submitManualContribution = () => {
    if (!targetWishlistForContribution.value) return;
    manualContributionForm.post(route('admin.wishlist.contribution.store', targetWishlistForContribution.value.id), {
        preserveScroll: true,
        onSuccess: () => closeManualContributionModal(),
    });
};

// Verification / Reject Contribution Actions
const verifyContribution = (contribution) => {
    if (confirm(`Setujui dan verifikasi donasi dari "${contribution.donor_name}" sebanyak ${contribution.quantity} unit? Progress kebutuhan akan bertambah otomatis.`)) {
        router.patch(route('admin.wishlist.contribution.verify', contribution.id), {}, {
            preserveScroll: true,
        });
    }
};

const rejectingContribution = ref(null);
const rejectNotes = ref('');
const showRejectModal = ref(false);

const openRejectModal = (contribution) => {
    rejectingContribution.value = contribution;
    rejectNotes.value = '';
    showRejectModal.value = true;
};

const confirmReject = () => {
    if (!rejectingContribution.value) return;
    router.patch(
        route('admin.wishlist.contribution.reject', rejectingContribution.value.id),
        { admin_notes: rejectNotes.value },
        {
            preserveScroll: true,
            onSuccess: () => {
                showRejectModal.value = false;
                rejectingContribution.value = null;
            },
        }
    );
};

// Proof Image Lightbox
const previewImageUrl = ref(null);
const openProofPreview = (url) => {
    previewImageUrl.value = url;
};

const formatRupiah = (val) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0
    }).format(val || 0);
};

const formatDate = (dateString) => {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleDateString('id-ID', {
        day: 'numeric',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
};
</script>

<template>
    <Head title="Kelola Kebutuhan & Wishlist Masjid" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
                <div>
                    <h2 class="font-bold text-2xl text-slate-800 dark:text-white leading-tight flex items-center gap-2">
                        <GiftIcon class="w-7 h-7 text-emerald-600 dark:text-emerald-400" />
                        Kelola Kebutuhan & Wishlist Masjid
                    </h2>
                    <p class="text-xs sm:text-sm text-slate-500 dark:text-slate-400 mt-1">
                        Katalog sarana prasarana, pelacakan progres pemenuhan, dan verifikasi donasi dari jamaah.
                    </p>
                </div>

                <div class="flex items-center gap-3">
                    <a
                        :href="route('public.wishlist.index')"
                        target="_blank"
                        class="px-4 py-2 bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-200 rounded-xl text-xs font-bold transition flex items-center gap-1.5"
                    >
                        <span>Lihat Portal Publik</span>
                        <span class="text-xs">↗</span>
                    </a>

                    <button
                        @click="openWishlistModal()"
                        class="px-4 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold flex items-center justify-center gap-2 transition shadow-md shadow-emerald-600/20"
                    >
                        <PlusIcon class="w-4 h-4" />
                        Tambah Kebutuhan
                    </button>
                </div>
            </div>
        </template>

        <div class="py-8">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8">
                <!-- Flash Alert -->
                <div
                    v-if="flashSuccess"
                    class="p-4 bg-emerald-50 dark:bg-emerald-950/80 border border-emerald-200 dark:border-emerald-800 rounded-2xl flex items-center gap-3 text-emerald-800 dark:text-emerald-200 shadow-sm"
                >
                    <CheckCircleIcon class="w-5 h-5 text-emerald-600 shrink-0" />
                    <span class="text-sm font-semibold">{{ flashSuccess }}</span>
                </div>

                <!-- KPI Summary Stat Cards -->
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
                    <div class="bg-white dark:bg-slate-900 rounded-2xl p-5 border border-slate-100 dark:border-slate-800 shadow-sm">
                        <div class="flex items-center justify-between text-slate-400 mb-2">
                            <span class="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">Total Kebutuhan</span>
                            <ShoppingBagIcon class="w-5 h-5 text-emerald-600" />
                        </div>
                        <div class="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white">
                            {{ stats.total_items }}
                        </div>
                        <div class="text-xs text-slate-500 mt-1">
                            Target dana: <strong>{{ formatRupiah(stats.total_target_amount) }}</strong>
                        </div>
                    </div>

                    <div class="bg-white dark:bg-slate-900 rounded-2xl p-5 border border-slate-100 dark:border-slate-800 shadow-sm">
                        <div class="flex items-center justify-between text-slate-400 mb-2">
                            <span class="text-xs font-bold uppercase tracking-wider text-amber-500">Sedang Berjalan</span>
                            <ClockIcon class="w-5 h-5 text-amber-500" />
                        </div>
                        <div class="text-2xl sm:text-3xl font-black text-amber-600 dark:text-amber-400">
                            {{ stats.active_items }}
                        </div>
                        <div class="text-xs text-slate-500 mt-1">Item aktif membutuhkan donasi</div>
                    </div>

                    <div class="bg-white dark:bg-slate-900 rounded-2xl p-5 border border-slate-100 dark:border-slate-800 shadow-sm">
                        <div class="flex items-center justify-between text-slate-400 mb-2">
                            <span class="text-xs font-bold uppercase tracking-wider text-teal-600">Selesai Terpenuhi</span>
                            <CheckCircleIcon class="w-5 h-5 text-teal-600" />
                        </div>
                        <div class="text-2xl sm:text-3xl font-black text-teal-600 dark:text-teal-400">
                            {{ stats.completed_items }}
                        </div>
                        <div class="text-xs text-slate-500 mt-1">
                            Terkumpul: <strong>{{ formatRupiah(stats.total_fulfilled_amount) }}</strong>
                        </div>
                    </div>

                    <div
                        @click="activeTab = 'contributions'"
                        class="bg-white dark:bg-slate-900 rounded-2xl p-5 border shadow-sm cursor-pointer transition hover:border-amber-400"
                        :class="stats.pending_contributions > 0 ? 'border-amber-300 dark:border-amber-700 bg-amber-50/40 dark:bg-amber-950/20' : 'border-slate-100 dark:border-slate-800'"
                    >
                        <div class="flex items-center justify-between text-slate-400 mb-2">
                            <span class="text-xs font-bold uppercase tracking-wider" :class="stats.pending_contributions > 0 ? 'text-amber-700 dark:text-amber-300' : 'text-slate-500'">
                                Donasi Menunggu
                            </span>
                            <DocumentCheckIcon class="w-5 h-5" :class="stats.pending_contributions > 0 ? 'text-amber-600 animate-bounce' : 'text-slate-400'" />
                        </div>
                        <div class="text-2xl sm:text-3xl font-black" :class="stats.pending_contributions > 0 ? 'text-amber-600 dark:text-amber-400' : 'text-slate-900 dark:text-white'">
                            {{ stats.pending_contributions }}
                        </div>
                        <div class="text-xs text-slate-500 mt-1 flex items-center justify-between">
                            <span>Perlu verifikasi pengurus</span>
                            <span v-if="stats.pending_contributions > 0" class="text-amber-600 font-bold">Buka Tab →</span>
                        </div>
                    </div>
                </div>

                <!-- Tab Navigation & Main Section -->
                <div class="bg-white dark:bg-slate-900 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm overflow-hidden">
                    <!-- Tabs Bar -->
                    <div class="border-b border-slate-100 dark:border-slate-800 p-4 sm:p-6 flex flex-col sm:flex-row justify-between items-center gap-4">
                        <div class="flex items-center gap-2 w-full sm:w-auto">
                            <button
                                @click="activeTab = 'items'"
                                :class="[
                                    'px-5 py-2.5 rounded-xl text-xs font-bold transition flex items-center gap-2',
                                    activeTab === 'items'
                                        ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/30'
                                        : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-slate-200'
                                ]"
                            >
                                <ShoppingBagIcon class="w-4 h-4" />
                                <span>Daftar Kebutuhan Barang</span>
                            </button>

                            <button
                                @click="activeTab = 'contributions'"
                                :class="[
                                    'px-5 py-2.5 rounded-xl text-xs font-bold transition flex items-center gap-2 relative',
                                    activeTab === 'contributions'
                                        ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/30'
                                        : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-slate-200'
                                ]"
                            >
                                <DocumentCheckIcon class="w-4 h-4" />
                                <span>Verifikasi Kontribusi Jamaah</span>
                                <span
                                    v-if="pendingContributions && pendingContributions.length > 0"
                                    class="inline-flex items-center justify-center px-1.5 py-0.5 text-[10px] font-bold text-white bg-rose-500 rounded-full"
                                >
                                    {{ pendingContributions.length }}
                                </span>
                            </button>
                        </div>

                        <!-- Filter Controls (for items tab) -->
                        <div v-if="activeTab === 'items'" class="flex items-center gap-3 w-full sm:w-auto">
                            <select
                                v-model="statusFilter"
                                @change="applyFilters"
                                class="rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-xs font-medium text-slate-700 dark:text-slate-300 py-2 pl-3 pr-8"
                            >
                                <option value="semua">Semua Status</option>
                                <option value="active">Aktif</option>
                                <option value="pending">Menunggu</option>
                                <option value="completed">Selesai</option>
                                <option value="cancelled">Dibatalkan</option>
                            </select>

                            <div class="relative w-full sm:w-64">
                                <MagnifyingGlassIcon class="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                                <input
                                    v-model="search"
                                    @input="handleSearch"
                                    type="text"
                                    placeholder="Cari kebutuhan..."
                                    class="w-full pl-9 pr-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs text-slate-800 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                />
                            </div>
                        </div>
                    </div>

                    <!-- TAB 1: WISHLIST ITEMS TABLE -->
                    <div v-if="activeTab === 'items'" class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-slate-50/80 dark:bg-slate-800/50 border-b border-slate-100 dark:border-slate-800 text-[11px] font-extrabold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
                                    <th class="px-6 py-4">Nama Barang & Deskripsi</th>
                                    <th class="px-6 py-4">Harga Satuan</th>
                                    <th class="px-6 py-4">Progres Pemenuhan</th>
                                    <th class="px-6 py-4">Total Target</th>
                                    <th class="px-6 py-4">Status</th>
                                    <th class="px-6 py-4 text-right">Aksi</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 dark:divide-slate-800">
                                <tr
                                    v-for="item in wishlists.data"
                                    :key="item.id"
                                    class="hover:bg-slate-50/50 dark:hover:bg-slate-800/30 transition-colors"
                                >
                                    <!-- Name & Desc -->
                                    <td class="px-6 py-4">
                                        <div class="font-bold text-slate-900 dark:text-white text-sm">
                                            {{ item.item_name }}
                                        </div>
                                        <div class="text-xs text-slate-500 dark:text-slate-400 max-w-xs truncate mt-0.5">
                                            {{ item.description || '-' }}
                                        </div>
                                        <div v-if="item.pending_contributions_count > 0" class="mt-1">
                                            <span class="inline-flex items-center gap-1 text-[10px] font-bold text-amber-600 bg-amber-50 px-2 py-0.5 rounded-full border border-amber-200">
                                                {{ item.pending_contributions_count }} donasi pending
                                            </span>
                                        </div>
                                    </td>

                                    <!-- Unit Price -->
                                    <td class="px-6 py-4 text-xs font-semibold text-slate-700 dark:text-slate-300">
                                        {{ item.formatted_unit_price }}
                                    </td>

                                    <!-- Progress -->
                                    <td class="px-6 py-4 w-56">
                                        <div class="flex items-center justify-between text-xs mb-1 font-bold">
                                            <span class="text-slate-800 dark:text-slate-200">{{ item.fulfilled_qty }} / {{ item.target_qty }} unit</span>
                                            <span class="text-emerald-600 dark:text-emerald-400">{{ item.progress_percentage }}%</span>
                                        </div>
                                        <div class="w-full bg-slate-100 dark:bg-slate-800 h-2 rounded-full overflow-hidden">
                                            <div
                                                class="h-full rounded-full"
                                                :class="item.status === 'completed' ? 'bg-teal-500' : 'bg-gradient-to-r from-emerald-500 to-teal-400'"
                                                :style="{ width: `${item.progress_percentage}%` }"
                                            ></div>
                                        </div>
                                        <div class="text-[10px] text-slate-400 mt-1">Sisa: {{ item.remaining_qty }} unit</div>
                                    </td>

                                    <!-- Total Target -->
                                    <td class="px-6 py-4 text-xs font-bold text-emerald-600 dark:text-emerald-400">
                                        {{ item.formatted_total_target }}
                                    </td>

                                    <!-- Status Badge -->
                                    <td class="px-6 py-4">
                                        <span
                                            v-if="item.status === 'completed'"
                                            class="inline-flex items-center px-2.5 py-1 rounded-full text-[11px] font-bold bg-teal-50 text-teal-700 border border-teal-200"
                                        >
                                            Selesai
                                        </span>
                                        <span
                                            v-else-if="item.status === 'active'"
                                            class="inline-flex items-center px-2.5 py-1 rounded-full text-[11px] font-bold bg-amber-50 text-amber-700 border border-amber-200"
                                        >
                                            Aktif
                                        </span>
                                        <span
                                            v-else
                                            class="inline-flex items-center px-2.5 py-1 rounded-full text-[11px] font-bold bg-slate-100 text-slate-700"
                                        >
                                            {{ item.status_label }}
                                        </span>
                                    </td>

                                    <!-- Actions -->
                                    <td class="px-6 py-4 text-right">
                                        <div class="flex items-center justify-end gap-1.5">
                                            <button
                                                @click="openManualContributionModal(item)"
                                                class="p-2 text-emerald-600 hover:bg-emerald-50 dark:hover:bg-emerald-950/60 rounded-xl transition"
                                                title="Catat Donasi Masuk (Offline)"
                                            >
                                                <PlusIcon class="w-4 h-4" />
                                            </button>
                                            <button
                                                @click="openWishlistModal(item)"
                                                class="p-2 text-amber-600 hover:bg-amber-50 dark:hover:bg-amber-950/60 rounded-xl transition"
                                                title="Edit Kebutuhan"
                                            >
                                                <PencilSquareIcon class="w-4 h-4" />
                                            </button>
                                            <button
                                                @click="deleteWishlist(item)"
                                                class="p-2 text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/60 rounded-xl transition"
                                                title="Hapus Kebutuhan"
                                            >
                                                <TrashIcon class="w-4 h-4" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>

                                <tr v-if="wishlists.data.length === 0">
                                    <td colspan="6" class="px-6 py-12 text-center text-slate-400 text-sm">
                                        Belum ada data kebutuhan masjid yang tercatat. Silakan klik "+ Tambah Kebutuhan".
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <div v-if="wishlists.links && wishlists.links.length > 3" class="p-6 border-t border-slate-100 dark:border-slate-800 flex justify-center">
                            <div class="flex flex-wrap gap-1">
                                <template v-for="(link, k) in wishlists.links" :key="k">
                                    <div
                                        v-if="link.url === null"
                                        class="px-3.5 py-1.5 text-xs text-slate-400 border rounded-lg bg-white dark:bg-slate-800 opacity-60"
                                        v-html="link.label"
                                    ></div>
                                    <Link
                                        v-else
                                        :href="link.url"
                                        class="px-3.5 py-1.5 text-xs border rounded-lg bg-white dark:bg-slate-800 transition"
                                        :class="link.active ? 'bg-emerald-600 text-white border-emerald-600 font-bold' : 'text-slate-700 dark:text-slate-300 hover:bg-slate-50'"
                                        v-html="link.label"
                                    ></Link>
                                </template>
                            </div>
                        </div>
                    </div>

                    <!-- TAB 2: PENDING CONTRIBUTIONS VERIFICATION TABLE -->
                    <div v-if="activeTab === 'contributions'" class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-slate-50/80 dark:bg-slate-800/50 border-b border-slate-100 dark:border-slate-800 text-[11px] font-extrabold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
                                    <th class="px-6 py-4">Tanggal & Donatur</th>
                                    <th class="px-6 py-4">Kebutuhan Barang</th>
                                    <th class="px-6 py-4">Bentuk & Jumlah</th>
                                    <th class="px-6 py-4">Bukti / Foto</th>
                                    <th class="px-6 py-4">Doa / Pesan</th>
                                    <th class="px-6 py-4 text-right">Verifikasi</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 dark:divide-slate-800">
                                <tr
                                    v-for="c in pendingContributions"
                                    :key="c.id"
                                    class="hover:bg-slate-50/50 dark:hover:bg-slate-800/30 transition-colors"
                                >
                                    <!-- Donor info -->
                                    <td class="px-6 py-4">
                                        <div class="font-bold text-slate-900 dark:text-white text-sm">
                                            {{ c.donor_name }}
                                            <span v-if="c.is_anonymous" class="text-[10px] text-amber-600 bg-amber-50 px-1.5 py-0.5 rounded ml-1">
                                                (Anonim di web)
                                            </span>
                                        </div>
                                        <div class="text-xs text-slate-500 mt-0.5 font-mono">
                                            {{ c.donor_phone }}
                                        </div>
                                        <div class="text-[11px] text-slate-400 mt-0.5">
                                            {{ formatDate(c.created_at) }}
                                        </div>
                                    </td>

                                    <!-- Target Item -->
                                    <td class="px-6 py-4">
                                        <div class="font-bold text-slate-800 dark:text-slate-200 text-sm">
                                            {{ c.wishlist?.item_name || 'Item telah dihapus' }}
                                        </div>
                                    </td>

                                    <!-- Quantity & Type -->
                                    <td class="px-6 py-4">
                                        <div class="text-xs font-bold text-slate-800 dark:text-slate-200">
                                            {{ c.quantity }} Unit
                                        </div>
                                        <span class="inline-flex items-center text-[10px] font-semibold px-2 py-0.5 rounded-full bg-slate-100 text-slate-700 mt-1">
                                            {{ c.type_label }}
                                        </span>
                                        <div v-if="c.amount" class="text-xs font-extrabold text-emerald-600 mt-1">
                                            {{ c.formatted_amount }}
                                        </div>
                                    </td>

                                    <!-- Proof -->
                                    <td class="px-6 py-4">
                                        <div v-if="c.proof_image_url">
                                            <button
                                                @click="openProofPreview(c.proof_image_url)"
                                                class="flex items-center gap-1 text-xs font-bold text-emerald-600 hover:text-emerald-700 underline"
                                            >
                                                <PhotoIcon class="w-4 h-4" />
                                                Lihat Struk
                                            </button>
                                        </div>
                                        <span v-else class="text-xs text-slate-400 italic">Tidak ada foto</span>
                                    </td>

                                    <!-- Notes -->
                                    <td class="px-6 py-4 max-w-xs">
                                        <p class="text-xs text-slate-600 dark:text-slate-400 italic line-clamp-2">
                                            {{ c.notes || '-' }}
                                        </p>
                                    </td>

                                    <!-- Verify Actions -->
                                    <td class="px-6 py-4 text-right">
                                        <div class="flex items-center justify-end gap-2">
                                            <button
                                                @click="verifyContribution(c)"
                                                class="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold flex items-center gap-1 transition shadow-sm"
                                            >
                                                <CheckIcon class="w-4 h-4" />
                                                Setujui
                                            </button>
                                            <button
                                                @click="openRejectModal(c)"
                                                class="px-3 py-1.5 bg-rose-50 text-rose-700 hover:bg-rose-100 rounded-xl text-xs font-bold flex items-center gap-1 transition border border-rose-200"
                                            >
                                                <XMarkIcon class="w-4 h-4" />
                                                Tolak
                                            </button>
                                        </div>
                                    </td>
                                </tr>

                                <tr v-if="!pendingContributions || pendingContributions.length === 0">
                                    <td colspan="6" class="px-6 py-12 text-center text-slate-400 text-sm">
                                        Tidak ada donasi baru yang menunggu verifikasi saat ini.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL 1: ADD / EDIT WISHLIST -->
        <TransitionRoot as="template" :show="showWishlistModal">
            <Dialog as="div" class="relative z-50" @close="closeWishlistModal">
                <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0" enter-to="opacity-100" leave="ease-in duration-200" leave-from="opacity-100" leave-to="opacity-0">
                    <div class="fixed inset-0 bg-slate-900/75 transition-opacity" />
                </TransitionChild>

                <div class="fixed inset-0 z-10 overflow-y-auto">
                    <div class="flex min-h-full items-center justify-center p-4 text-center">
                        <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0 scale-95" enter-to="opacity-100 scale-100" leave="ease-in duration-200" leave-from="opacity-100 scale-100" leave-to="opacity-0 scale-95">
                            <DialogPanel class="w-full max-w-lg transform overflow-hidden rounded-3xl bg-white dark:bg-slate-900 p-6 sm:p-8 text-left align-middle shadow-2xl border border-slate-100 dark:border-slate-800 transition-all">
                                <div class="flex items-center justify-between mb-6 border-b border-slate-100 dark:border-slate-800 pb-4">
                                    <DialogTitle as="h3" class="text-lg font-bold text-slate-900 dark:text-white flex items-center gap-2">
                                        <GiftIcon class="w-5 h-5 text-emerald-600" />
                                        {{ editingWishlist ? 'Edit Kebutuhan Masjid' : 'Tambah Kebutuhan Baru' }}
                                    </DialogTitle>
                                    <button @click="closeWishlistModal" class="text-slate-400 hover:text-slate-600">
                                        <XMarkIcon class="w-5 h-5" />
                                    </button>
                                </div>

                                <form @submit.prevent="submitWishlist" class="space-y-4">
                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                            Nama Kebutuhan / Barang
                                        </label>
                                        <input
                                            v-model="wishlistForm.item_name"
                                            type="text"
                                            placeholder="Contoh: Karpet Sholat Saf Utama"
                                            class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm font-semibold text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                            required
                                        />
                                        <div v-if="wishlistForm.errors.item_name" class="text-rose-500 text-xs mt-1">{{ wishlistForm.errors.item_name }}</div>
                                    </div>

                                    <div class="grid grid-cols-2 gap-3">
                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                                Target Kuantitas
                                            </label>
                                            <input
                                                v-model.number="wishlistForm.target_qty"
                                                type="number"
                                                min="1"
                                                class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm font-bold text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                                required
                                            />
                                        </div>

                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                                Sudah Terpenuhi
                                            </label>
                                            <input
                                                v-model.number="wishlistForm.fulfilled_qty"
                                                type="number"
                                                min="0"
                                                class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm font-bold text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                                required
                                            />
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-2 gap-3">
                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                                Estimasi Harga / Unit (Rp)
                                            </label>
                                            <input
                                                v-model.number="wishlistForm.unit_price"
                                                type="number"
                                                min="0"
                                                class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm font-bold text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                                required
                                            />
                                        </div>

                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                                Status
                                            </label>
                                            <select
                                                v-model="wishlistForm.status"
                                                class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm font-semibold text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                            >
                                                <option value="active">Aktif (Sedang Dibutuhkan)</option>
                                                <option value="pending">Menunggu Pengadaan</option>
                                                <option value="completed">Selesai (Terpenuhi)</option>
                                                <option value="cancelled">Dibatalkan</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                            Deskripsi & Spesifikasi Barang
                                        </label>
                                        <textarea
                                            v-model="wishlistForm.description"
                                            rows="3"
                                            placeholder="Jelaskan spesifikasi ukuran, merk, atau fungsi barang..."
                                            class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                        ></textarea>
                                    </div>

                                    <div class="flex justify-end gap-3 pt-4 border-t border-slate-100 dark:border-slate-800">
                                        <button
                                            type="button"
                                            @click="closeWishlistModal"
                                            class="px-4 py-2 bg-slate-100 text-slate-700 rounded-xl text-xs font-bold hover:bg-slate-200 transition"
                                        >
                                            Batal
                                        </button>
                                        <button
                                            type="submit"
                                            :disabled="wishlistForm.processing"
                                            class="px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold transition shadow-md"
                                        >
                                            {{ editingWishlist ? 'Simpan Perubahan' : 'Buat Kebutuhan' }}
                                        </button>
                                    </div>
                                </form>
                            </DialogPanel>
                        </TransitionChild>
                    </div>
                </div>
            </Dialog>
        </TransitionRoot>

        <!-- MODAL 2: MANUAL CONTRIBUTION OFFLINE -->
        <TransitionRoot as="template" :show="showManualContributionModal">
            <Dialog as="div" class="relative z-50" @close="closeManualContributionModal">
                <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0" enter-to="opacity-100" leave="ease-in duration-200" leave-from="opacity-100" leave-to="opacity-0">
                    <div class="fixed inset-0 bg-slate-900/75 transition-opacity" />
                </TransitionChild>

                <div class="fixed inset-0 z-10 overflow-y-auto">
                    <div class="flex min-h-full items-center justify-center p-4 text-center">
                        <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0 scale-95" enter-to="opacity-100 scale-100" leave="ease-in duration-200" leave-from="opacity-100 scale-100" leave-to="opacity-0 scale-95">
                            <DialogPanel class="w-full max-w-lg transform overflow-hidden rounded-3xl bg-white dark:bg-slate-900 p-6 sm:p-8 text-left align-middle shadow-2xl border border-slate-100 dark:border-slate-800 transition-all">
                                <div class="flex items-center justify-between mb-4 border-b border-slate-100 dark:border-slate-800 pb-3">
                                    <div>
                                        <DialogTitle as="h3" class="text-lg font-bold text-slate-900 dark:text-white">
                                            Catat Donasi Masuk (Offline)
                                        </DialogTitle>
                                        <p class="text-xs text-emerald-600 font-bold mt-0.5">
                                            Untuk: {{ targetWishlistForContribution?.item_name }}
                                        </p>
                                    </div>
                                    <button @click="closeManualContributionModal" class="text-slate-400 hover:text-slate-600">
                                        <XMarkIcon class="w-5 h-5" />
                                    </button>
                                </div>

                                <form @submit.prevent="submitManualContribution" class="space-y-4">
                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                            Nama Donatur
                                        </label>
                                        <input
                                            v-model="manualContributionForm.donor_name"
                                            type="text"
                                            placeholder="Nama donatur"
                                            class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm font-semibold text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                            required
                                        />
                                    </div>

                                    <div class="grid grid-cols-2 gap-3">
                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                                No. Telepon / WA
                                            </label>
                                            <input
                                                v-model="manualContributionForm.donor_phone"
                                                type="tel"
                                                placeholder="08..."
                                                class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                            />
                                        </div>

                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                                Jumlah Unit
                                            </label>
                                            <input
                                                v-model.number="manualContributionForm.quantity"
                                                type="number"
                                                min="1"
                                                class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm font-bold text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                                required
                                            />
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-2 gap-3">
                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                                Bentuk Donasi
                                            </label>
                                            <select
                                                v-model="manualContributionForm.type"
                                                class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm font-semibold text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                            >
                                                <option value="barang">Barang Fisik</option>
                                                <option value="dana">Uang / Transfer Dana</option>
                                            </select>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                                Nominal (Opsional)
                                            </label>
                                            <input
                                                v-model.number="manualContributionForm.amount"
                                                type="number"
                                                placeholder="Rp 0"
                                                class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                            />
                                        </div>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                            Catatan / Doa
                                        </label>
                                        <textarea
                                            v-model="manualContributionForm.notes"
                                            rows="2"
                                            placeholder="Keterangan serah terima..."
                                            class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                                        ></textarea>
                                    </div>

                                    <div class="flex items-center gap-2">
                                        <input
                                            id="manual-anon"
                                            v-model="manualContributionForm.is_anonymous"
                                            type="checkbox"
                                            class="w-4 h-4 rounded text-emerald-600 focus:ring-emerald-500"
                                        />
                                        <label for="manual-anon" class="text-xs text-slate-600 dark:text-slate-400 cursor-pointer">
                                            Tampilkan sebagai Hamba Allah di web
                                        </label>
                                    </div>

                                    <div class="flex justify-end gap-3 pt-4 border-t border-slate-100 dark:border-slate-800">
                                        <button
                                            type="button"
                                            @click="closeManualContributionModal"
                                            class="px-4 py-2 bg-slate-100 text-slate-700 rounded-xl text-xs font-bold hover:bg-slate-200 transition"
                                        >
                                            Batal
                                        </button>
                                        <button
                                            type="submit"
                                            :disabled="manualContributionForm.processing"
                                            class="px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold transition shadow-md"
                                        >
                                            Simpan Donasi Masuk
                                        </button>
                                    </div>
                                </form>
                            </DialogPanel>
                        </TransitionChild>
                    </div>
                </div>
            </Dialog>
        </TransitionRoot>

        <!-- MODAL 3: REJECT CONTRIBUTION -->
        <TransitionRoot as="template" :show="showRejectModal">
            <Dialog as="div" class="relative z-50" @close="showRejectModal = false">
                <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0" enter-to="opacity-100" leave="ease-in duration-200" leave-from="opacity-100" leave-to="opacity-0">
                    <div class="fixed inset-0 bg-slate-900/75 transition-opacity" />
                </TransitionChild>

                <div class="fixed inset-0 z-10 overflow-y-auto">
                    <div class="flex min-h-full items-center justify-center p-4 text-center">
                        <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0 scale-95" enter-to="opacity-100 scale-100" leave="ease-in duration-200" leave-from="opacity-100 scale-100" leave-to="opacity-0 scale-95">
                            <DialogPanel class="w-full max-w-md transform overflow-hidden rounded-3xl bg-white dark:bg-slate-900 p-6 text-left align-middle shadow-2xl border border-slate-100 dark:border-slate-800 transition-all">
                                <DialogTitle as="h3" class="text-base font-bold text-slate-900 dark:text-white mb-2">
                                    Tolak Kontribusi Donasi
                                </DialogTitle>
                                <p class="text-xs text-slate-500 dark:text-slate-400 mb-4">
                                    Donasi dari <strong>{{ rejectingContribution?.donor_name }}</strong> akan ditandai sebagai ditolak.
                                </p>

                                <div>
                                    <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1">
                                        Alasan Penolakan
                                    </label>
                                    <textarea
                                        v-model="rejectNotes"
                                        rows="3"
                                        placeholder="Contoh: Bukti transfer tidak terbaca / dana belum masuk rekening..."
                                        class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-rose-500"
                                    ></textarea>
                                </div>

                                <div class="flex justify-end gap-3 pt-4 border-t border-slate-100 dark:border-slate-800 mt-4">
                                    <button
                                        type="button"
                                        @click="showRejectModal = false"
                                        class="px-4 py-2 bg-slate-100 text-slate-700 rounded-xl text-xs font-bold hover:bg-slate-200 transition"
                                    >
                                        Batal
                                    </button>
                                    <button
                                        type="button"
                                        @click="confirmReject"
                                        class="px-5 py-2 bg-rose-600 hover:bg-rose-700 text-white rounded-xl text-xs font-bold transition shadow-md"
                                    >
                                        Tolak Kontribusi
                                    </button>
                                </div>
                            </DialogPanel>
                        </TransitionChild>
                    </div>
                </div>
            </Dialog>
        </TransitionRoot>

        <!-- LIGHTBOX PROOF IMAGE MODAL -->
        <TransitionRoot as="template" :show="!!previewImageUrl">
            <Dialog as="div" class="relative z-50" @close="previewImageUrl = null">
                <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0" enter-to="opacity-100" leave="ease-in duration-200" leave-from="opacity-100" leave-to="opacity-0">
                    <div class="fixed inset-0 bg-slate-900/90 backdrop-blur-sm transition-opacity" />
                </TransitionChild>

                <div class="fixed inset-0 z-10 overflow-y-auto">
                    <div class="flex min-h-full items-center justify-center p-4 text-center">
                        <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0 scale-95" enter-to="opacity-100 scale-100" leave="ease-in duration-200" leave-from="opacity-100 scale-100" leave-to="opacity-0 scale-95">
                            <DialogPanel class="relative max-w-2xl bg-white dark:bg-slate-900 rounded-3xl overflow-hidden shadow-2xl p-4">
                                <button
                                    @click="previewImageUrl = null"
                                    class="absolute top-4 right-4 p-2 bg-slate-900/60 hover:bg-slate-900 text-white rounded-full transition z-10"
                                >
                                    <XMarkIcon class="w-5 h-5" />
                                </button>
                                <img :src="previewImageUrl" class="max-h-[80vh] w-auto mx-auto rounded-2xl object-contain" />
                            </DialogPanel>
                        </TransitionChild>
                    </div>
                </div>
            </Dialog>
        </TransitionRoot>
    </AuthenticatedLayout>
</template>
