<script setup>
import { Head } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { usePrayerTimes } from '@/Composables/usePrayerTimes';
import { MapPinIcon, ArrowPathIcon } from '@heroicons/vue/24/outline';

const props = defineProps({
    schedule: Object,
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
    <Head title="Jadwal Jumat" />

    <PublicLayout>

        <!-- Header -->
        <div class="bg-emerald-800 pt-32 pb-16 text-center text-white">
            <h1 class="text-4xl font-bold mb-4">Petugas Jumat</h1>
            <p class="text-emerald-200">
                Informasi petugas sholat Jumat minggu ini
            </p>
        </div>

        <div class="max-w-3xl mx-auto px-4 py-12 -mt-10">
            <!-- Main Card -->
            <div class="bg-white rounded-3xl shadow-xl overflow-hidden">
                <div class="bg-emerald-600 p-6 text-center text-white">
                    <h2 class="text-2xl font-bold mb-1">{{ schedule.date }}</h2>
                    <p class="opacity-90">{{ schedule.time }} WIB</p>
                </div>
                
                <div class="p-8 space-y-8">
                    <!-- Khutbah Topic -->
                    <div v-if="schedule.title" class="text-center mb-8">
                         <span class="inline-block px-3 py-1 bg-amber-100 text-amber-800 text-xs font-bold rounded-full mb-3">TOPIK KHUTBAH</span>
                         <h3 class="text-xl font-bold text-slate-800 italic">"{{ schedule.title }}"</h3>
                    </div>

                    <!-- Khatib -->
                    <div class="text-center">
                        <span class="inline-block px-3 py-1 bg-emerald-100 text-emerald-800 text-xs font-bold rounded-full mb-3">KHATIB</span>
                        <h3 class="text-3xl font-bold text-slate-800">{{ schedule.khatib }}</h3>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 border-t border-slate-100 pt-8">
                        <div class="text-center">
                            <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Imam</span>
                            <p class="text-lg font-bold text-slate-700 mt-1">{{ schedule.imam }}</p>
                        </div>
                        <div class="text-center">
                            <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Muadzin</span>
                            <p class="text-lg font-bold text-slate-700 mt-1">{{ schedule.muadzin }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Prayer Times Reference -->
            <div class="mt-8 bg-white rounded-xl shadow p-6 relative overflow-hidden">
                <div class="flex justify-between items-center mb-4">
                    <div>
                        <h3 class="text-lg font-bold text-slate-800">Jadwal Sholat Hari Ini</h3>
                        <div class="text-xs text-slate-400 flex items-center gap-1">
                             <span v-if="usingUserLocation">📍 Sesuai Lokasi Anda</span>
                             <span v-else>🕌 Jadwal Masjid</span>
                             <span v-if="isLocating" class="ml-2 animate-spin"><ArrowPathIcon class="w-3 h-3 inline"/></span>
                        </div>
                    </div>
                    <button 
                        @click="getUserLocation" 
                        class="text-slate-400 hover:text-emerald-600 transition-colors p-1 rounded-full hover:bg-slate-100"
                        title="Refresh Lokasi"
                    >
                        <MapPinIcon class="w-5 h-5" :class="{'text-emerald-500': usingUserLocation}" />
                    </button>
                </div>

                <div class="grid grid-cols-5 gap-2 text-center">
                    <div v-for="(time, name) in displayTimes(currentPrayerTimes)" :key="name" class="bg-slate-50 p-2 rounded hover:bg-emerald-50 transition-colors">
                        <div class="text-xs text-slate-500 mb-1 capitalize">{{ name }}</div>
                        <div class="font-bold text-slate-800">{{ time }}</div>
                    </div>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>
