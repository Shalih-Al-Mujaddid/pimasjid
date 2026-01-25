<script setup>
import { Head } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';

const props = defineProps({
    slides: Array
});
</script>

<template>
    <Head title="Galeri Kegiatan" />

    <PublicLayout>

        <div class="bg-emerald-700 pt-32 pb-16 text-center text-white">
            <h1 class="text-4xl font-bold mb-4">Galeri Kegiatan</h1>
            <p class="text-emerald-100">Dokumentasi kegiatan dan informasi masjid</p>
        </div>

        <div class="max-w-7xl mx-auto px-4 py-12">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <div v-for="slide in slides" :key="slide.id" class="group bg-white rounded-xl shadow-md overflow-hidden hover:shadow-xl transition-shadow">
                    <div class="relative h-64 overflow-hidden">
                        <img :src="slide.image_url" :alt="slide.title" class="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-500" />
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                    </div>
                    <div class="p-6">
                        <h3 class="text-lg font-bold text-slate-800 mb-2">{{ slide.title }}</h3>
                        <p class="text-sm text-slate-500">Ditampilkan di TV Informasi Masjid</p>
                    </div>
                </div>
            </div>
            
            <div v-if="slides.length === 0" class="text-center py-20">
                <div class="text-6xl mb-4">📷</div>
                <h3 class="text-xl font-bold text-slate-600">Belum ada foto galeri</h3>
                <p class="text-slate-500">Silakan cek kembali nanti.</p>
            </div>
        </div>
    </PublicLayout>
</template>
