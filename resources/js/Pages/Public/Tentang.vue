<script setup>
import { Head } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';

const props = defineProps({
    about: {
        type: Object,
        default: () => ({
            hero_title: 'Tentang Kami',
            hero_subtitle: 'Sejarah dan visi misi Masjid Al-Hidayah dalam melayani umat.',
            vision: '',
            mission: '',
            history: '',
            image: null
        })
    }
});

// Helper to split mission text into list items
const getMissionList = (missionText) => {
    if (!missionText) return [];
    return missionText.split('\n').filter(item => item.trim() !== '');
};
</script>

<template>
    <Head :title="`Tentang ${$page.props.settings?.site_name || 'Masjid'}`" />

    <PublicLayout>

        <!-- Hero Section -->
        <div class="relative bg-gradient-to-br from-primary-700 to-primary-900 pt-32 pb-24 text-center text-white overflow-hidden">
             <!-- Decorative Islamic Pattern Overlay -->
            <div class="absolute inset-0 opacity-10 bg-[url('https://www.transparenttextures.com/patterns/arabesque.png')]"></div>
            
            <div class="relative z-10 px-4">
                <div class="block w-fit mx-auto py-1 px-3 rounded-full bg-white/10 backdrop-blur-sm text-emerald-100 text-sm font-medium mb-4 border border-white/20">
                    Tentang Kami
                </div>
                <h1 class="text-4xl md:text-5xl font-bold mb-4 font-serif relative inline-block text-amber-400 drop-shadow-md">
                    {{ about.hero_title }}
                    <span class="absolute -bottom-2 left-1/4 right-1/4 h-1 bg-gradient-to-r from-transparent via-amber-400 to-transparent"></span>
                </h1>
                <p class="text-emerald-100 max-w-2xl mx-auto text-lg mt-4 leading-relaxed">
                    {{ about.hero_subtitle }}
                </p>
            </div>
        </div>

        <div class="max-w-7xl mx-auto px-4 py-16 -mt-10 relative z-20">
            
            <!-- Vision & Mission Cards -->
            <div class="grid md:grid-cols-2 gap-8 mb-20">
                <!-- Vision -->
                <div class="bg-white rounded-2xl shadow-xl overflow-hidden group hover:-translate-y-1 transition-all duration-300">
                    <div class="bg-emerald-600 p-6 relative overflow-hidden">
                        <div class="absolute -right-4 -top-4 text-emerald-500/20">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-32 w-32" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                        </div>
                        <h2 class="text-2xl font-bold text-white relative z-10 font-serif">Visi</h2>
                    </div>
                    <div class="p-8">
                        <p class="text-slate-600 text-lg leading-relaxed italic">
                            "{{ about.vision || 'Visi belum diatur.' }}"
                        </p>
                    </div>
                </div>

                <!-- Mission -->
                <div class="bg-white rounded-2xl shadow-xl overflow-hidden group hover:-translate-y-1 transition-all duration-300">
                    <div class="bg-amber-500 p-6 relative overflow-hidden">
                         <div class="absolute -right-4 -top-4 text-amber-400/20">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-32 w-32" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                            </svg>
                        </div>
                        <h2 class="text-2xl font-bold text-white relative z-10 font-serif">Misi</h2>
                    </div>
                    <div class="p-8">
                        <ul class="space-y-3">
                            <li v-for="(item, index) in getMissionList(about.mission)" :key="index" class="flex items-start">
                                <span class="flex-shrink-0 w-6 h-6 rounded-full bg-amber-100 text-amber-600 flex items-center justify-center text-sm font-bold mt-0.5 mr-3">
                                    {{ index + 1 }}
                                </span>
                                <span class="text-slate-600">{{ item.replace(/^\d+\.\s*/, '') }}</span>
                            </li>
                            <li v-if="!about.mission" class="text-slate-500 italic">Misi belum diatur.</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- History Section -->
            <div class="bg-white rounded-3xl shadow-lg p-8 md:p-12 relative overflow-hidden">
                <!-- Background Decoration -->
                <div class="absolute top-0 right-0 w-64 h-64 bg-emerald-50 rounded-full blur-3xl -mr-32 -mt-32 pointer-events-none"></div>
                <div class="absolute bottom-0 left-0 w-64 h-64 bg-amber-50 rounded-full blur-3xl -ml-32 -mb-32 pointer-events-none"></div>

                <div class="relative z-10 flex flex-col md:flex-row items-start gap-12">
                    <!-- Text Content -->
                    <div class="flex-1">
                        <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-100 text-emerald-700 text-xs font-bold uppercase tracking-wider mb-6">
                            <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                            Sejarah Kami
                        </div>
                        <h2 class="text-3xl md:text-4xl font-bold text-slate-800 mb-6 font-serif">
                            Perjalanan Membangun Peradaban
                        </h2>
                        <div class="prose prose-lg prose-slate text-slate-600 leading-relaxed whitespace-pre-line">
                            {{ about.history || 'Sejarah belum diatur.' }}
                        </div>
                    </div>

                    <!-- Image -->
                    <div v-if="about.image" class="w-full md:w-5/12">
                        <div class="relative rounded-2xl overflow-hidden shadow-2xl rotate-2 hover:rotate-0 transition-all duration-500">
                            <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent z-10"></div>
                            <img :src="about.image" :alt="$page.props.settings?.site_name" class="w-full h-auto object-cover transform hover:scale-105 transition-transform duration-700">
                            <div class="absolute bottom-0 left-0 p-6 z-20">
                                <p class="text-white font-serif text-lg italic opacity-90">"Rumah Allah, rumah kita bersama."</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </PublicLayout>
</template>
