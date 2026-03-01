<script setup>
import { ref, computed, onMounted } from 'vue';
import { Head, router, usePage } from '@inertiajs/vue3';
import { useIntervalFn, useNow } from '@vueuse/core';
import { TransitionGroup } from 'vue';

const page = usePage();

const props = defineProps({
    currentTime: String,
    todayPrayerTimes: Object,
    nextPrayer: Object,
    isFriday: Boolean,
    fridaySchedule: Object,
    slides: Array,
    recentDonations: Array,
    monthlyStats: Object,
    wishlists: Array,
});

// Real-time clock using VueUse
const now = useNow({ interval: 1000 });

// Format time for display
const formattedTime = computed(() => now.value.toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit', second: '2-digit' }));
const formattedDate = computed(() => now.value.toLocaleDateString('id-ID', {  weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }));

// Calculate countdown to next prayer
const prayerCountdown = computed(() => {
    if (!props.nextPrayer) return '00:00';
    
    const [hours, minutes] = props.nextPrayer.time.split(':');
    const prayerTime = new Date(now.value);
    prayerTime.setHours(parseInt(hours), parseInt(minutes), 0, 0);
    
    // If prayer is tomorrow
    if (props.nextPrayer.tomorrow) {
        prayerTime.setDate(prayerTime.getDate() + 1);
    }
    
    const diff = prayerTime - now.value;
    if (diff < 0) return '00:00';
    
    const totalMinutes = Math.floor(diff / 60000);
    const hrs = Math.floor(totalMinutes / 60);
    const mins = totalMinutes % 60;
    
    if (hrs > 0) return `${hrs}j ${mins}m`;
    return `${mins} menit`;
});

// Carousel management
const currentSlideIndex = ref(0);

// Current slide type and data
const currentSlide = computed(() => {
    const index = currentSlideIndex.value;
    const slidesCount = props.slides?.length || 0;
    
    // If it's Friday, we could add a special slide for Friday officers
    const extraSlides = [];
    if (props.isFriday && props.fridaySchedule) {
        extraSlides.push({ 
            type: 'Jumat', 
            data: { 
                title: 'Petugas Shalat Jumat', 
                content: `Khatib: ${props.fridaySchedule.khatib} | Imam: ${props.fridaySchedule.imam} | Muadzin: ${props.fridaySchedule.muadzin}`
            } 
        });
    }
    
    extraSlides.push({ 
        type: 'Keuangan', 
        data: { 
            title: 'Transparansi Keuangan', 
            content: `Pemasukan: Rp ${props.monthlyStats?.income || 0} | Pengeluaran: Rp ${props.monthlyStats?.expense || 0} | Saldo: Rp ${props.monthlyStats?.balance || 0}`
        } 
    });

    if (props.wishlists?.length > 0) {
        extraSlides.push({ 
            type: 'Wakaf', 
            data: { 
                title: 'Progres Wakaf & Donasi', 
                content: `${props.wishlists[0].item_name}: ${props.wishlists[0].progress_percentage}% Terkumpul`
            } 
        });
    }

    const allSlides = [
        ...(props.slides?.map(s => ({ type: 'Informasi', data: s })) || []),
        ...extraSlides
    ];

    if (allSlides.length === 0) return { type: 'Welcome', data: { title: 'Selamat Datang', content: 'Semoga berkah menyertai kita semua.' } };
    
    return allSlides[index % allSlides.length];
});

const totalSlides = computed(() => {
    let count = props.slides?.length || 0;
    if (props.isFriday && props.fridaySchedule) count++;
    count++; // Financial
    if (props.wishlists?.length > 0) count++;
    return count === 0 ? 1 : count;
});

// Auto-advance carousel every 10 seconds
useIntervalFn(() => {
    currentSlideIndex.value = (currentSlideIndex.value + 1) % totalSlides.value;
}, 10000);

// Marquee ticker content
const tickerContent = computed(() => {
    const donations = props.recentDonations?.map(d => 
        `💚 Jazakallah - ${d.category}: Rp ${d.amount}`
    ) || [];
    return donations.join('  •  ') + '  •  Semoga menjadi amal jariyah bagi para donatur.  •  ';
});

// Inertia polling every 60 seconds
useIntervalFn(() => {
    router.reload({
        only: ['todayPrayerTimes', 'nextPrayer', 'recentDonations', 'slides', 'monthlyStats', 'wishlists'],
        preserveScroll: true,
    });
}, 60000);

// Prayer time indicators
const prayerTimes = computed(() => {
    if (!props.todayPrayerTimes) return [];
    return [
        { name: 'Subuh', time: props.todayPrayerTimes.subuh },
        { name: 'Terbit', time: props.todayPrayerTimes.syuruq || '05:45' },
        { name: 'Dhuhr', time: props.todayPrayerTimes.dhuhr },
        { name: 'Asr', time: props.todayPrayerTimes.asr },
        { name: 'Maghrib', time: props.todayPrayerTimes.maghrib },
        { name: 'Isha', time: props.todayPrayerTimes.isha },
    ];
});
</script>

<template>
    <Head :title="page.props.settings?.site_name || 'TV Display'" />

    <div class="h-screen bg-[#F0F5F5] text-slate-800 overflow-hidden font-sans selection:bg-emerald-100 flex p-6 gap-6 relative">
        <!-- Sidebar Navigation (Decorative) -->
        <aside class="w-24 bg-white rounded-[2rem] shadow-sm flex flex-col items-center py-10 gap-12 z-20">
            <div class="w-16 h-16 bg-emerald-50 rounded-2xl flex items-center justify-center text-emerald-600 shadow-inner">
                <img v-if="page.props.settings?.logo_path" :src="page.props.settings.logo_path" class="w-10 h-10 object-contain" />
                <svg v-else class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
            </div>
            
            <nav class="flex flex-col gap-8">
                <div class="p-3 bg-emerald-500 text-white rounded-2xl shadow-lg shadow-emerald-200 cursor-pointer">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                </div>
                <!-- Other icons omitted for brevity -->
            </nav>

            <div class="mt-auto mb-4">
                <div class="w-12 h-12 rounded-full border-2 border-emerald-100 p-1">
                    <div class="w-full h-full bg-emerald-100 rounded-full flex items-center justify-center text-emerald-600 font-bold text-[10px] uppercase tracking-tighter">
                        Live
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Workspace -->
        <main class="flex-1 flex flex-col gap-6 z-10 overflow-hidden">
            <!-- Header -->
            <header class="flex justify-between items-center px-4">
                <div class="space-y-1">
                    <h1 class="text-3xl font-extrabold text-slate-800 tracking-tight">
                        Ahlan wa Sahlan, <span class="text-emerald-600">Jamaah!</span> 👋
                    </h1>
                    <p class="text-slate-500 font-medium tracking-wide">
                        Selamat datang di <span class="font-bold text-slate-700">{{ page.props.settings?.site_name || 'Masjid Kita' }}</span> — Semoga berkah hari ini.
                    </p>
                </div>

                <div class="flex items-center gap-6">
                    <div class="flex flex-col items-end">
                        <span class="text-sm font-bold text-emerald-600 uppercase tracking-widest">{{ todayPrayerTimes?.hijri_date || '1446 H' }}</span>
                        <span class="text-xs font-semibold text-slate-400">Kalender Hijriah</span>
                    </div>
                    <div class="w-px h-10 bg-slate-200"></div>
                    <div class="flex items-center gap-3 bg-white px-5 py-3 rounded-2xl shadow-sm border border-slate-100">
                        <div class="w-10 h-10 bg-amber-50 rounded-xl flex items-center justify-center text-amber-500">
                            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z" clip-rule="evenodd"></path></svg>
                        </div>
                        <div>
                            <div class="text-sm font-bold text-slate-700">32°C</div>
                            <div class="text-[10px] font-semibold text-slate-400 uppercase tracking-tighter">Cerah Berawan</div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Highlights Row -->
            <div class="grid grid-cols-3 gap-6 h-64">
                <div class="relative group overflow-hidden rounded-[2.5rem] bg-emerald-600 shadow-2xl shadow-emerald-200">
                    <div class="absolute inset-0 bg-gradient-to-br from-black/20 to-transparent z-10"></div>
                    <div class="relative z-20 h-full p-8 flex flex-col justify-between text-white">
                        <div class="space-y-1">
                            <span class="text-xs font-bold uppercase tracking-widest opacity-80">Waktu Utama</span>
                            <h3 class="text-4xl font-black">{{ nextPrayer?.name || '---' }}</h3>
                        </div>
                        <div class="flex items-end justify-between">
                            <div class="text-6xl font-black tracking-tighter">{{ nextPrayer?.time || '--:--' }}</div>
                            <div class="w-12 h-12 bg-white/20 rounded-2xl flex items-center justify-center backdrop-blur-md">
                                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"></path></svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="relative group overflow-hidden rounded-[2.5rem] bg-[#FF7E47] shadow-2xl shadow-orange-100">
                    <div class="relative z-20 h-full p-8 flex flex-col justify-between text-white">
                        <div class="space-y-1">
                            <span class="text-xs font-bold uppercase tracking-widest opacity-80 uppercase">Menuju Sholat</span>
                            <h3 class="text-4xl font-black">{{ prayerCountdown }}</h3>
                        </div>
                        <div class="space-y-2">
                            <p class="text-sm font-medium leading-tight opacity-90 italic">"Sholatlah engkau tepat pada waktunya."</p>
                            <div class="flex items-center gap-2">
                                <span class="text-[10px] font-bold uppercase tracking-widest text-orange-100 italic animate-pulse">Menanti Panggilan-Nya</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="relative group overflow-hidden rounded-[2.5rem] bg-[#3B8BEB] shadow-2xl shadow-blue-100">
                    <div class="absolute inset-0 bg-gradient-to-br from-black/20 to-transparent z-10"></div>
                    <div class="relative z-20 h-full p-8 flex flex-col justify-between text-white">
                        <div class="space-y-1">
                            <span class="text-xs font-bold uppercase tracking-widest opacity-80 uppercase">Highlight Maklumat</span>
                            <h3 class="text-2xl font-black leading-tight">{{ currentSlide.data?.title }}</h3>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="px-5 py-2.5 bg-white/20 rounded-xl backdrop-blur-md text-[10px] font-black uppercase tracking-widest border border-white/20">
                                Selengkapnya
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content Area -->
            <div class="flex gap-6 flex-1 min-h-0">
                <!-- Left: Prayer Times -->
                <div class="w-[32%] bg-white rounded-[2.5rem] p-8 shadow-sm flex flex-col border border-slate-50">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-xl font-extrabold text-slate-800 tracking-tight">Jadwal Sholat</h2>
                        <div class="px-3 py-1 bg-emerald-50 text-emerald-600 rounded-lg text-[10px] font-black uppercase tracking-wider">Harian</div>
                    </div>
                    
                    <div class="flex-1 space-y-3 overflow-y-auto no-scrollbar">
                        <div 
                            v-for="prayer in prayerTimes" 
                            :key="prayer.name"
                            :class="[
                                'group flex items-center p-4 rounded-3xl transition-all duration-300 border',
                                nextPrayer?.name === prayer.name 
                                    ? 'bg-emerald-500 border-emerald-400 text-white shadow-xl shadow-emerald-100' 
                                    : 'bg-slate-50 border-slate-50 hover:bg-white hover:border-emerald-100'
                            ]"
                        >
                            <div :class="[
                                'w-10 h-10 rounded-2xl flex items-center justify-center mr-4',
                                nextPrayer?.name === prayer.name ? 'bg-white/20 text-white' : 'bg-white text-emerald-500'
                            ]">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                            </div>
                            <div class="flex-1">
                                <div class="text-[14px] font-bold" :class="nextPrayer?.name === prayer.name ? 'text-white' : 'text-slate-700'">{{ prayer.name }}</div>
                            </div>
                            <div class="text-2xl font-black font-mono tracking-tighter">{{ prayer.time }}</div>
                        </div>
                    </div>
                </div>

                <!-- Center: Carousel -->
                <div class="flex-1 bg-white rounded-[2.5rem] p-8 shadow-sm flex flex-col relative overflow-hidden border border-slate-50">
                    <TransitionGroup name="slide-up">
                        <div :key="currentSlideIndex" class="h-full flex flex-col">
                            <div class="flex items-center gap-4 mb-8">
                                <div class="w-12 h-12 bg-emerald-50 rounded-2xl flex items-center justify-center text-emerald-600 shadow-sm">
                                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                </div>
                                <div>
                                    <h2 class="text-xl font-extrabold text-slate-800 tracking-tight">Maklumat Masjid</h2>
                                    <p class="text-[10px] text-emerald-600 font-bold uppercase tracking-widest">{{ currentSlide.type }} Terkini</p>
                                </div>
                            </div>

                            <div class="flex-1 flex gap-8 items-center px-4">
                                <div class="w-1/2 aspect-[4/3] rounded-[2rem] overflow-hidden shadow-2xl relative bg-slate-50 border border-slate-100">
                                    <img 
                                        v-if="currentSlide.data?.image_url" 
                                        :src="currentSlide.data.image_url" 
                                        class="w-full h-full object-cover"
                                    />
                                    <div v-else class="w-full h-full bg-gradient-to-br from-emerald-50 to-slate-100 flex items-center justify-center p-8">
                                        <svg v-if="currentSlide.type === 'Keuangan'" class="w-24 h-24 text-emerald-200" fill="currentColor" viewBox="0 0 20 20"><path d="M2 11a1 1 0 011-1h2a1 1 0 011 1v5a1 1 0 01-1 1H3a1 1 0 01-1-1v-5zM8 7a1 1 0 011-1h2a1 1 0 011 1v9a1 1 0 01-1 1H9a1 1 0 01-1-1V7zM14 4a1 1 0 011-1h2a1 1 0 011 1v12a1 1 0 01-1 1h-2a1 1 0 01-1-1V4z"></path></svg>
                                        <svg v-else-if="currentSlide.type === 'Jumat'" class="w-24 h-24 text-emerald-200" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2L4.5 20.29L5.21 21L12 18L18.79 21L19.5 20.29L12 2Z"></path></svg>
                                        <svg v-else class="w-24 h-24 text-slate-200" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-8 3 6 2-4 3 6z" clip-rule="evenodd"></path></svg>
                                    </div>
                                </div>

                                <div class="w-1/2 space-y-6">
                                    <div class="space-y-3">
                                        <h3 class="text-4xl font-black text-slate-800 tracking-tight leading-[1.1] transition-all">
                                            {{ currentSlide.data?.title }}
                                        </h3>
                                        <div class="w-12 h-1.5 bg-emerald-500 rounded-full"></div>
                                    </div>
                                    <div class="space-y-4">
                                        <template v-if="currentSlide.type === 'Keuangan' || currentSlide.type === 'Jumat'">
                                            <div v-for="item in currentSlide.data.content.split(' | ')" :key="item" class="flex items-center gap-3">
                                                <div class="w-2 h-2 rounded-full bg-emerald-500"></div>
                                                <span class="text-lg text-slate-700 font-bold uppercase tracking-tight">{{ item }}</span>
                                            </div>
                                        </template>
                                        <p v-else class="text-lg text-slate-500 font-medium leading-relaxed max-w-lg">
                                            {{ currentSlide.data?.content }}
                                        </p>
                                    </div>
                                    <div class="pt-2 flex items-center gap-3 uppercase font-black tracking-widest text-xs text-slate-800">
                                        <div class="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center text-white">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                                        </div>
                                        <span>Bergabung Kebaikan</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Indicators -->
                            <div class="flex justify-center gap-3 mt-10">
                                <div 
                                    v-for="i in totalSlides" 
                                    :key="i"
                                    :class="[
                                        'h-1.5 rounded-full transition-all duration-700 shadow-sm',
                                        currentSlideIndex === i - 1 ? 'bg-emerald-500 w-12' : 'bg-slate-100 w-3 hover:bg-slate-200'
                                    ]"
                                ></div>
                            </div>
                        </div>
                    </TransitionGroup>
                </div>
            </div>
        </main>

        <!-- Right Side: Clock & Agenda -->
        <aside class="w-[28%] flex flex-col gap-6 z-10 transition-all">
            <div class="bg-white rounded-[3rem] p-10 shadow-sm flex flex-col items-center justify-center border border-slate-50 group">
                <div class="text-7xl font-black text-slate-800 tracking-tighter font-mono">{{ formattedTime }}</div>
                <div class="h-1.5 w-12 bg-emerald-500 rounded-full my-6 shadow-lg shadow-emerald-100"></div>
                <div class="text-sm font-black text-slate-400 uppercase tracking-widest">{{ formattedDate }}</div>
            </div>

            <div class="flex-1 bg-white rounded-[3rem] p-10 shadow-sm flex flex-col border border-slate-50 overflow-hidden">
                <div class="flex justify-between items-center mb-10">
                    <h2 class="text-2xl font-black text-slate-800 tracking-tight">Agenda Masjid</h2>
                </div>

                <div class="flex-1 space-y-8 overflow-y-auto no-scrollbar scroll-smooth">
                    <div 
                        v-for="(agenda, i) in [
                            { title: 'Kajian Rutin Maghrib', time: '18:30 WIB - Selesai', category: 'Kajian', iconColor: 'emerald' },
                            { title: 'Program Tahfidz Anak', time: '16:00 WIB - 17:30', category: 'Pendidikan', iconColor: 'blue' },
                            { title: 'Sosialisasi Zakat Fitrah', time: '08:00 WIB - 12:00', category: 'Sosial', iconColor: 'amber' }
                        ]" 
                        :key="i"
                        class="group flex gap-5"
                    >
                        <div :class="[
                            'w-14 h-14 rounded-2xl flex-shrink-0 flex items-center justify-center transition-all duration-500 group-hover:scale-110 shadow-sm border',
                            agenda.iconColor === 'emerald' ? 'bg-emerald-50 text-emerald-600 border-emerald-100' : 
                            agenda.iconColor === 'blue' ? 'bg-blue-50 text-blue-600 border-blue-100' : 'bg-amber-50 text-amber-600 border-amber-100'
                        ]">
                            <svg class="w-7 h-7" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"></path></svg>
                        </div>
                        <div class="flex-1 space-y-1 py-1">
                            <h4 class="text-base font-extrabold text-slate-800 transition-colors group-hover:text-emerald-700 tracking-tight">{{ agenda.title }}</h4>
                            <div class="flex items-center gap-3">
                                <span class="text-[10px] font-black uppercase text-slate-400 tracking-widest">{{ agenda.time }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-10 p-8 bg-slate-900 rounded-[2.5rem] relative overflow-hidden group shadow-2xl shadow-slate-200">
                    <div class="absolute inset-0 bg-emerald-600/10 group-hover:bg-emerald-600/30 transition-all duration-700"></div>
                    <div class="relative z-10 flex flex-col gap-6">
                        <div class="space-y-2">
                            <div class="text-emerald-400 text-[10px] font-black uppercase tracking-widest">Infaq & Sedekah</div>
                            <div class="text-white text-2xl font-black leading-tight tracking-tight">Makmurkan Masjid Dengan Kebaikan</div>
                        </div>
                        <div class="flex items-center gap-4">
                            <button class="flex-1 bg-emerald-500 text-white px-2 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-emerald-400 shadow-xl shadow-emerald-900/50">Zakat Sekarang</button>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Floating Ticker -->
        <div class="fixed bottom-10 left-36 right-10 h-22 bg-white/80 backdrop-blur-3xl rounded-[3rem] shadow-2xl border border-white/50 flex items-center overflow-hidden z-20 px-2 py-2">
            <div class="bg-gradient-to-r from-emerald-600 to-emerald-500 h-full flex items-center px-10 rounded-[2.5rem] text-white">
                <span class="font-black text-[10px] uppercase tracking-[0.3em] whitespace-nowrap">Donasi Terkini</span>
            </div>
            <div class="flex-1 overflow-hidden ml-4">
                <div class="animate-marquee whitespace-nowrap text-emerald-800 font-extrabold text-xl py-4">
                    {{ tickerContent }} {{ tickerContent }} {{ tickerContent }}
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');

:deep(html), :deep(body) {
    font-family: 'Plus Jakarta Sans', sans-serif;
}

.no-scrollbar::-webkit-scrollbar {
    display: none;
}
.no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
}

.slide-up-enter-active,
.slide-up-leave-active {
    transition: all 1s cubic-bezier(0.23, 1, 0.32, 1);
}

.slide-up-enter-from {
    opacity: 0;
    transform: translateY(40px) scale(0.96);
}

.slide-up-leave-to {
    opacity: 0;
    transform: translateY(-40px) scale(1.04);
}

@keyframes marquee {
    0% { transform: translateX(0); }
    100% { transform: translateX(-50%); }
}

.animate-marquee {
    animation: marquee 50s linear infinite;
}
</style>
