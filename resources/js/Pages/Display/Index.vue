<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { Head, router } from '@inertiajs/vue3';
import { useIntervalFn, useNow } from '@vueuse/core';
import { TransitionGroup } from 'vue';

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
    
    return hrs > 0 ? `${hrs}j ${mins}m` : `${mins} menit`;
});

// Carousel management
const currentSlideIndex = ref(0);
const totalSlides = computed(() => (props.slides?.length || 0) + 2); // slides + financial + wishlist

// Auto-advance carousel every 7 seconds
useIntervalFn(() => {
    currentSlideIndex.value = (currentSlideIndex.value + 1) % totalSlides.value;
}, 7000);

// Current slide type
const currentSlide = computed(() => {
    const index = currentSlideIndex.value;
    const slidesCount = props.slides?.length || 0;
    
    if (index < slidesCount) {
        return { type: 'info', data: props.slides[index] };
    } else if (index === slidesCount) {
        return { type: 'financial', data: props.monthlyStats };
    } else {
        return { type: 'wishlist', data: props.wishlists };
    }
});

// Marquee ticker content
const tickerContent = computed(() => {
    const donations = props.recentDonations?.map(d => 
        `💚 Jazakallah - ${d.category}: ${d.amount}`
    ) || [];
    return donations.join('  •  ') + '  •  ';
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
        { name: 'Dhuhr', time: props.todayPrayerTimes.dhuhr },
        { name: 'Asr', time: props.todayPrayerTimes.asr },
        { name: 'Maghrib', time: props.todayPrayerTimes.maghrib },
        { name: 'Isha', time: props.todayPrayerTimes.isha },
    ];
});
</script>

<template>
    <Head title="Display - Masjid" />

    <!-- Fullscreen Dark Background -->
    <div class="h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 text-white overflow-hidden relative">
        <!-- Subtle Pattern Overlay -->
        <div class="absolute inset-0 bg-pattern-islamic opacity-5"></div>
        
        <!-- Main Content Grid -->
        <div class="h-full flex flex-col relative z-10">
            <!-- Main Panels (85% height) -->
            <div class="flex gap-4 p-4" style="height: 85vh;">
                <!-- Left Panel (30%) - Clock & Prayer Times -->
                <div class="w-[30%] flex flex-col gap-4">
                    <!-- Digital Clock Card -->
                    <div class="bg-gradient-to-br from-emerald-600 to-emerald-700 rounded-2xl p-5 text-center shadow-2xl border border-emerald-500/20">
                        <div class="text-6xl font-black tracking-tight mb-2 text-shadow-glow">{{ formattedTime }}</div>
                        <div class="text-lg font-semibold text-emerald-100">{{ formattedDate }}</div>
                        <div v-if="todayPrayerTimes?.hijri_date" class="text-base text-amber-300 mt-2 font-medium">
                            {{ todayPrayerTimes.hijri_date }}
                        </div>
                    </div>

                    <!-- Next Prayer Countdown -->
                    <div v-if="nextPrayer" class="bg-gradient-to-br from-amber-500 to-orange-600 rounded-2xl p-4 shadow-2xl border border-amber-400/30">
                        <div class="text-xs font-bold text-amber-100 mb-1 uppercase tracking-wider">Sholat Berikutnya</div>
                        <div class="text-3xl font-black text-white mb-1">{{ nextPrayer.name }}</div>
                        <div class="text-4xl font-black text-white mb-2">{{ nextPrayer.time }}</div>
                        <div class="flex items-center justify-center gap-2 text-lg font-bold text-amber-100 bg-black/20 rounded-xl py-2 px-3">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/></svg>
                            <span>{{ prayerCountdown }}</span>
                        </div>
                    </div>

                    <!-- Prayer Times List -->
                    <div class="bg-white/10 backdrop-blur-lg rounded-2xl p-4 flex-1 shadow-2xl border border-white/20 overflow-y-auto">
                        <h3 class="text-lg font-black mb-3 text-emerald-300 flex items-center gap-2">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6zM10 18a3 3 0 01-3-3h6a3 3 0 01-3 3z"/></svg>
                            Jadwal Sholat
                        </h3>
                        <div class="space-y-2">
                            <div
                                v-for="prayer in prayerTimes"
                                :key="prayer.name"
                                :class="[
                                    'flex justify-between items-center p-3 rounded-xl transition-all duration-300',
                                    nextPrayer?.name === prayer.name 
                                        ? 'bg-emerald-500 shadow-lg scale-105 border-2 border-emerald-300' 
                                        : 'bg-white/5 hover:bg-white/10'
                                ]"
                            >
                                <span class="text-base font-bold">{{ prayer.name }}</span>
                                <span class="text-xl font-black font-mono">{{ prayer.time }}</span>
                            </div>
                        </div>
                        
                        <!-- Friday Prayer Officers (Only shown on Friday) -->
                        <div v-if="isFriday && fridaySchedule" class="mt-4 pt-4 border-t-2 border-amber-400/30">
                            <h4 class="text-sm font-black mb-3 text-amber-300 flex items-center gap-2">
                                🕌 Petugas Jumat
                            </h4>
                            <div class="space-y-2 text-sm">
                                <div class="flex justify-between bg-white/5 rounded-lg p-2">
                                    <span class="text-slate-300">Khatib:</span>
                                    <span class="font-bold text-white">{{ fridaySchedule.khatib }}</span>
                                </div>
                                <div class="flex justify-between bg-white/5 rounded-lg p-2">
                                    <span class="text-slate-300">Imam:</span>
                                    <span class="font-bold text-white">{{ fridaySchedule.imam }}</span>
                                </div>
                                <div class="flex justify-between bg-white/5 rounded-lg p-2">
                                    <span class="text-slate-300">Muadzin:</span>
                                    <span class="font-bold text-white">{{ fridaySchedule.muadzin }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Panel (70%) - Carousel -->
                <div class="flex-1">
                    <div class="bg-white/10 backdrop-blur-xl rounded-2xl h-full p-6 relative overflow-hidden shadow-2xl border border-white/20">
                        <TransitionGroup
                            name="slide-fade"
                            tag="div"
                            class="h-full"
                        >
                            <!-- Info Slides -->
                            <div
                                v-if="currentSlide.type === 'info'"
                                :key="`slide-${currentSlideIndex}`"
                                class="absolute inset-0 p-6 flex flex-col items-center justify-center"
                            >
                                <img
                                    v-if="currentSlide.data.image_url"
                                    :src="currentSlide.data.image_url"
                                    :alt="currentSlide.data.title"
                                    class="max-h-[40%] rounded-2xl mb-6 shadow-2xl ring-4 ring-white/20"
                                />
                                <h2 class="text-5xl font-black mb-6 text-center bg-gradient-to-r from-emerald-400 to-cyan-400 bg-clip-text text-transparent leading-tight">
                                    {{ currentSlide.data.title }}
                                </h2>
                                <p class="text-2xl text-center text-slate-200 max-w-4xl leading-relaxed font-medium">
                                    {{ currentSlide.data.content }}
                                </p>
                            </div>

                            <!-- Financial Summary Slide -->
                            <div
                                v-else-if="currentSlide.type === 'financial'"
                                :key="'financial'"
                                class="absolute inset-0 p-6 flex flex-col items-center justify-center"
                            >
                                <h2 class="text-4xl font-black mb-10 bg-gradient-to-r from-emerald-400 to-cyan-400 bg-clip-text text-transparent flex items-center gap-3">
                                    <svg class="w-12 h-12 text-emerald-400" fill="currentColor" viewBox="0 0 20 20"><path d="M2 11a1 1 0 011-1h2a1 1 0 011 1v5a1 1 0 01-1 1H3a1 1 0 01-1-1v-5zM8 7a1 1 0 011-1h2a1 1 0 011 1v9a1 1 0 01-1 1H9a1 1 0 01-1-1V7zM14 4a1 1 0 011-1h2a1 1 0 011 1v12a1 1 0 01-1 1h-2a1 1 0 01-1-1V4z"/></svg>
                                    Transparansi Keuangan Bulan Ini
                                </h2>
                                <div class="grid grid-cols-3 gap-6 w-full max-w-5xl">
                                    <div class="bg-gradient-to-br from-emerald-500 to-emerald-600 p-6 rounded-2xl text-center shadow-2xl border-2 border-emerald-400/50">
                                        <div class="text-emerald-100 text-lg mb-2 font-black uppercase">Pemasukan</div>
                                        <div class="text-3xl font-black text-white">Rp {{ monthlyStats.income }}</div>
                                    </div>
                                    <div class="bg-gradient-to-br from-red-500 to-red-600 p-6 rounded-2xl text-center shadow-2xl border-2 border-red-400/50">
                                        <div class="text-red-100 text-lg mb-2 font-black uppercase">Pengeluaran</div>
                                        <div class="text-3xl font-black text-white">Rp {{ monthlyStats.expense }}</div>
                                    </div>
                                    <div class="bg-gradient-to-br from-amber-500 to-orange-600 p-6 rounded-2xl text-center shadow-2xl border-4 border-amber-300">
                                        <div class="text-amber-100 text-lg mb-2 font-black uppercase">Saldo</div>
                                        <div class="text-3xl font-black text-white">Rp {{ monthlyStats.balance }}</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Wishlist Progress Slide -->
                            <div
                                v-else-if="currentSlide.type === 'wishlist'"
                                :key="'wishlist'"
                                class="absolute inset-0 p-6 flex flex-col items-center justify-center"
                            >
                                <h2 class="text-4xl font-black mb-8 bg-gradient-to-r from-amber-400 to-orange-400 bg-clip-text text-transparent flex items-center gap-3">
                                    <svg class="w-12 h-12 text-amber-400" fill="currentColor" viewBox="0 0 20 20"><path d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z"/></svg>
                                    Program Wakaf & Donasi
                                </h2>
                                <div class="space-y-5 w-full max-w-4xl">
                                    <div
                                        v-for="item in wishlists"
                                        :key="item.id"
                                        class="bg-white/10 backdrop-blur-lg p-5 rounded-2xl shadow-xl border border-white/20"
                                    >
                                        <div class="flex justify-between items-center mb-3">
                                            <h3 class="text-2xl font-black text-white">{{ item.item_name }}</h3>
                                            <span class="text-emerald-400 text-3xl font-black">{{ item.progress_percentage }}%</span>
                                        </div>
                                        <div class="bg-slate-900/50 rounded-full h-5 mb-3 overflow-hidden border-2 border-slate-700">
                                            <div
                                                class="bg-gradient-to-r from-emerald-500 to-cyan-500 h-full transition-all duration-1000 shadow-lg"
                                                :style="{ width: item.progress_percentage + '%' }"
                                            ></div>
                                        </div>
                                        <div class="flex justify-between text-slate-300 text-lg font-semibold">
                                            <span>Terkumpul: <strong class="text-emerald-400">{{ item.formatted_total_fulfilled }}</strong></span>
                                            <span>Target: <strong class="text-amber-400">{{ item.formatted_total_target }}</strong></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </TransitionGroup>

                        <!-- Slide Indicators -->
                        <div class="absolute bottom-6 left-0 right-0 flex justify-center gap-2">
                            <div
                                v-for="i in totalSlides"
                                :key="i"
                                :class="[
                                    'h-2.5 rounded-full transition-all duration-300',
                                    currentSlideIndex === i - 1 
                                        ? 'bg-emerald-500 w-10 shadow-lg' 
                                        : 'bg-white/30 w-2.5'
                                ]"
                            ></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom Ticker (15% height) -->
            <div class="bg-gradient-to-r from-emerald-600 via-emerald-700 to-emerald-600 border-t-4 border-emerald-400 overflow-hidden shadow-2xl" style="height: 15vh;">
                <div class="h-full flex items-center">
                    <div class="bg-gradient-to-r from-amber-500 to-orange-600 px-8 py-3 mr-4 shadow-xl rounded-r-xl flex-shrink-0">
                        <span class="font-black text-xl tracking-wide">DONASI TERBARU</span>
                    </div>
                    <div class="flex-1 overflow-hidden">
                        <div class="animate-marquee whitespace-nowrap text-xl font-bold">
                            {{ tickerContent }}{{ tickerContent }}{{ tickerContent }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.slide-fade-enter-active,
.slide-fade-leave-active {
    transition: all 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-fade-enter-from {
    opacity: 0;
    transform: scale(0.95);
}

.slide-fade-leave-to {
    opacity: 0;
    transform: scale(1.05);
}

.text-shadow-glow {
    text-shadow: 0 0 40px rgba(16, 185, 129, 0.5),
                 0 0 20px rgba(16, 185, 129, 0.3);
}

.font-arabic {
    font-family: 'Amiri', serif;
}
</style>
