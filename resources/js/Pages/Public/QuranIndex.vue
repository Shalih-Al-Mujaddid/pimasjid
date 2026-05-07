<script setup>
import { ref, onMounted, computed } from 'vue';
import { Head, Link } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { MagnifyingGlassIcon } from '@heroicons/vue/24/outline';



const surahs = ref([]);
const loading = ref(true);
const searchQuery = ref('');

// Fetch all surahs from eQuran API
const fetchSurahs = async () => {
    try {
        const response = await fetch('https://equran.id/api/v2/surat');
        const data = await response.json();
        if (data && data.data) {
            surahs.value = data.data;
        }
    } catch (error) {
        console.error("Gagal mengambil data Al-Quran", error);
    } finally {
        loading.value = false;
    }
};

onMounted(() => {
    fetchSurahs();
});

// Filter surahs based on search query
const filteredSurahs = computed(() => {
    if (!searchQuery.value) return surahs.value;
    
    const query = searchQuery.value.toLowerCase();
    return surahs.value.filter(surah => 
        surah.namaLatin.toLowerCase().includes(query) || 
        surah.arti.toLowerCase().includes(query)
    );
});
</script>

<template>
    <Head title="Al-Quran Digital" />

    <PublicLayout>
        <!-- Hero Section Minimal -->
    <div class="relative bg-bakri-teal pt-32 pb-20 lg:pt-40 lg:pb-28 overflow-hidden">
        <div class="absolute inset-0 opacity-10 bg-pattern-islamic bg-repeat"></div>
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 text-center">
            <span class="badge badge-soft bg-white/20 text-white border-none uppercase tracking-widest font-bold mb-4">Layanan Umat</span>
            <h1 class="text-4xl md:text-5xl lg:text-6xl font-black text-white mb-6 tracking-tight">Al-Quran Digital</h1>
            <p class="text-white/80 text-lg max-w-2xl mx-auto mb-10 leading-relaxed font-light">
                Baca dan pahami Al-Quran kapan saja dan di mana saja. Dilengkapi dengan terjemahan dan audio.
            </p>

            <!-- Search Bar -->
            <div class="max-w-xl mx-auto relative group">
                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400 group-focus-within:text-bakri-teal transition-colors">
                    <MagnifyingGlassIcon class="h-6 w-6" />
                </div>
                <input 
                    v-model="searchQuery" 
                    type="text" 
                    class="block w-full pl-12 pr-4 py-4 rounded-full border-none ring-4 ring-white/10 focus:ring-bakri-teal focus:ring-offset-2 focus:ring-offset-bakri-teal shadow-2xl text-slate-800 placeholder-slate-400 font-medium text-lg transition-all" 
                    placeholder="Cari nama surah atau terjemahan..." 
                />
            </div>
        </div>
    </div>

    <div class="bg-slate-50 min-h-screen py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            
            <!-- Loading Skeleton -->
            <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <div v-for="i in 12" :key="i" class="card bg-white p-6 rounded-3xl border-none shadow-sm animate-pulse">
                    <div class="flex items-center gap-4">
                        <div class="w-12 h-12 bg-slate-200 rounded-full flex-shrink-0"></div>
                        <div class="flex-1 space-y-3">
                            <div class="h-4 bg-slate-200 rounded w-1/2"></div>
                            <div class="h-3 bg-slate-200 rounded w-1/3"></div>
                        </div>
                        <div class="w-16 h-8 bg-slate-200 rounded-lg"></div>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div v-else-if="filteredSurahs.length === 0" class="text-center py-20">
                <div class="text-6xl mb-4">📖</div>
                <h3 class="text-xl font-bold text-slate-700 mb-2">Surah tidak ditemukan</h3>
                <p class="text-slate-500">Coba gunakan kata kunci pencarian yang lain.</p>
            </div>

            <!-- Surah Grid -->
            <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <Link 
                    v-for="surah in filteredSurahs" 
                    :key="surah.nomor" 
                    :href="`/quran/${surah.nomor}`"
                    class="card bg-white hover:bg-slate-50 p-6 rounded-[2rem] border border-slate-100 hover:border-bakri-teal/30 shadow-sm hover:shadow-xl transition-all duration-300 group flex items-center justify-between"
                >
                    <div class="flex items-center gap-5">
                        <!-- Nomor Surah (Octagram shape approximation) -->
                        <div class="relative w-12 h-12 flex items-center justify-center flex-shrink-0">
                            <div class="absolute inset-0 bg-bakri-teal/10 rotate-45 rounded-lg group-hover:rotate-90 transition-transform duration-500"></div>
                            <div class="absolute inset-0 border-2 border-bakri-teal/20 rotate-12 rounded-lg group-hover:-rotate-45 transition-transform duration-500"></div>
                            <span class="relative text-bakri-teal font-black text-sm">{{ surah.nomor }}</span>
                        </div>
                        
                        <div class="flex flex-col">
                            <h3 class="text-lg font-bold text-slate-800 group-hover:text-bakri-teal transition-colors flex items-center gap-2">
                                {{ surah.namaLatin }}
                            </h3>
                            <span class="text-xs font-bold text-slate-400 uppercase tracking-wider mt-1 flex items-center gap-1.5">
                                {{ surah.arti }}
                                <span class="w-1 h-1 rounded-full bg-slate-300"></span>
                                {{ surah.jumlahAyat }} Ayat
                            </span>
                        </div>
                    </div>
                    
                    <div class="text-2xl font-arabic text-slate-800 group-hover:text-bakri-teal transition-colors">
                        {{ surah.nama }}
                    </div>
                </Link>
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
