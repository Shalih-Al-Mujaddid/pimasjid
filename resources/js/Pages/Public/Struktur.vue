<script setup>
import { Head } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';

const props = defineProps({
    committee: Object
});
</script>

<template>
    <Head title="Struktur Pengurus DKM" />

    <PublicLayout>

        <!-- Hero Section -->
        <div class="relative bg-gradient-to-br from-primary-700 to-primary-900 pt-32 pb-24 text-center text-white overflow-hidden">
             <!-- Decorative Islamic Pattern Overlay -->
            <div class="absolute inset-0 opacity-10 bg-[url('https://www.transparenttextures.com/patterns/arabesque.png')]"></div>
            
            <div class="relative z-10 px-4">
                <div class="block w-fit mx-auto py-1 px-3 rounded-full bg-white/10 backdrop-blur-sm text-emerald-100 text-sm font-medium mb-4 border border-white/20">
                    Dewan Kemakmuran Masjid
                </div>
                <h1 class="text-4xl md:text-5xl font-bold mb-4 font-serif relative inline-block text-amber-400 drop-shadow-md">
                    Struktur Organisasi
                    <span class="absolute -bottom-2 left-1/4 right-1/4 h-1 bg-gradient-to-r from-transparent via-amber-400 to-transparent"></span>
                </h1>
                <p class="text-emerald-100 max-w-2xl mx-auto text-lg mt-4 leading-relaxed">
                    Bersinergi membangun umat dengan amanah dan profesionalisme untuk kemakmuran {{ $page.props.settings?.site_name || 'Masjid' }}.
                </p>
            </div>
        </div>

        <div class="max-w-7xl mx-auto px-4 py-16 -mt-10 relative z-20">
            
            <div class="flex flex-col items-center space-y-16">
                
                 <!-- Top Leadership: Ketua -->
                 <div v-if="committee.Inti" class="w-full flex justify-center">
                    <div v-for="member in committee.Inti.filter(m => m.order === 1)" :key="member.id" class="relative group">
                        <div class="absolute inset-0 bg-emerald-500 blur-xl opacity-20 group-hover:opacity-30 transition-opacity rounded-full"></div>
                        <div class="relative bg-white rounded-3xl shadow-2xl overflow-hidden max-w-sm w-full border border-slate-100 transform hover:-translate-y-2 transition-transform duration-300">
                            <div class="h-40 bg-gradient-to-br from-emerald-600 to-emerald-800 relative overflow-hidden">
                                <div class="absolute inset-0 opacity-20 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')]"></div>
                            </div>
                            <div class="px-8 pb-8 text-center -mt-20">
                                <div class="relative inline-block">
                                    <div class="absolute inset-0 bg-amber-400 rounded-full blur opacity-50"></div>
                                    <img :src="member.photo_url" :alt="member.name" class="relative w-40 h-40 rounded-full border-4 border-white shadow-lg object-cover z-10 bg-slate-100" />
                                </div>
                                <div class="mt-6">
                                    <h3 class="text-2xl font-bold text-slate-800">{{ member.name }}</h3>
                                    <div class="inline-flex items-center gap-2 mt-2 px-4 py-1 bg-emerald-50 text-emerald-700 rounded-full font-medium text-sm">
                                        <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                                        {{ member.position }}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                 </div>

                 <!-- Core Team (Inti excluding Ketua) -->
                 <div v-if="committee.Inti && committee.Inti.length > 1" class="w-full max-w-5xl">
                     <div class="flex items-center justify-center gap-4 mb-8">
                        <div class="h-px bg-slate-200 w-16"></div>
                        <h3 class="text-xl font-bold text-slate-400 uppercase tracking-widest text-center">Pengurus Inti</h3>
                        <div class="h-px bg-slate-200 w-16"></div>
                     </div>
                     
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 justify-center">
                        <div v-for="member in committee.Inti.filter(m => m.order > 1)" :key="member.id" class="bg-white rounded-xl shadow-lg p-6 border border-slate-100 flex flex-col items-center text-center hover:shadow-xl transition-shadow group">
                            <div class="w-24 h-24 rounded-full p-1 bg-gradient-to-tr from-emerald-400 to-emerald-100 mb-4 group-hover:from-amber-400 group-hover:to-amber-100 transition-colors">
                                <img :src="member.photo_url" :alt="member.name" class="w-full h-full rounded-full object-cover border-2 border-white" />
                            </div>
                            <h4 class="font-bold text-slate-800 text-lg">{{ member.name }}</h4>
                            <p class="text-emerald-600 font-medium text-sm">{{ member.position }}</p>
                        </div>
                    </div>
                 </div>

                 <!-- Divisions -->
                 <div class="w-full">
                    <div class="flex items-center justify-center gap-4 mb-12">
                        <div class="h-px bg-slate-200 w-16"></div>
                        <h3 class="text-xl font-bold text-slate-400 uppercase tracking-widest text-center">Bidang & Seksi</h3>
                        <div class="h-px bg-slate-200 w-16"></div>
                     </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
                        <template v-for="(members, divName) in committee" :key="divName">
                            <div v-if="divName !== 'Inti'" class="flex flex-col h-full">
                                <div class="flex items-center gap-3 mb-6">
                                    <div class="h-8 w-1 bg-emerald-500 rounded-full"></div>
                                    <h4 class="font-bold text-slate-800 text-lg uppercase tracking-tight">{{ divName }}</h4>
                                </div>
                                
                                <div class="grid grid-cols-1 gap-4">
                                    <div v-for="member in members" :key="member.id" class="bg-white rounded-2xl shadow-sm border border-slate-100 p-4 hover:shadow-md transition-shadow flex items-center gap-4 group">
                                        <div class="relative flex-shrink-0">
                                            <div class="absolute inset-0 bg-emerald-500 rounded-full blur-sm opacity-0 group-hover:opacity-20 transition-opacity"></div>
                                            <img :src="member.photo_url" :alt="member.name" class="relative w-14 h-14 rounded-full bg-slate-100 object-cover border-2 border-white shadow-sm" />
                                        </div>
                                        <div class="min-w-0">
                                            <div class="font-bold text-slate-800 text-sm truncate leading-snug">{{ member.name }}</div>
                                            <div class="text-xs text-emerald-600 font-medium mt-0.5 truncate">{{ member.position }}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </div>
                 </div>

            </div>
        </div>

    </PublicLayout>
</template>

<style scoped>
/* Custom grid layout for masonry-like effect if needed later */
</style>
