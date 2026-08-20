<script setup>
import { ref, watch } from 'vue';
import { Head, Link, router } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import {
    GiftIcon,
    SparklesIcon,
    MagnifyingGlassIcon,
    CheckCircleIcon,
    ClockIcon,
    HeartIcon,
    ArrowRightIcon,
    BuildingLibraryIcon,
    BanknotesIcon,
    ChevronRightIcon,
    ShieldCheckIcon,
    ShoppingBagIcon
} from '@heroicons/vue/24/outline';

const props = defineProps({
    wishlists: Object,
    filters: Object,
    stats: Object,
});

const search = ref(props.filters.search || '');
const selectedStatus = ref(props.filters.status || 'semua');

let searchTimeout = null;
const handleSearch = () => {
    clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        applyFilters();
    }, 400);
};

const setStatus = (status) => {
    selectedStatus.value = status;
    applyFilters();
};

const applyFilters = () => {
    router.get(
        route('public.wishlist.index'),
        {
            search: search.value || undefined,
            status: selectedStatus.value !== 'semua' ? selectedStatus.value : undefined,
        },
        {
            preserveState: true,
            preserveScroll: true,
            replace: true,
        }
    );
};

const formatRupiah = (val) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0
    }).format(val || 0);
};
</script>

<template>
    <Head title="Kebutuhan & Wishlist Masjid — Sedekah Jariyah" />

    <PublicLayout :transparent-nav="true">
        <!-- Hero Section -->
        <div class="relative bg-gradient-to-br from-emerald-950 via-emerald-900 to-teal-900 text-white pt-32 pb-24 overflow-hidden">
            <!-- Background Ornaments -->
            <div class="absolute inset-0 opacity-10 bg-[radial-gradient(#34d399_1px,transparent_1px)] [background-size:16px_16px]"></div>
            <div class="absolute -top-24 -right-24 w-96 h-96 bg-emerald-500/20 rounded-full blur-3xl pointer-events-none"></div>
            <div class="absolute -bottom-24 -left-24 w-96 h-96 bg-teal-500/20 rounded-full blur-3xl pointer-events-none"></div>

            <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                <!-- Badge -->
                <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-emerald-800/80 border border-emerald-700/60 text-emerald-200 text-xs font-semibold uppercase tracking-wider mb-6 shadow-inner">
                    <SparklesIcon class="w-4 h-4 text-amber-400" />
                    <span>Peluang Amal Jariyah & Pengadaan Sarana Ibadah</span>
                </div>

                <h1 class="text-3xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight text-white mb-6">
                    Kebutuhan & Wishlist <span class="bg-gradient-to-r from-amber-300 via-amber-200 to-emerald-200 bg-clip-text text-transparent">Masjid</span>
                </h1>

                <p class="max-w-2xl mx-auto text-base sm:text-lg text-emerald-100/90 leading-relaxed mb-10">
                    Bantu wujudkan fasilitas dan sarana ibadah terbaik bagi para jamaah. Setiap rupiah dan unit barang yang Anda sedekahkan menjadi pahala jariyah yang terus mengalir.
                </p>

                <!-- Summary Statistics Bar -->
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4 max-w-5xl mx-auto">
                    <div class="bg-white/10 backdrop-blur-md rounded-2xl p-4 sm:p-5 border border-white/10 text-left transition-all hover:bg-white/15">
                        <div class="text-emerald-300 text-xs font-bold uppercase tracking-wider mb-1 flex items-center gap-1.5">
                            <ShoppingBagIcon class="w-4 h-4" />
                            Total Kebutuhan
                        </div>
                        <div class="text-2xl sm:text-3xl font-black text-white">
                            {{ stats.total_items }} <span class="text-xs font-normal text-emerald-200">Item</span>
                        </div>
                        <div class="text-[11px] text-emerald-200/80 mt-1">Daftar sarana & prasarana</div>
                    </div>

                    <div class="bg-white/10 backdrop-blur-md rounded-2xl p-4 sm:p-5 border border-white/10 text-left transition-all hover:bg-white/15">
                        <div class="text-amber-300 text-xs font-bold uppercase tracking-wider mb-1 flex items-center gap-1.5">
                            <ClockIcon class="w-4 h-4" />
                            Sedang Berjalan
                        </div>
                        <div class="text-2xl sm:text-3xl font-black text-amber-300">
                            {{ stats.active_items }} <span class="text-xs font-normal text-amber-200">Item</span>
                        </div>
                        <div class="text-[11px] text-amber-100/80 mt-1">Menunggu uluran tangan Anda</div>
                    </div>

                    <div class="bg-white/10 backdrop-blur-md rounded-2xl p-4 sm:p-5 border border-white/10 text-left transition-all hover:bg-white/15">
                        <div class="text-teal-300 text-xs font-bold uppercase tracking-wider mb-1 flex items-center gap-1.5">
                            <CheckCircleIcon class="w-4 h-4" />
                            Sudah Terpenuhi
                        </div>
                        <div class="text-2xl sm:text-3xl font-black text-teal-300">
                            {{ stats.completed_items }} <span class="text-xs font-normal text-teal-200">Item</span>
                        </div>
                        <div class="text-[11px] text-teal-100/80 mt-1">Alhamdulillah telah lengkap</div>
                    </div>

                    <div class="bg-white/10 backdrop-blur-md rounded-2xl p-4 sm:p-5 border border-white/10 text-left transition-all hover:bg-white/15">
                        <div class="text-emerald-300 text-xs font-bold uppercase tracking-wider mb-1 flex items-center gap-1.5">
                            <BanknotesIcon class="w-4 h-4" />
                            Progres Pemenuhan
                        </div>
                        <div class="text-2xl sm:text-3xl font-black text-white">
                            {{ stats.overall_percentage }}%
                        </div>
                        <div class="text-[11px] text-emerald-200/80 mt-1">
                            {{ formatRupiah(stats.total_fulfilled_amount) }} terkumpul
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 -mt-8 relative z-10 pb-20">
            <!-- Filter & Search Card -->
            <div class="bg-white dark:bg-slate-900 rounded-2xl shadow-xl shadow-slate-200/50 dark:shadow-none border border-slate-100 dark:border-slate-800 p-4 sm:p-6 mb-10">
                <div class="flex flex-col md:flex-row gap-4 justify-between items-center">
                    <!-- Status Filter Tabs -->
                    <div class="flex flex-wrap gap-2 w-full md:w-auto">
                        <button
                            @click="setStatus('semua')"
                            :class="[
                                'px-4 py-2 rounded-xl text-xs font-bold transition-all',
                                selectedStatus === 'semua'
                                    ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/30'
                                    : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200'
                            ]"
                        >
                            Semua Kebutuhan
                        </button>
                        <button
                            @click="setStatus('active')"
                            :class="[
                                'px-4 py-2 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5',
                                selectedStatus === 'active'
                                    ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/30'
                                    : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200'
                            ]"
                        >
                            <span class="w-2 h-2 rounded-full bg-amber-400 inline-block animate-pulse"></span>
                            Sedang Dibutuhkan ({{ stats.active_items }})
                        </button>
                        <button
                            @click="setStatus('completed')"
                            :class="[
                                'px-4 py-2 rounded-xl text-xs font-bold transition-all',
                                selectedStatus === 'completed'
                                    ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/30'
                                    : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200'
                            ]"
                        >
                            Sudah Terpenuhi ({{ stats.completed_items }})
                        </button>
                    </div>

                    <!-- Search Input -->
                    <div class="relative w-full md:w-80">
                        <MagnifyingGlassIcon class="w-5 h-5 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                        <input
                            v-model="search"
                            @input="handleSearch"
                            type="text"
                            placeholder="Cari barang atau kebutuhan..."
                            class="w-full pl-10 pr-4 py-2.5 bg-slate-50 dark:bg-slate-800/80 border border-slate-200 dark:border-slate-700 rounded-xl text-sm focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all text-slate-800 dark:text-white"
                        />
                    </div>
                </div>
            </div>

            <!-- Wishlist Grid -->
            <div v-if="wishlists.data && wishlists.data.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8">
                <div
                    v-for="item in wishlists.data"
                    :key="item.id"
                    class="group bg-white dark:bg-slate-900 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm hover:shadow-xl hover:border-emerald-200 dark:hover:border-emerald-800/50 transition-all duration-300 flex flex-col justify-between overflow-hidden"
                >
                    <!-- Card Top Content -->
                    <div class="p-6 sm:p-7">
                        <!-- Status Badge & Icon -->
                        <div class="flex items-center justify-between mb-4">
                            <div class="w-12 h-12 rounded-2xl bg-emerald-50 dark:bg-emerald-950/60 border border-emerald-100 dark:border-emerald-800/60 flex items-center justify-center text-emerald-600 dark:text-emerald-400 shadow-sm group-hover:scale-110 transition-transform">
                                <GiftIcon class="w-6 h-6" />
                            </div>

                            <span
                                v-if="item.status === 'completed'"
                                class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-teal-50 text-teal-700 dark:bg-teal-950/80 dark:text-teal-300 border border-teal-200 dark:border-teal-800"
                            >
                                <CheckCircleIcon class="w-4 h-4" />
                                Terpenuhi
                            </span>
                            <span
                                v-else-if="item.status === 'active'"
                                class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-amber-50 text-amber-700 dark:bg-amber-950/80 dark:text-amber-300 border border-amber-200 dark:border-amber-800"
                            >
                                <span class="w-2 h-2 rounded-full bg-amber-500 animate-pulse"></span>
                                Butuh {{ item.remaining_qty }} Unit Lagi
                            </span>
                            <span
                                v-else
                                class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300"
                            >
                                {{ item.status_label }}
                            </span>
                        </div>

                        <!-- Item Title -->
                        <h3 class="text-xl font-bold text-slate-900 dark:text-white group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-colors line-clamp-1 mb-2">
                            {{ item.item_name }}
                        </h3>

                        <!-- Item Description -->
                        <p class="text-sm text-slate-500 dark:text-slate-400 line-clamp-2 mb-6 min-h-[2.5rem]">
                            {{ item.description || 'Penyediaan dan pengadaan sarana fasilitas ibadah untuk kemakmuran masjid dan kenyamanan jamaah.' }}
                        </p>

                        <!-- Progress Section -->
                        <div class="space-y-2 mb-6 bg-slate-50 dark:bg-slate-800/40 p-4 rounded-2xl border border-slate-100 dark:border-slate-800/60">
                            <div class="flex justify-between items-center text-xs font-bold">
                                <span class="text-slate-600 dark:text-slate-300">Progress Pemenuhan</span>
                                <span class="text-emerald-600 dark:text-emerald-400 font-extrabold">{{ item.progress_percentage }}%</span>
                            </div>

                            <!-- Progress Bar -->
                            <div class="w-full bg-slate-200 dark:bg-slate-700 h-2.5 rounded-full overflow-hidden">
                                <div
                                    class="h-full rounded-full transition-all duration-700 ease-out"
                                    :class="item.status === 'completed' ? 'bg-teal-500' : 'bg-gradient-to-r from-emerald-500 to-teal-400'"
                                    :style="{ width: `${item.progress_percentage}%` }"
                                ></div>
                            </div>

                            <div class="flex justify-between items-center text-[11px] text-slate-500 dark:text-slate-400 pt-1">
                                <span>Terkumpul: <strong class="text-slate-700 dark:text-slate-200">{{ item.fulfilled_qty }}</strong> unit</span>
                                <span>Target: <strong class="text-slate-700 dark:text-slate-200">{{ item.target_qty }}</strong> unit</span>
                            </div>
                        </div>

                        <!-- Financial Details -->
                        <div class="flex justify-between items-center pt-2 border-t border-slate-100 dark:border-slate-800/80 text-xs">
                            <div class="text-slate-500 dark:text-slate-400">
                                <div>Estimasi / Unit:</div>
                                <div class="font-bold text-slate-800 dark:text-slate-200 text-sm mt-0.5">
                                    {{ item.formatted_unit_price }}
                                </div>
                            </div>

                            <div class="text-right text-slate-500 dark:text-slate-400">
                                <div>Total Nilai:</div>
                                <div class="font-bold text-emerald-600 dark:text-emerald-400 text-sm mt-0.5">
                                    {{ item.formatted_total_target }}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Card Footer Actions -->
                    <div class="p-6 pt-0">
                        <Link
                            :href="route('public.wishlist.show', item.id)"
                            :class="[
                                'w-full py-3 px-4 rounded-xl font-bold text-sm flex items-center justify-center gap-2 transition-all duration-200',
                                item.status === 'completed'
                                    ? 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-200'
                                    : 'bg-gradient-to-r from-emerald-600 to-teal-600 text-white shadow-lg shadow-emerald-600/20 hover:shadow-emerald-600/40 hover:-translate-y-0.5'
                            ]"
                        >
                            <span v-if="item.status === 'completed'">Lihat Detail Pengadaan</span>
                            <span v-else class="flex items-center gap-1.5">
                                <HeartIcon class="w-4 h-4 text-amber-300" />
                                Bantu Donasi Sekarang
                            </span>
                            <ArrowRightIcon class="w-4 h-4" />
                        </Link>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div
                v-else
                class="bg-white dark:bg-slate-900 rounded-3xl border border-slate-100 dark:border-slate-800 p-12 text-center max-w-lg mx-auto shadow-sm"
            >
                <div class="w-16 h-16 rounded-full bg-emerald-50 dark:bg-emerald-950 flex items-center justify-center text-emerald-600 mx-auto mb-4">
                    <ShoppingBagIcon class="w-8 h-8" />
                </div>
                <h3 class="text-lg font-bold text-slate-800 dark:text-white mb-2">Tidak Ada Kebutuhan Ditemukan</h3>
                <p class="text-sm text-slate-500 dark:text-slate-400 mb-6">
                    Tidak ada data kebutuhan barang masjid yang sesuai dengan kata kunci atau filter yang Anda pilih.
                </p>
                <button
                    @click="search = ''; setStatus('semua');"
                    class="px-5 py-2.5 bg-emerald-600 text-white rounded-xl text-xs font-bold hover:bg-emerald-700 transition"
                >
                    Reset Filter
                </button>
            </div>

            <!-- Pagination -->
            <div v-if="wishlists.links && wishlists.links.length > 3" class="mt-12 flex justify-center">
                <div class="flex flex-wrap gap-1.5">
                    <template v-for="(link, k) in wishlists.links" :key="k">
                        <div
                            v-if="link.url === null"
                            class="px-4 py-2 text-xs font-medium text-slate-400 border border-slate-200 dark:border-slate-700 rounded-xl bg-white dark:bg-slate-900 opacity-60"
                            v-html="link.label"
                        ></div>
                        <Link
                            v-else
                            :href="link.url"
                            class="px-4 py-2 text-xs font-bold border rounded-xl bg-white dark:bg-slate-900 transition-colors"
                            :class="link.active ? 'bg-emerald-600 text-white border-emerald-600 shadow-md shadow-emerald-600/30' : 'text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800'"
                            v-html="link.label"
                        ></Link>
                    </template>
                </div>
            </div>

            <!-- FAQ / Info Banner -->
            <div class="mt-16 bg-gradient-to-br from-slate-900 to-emerald-950 text-white rounded-3xl p-8 sm:p-10 shadow-2xl relative overflow-hidden">
                <div class="relative z-10 flex flex-col md:flex-row items-center justify-between gap-6">
                    <div class="max-w-2xl">
                        <div class="flex items-center gap-2 text-amber-300 font-bold text-xs uppercase tracking-wider mb-2">
                            <ShieldCheckIcon class="w-5 h-5" />
                            Transparansi & Akuntabilitas PIMASJID
                        </div>
                        <h2 class="text-2xl sm:text-3xl font-extrabold mb-3">
                            Punya Barang Fisik Ingin Diwakafkan?
                        </h2>
                        <p class="text-emerald-100 text-sm leading-relaxed">
                            Pengurus masjid menerima serah terima barang secara langsung di lokasi masjid atau melalui konfirmasi online. Setiap barang yang diserahkan akan dicatat dalam inventaris resmi dan laporan transparansi aset masjid.
                        </p>
                    </div>

                    <div class="shrink-0 flex flex-col sm:flex-row gap-3">
                        <a
                            :href="$page.props.settings?.whatsapp ? `https://wa.me/${$page.props.settings.whatsapp}?text=Assalamu%27alaikum%20Pengurus%20Masjid%2C%20saya%20ingin%20berdonasi%20barang` : 'https://wa.me/6282346719219?text=Assalamu%27alaikum%20Pengurus%20Masjid%2C%20saya%20ingin%20berdonasi%20barang'"
                            target="_blank"
                            class="px-6 py-3 bg-amber-400 hover:bg-amber-300 text-slate-900 rounded-xl font-bold text-xs uppercase tracking-wider transition shadow-lg text-center"
                        >
                            Hubungi Pengurus
                        </a>
                        <Link
                            :href="route('public.keuangan')"
                            class="px-6 py-3 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl font-bold text-xs uppercase tracking-wider transition text-center"
                        >
                            Laporan Keuangan
                        </Link>
                    </div>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>
