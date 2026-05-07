<script setup>
import { ref, onMounted, computed } from 'vue';
import { Head, Link } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { ArrowLeftIcon, PlayIcon, PauseIcon } from '@heroicons/vue/24/outline';



const props = defineProps({
    nomor: {
        type: String,
        required: true
    }
});

const surah = ref(null);
const loading = ref(true);
const audioPlayer = ref(null);
const isPlaying = ref(false);

const fetchSurahDetail = async () => {
    try {
        const response = await fetch(`https://equran.id/api/v2/surat/${props.nomor}`);
        const data = await response.json();
        if (data && data.data) {
            surah.value = data.data;
        }
    } catch (error) {
        console.error("Gagal mengambil detail surah", error);
    } finally {
        loading.value = false;
    }
};

onMounted(() => {
    fetchSurahDetail();
});

const toggleAudio = () => {
    if (!audioPlayer.value) return;
    
    if (isPlaying.value) {
        audioPlayer.value.pause();
    } else {
        audioPlayer.value.play();
    }
    isPlaying.value = !isPlaying.value;
};

const handleAudioEnded = () => {
    isPlaying.value = false;
};

// Use Mishary Rashid Alafasy audio if available
const audioUrl = computed(() => {
    if (!surah.value || !surah.value.audioFull) return null;
    return surah.value.audioFull["05"] || surah.value.audioFull["01"];
});
</script>

<template>
    <Head :title="surah ? `Surah ${surah.namaLatin} - Al-Quran Digital` : 'Memuat Surah...'" />

    <PublicLayout>
        <!-- Hero / Header Section -->
    <div class="relative bg-slate-900 pt-32 pb-16 lg:pt-40 lg:pb-20 overflow-hidden">
        <div class="absolute inset-0 opacity-5 bg-pattern-islamic bg-repeat"></div>
        <div class="absolute inset-0 bg-gradient-to-t from-slate-900 via-transparent to-transparent"></div>
        
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
            <Link href="/quran" class="inline-flex items-center gap-2 text-slate-400 hover:text-white transition-colors mb-8 font-bold text-sm uppercase tracking-wider">
                <ArrowLeftIcon class="w-4 h-4" /> Kembali ke Daftar
            </Link>

            <div v-if="loading" class="animate-pulse flex flex-col items-center justify-center space-y-4">
                <div class="h-8 bg-slate-800 rounded w-48"></div>
                <div class="h-16 bg-slate-800 rounded w-64"></div>
                <div class="h-4 bg-slate-800 rounded w-32"></div>
            </div>

            <div v-else-if="surah" class="text-center">
                <span class="badge badge-soft bg-white/10 text-slate-300 border-none uppercase tracking-widest font-bold mb-4 text-xs">
                    Surah Ke-{{ surah.nomor }} • {{ surah.tempatTurun }}
                </span>
                
                <h1 class="text-5xl lg:text-7xl font-arabic text-bakri-teal mb-2 leading-tight">
                    {{ surah.nama }}
                </h1>
                <h2 class="text-3xl lg:text-4xl font-black text-white mb-4 tracking-tight">
                    {{ surah.namaLatin }}
                </h2>
                
                <p class="text-slate-400 font-medium tracking-wide flex items-center justify-center gap-2">
                    {{ surah.arti }} 
                    <span class="w-1.5 h-1.5 rounded-full bg-slate-600"></span> 
                    {{ surah.jumlahAyat }} Ayat
                </p>

                <!-- Audio Player Controls -->
                <div v-if="audioUrl" class="mt-10 flex flex-col items-center justify-center">
                    <audio ref="audioPlayer" :src="audioUrl" @ended="handleAudioEnded" class="hidden"></audio>
                    <button 
                        @click="toggleAudio"
                        class="btn rounded-full px-8 py-3 shadow-xl flex items-center gap-3 transition-all transform hover:scale-105 active:scale-95 font-bold uppercase tracking-widest text-sm"
                        :class="isPlaying ? 'bg-slate-800 text-white hover:bg-slate-700' : 'bg-bakri-teal text-white hover:bg-teal-600'"
                    >
                        <PauseIcon v-if="isPlaying" class="w-5 h-5" />
                        <PlayIcon v-else class="w-5 h-5" />
                        {{ isPlaying ? 'Jeda Audio' : 'Putar Surah' }}
                    </button>
                    <span class="text-xs text-slate-500 mt-3 font-medium uppercase tracking-wider">Mishary Rashid Alafasy</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Ayat List Section -->
    <div class="bg-slate-50 min-h-screen py-16">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8">
            
            <div v-if="loading" class="space-y-6">
                <div v-for="i in 5" :key="i" class="card bg-white p-8 rounded-3xl border-none shadow-sm animate-pulse">
                    <div class="h-16 bg-slate-100 rounded w-full mb-4"></div>
                    <div class="h-4 bg-slate-100 rounded w-3/4 mb-2"></div>
                    <div class="h-4 bg-slate-100 rounded w-1/2"></div>
                </div>
            </div>

            <div v-else-if="surah">
                <!-- Bismillah if not Al-Fatihah or At-Taubah -->
                <div v-if="surah.nomor !== 1 && surah.nomor !== 9" class="text-center py-10 mb-8">
                    <h3 class="text-4xl lg:text-5xl font-arabic text-slate-800 leading-relaxed">
                        بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ
                    </h3>
                </div>

                <!-- Ayat Cards -->
                <div v-for="ayat in surah.ayat" :key="ayat.nomorAyat" class="card bg-white p-8 lg:p-10 rounded-[2.5rem] border border-slate-100 shadow-sm hover:shadow-xl transition-all duration-300 relative group mb-8">
                    
                    <!-- Ayat Number Badge -->
                    <div class="absolute -top-4 -left-4 lg:-left-6 w-12 h-12 bg-bakri-teal text-white rounded-2xl flex items-center justify-center font-black text-lg shadow-lg rotate-3 group-hover:-rotate-3 transition-transform">
                        {{ ayat.nomorAyat }}
                    </div>

                    <!-- Arabic Text -->
                    <div class="text-right mb-8">
                        <p class="text-3xl lg:text-5xl font-arabic text-slate-800 leading-[2.5] lg:leading-[2.5]" dir="rtl">
                            {{ ayat.teksArab }}
                        </p>
                    </div>

                    <div class="space-y-4">
                        <!-- Latin Transliteration -->
                        <p class="text-bakri-teal font-medium text-lg lg:text-xl leading-relaxed">
                            {{ ayat.teksLatin }}
                        </p>

                        <div class="w-12 h-px bg-slate-200"></div>

                        <!-- Translation -->
                        <p class="text-slate-600 text-base lg:text-lg leading-relaxed font-light">
                            {{ ayat.teksIndonesia }}
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
    </PublicLayout>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Amiri:wght@400;700&display=swap');

.font-arabic {
    font-family: 'Amiri', serif;
}
</style>
