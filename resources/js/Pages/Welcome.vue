<script setup>
import { ref, computed, onMounted } from 'vue';
import { Head, Link } from '@inertiajs/vue3';
import { Dialog, DialogPanel, TransitionChild, TransitionRoot, DialogTitle } from '@headlessui/vue';
import { 
    ClockIcon, 
    CurrencyDollarIcon, 
    HeartIcon, 
    ArrowRightIcon,
    CalendarIcon,
    MapPinIcon,
    ArrowPathIcon
} from '@heroicons/vue/24/outline';
import PublicLayout from '@/Layouts/PublicLayout.vue';

// Define layout
defineOptions({
    layout: PublicLayout
});

const props = defineProps({
    prayerTimes: Object,
    nextPrayer: Object,
    financialSummary: Object,
    slides: Array,
    committee: Object,
    jumatSchedule: Object,
    posts: Array,
});


const layoutRef = ref(null);

const openDonationModal = () => {
    // Access layout's method via ref
    if (layoutRef.value) {
        layoutRef.value.openDonationModal();
    }
};

// Committee helpers
const coreLeadership = computed(() => {
    return props.committee?.Inti?.sort((a, b) => a.order - b.order) || [];
});

const divisions = computed(() => {
    const { Inti, ...rest } = props.committee || {};
    return rest;
});

// Chart Data (Simple CSS calculation)
const incomePercent = computed(() => {
    if (!props.financialSummary) return 50;
    const total = props.financialSummary.income + props.financialSummary.expense;
    return total > 0 ? (props.financialSummary.income / total) * 100 : 50;
});

// --- Shared Geolocation Logic ---
import { usePrayerTimes } from '@/Composables/usePrayerTimes';
const { 
    currentPrayerTimes, 
    isLocating, 
    usingUserLocation, 
    getUserLocation 
} = usePrayerTimes(props.prayerTimes);

// Next Prayer Logic (remains local as it depends on display needs, or could be moved)
const currentNextPrayer = ref(props.nextPrayer);

const getNextPrayerFromSchedule = (schedule) => {
    const now = new Date();
    const currentTime = now.getHours() * 60 + now.getMinutes();
    const prayers = [
        { name: 'Subuh', time: schedule.subuh },
        { name: 'Dzuhur', time: schedule.dzuhur },
        { name: 'Ashar', time: schedule.ashar },
        { name: 'Maghrib', time: schedule.maghrib },
        { name: 'Isya', time: schedule.isya },
    ];

    for (const prayer of prayers) {
        if (!prayer.time) continue; // Defense
        const [hours, minutes] = prayer.time.split(':').map(Number);
        const prayerTime = hours * 60 + minutes;
        
        if (prayerTime > currentTime) {
            const diff = prayerTime - currentTime;
            const diffHours = Math.floor(diff / 60);
            const diffMinutes = diff % 60;
            const countdown = `-${diffHours}j ${diffMinutes}m`;
            
            return {
                name: prayer.name,
                time: prayer.time,
                countdown: countdown
            };
        }
    }
    return { name: 'Subuh', time: schedule.subuh, countdown: 'Besok' };
};

// Watch for changes in times to update next prayer
import { watch } from 'vue';
watch(currentPrayerTimes, (newTimes) => {
    if (newTimes) {
        currentNextPrayer.value = getNextPrayerFromSchedule(newTimes);
    }
});
</script>

<template>
    <Head title="Pusat Ibadah & Kegiatan Umat" />

    <PublicLayout ref="layoutRef">
        <!-- 1. Hero Section -->
        <div class="relative h-[600px] flex items-center justify-center overflow-hidden">
            <!-- Background Image -->
            <div class="absolute inset-0 z-0">
                <img 
                    :src="$page.props.settings?.hero_bg_image || 'https://images.unsplash.com/photo-1519817650390-64a93db51149?q=80&w=2000&auto=format&fit=crop'" 
                    alt="Masjid Background" 
                    class="w-full h-full object-cover"
                    @error="$event.target.src = 'https://placehold.co/1920x1080?text=Masjid+Al-Hidayah'"
                />
                <!-- Modern Gradient Overlay -->
                <div class="absolute inset-0 bg-gradient-to-br from-emerald-900/90 via-emerald-800/80 to-slate-900/40"></div>
                <!-- Pattern Overlay -->
                <div class="absolute inset-0 opacity-10" style="background-image: radial-gradient(#fff 1px, transparent 1px); background-size: 30px 30px;"></div>
            </div>

            <!-- Content -->
            <div class="relative z-10 text-center px-4 max-w-4xl mx-auto mt-16">
                <!-- Logo/Icon -->
                <div class="mx-auto w-20 h-20 bg-emerald-500/20 backdrop-blur-sm rounded-full flex items-center justify-center mb-6 border border-emerald-400/30">
                    <img 
                        v-if="$page.props.settings?.logo_path" 
                        :src="$page.props.settings.logo_path" 
                        alt="Logo" 
                        class="w-12 h-12 object-contain"
                    />
                    <span v-else class="text-4xl">🕌</span>
                </div>
                
                <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold text-white mb-4 leading-tight tracking-tight drop-shadow-lg">
                    {{ $page.props.settings?.hero_title || 'Pusat Ibadah & Kegiatan Umat' }}
                </h1>
                
                <p class="text-lg md:text-xl text-emerald-100 mb-8 font-light max-w-2xl mx-auto">
                    {{ $page.props.settings?.hero_subtitle || 'Masjid Al-Hidayah, Jl. Contoh No. 123, Jakarta Selatan' }}
                </p>
                
                <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
                    <button 
                        @click="openDonationModal"
                        class="px-8 py-3.5 bg-gradient-to-r from-amber-500 to-amber-600 hover:from-amber-600 hover:to-amber-700 text-white font-bold rounded-full shadow-[0_0_20px_rgba(245,158,11,0.5)] transition-all transform hover:-translate-y-1 hover:shadow-[0_0_30px_rgba(245,158,11,0.6)] flex items-center gap-2"
                    >
                        <span>Donasi Sekarang</span>
                        <HeartIcon class="w-5 h-5" />
                    </button>
                    
                    <Link 
                        href="/ibadah/jadwal" 
                        class="px-8 py-3.5 bg-transparent border-2 border-white/30 hover:border-white/80 text-white font-medium rounded-full transition-all flex items-center gap-2 backdrop-blur-sm"
                    >
                        <span>Lihat Jadwal Sholat</span>
                        <ArrowRightIcon class="w-4 h-4" />
                    </Link>
                </div>
            </div>
        </div>

        <!-- 2. Quick Info Cards (Overlap) -->
        <div class="max-w-7xl mx-auto px-4 relative z-20 -mt-20 mb-20">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Prayer Times Card -->
                <div class="bg-white rounded-2xl shadow-xl p-6 border-b-4 border-emerald-500 transform hover:translate-y-[-5px] transition-transform relative overflow-hidden">
                    <div class="flex items-start justify-between mb-4">
                        <div class="p-3 bg-emerald-100 rounded-xl text-emerald-600">
                            <ClockIcon v-if="!isLocating" class="w-8 h-8" />
                            <ArrowPathIcon v-else class="w-8 h-8 animate-spin" />
                        </div>
                        <div v-if="currentNextPrayer" class="text-right">
                            <div class="text-xs font-semibold text-slate-500 uppercase tracking-wide">Menuju Sholat</div>
                            <div class="text-sm font-bold text-emerald-600">{{ currentNextPrayer.countdown }}</div>
                        </div>
                    </div>
                    <div>
                        <div class="flex justify-between items-center">
                            <h3 class="text-lg font-bold text-slate-800">Waktu Sholat</h3>
                             <button 
                                @click="getUserLocation" 
                                class="text-slate-400 hover:text-emerald-600 transition-colors"
                                :title="usingUserLocation ? 'Refesh Lokasi' : 'Gunakan Lokasi Saya'"
                            >
                                <MapPinIcon class="w-5 h-5" :class="{'text-emerald-500': usingUserLocation}" />
                            </button>
                        </div>
                        
                        <div v-if="isLocating" class="animate-pulse mt-2">
                             <div class="h-8 bg-slate-200 rounded w-3/4 mb-2"></div>
                             <div class="h-4 bg-slate-200 rounded w-1/2"></div>
                        </div>
                        <div v-else>
                            <p v-if="currentNextPrayer" class="text-3xl font-bold text-slate-900 mt-1 mb-1">
                                {{ currentNextPrayer.name }} <span class="text-lg text-slate-500 font-normal">{{ currentNextPrayer.time }}</span>
                            </p>
                            <p v-else class="text-slate-500">Mengkalkulasi...</p>
                            
                            <div class="text-xs text-slate-400 mt-1 flex items-center gap-1">
                                <span v-if="usingUserLocation">📍 Sesuai Lokasi Anda</span>
                                <span v-else>🕌 Jadwal Masjid</span>
                            </div>
                        </div>

                        <div class="mt-4 pt-4 border-t border-slate-100 flex justify-between items-center text-sm">
                            <span class="text-slate-500">Hari ini</span>
                            <Link href="/ibadah/jadwal" class="text-emerald-600 font-medium hover:underline">Lihat Jadwal Lengkap →</Link>
                        </div>
                    </div>
                </div>

                <!-- Balance Card -->
                <div class="bg-white rounded-2xl shadow-xl p-6 border-b-4 border-amber-500 transform hover:translate-y-[-5px] transition-transform">
                    <div class="flex items-start justify-between mb-4">
                        <div class="p-3 bg-amber-100 rounded-xl text-amber-600">
                            <CurrencyDollarIcon class="w-8 h-8" />
                        </div>
                        <div class="text-right">
                            <div class="text-xs font-semibold text-slate-500 uppercase tracking-wide">Status Keuangan</div>
                            <div class="text-sm font-bold text-green-600">+Income</div>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-lg font-bold text-slate-800">Saldo Kas Masjid</h3>
                        <p class="text-3xl font-bold text-slate-900 mt-1 mb-1">
                            {{ financialSummary.formatted_balance }}
                        </p>
                        <div class="mt-4 pt-4 border-t border-slate-100 flex justify-between items-center text-sm">
                            <span class="text-slate-500">Update Realtime</span>
                            <Link href="/transparansi/keuangan" class="text-amber-600 font-medium hover:underline">Lihat Laporan →</Link>
                        </div>
                    </div>
                </div>

                <!-- Services Card -->
                <div class="bg-white rounded-2xl shadow-xl p-6 border-b-4 border-blue-500 transform hover:translate-y-[-5px] transition-transform">
                    <div class="flex items-start justify-between mb-4">
                        <div class="p-3 bg-blue-100 rounded-xl text-blue-600">
                            <HeartIcon class="w-8 h-8" />
                        </div>
                        <div class="text-right">
                            <div class="text-xs font-semibold text-slate-500 uppercase tracking-wide">Sosial</div>
                            <div class="text-sm font-bold text-blue-600">Aktif</div>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-lg font-bold text-slate-800">Layanan Umat</h3>
                        <p class="text-slate-600 mt-2 mb-3 text-sm leading-relaxed line-clamp-2">
                            Layanan ambulan gratis, santunan yatim piatu, dan program beras untuk dhuafa.
                        </p>
                        <div class="mt-4 pt-4 border-t border-slate-100 flex justify-between items-center text-sm">
                            <span class="text-slate-500">Program</span>
                            <a href="#" class="text-blue-600 font-medium hover:underline">Info Detail →</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. Transparency Section -->
        <section class="py-20 bg-slate-100">
            <div class="max-w-7xl mx-auto px-4">
                <div class="text-center mb-16">
                    <span class="text-emerald-600 font-bold tracking-wider text-sm uppercase">Akuntabilitas</span>
                    <h2 class="text-3xl md:text-4xl font-bold text-slate-900 mt-2">Transparansi Keuangan</h2>
                    <div class="w-20 h-1 bg-emerald-500 mx-auto mt-4 rounded-full"></div>
                </div>

                <div class="bg-white rounded-3xl shadow-xl overflow-hidden">
                    <div class="grid grid-cols-1 lg:grid-cols-2">
                        <!-- Left: Visual Chart Area -->
                        <div class="p-8 lg:p-12 bg-slate-50 flex flex-col items-center justify-center border-r border-slate-100">
                            <div class="relative w-64 h-64">
                                <!-- Donut Chart Approximation using Conic Gradient -->
                                <div 
                                    class="w-full h-full rounded-full"
                                    :style="`background: conic-gradient(#10b981 0% ${incomePercent}%, #f43f5e ${incomePercent}% 100%);`"
                                ></div>
                                <div class="absolute inset-4 bg-slate-50 rounded-full flex items-center justify-center flex-col">
                                    <span class="text-sm text-slate-500 font-medium">Cashflow</span>
                                    <span class="text-xs text-slate-400">Bulan Ini</span>
                                </div>
                            </div>
                            <div class="flex gap-8 mt-8">
                                <div class="flex items-center gap-2">
                                    <div class="w-3 h-3 rounded-full bg-emerald-500"></div>
                                    <span class="text-sm font-medium text-slate-600">Pemasukan</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <div class="w-3 h-3 rounded-full bg-rose-500"></div>
                                    <span class="text-sm font-medium text-slate-600">Pengeluaran</span>
                                </div>
                            </div>
                        </div>

                        <!-- Right: Summary & Action -->
                        <div class="p-8 lg:p-12 flex flex-col justify-center">
                            <h3 class="text-2xl font-bold text-slate-900 mb-6">Ringkasan Bulan Ini</h3>
                            
                            <div class="space-y-6 mb-8">
                                <div>
                                    <div class="flex justify-between items-end mb-2">
                                        <span class="text-slate-600 font-medium">Total Pemasukan</span>
                                        <span class="text-emerald-600 font-bold text-xl">{{ financialSummary.formatted_income }}</span>
                                    </div>
                                    <div class="w-full bg-slate-100 rounded-full h-2">
                                        <div class="bg-emerald-500 h-2 rounded-full" style="width: 100%"></div>
                                    </div>
                                </div>

                                <div>
                                    <div class="flex justify-between items-end mb-2">
                                        <span class="text-slate-600 font-medium">Total Pengeluaran</span>
                                        <span class="text-rose-600 font-bold text-xl">{{ financialSummary.formatted_expense }}</span>
                                    </div>
                                    <div class="w-full bg-slate-100 rounded-full h-2">
                                        <div 
                                            class="bg-rose-500 h-2 rounded-full" 
                                            :style="`width: ${Math.min((financialSummary.expense / (financialSummary.income || 1)) * 100, 100)}%`"
                                        ></div>
                                    </div>
                                </div>

                                <div class="pt-4 border-t border-slate-200">
                                    <div class="flex justify-between items-end">
                                        <span class="text-slate-700 font-semibold">Sisa Saldo</span>
                                        <span class="text-blue-600 font-bold text-2xl">{{ financialSummary.formatted_balance }}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-amber-50 border border-amber-100 rounded-xl p-4 mb-8">
                                <div class="flex gap-3">
                                    <div class="text-amber-500 mt-0.5">
                                        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                        </svg>
                                    </div>
                                    <p class="text-sm text-slate-700">
                                        Dana masyarakat dikelola secara transparan dan dilaporkan secara berkala sesuai standar akuntansi masjid.
                                    </p>
                                </div>
                            </div>

                            <Link 
                                href="/transparansi/keuangan"
                                class="w-full py-4 text-center bg-slate-900 hover:bg-slate-800 text-white font-bold rounded-xl transition-colors flex justify-center items-center gap-2"
                            >
                                <span>Lihat Laporan Lengkap</span>
                                <ArrowRightIcon class="w-5 h-5" />
                            </Link>
                        </div>
                    </div>
                </div>
            </div>
        </section>


        <!-- 4. Layanan & Fasilitas Umat Section -->
        <section class="py-24 bg-gradient-to-br from-slate-50 via-emerald-50/30 to-slate-50">
            <div class="max-w-7xl mx-auto px-4">
                <div class="text-center mb-16">
                    <span class="text-emerald-600 font-bold tracking-wider text-sm uppercase">Program Kami</span>
                    <h2 class="text-3xl md:text-4xl font-bold text-slate-900 mt-2">Layanan & Fasilitas Umat</h2>
                    <div class="w-20 h-1 bg-emerald-500 mx-auto mt-4 rounded-full"></div>
                    <p class="text-slate-600 mt-4 max-w-2xl mx-auto">Kami berkomitmen memberikan layanan terbaik untuk umat dalam pembinaan, pendidikan, dan kesejahteraan.</p>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                    <!-- Service 1: Ambulans Gratis -->
                    <div class="group bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 border border-slate-100">
                        <div class="w-16 h-16 bg-gradient-to-br from-red-500 to-red-600 rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900 mb-3">Ambulans Gratis</h3>
                        <p class="text-slate-600 leading-relaxed">Layanan antar jemput pasien dhuafa 24 jam. Hubungi kami kapan saja.</p>
                    </div>

                    <!-- Service 2: Baitul Maal -->
                    <div class="group bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 border border-slate-100">
                        <div class="w-16 h-16 bg-gradient-to-br from-emerald-500 to-emerald-600 rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900 mb-3">Baitul Maal</h3>
                        <p class="text-slate-600 leading-relaxed">Pengelolaan Zakat, Infaq, dan Sedekah yang transparan dan amanah.</p>
                    </div>

                    <!-- Service 3: Taman Pendidikan -->
                    <div class="group bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 border border-slate-100">
                        <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900 mb-3">Taman Pendidikan</h3>
                        <p class="text-slate-600 leading-relaxed">Membentuk generasi Qurani sejak dini dengan metode yang menyenangkan.</p>
                    </div>

                    <!-- Service 4: Kajian Rutin -->
                    <div class="group bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 border border-slate-100">
                        <div class="w-16 h-16 bg-gradient-to-br from-amber-500 to-amber-600 rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900 mb-3">Kajian Rutin</h3>
                        <p class="text-slate-600 leading-relaxed">Siraman rohani harian dan mingguan bersama ustadz pilihan.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- 5. Berita & Kegiatan Section -->
        <section v-if="posts && posts.length > 0" class="py-24 bg-white">
            <div class="max-w-7xl mx-auto px-4">
                <div class="text-center mb-16">
                    <span class="text-emerald-600 font-bold tracking-wider text-sm uppercase">Informasi Terkini</span>
                    <h2 class="text-3xl md:text-4xl font-bold text-slate-900 mt-2">Berita & Kegiatan</h2>
                    <div class="w-20 h-1 bg-emerald-500 mx-auto mt-4 rounded-full"></div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <Link v-for="post in posts" :key="post.id" :href="route('public.post', post.slug)" class="group bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 border border-slate-100 overflow-hidden flex flex-col h-full hover:-translate-y-1">
                        <!-- Image -->
                        <div class="relative h-48 overflow-hidden bg-slate-200">
                            <img :src="post.image_url" :alt="post.title" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
                            <div class="absolute top-4 left-4 bg-emerald-600 text-white text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wider">
                                Berita
                            </div>
                        </div>
                        
                        <!-- Content -->
                        <div class="p-6 flex flex-col flex-grow">
                            <div class="flex items-center gap-4 text-xs text-slate-500 mb-4">
                                <span class="flex items-center gap-1">
                                    <CalendarIcon class="w-4 h-4" />
                                    {{ post.published_at }}
                                </span>
                                <span class="flex items-center gap-1">
                                    <UserIcon class="w-4 h-4" />
                                    {{ post.author_name }}
                                </span>
                            </div>
                            
                            <h3 class="text-xl font-bold text-slate-900 mb-3 group-hover:text-emerald-600 transition-colors line-clamp-2">
                                {{ post.title }}
                            </h3>
                            
                            <p class="text-slate-600 text-sm mb-6 line-clamp-3">
                                {{ post.excerpt }}
                            </p>
                            
                            <div class="mt-auto">
                                <span class="inline-flex items-center text-emerald-600 font-bold text-sm group-hover:gap-2 transition-all">
                                    Baca Selengkapnya
                                    <ArrowRightIcon class="w-4 h-4 ml-1" />
                                </span>
                            </div>
                        </div>
                    </Link>
                </div>

                <div class="mt-12 text-center">
                    <Link :href="route('public.berita')" class="inline-flex items-center gap-2 px-8 py-3 bg-white border border-emerald-200 text-emerald-700 font-bold rounded-full hover:bg-emerald-50 hover:border-emerald-300 transition-all shadow-sm hover:shadow-md group">
                        Lihat Semua Berita
                        <ArrowRightIcon class="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                    </Link>
                </div>
            </div>
        </section>


        <!-- 6. Footer -->
        <footer class="bg-slate-900 text-slate-300 py-16 border-t border-slate-800">
            <div class="max-w-7xl mx-auto px-4">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12">
                    <!-- Brand -->
                    <div class="space-y-4">
                        <div class="flex items-center gap-3 text-white font-bold text-2xl">
                            <img 
                                v-if="$page.props.settings?.logo_path" 
                                :src="$page.props.settings.logo_path" 
                                alt="Logo" 
                                class="h-8 w-auto"
                            />
                            <span v-else class="text-3xl">🕌</span>
                            <span>{{ $page.props.settings?.site_name || 'MasjidVision' }}</span>
                        </div>
                        <p class="text-sm text-slate-400 leading-relaxed">
                            {{ $page.props.settings?.footer_text || 'Membangun peradaban umat melalui masjid yang transparan, modern, dan melayani dengan sepenuh hati.' }}
                        </p>
                        <!-- Socials -->
                        <div class="flex gap-4 pt-2">
                             <a v-if="$page.props.settings?.facebook_url" :href="$page.props.settings.facebook_url" class="text-slate-400 hover:text-emerald-500 transition-colors">Facebook</a>
                             <a v-if="$page.props.settings?.instagram_url" :href="$page.props.settings.instagram_url" class="text-slate-400 hover:text-emerald-500 transition-colors">Instagram</a>
                             <a v-if="$page.props.settings?.youtube_url" :href="$page.props.settings.youtube_url" class="text-slate-400 hover:text-emerald-500 transition-colors">YouTube</a>
                        </div>
                    </div>

                    <!-- Contact -->
                    <div>
                        <h4 class="text-white font-bold mb-6">Hubungi Kami</h4>
                        <div class="space-y-3 text-sm">
                            <p class="flex items-start gap-3">
                                <span class="text-emerald-500">📍</span>
                                <span>{{ $page.props.settings?.address || 'Jl. Contoh No. 123, Jakarta Selatan' }}</span>
                            </p>
                            <p class="flex items-center gap-3">
                                <span class="text-emerald-500">📞</span>
                                <span>{{ $page.props.settings?.phone || '(021) 7890-1234' }}</span>
                            </p>
                            <p class="flex items-center gap-3">
                                <span class="text-emerald-500">📧</span>
                                <span>{{ $page.props.settings?.email || 'info@masjidvision.com' }}</span>
                            </p>
                        </div>
                    </div>

                    <!-- Links -->
                    <div>
                        <h4 class="text-white font-bold mb-6">Akses Cepat</h4>
                        <ul class="space-y-3 text-sm">
                            <li><a href="/ibadah/jadwal" class="hover:text-emerald-400 transition-colors">Jadwal Sholat</a></li>
                            <li><Link href="/transparansi/keuangan" class="hover:text-emerald-400 transition-colors">Laporan Keuangan</Link></li>
                            <li><Link href="/transparansi/aset" class="hover:text-emerald-400 transition-colors">Data Aset</Link></li>
                            <li><Link href="/login" class="hover:text-emerald-400 transition-colors">Login Pengurus</Link></li>
                        </ul>
                    </div>

                    <!-- Donation Info -->
                    <div>
                        <h4 class="text-white font-bold mb-6">Rekening Donasi</h4>
                        <div class="bg-slate-800 p-4 rounded-xl border border-slate-700">
                             <div v-if="$page.props.settings?.donation_bank_info">
                                <div 
                                    v-for="(line, index) in $page.props.settings.donation_bank_info.split('\n')" 
                                    :key="index"
                                    :class="[
                                        index === 0 ? 'text-xs text-slate-400 uppercase tracking-wider mb-1' : '',
                                        index === 1 ? 'text-xl font-mono text-white font-bold mb-2' : '',
                                        index > 1 ? 'text-sm text-slate-400' : ''
                                    ]"
                                >
                                    {{ line }}
                                </div>
                            </div>
                            <div v-else>
                                <div class="text-xs text-slate-400 uppercase tracking-wider mb-1">Bank Syariah Indonesia</div>
                                <div class="text-xl font-mono text-white font-bold mb-2">1234 5678 90</div>
                                <div class="text-sm text-slate-400">a.n. DKM {{ $page.props.settings?.site_name || 'Masjid' }}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-16 pt-8 border-t border-slate-800 text-center text-sm text-slate-500">
                    {{ $page.props.settings?.copyright_text || '&copy; 2026 MasjidVision. All rights reserved.' }}
                </div>
            </div>
        </footer>
    </PublicLayout>
</template>

<style>
@keyframes scan {
    0% { top: 0%; opacity: 0; }
    10% { opacity: 1; }
    90% { opacity: 1; }
    100% { top: 100%; opacity: 0; }
}
</style>

