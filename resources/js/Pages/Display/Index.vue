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

    <!-- Fullscreen Clean White Background -->
    <div class="h-screen bg-gradient-to-br from-gray-50 via-white to-gray-100 text-gray-800 overflow-hidden relative">
        <!-- Subtle Pattern Overlay -->
        <div class="absolute inset-0 bg-pattern-islamic opacity-[0.03]"></div>
        
        <!-- Main Content Grid -->
        <div class="h-full flex flex-col relative z-10">
            <!-- Main Panels (85% height) -->
            <div class="flex gap-6 p-6" style="height: 85vh;">
                <!-- Left Panel (30%) - Clock & Prayer Times -->
                <div class="w-[30%] flex flex-col gap-5">
                    <!-- Digital Clock Card -->
                    <div class="bg-white rounded-3xl p-6 text-center shadow-xl border border-gray-100">
                        <div class="text-6xl font-black tracking-tight mb-2 text-primary-600">{{ formattedTime }}</div>
                        <div class="text-lg font-semibold text-gray-600">{{ formattedDate }}</div>
                        <div v-if="todayPrayerTimes?.hijri_date" class="text-base text-primary-500 mt-3 font-medium bg-primary-50 rounded-full py-1 px-4 inline-block">
                            {{ todayPrayerTimes.hijri_date }}
                        </div>
                    </div>

                    <!-- Next Prayer Countdown -->
                    <div v-if="nextPrayer" class="bg-primary-600 rounded-3xl p-5 shadow-xl text-white">
                        <div class="text-xs font-bold text-primary-100 mb-1 uppercase tracking-wider">Sholat Berikutnya</div>
                        <div class="text-3xl font-black mb-1">{{ nextPrayer.name }}</div>
                        <div class="text-4xl font-black mb-3">{{ nextPrayer.time }}</div>
                        <div class="flex items-center justify-center gap-2 text-lg font-bold text-white bg-white/20 rounded-xl py-2 px-4">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/></svg>
                            <span>{{ prayerCountdown }}</span>
                        </div>
                    </div>

                    <!-- Prayer Times List -->
                    <div class="bg-white rounded-3xl p-5 flex-1 shadow-xl border border-gray-100 overflow-y-auto">
                        <h3 class="text-lg font-black mb-4 text-gray-800 flex items-center gap-2">
                            <svg class="w-6 h-6 text-primary-500" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6zM10 18a3 3 0 01-3-3h6a3 3 0 01-3 3z"/></svg>
                            Jadwal Sholat
                        </h3>
                        <div class="space-y-2">
                            <div
                                v-for="prayer in prayerTimes"
                                :key="prayer.name"
                                :class="[
                                    'flex justify-between items-center p-4 rounded-2xl transition-all duration-300',
                                    nextPrayer?.name === prayer.name 
                                        ? 'bg-primary-500 text-white shadow-lg scale-[1.02]' 
                                        : 'bg-gray-50 hover:bg-gray-100 text-gray-700'
                                ]"
                            >
                                <span class="text-base font-bold">{{ prayer.name }}</span>
                                <span class="text-xl font-black font-mono">{{ prayer.time }}</span>
                            </div>
                        </div>
                        
                        <!-- Friday Prayer Officers (Only shown on Friday) -->
                        <div v-if="isFriday && fridaySchedule" class="mt-5 pt-5 border-t-2 border-gray-100">
                            <h4 class="text-sm font-black mb-3 text-primary-600 flex items-center gap-2">
                                🕌 Petugas Jumat
                            </h4>
                            <div class="space-y-2 text-sm">
                                <div class="flex justify-between bg-gray-50 rounded-xl p-3">
                                    <span class="text-gray-500">Khatib:</span>
                                    <span class="font-bold text-gray-800">{{ fridaySchedule.khatib }}</span>
                                </div>
                                <div class="flex justify-between bg-gray-50 rounded-xl p-3">
                                    <span class="text-gray-500">Imam:</span>
                                    <span class="font-bold text-gray-800">{{ fridaySchedule.imam }}</span>
                                </div>
                                <div class="flex justify-between bg-gray-50 rounded-xl p-3">
                                    <span class="text-gray-500">Muadzin:</span>
                                    <span class="font-bold text-gray-800">{{ fridaySchedule.muadzin }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Panel (70%) - Carousel -->
                <div class="flex-1">
                    <div class="bg-white rounded-3xl h-full p-8 relative overflow-hidden shadow-xl border border-gray-100">
                        <TransitionGroup
                            name="slide-fade"
                            tag="div"
                            class="h-full"
                        >
                            <!-- Info Slides -->
                            <div
                                v-if="currentSlide.type === 'info'"
                                :key="`slide-${currentSlideIndex}`"
                                class="absolute inset-0 p-8 flex flex-col items-center justify-center"
                            >
                                <img
                                    v-if="currentSlide.data.image_url"
                                    :src="currentSlide.data.image_url"
                                    :alt="currentSlide.data.title"
                                    class="max-h-[40%] rounded-2xl mb-8 shadow-2xl ring-4 ring-gray-100"
                                />
                                <h2 class="text-5xl font-black mb-6 text-center text-gray-800 leading-tight">
                                    {{ currentSlide.data.title }}
                                </h2>
                                <p class="text-2xl text-center text-gray-600 max-w-4xl leading-relaxed font-medium">
                                    {{ currentSlide.data.content }}
                                </p>
                            </div>

                            <!-- Financial Summary Slide -->
                            <div
                                v-else-if="currentSlide.type === 'financial'"
                                :key="'financial'"
                                class="absolute inset-0 p-8 flex flex-col items-center justify-center"
                            >
                                <h2 class="text-4xl font-black mb-10 text-gray-800 flex items-center gap-3">
                                    <svg class="w-12 h-12 text-primary-500" fill="currentColor" viewBox="0 0 20 20"><path d="M2 11a1 1 0 011-1h2a1 1 0 011 1v5a1 1 0 01-1 1H3a1 1 0 01-1-1v-5zM8 7a1 1 0 011-1h2a1 1 0 011 1v9a1 1 0 01-1 1H9a1 1 0 01-1-1V7zM14 4a1 1 0 011-1h2a1 1 0 011 1v12a1 1 0 01-1 1h-2a1 1 0 01-1-1V4z"/></svg>
                                    Transparansi Keuangan Bulan Ini
                                </h2>
                                <div class="grid grid-cols-3 gap-8 w-full max-w-5xl">
                                    <div class="bg-gradient-to-br from-primary-50 to-primary-100 p-8 rounded-3xl text-center shadow-lg border-2 border-primary-200">
                                        <div class="text-primary-600 text-lg mb-3 font-black uppercase">Pemasukan</div>
                                        <div class="text-3xl font-black text-primary-700">Rp {{ monthlyStats.income }}</div>
                                    </div>
                                    <div class="bg-gradient-to-br from-red-50 to-red-100 p-8 rounded-3xl text-center shadow-lg border-2 border-red-200">
                                        <div class="text-red-600 text-lg mb-3 font-black uppercase">Pengeluaran</div>
                                        <div class="text-3xl font-black text-red-700">Rp {{ monthlyStats.expense }}</div>
                                    </div>
                                    <div class="bg-gradient-to-br from-amber-50 to-amber-100 p-8 rounded-3xl text-center shadow-lg border-2 border-amber-300">
                                        <div class="text-amber-600 text-lg mb-3 font-black uppercase">Saldo</div>
                                        <div class="text-3xl font-black text-amber-700">Rp {{ monthlyStats.balance }}</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Wishlist Progress Slide -->
                            <div
                                v-else-if="currentSlide.type === 'wishlist'"
                                :key="'wishlist'"
                                class="absolute inset-0 p-8 flex flex-col items-center justify-center"
                            >
                                <h2 class="text-4xl font-black mb-10 text-gray-800 flex items-center gap-3">
                                    <svg class="w-12 h-12 text-primary-500" fill="currentColor" viewBox="0 0 20 20"><path d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z"/></svg>
                                    Program Wakaf & Donasi
                                </h2>
                                <div class="space-y-5 w-full max-w-4xl">
                                    <div
                                        v-for="item in wishlists"
                                        :key="item.id"
                                        class="bg-gray-50 p-6 rounded-2xl shadow-md border border-gray-100"
                                    >
                                        <div class="flex justify-between items-center mb-4">
                                            <h3 class="text-2xl font-black text-gray-800">{{ item.item_name }}</h3>
                                            <span class="text-primary-600 text-3xl font-black">{{ item.progress_percentage }}%</span>
                                        </div>
                                        <div class="bg-gray-200 rounded-full h-4 mb-4 overflow-hidden">
                                            <div
                                                class="bg-gradient-to-r from-primary-500 to-primary-400 h-full transition-all duration-1000"
                                                :style="{ width: item.progress_percentage + '%' }"
                                            ></div>
                                        </div>
                                        <div class="flex justify-between text-gray-600 text-lg font-semibold">
                                            <span>Terkumpul: <strong class="text-primary-600">{{ item.formatted_total_fulfilled }}</strong></span>
                                            <span>Target: <strong class="text-gray-800">{{ item.formatted_total_target }}</strong></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </TransitionGroup>

                        <!-- Slide Indicators -->
                        <div class="absolute bottom-8 left-0 right-0 flex justify-center gap-2">
                            <div
                                v-for="i in totalSlides"
                                :key="i"
                                :class="[
                                    'h-2.5 rounded-full transition-all duration-300',
                                    currentSlideIndex === i - 1 
                                        ? 'bg-primary-500 w-10 shadow-lg' 
                                        : 'bg-gray-300 w-2.5'
                                ]"
                            ></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom Ticker (15% height) -->
            <div class="bg-primary-600 overflow-hidden shadow-2xl" style="height: 15vh;">
                <div class="h-full flex items-center">
                    <div class="bg-white px-8 py-4 mr-6 shadow-xl rounded-r-2xl flex-shrink-0">
                        <span class="font-black text-xl tracking-wide text-primary-600">DONASI TERBARU</span>
                    </div>
                    <div class="flex-1 overflow-hidden text-white">
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

@keyframes marquee {
    0% { transform: translateX(0); }
    100% { transform: translateX(-50%); }
}

.animate-marquee {
    animation: marquee 30s linear infinite;
}
</style>
