<script setup>
import { Head } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { usePrayerTimes } from '@/Composables/usePrayerTimes';
import { MapPinIcon, ArrowPathIcon, ClockIcon } from '@heroicons/vue/24/outline';

const props = defineProps({
    prayerTimes: Object
});

const { 
    currentPrayerTimes, 
    isLocating, 
    usingUserLocation, 
    getUserLocation 
} = usePrayerTimes(props.prayerTimes);

// Filter out 'date' key safely
const displayTimes = (times) => {
    const { date, ...rest } = times || {};
    return rest;
};
</script>

<template>
    <Head title="Jadwal Sholat" />

    <PublicLayout>

        <!-- Header -->
        <div class="bg-emerald-800 pt-32 pb-16 text-center text-white relative overflow-hidden">
            <div class="absolute inset-0 z-0">
                <div class="absolute inset-0 bg-gradient-to-br from-emerald-900/90 to-emerald-800/80"></div>
            </div>
            <div class="relative z-10 px-4">
                <h1 class="text-4xl font-bold mb-4">Jadwal Sholat</h1>
                <p class="text-emerald-200">
                    Jadwal sholat 5 waktu hari ini
                </p>
                <p class="text-white mt-2 font-bold text-xl">{{ currentPrayerTimes?.date || 'Hari Ini' }}</p>
            </div>
        </div>

        <div class="max-w-3xl mx-auto px-4 py-12 -mt-10">
            <!-- Main Card -->
            <div class="bg-white rounded-3xl shadow-xl overflow-hidden p-8">
                <div class="flex justify-between items-center mb-8 pb-8 border-b border-slate-100">
                    <div>
                        <h2 class="text-2xl font-bold text-slate-800">Waktu Sholat</h2>
                        <div class="text-sm text-slate-500 mt-1 flex items-center gap-2">
                             <span v-if="usingUserLocation" class="flex items-center gap-1 text-emerald-600 font-medium">
                                <MapPinIcon class="w-4 h-4" />
                                Sesuai Lokasi Anda
                             </span>
                             <span v-else class="flex items-center gap-1">
                                🕌 Jadwal Masjid (Default)
                             </span>
                             <span v-if="isLocating" class="ml-2 animate-spin text-emerald-500"><ArrowPathIcon class="w-4 h-4"/></span>
                        </div>
                    </div>
                    <button 
                        @click="getUserLocation" 
                        class="px-4 py-2 bg-slate-100 hover:bg-emerald-50 text-slate-600 hover:text-emerald-600 rounded-lg transition-colors flex items-center gap-2 text-sm font-medium"
                        :disabled="isLocating"
                    >
                        <MapPinIcon class="w-5 h-5" :class="{'text-emerald-500': usingUserLocation}" />
                        <span>{{ isLocating ? 'Mencari...' : 'Gunakan Lokasi Saya' }}</span>
                    </button>
                </div>

                <div class="space-y-4">
                    <div v-for="(time, name) in displayTimes(currentPrayerTimes)" :key="name" 
                        class="flex items-center justify-between p-4 rounded-xl transition-all hover:scale-[1.01]"
                        :class="[
                            'hover:shadow-md cursor-default',
                            name === 'Subuh' ? 'bg-indigo-50 border border-indigo-100' : 
                            name === 'Dzuhur' ? 'bg-amber-50 border border-amber-100' :
                            name === 'Ashar' ? 'bg-orange-50 border border-orange-100' :
                            name === 'Maghrib' ? 'bg-rose-50 border border-rose-100' :
                            'bg-slate-50 border border-slate-100'
                        ]"
                    >
                        <div class="flex items-center gap-4">
                            <div class="p-3 rounded-full bg-white shadow-sm">
                                <ClockIcon class="w-6 h-6 text-slate-400" />
                            </div>
                            <span class="text-lg font-bold text-slate-700 capitalize">{{ name }}</span>
                        </div>
                        <span class="text-2xl font-bold text-slate-900 font-mono">{{ time }}</span>
                    </div>
                </div>

                <div class="mt-8 p-4 bg-emerald-50 rounded-xl border border-emerald-100 text-center">
                    <p class="text-emerald-800 text-sm">
                        "Sesungguhnya sholat itu adalah fardhu yang ditentukan waktunya atas orang-orang yang beriman." <br>
                        <strong>(QS. An-Nisa: 103)</strong>
                    </p>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>
