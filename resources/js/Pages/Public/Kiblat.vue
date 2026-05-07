<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue';
import { Head, Link } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';

const latitude = ref(null);
const longitude = ref(null);
const qiblaBearing = ref(null);
const deviceHeading = ref(0);
const compassAccuracy = ref(0);
const errorMsg = ref('');
const hasLocationPermission = ref(false);
const hasCompassPermission = ref(false);
const isIOS = ref(false);
const isCalibrating = ref(false);

const MECCA_LAT = 21.422487;
const MECCA_LNG = 39.826206;

// Menghitung derajat arah kiblat dari lokasi user (Utara = 0 derajat)
const calculateQibla = (lat, lng) => {
    const latRad = (lat * Math.PI) / 180;
    const lngRad = (lng * Math.PI) / 180;
    const meccaLatRad = (MECCA_LAT * Math.PI) / 180;
    const meccaLngRad = (MECCA_LNG * Math.PI) / 180;

    const y = Math.sin(meccaLngRad - lngRad);
    const x = Math.cos(latRad) * Math.tan(meccaLatRad) - Math.sin(latRad) * Math.cos(meccaLngRad - lngRad);
    
    let qibla = (Math.atan2(y, x) * 180) / Math.PI;
    return (qibla + 360) % 360;
};

const getLocation = () => {
    errorMsg.value = '';
    if (!navigator.geolocation) {
        errorMsg.value = 'Browser Anda tidak mendukung Geolocation.';
        return;
    }

    navigator.geolocation.getCurrentPosition(
        (position) => {
            latitude.value = position.coords.latitude;
            longitude.value = position.coords.longitude;
            qiblaBearing.value = calculateQibla(latitude.value, longitude.value);
            hasLocationPermission.value = true;
            checkCompassSupport();
        },
        (error) => {
            if (error.code === error.PERMISSION_DENIED) {
                errorMsg.value = 'Izin lokasi ditolak. Silakan izinkan akses lokasi untuk menghitung arah kiblat.';
            } else {
                errorMsg.value = 'Gagal mendapatkan lokasi Anda.';
            }
        },
        { enableHighAccuracy: true }
    );
};

const handleOrientation = (event) => {
    let heading = null;

    // iOS devices use webkitCompassHeading
    if (event.webkitCompassHeading !== undefined && event.webkitCompassHeading !== null) {
        heading = event.webkitCompassHeading;
        compassAccuracy.value = event.webkitCompassAccuracy || 0;
    } 
    // Android / standard devices use alpha
    else if (event.alpha !== null) {
        // alpha represents orientation around Z axis (0 to 360). 
        // 0 usually points to Earth's North Pole on absolute orientation.
        // If the event is absolute, we can use 360 - alpha to get compass heading.
        heading = 360 - event.alpha;
    }

    if (heading !== null) {
        deviceHeading.value = heading;
        hasCompassPermission.value = true;
    }
};

const requestCompassPermission = () => {
    if (typeof DeviceOrientationEvent !== 'undefined' && typeof DeviceOrientationEvent.requestPermission === 'function') {
        // iOS 13+ devices
        DeviceOrientationEvent.requestPermission()
            .then(permissionState => {
                if (permissionState === 'granted') {
                    window.addEventListener('deviceorientation', handleOrientation, true);
                    hasCompassPermission.value = true;
                } else {
                    errorMsg.value = 'Izin sensor kompas ditolak.';
                }
            })
            .catch(console.error);
    } else {
        // Non iOS 13+ devices
        // Coba gunakan deviceorientationabsolute jika tersedia, atau deviceorientation biasa
        window.addEventListener('deviceorientationabsolute', handleOrientation, true);
        window.addEventListener('deviceorientation', handleOrientation, true);
        hasCompassPermission.value = true;
    }
};

const checkCompassSupport = () => {
    // Check if it's iOS which might need explicit button click
    const userAgent = window.navigator.userAgent.toLowerCase();
    isIOS.value = /iphone|ipad|ipod/.test(userAgent);
    
    if (!isIOS.value) {
        requestCompassPermission();
    }
};

onMounted(() => {
    getLocation();
});

onUnmounted(() => {
    window.removeEventListener('deviceorientationabsolute', handleOrientation, true);
    window.removeEventListener('deviceorientation', handleOrientation, true);
});

// Calculate rotation for the compass dial and qibla arrow
const compassRotation = computed(() => {
    return -deviceHeading.value;
});

const arrowRotation = computed(() => {
    return qiblaBearing.value !== null ? qiblaBearing.value : 0;
});

// Format degree helpers
const formatDegree = (deg) => {
    if (deg === null) return '-';
    return `${deg.toFixed(1)}°`;
};
</script>

<template>
    <PublicLayout>
        <Head title="Arah Kiblat" />

        <div class="bg-emerald-700 pt-32 pb-16 text-center text-white mb-8">
            <h1 class="text-4xl font-black tracking-tight mb-4">🧭 Arah Kiblat</h1>
            <p class="text-emerald-100 max-w-2xl mx-auto">
                Temukan arah kiblat dengan presisi menggunakan kompas perangkat Anda.
            </p>
        </div>

        <div class="min-h-screen bg-slate-50 pb-12">
            <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">

                <!-- Error Alert -->
                <div v-if="errorMsg" class="bg-red-50 border-l-4 border-red-500 p-4 mb-8 rounded-r-xl shadow-sm">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                            </svg>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm text-red-700 font-medium">
                                {{ errorMsg }}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Main Compass Container -->
                <div class="bg-white rounded-3xl shadow-xl shadow-slate-200/50 p-6 sm:p-10 border border-slate-100 mb-8 relative overflow-hidden">
                    <!-- Background Decoration -->
                    <div class="absolute -top-24 -right-24 w-64 h-64 bg-emerald-50 rounded-full blur-3xl opacity-60"></div>
                    <div class="absolute -bottom-24 -left-24 w-64 h-64 bg-emerald-50 rounded-full blur-3xl opacity-60"></div>

                    <!-- Steps / Status -->
                    <div v-if="!hasLocationPermission && !errorMsg" class="text-center py-12 relative z-10">
                        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-emerald-500 mx-auto mb-4"></div>
                        <p class="text-slate-600 font-medium">Meminta akses lokasi...</p>
                        <button @click="getLocation" class="mt-4 text-emerald-600 text-sm font-bold hover:underline">Coba Lagi</button>
                    </div>

                    <div v-else-if="hasLocationPermission" class="relative z-10">
                        <!-- Location Info -->
                        <div class="flex flex-col sm:flex-row items-center justify-between bg-slate-50 p-4 rounded-2xl mb-8 border border-slate-100">
                            <div class="text-center sm:text-left mb-4 sm:mb-0">
                                <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Koordinat Anda</p>
                                <p class="text-sm font-medium text-slate-700">
                                    {{ latitude ? latitude.toFixed(4) : '-' }}, {{ longitude ? longitude.toFixed(4) : '-' }}
                                </p>
                            </div>
                            <div class="text-center sm:text-right">
                                <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Sudut Kiblat</p>
                                <p class="text-lg font-black text-emerald-600">
                                    {{ formatDegree(qiblaBearing) }}
                                </p>
                            </div>
                        </div>

                        <!-- iOS Compass Permission Button -->
                        <div v-if="isIOS && !hasCompassPermission" class="text-center py-8">
                            <div class="bg-amber-50 rounded-2xl p-6 border border-amber-100 mb-6">
                                <p class="text-amber-800 text-sm font-medium mb-4">
                                    Perangkat iOS memerlukan izin untuk mengakses sensor kompas.
                                </p>
                                <button 
                                    @click="requestCompassPermission"
                                    class="bg-emerald-500 hover:bg-emerald-600 text-white px-6 py-3 rounded-full font-bold transition-colors shadow-lg shadow-emerald-500/30"
                                >
                                    Aktifkan Kompas
                                </button>
                            </div>
                        </div>

                        <!-- Compass UI -->
                        <div v-else class="relative mx-auto w-64 h-64 sm:w-80 sm:h-80 flex items-center justify-center">
                            
                            <!-- Calibration Warning -->
                            <div v-if="compassAccuracy > 0 && compassAccuracy > 25" class="absolute -top-12 left-0 right-0 text-center">
                                <span class="bg-amber-100 text-amber-800 text-xs px-3 py-1 rounded-full font-medium">Akurasi rendah. Putar HP Anda membentuk angka 8.</span>
                            </div>

                            <!-- Outer Ring (Device Orientation) -->
                            <div 
                                class="absolute inset-0 rounded-full border-4 border-slate-100 shadow-inner bg-white transition-transform duration-100 ease-linear"
                                :style="{ transform: `rotate(${compassRotation}deg)` }"
                            >
                                <!-- Cardinal Directions -->
                                <div class="absolute top-2 left-1/2 -translate-x-1/2 text-red-500 font-black text-lg">U</div>
                                <div class="absolute bottom-2 left-1/2 -translate-x-1/2 text-slate-400 font-bold">S</div>
                                <div class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 font-bold">T</div>
                                <div class="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 font-bold">B</div>

                                <!-- Tick marks (every 30 degrees) -->
                                <template v-for="n in 12" :key="n">
                                    <div 
                                        class="absolute top-0 left-1/2 w-0.5 h-3 bg-slate-200 origin-bottom"
                                        :style="{ transform: `translateX(-50%) rotate(${n * 30}deg)`, height: '50%' }"
                                    ></div>
                                </template>

                                <!-- Qibla Direction Indicator (Fixed to the dial) -->
                                <div 
                                    v-if="qiblaBearing !== null"
                                    class="absolute inset-0 pointer-events-none transition-transform duration-100 ease-linear"
                                    :style="{ transform: `rotate(${arrowRotation}deg)` }"
                                >
                                    <!-- Qibla Arrow -->
                                    <div class="absolute top-8 left-1/2 -translate-x-1/2 flex flex-col items-center">
                                        <div class="text-3xl drop-shadow-md">🕋</div>
                                        <div class="w-1 h-24 bg-gradient-to-t from-transparent via-emerald-400 to-emerald-500 mt-2 rounded-full"></div>
                                        <div class="w-4 h-4 bg-emerald-500 rotate-45 -mt-2 shadow-sm rounded-sm"></div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Static Center Point -->
                            <div class="w-8 h-8 bg-slate-800 rounded-full z-20 shadow-md border-4 border-white flex items-center justify-center">
                                <div class="w-1 h-1 bg-white rounded-full"></div>
                            </div>
                            
                            <!-- Static Device Heading Marker (always points UP to represent top of phone) -->
                            <div class="absolute -top-4 left-1/2 -translate-x-1/2 w-4 h-4 bg-slate-900 rotate-45 z-30 rounded-sm"></div>
                        </div>

                        <!-- Current Heading Display -->
                        <div v-if="hasCompassPermission" class="text-center mt-8">
                            <p class="text-slate-500 text-sm font-medium">Arah HP Anda</p>
                            <p class="text-3xl font-black text-slate-800 font-mono mt-1">{{ Math.round(deviceHeading) }}°</p>
                            <p v-if="Math.abs(deviceHeading - qiblaBearing) < 5" class="mt-3 inline-block bg-emerald-100 text-emerald-800 px-4 py-2 rounded-full font-bold text-sm animate-pulse">
                                Anda menghadap Kiblat!
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Info Card -->
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-100">
                    <h3 class="font-bold text-slate-800 mb-2 flex items-center gap-2">
                        <svg class="w-5 h-5 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        Informasi
                    </h3>
                    <ul class="text-sm text-slate-600 space-y-2 list-disc list-inside">
                        <li>Pastikan Anda memberikan izin akses lokasi pada browser Anda.</li>
                        <li>Akurasi kompas bergantung pada sensor perangkat genggam (HP) Anda.</li>
                        <li>Jauhkan perangkat dari benda bermagnet atau elektronik lain yang dapat mengganggu sensor.</li>
                        <li>Untuk hasil terbaik, posisikan HP mendatar (sejajar dengan tanah) dan gerakkan membentuk angka 8 untuk kalibrasi.</li>
                        <li>Fitur kompas mungkin tidak berfungsi di komputer desktop/laptop yang tidak memiliki sensor orientasi.</li>
                    </ul>
                </div>

            </div>
        </div>
    </PublicLayout>
</template>
