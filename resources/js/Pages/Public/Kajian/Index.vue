<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { ref, watch } from 'vue';
import { MagnifyingGlassIcon, CalendarIcon, MapPinIcon, UserIcon, ClockIcon, PhotoIcon } from '@heroicons/vue/24/outline';

const props = defineProps({
    kajians: Object,
    filters: Object,
});

const search = ref(props.filters.search || '');
const statusFilter = ref(props.filters.status || 'semua');

let debounceTimer = null;
const applyFilters = () => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
        router.get(
            route('public.kajian.index'),
            { search: search.value, status: statusFilter.value },
            { preserveState: true, preserveScroll: true, replace: true }
        );
    }, 300);
};

watch([search, statusFilter], () => {
    applyFilters();
});
</script>

<template>
    <Head title="Kajian Rutin" />

    <PublicLayout>
        <div class="bg-emerald-700 pt-32 pb-16 text-center text-white">
            <h1 class="text-4xl font-bold mb-4">Kajian Rutin</h1>
            <p class="text-emerald-100 max-w-2xl mx-auto px-4">Ikuti majelis ilmu dan tingkatkan pemahaman agama bersama asatidzah di {{ $page.props.settings?.site_name || 'Masjid' }}</p>
        </div>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <!-- Search & Filter -->
            <div class="flex flex-col md:flex-row gap-4 mb-8 justify-between items-center bg-white p-4 rounded-xl shadow-sm border border-slate-100">
                <div class="relative w-full md:w-96">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <MagnifyingGlassIcon class="h-5 w-5 text-slate-400" />
                    </div>
                    <input 
                        v-model="search"
                        type="text" 
                        class="block w-full pl-10 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500 text-sm"
                        placeholder="Cari judul kajian atau nama ustaz..."
                    >
                </div>

                <div class="flex gap-2 overflow-x-auto pb-2 md:pb-0 w-full md:w-auto">
                    <button 
                        @click="statusFilter = 'semua'"
                        class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors"
                        :class="statusFilter === 'semua' ? 'bg-emerald-600 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'"
                    >
                        Semua
                    </button>
                    <button 
                        @click="statusFilter = 'akan_datang'"
                        class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors"
                        :class="statusFilter === 'akan_datang' ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'"
                    >
                        Akan Datang
                    </button>
                    <button 
                        @click="statusFilter = 'berlangsung'"
                        class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors"
                        :class="statusFilter === 'berlangsung' ? 'bg-emerald-600 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'"
                    >
                        Berlangsung
                    </button>
                    <button 
                        @click="statusFilter = 'selesai'"
                        class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors"
                        :class="statusFilter === 'selesai' ? 'bg-slate-600 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'"
                    >
                        Selesai / Arsip
                    </button>
                </div>
            </div>

            <!-- Kajian Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <div v-for="kajian in kajians.data" :key="kajian.id" class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden hover:shadow-md transition-shadow group flex flex-col h-full">
                    <!-- Banner -->
                    <div class="relative h-48 bg-slate-200 overflow-hidden">
                        <img v-if="kajian.banner" :src="kajian.banner" :alt="kajian.title" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        <div v-else class="w-full h-full flex items-center justify-center bg-emerald-50 text-emerald-300">
                            <PhotoIcon class="w-16 h-16" />
                        </div>
                        
                        <!-- Status Badge -->
                        <div class="absolute top-4 right-4">
                            <span class="px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider shadow-sm"
                                :class="{
                                    'bg-blue-500 text-white': kajian.status === 'akan_datang',
                                    'bg-emerald-500 text-white animate-pulse': kajian.status === 'berlangsung',
                                    'bg-slate-500 text-white': kajian.status === 'selesai'
                                }">
                                {{ kajian.status.replace('_', ' ') }}
                            </span>
                        </div>
                    </div>

                    <div class="p-6 flex-grow flex flex-col">
                        <div class="text-xs font-semibold text-emerald-600 mb-2 uppercase tracking-wider">{{ kajian.theme || 'Kajian Umum' }}</div>
                        <h3 class="text-xl font-bold text-slate-900 mb-4 line-clamp-2">
                            <Link :href="route('public.kajian.show', kajian.id)" class="hover:text-emerald-600 transition-colors">
                                {{ kajian.title }}
                            </Link>
                        </h3>

                        <div class="space-y-3 mt-auto pt-4 border-t border-slate-100 text-sm text-slate-600">
                            <div class="flex items-center gap-3">
                                <UserIcon class="w-5 h-5 text-slate-400" />
                                <span class="font-medium text-slate-800">{{ kajian.ustaz_name }}</span>
                            </div>
                            <div class="flex items-center gap-3">
                                <CalendarIcon class="w-5 h-5 text-slate-400" />
                                <span>{{ kajian.formatted_date }}</span>
                            </div>
                            <div class="flex items-center gap-3">
                                <ClockIcon class="w-5 h-5 text-slate-400" />
                                <span>{{ kajian.time.substring(0,5) }} WIB</span>
                            </div>
                            <div class="flex items-center gap-3">
                                <MapPinIcon class="w-5 h-5 text-slate-400" />
                                <span class="line-clamp-1">{{ kajian.location }}</span>
                            </div>
                        </div>

                        <Link :href="route('public.kajian.show', kajian.id)" class="mt-6 block w-full text-center px-4 py-2 bg-slate-50 hover:bg-emerald-50 text-emerald-700 font-medium rounded-lg transition-colors">
                            Lihat Detail
                        </Link>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div v-if="kajians.data.length === 0" class="text-center py-24 bg-white rounded-2xl border border-dashed border-slate-200">
                <CalendarIcon class="w-16 h-16 text-slate-300 mx-auto mb-4" />
                <h3 class="text-lg font-medium text-slate-900">Kajian tidak ditemukan</h3>
                <p class="text-slate-500 mt-1">Coba ubah kata kunci pencarian atau filter status.</p>
                <button @click="search=''; statusFilter='semua';" class="mt-4 text-emerald-600 font-medium hover:text-emerald-700">
                    Reset Pencarian
                </button>
            </div>

            <!-- Pagination -->
            <div v-if="kajians.links && kajians.links.length > 3" class="mt-12 flex justify-center">
                <div class="flex flex-wrap gap-1">
                    <template v-for="(link, k) in kajians.links" :key="k">
                        <div v-if="link.url === null" class="px-4 py-2 text-sm text-slate-400 border rounded-lg bg-white" v-html="link.label"></div>
                        <Link v-else :href="link.url" class="px-4 py-2 text-sm border rounded-lg bg-white hover:bg-slate-50 transition-colors" :class="{'bg-emerald-50 text-emerald-600 border-emerald-200 font-bold': link.active}" v-html="link.label"></Link>
                    </template>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>
