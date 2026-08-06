<script setup>
import { Head, Link } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { 
    CalendarIcon, 
    MapPinIcon, 
    ClockIcon, 
    ArrowLeftIcon,
    PlayCircleIcon,
    UserCircleIcon,
    PhotoIcon
} from '@heroicons/vue/24/outline';

defineProps({
    kajian: Object
});
</script>

<template>
    <Head :title="kajian.title" />

    <PublicLayout>
        <!-- Banner Section -->
        <div class="relative w-full h-[400px] md:h-[500px] bg-slate-800 pt-16">
            <img v-if="kajian.banner" :src="kajian.banner" :alt="kajian.title" class="w-full h-full object-cover opacity-60">
            <div v-else class="w-full h-full flex items-center justify-center bg-slate-800 opacity-60">
                <PhotoIcon class="w-32 h-32 text-slate-600" />
            </div>
            
            <div class="absolute inset-0 bg-gradient-to-t from-slate-900 via-transparent to-transparent"></div>
            
            <div class="absolute bottom-0 left-0 w-full p-6 md:p-12 max-w-7xl mx-auto">
                <Link :href="route('public.kajian.index')" class="inline-flex items-center gap-2 text-emerald-400 hover:text-emerald-300 font-medium mb-4 transition-colors">
                    <ArrowLeftIcon class="w-4 h-4" />
                    Kembali ke Daftar Kajian
                </Link>
                
                <div class="flex items-center gap-3 mb-4">
                    <span class="px-3 py-1 bg-emerald-600 text-white rounded-full text-xs font-bold uppercase tracking-wider">
                        {{ kajian.theme || 'Kajian Umum' }}
                    </span>
                    <span class="px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider"
                        :class="{
                            'bg-blue-500 text-white': kajian.status === 'akan_datang',
                            'bg-emerald-500 text-white animate-pulse': kajian.status === 'berlangsung',
                            'bg-slate-500 text-white': kajian.status === 'selesai'
                        }">
                        {{ kajian.status.replace('_', ' ') }}
                    </span>
                </div>
                
                <h1 class="text-3xl md:text-5xl font-bold text-white mb-4 leading-tight">{{ kajian.title }}</h1>
            </div>
        </div>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
                <!-- Main Content -->
                <div class="lg:col-span-2 space-y-10">
                    
                    <!-- Quick Info Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="bg-white p-4 rounded-xl border border-slate-100 shadow-sm flex items-center gap-4">
                            <div class="w-12 h-12 bg-emerald-50 rounded-full flex items-center justify-center text-emerald-600 flex-shrink-0">
                                <CalendarIcon class="w-6 h-6" />
                            </div>
                            <div>
                                <div class="text-xs text-slate-500 font-medium uppercase tracking-wider mb-1">Tanggal</div>
                                <div class="font-semibold text-slate-800">{{ kajian.formatted_date }}</div>
                            </div>
                        </div>
                        <div class="bg-white p-4 rounded-xl border border-slate-100 shadow-sm flex items-center gap-4">
                            <div class="w-12 h-12 bg-emerald-50 rounded-full flex items-center justify-center text-emerald-600 flex-shrink-0">
                                <ClockIcon class="w-6 h-6" />
                            </div>
                            <div>
                                <div class="text-xs text-slate-500 font-medium uppercase tracking-wider mb-1">Waktu</div>
                                <div class="font-semibold text-slate-800">{{ kajian.time.substring(0,5) }} WIB</div>
                            </div>
                        </div>
                        <div class="bg-white p-4 rounded-xl border border-slate-100 shadow-sm flex items-center gap-4">
                            <div class="w-12 h-12 bg-emerald-50 rounded-full flex items-center justify-center text-emerald-600 flex-shrink-0">
                                <MapPinIcon class="w-6 h-6" />
                            </div>
                            <div>
                                <div class="text-xs text-slate-500 font-medium uppercase tracking-wider mb-1">Lokasi</div>
                                <div class="font-semibold text-slate-800 line-clamp-2">{{ kajian.location }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="bg-white rounded-2xl p-6 md:p-8 shadow-sm border border-slate-100">
                        <h2 class="text-2xl font-bold text-slate-900 mb-6 border-b pb-4">Deskripsi Kajian</h2>
                        <div v-if="kajian.description" class="prose max-w-none text-slate-600 leading-relaxed whitespace-pre-wrap">
                            {{ kajian.description }}
                        </div>
                        <div v-else class="text-slate-500 italic">
                            Belum ada deskripsi untuk kajian ini.
                        </div>
                    </div>
                    
                    <!-- Live Stream / Rekaman -->
                    <div class="bg-white rounded-2xl p-6 md:p-8 shadow-sm border border-slate-100">
                        <h2 class="text-2xl font-bold text-slate-900 mb-6 border-b pb-4">Streaming & Rekaman</h2>
                        <div v-if="kajian.video_url" class="flex flex-col items-center justify-center py-8 text-center">
                            <div class="w-20 h-20 bg-red-50 text-red-600 rounded-full flex items-center justify-center mb-6">
                                <PlayCircleIcon class="w-12 h-12" />
                            </div>
                            <h3 class="text-xl font-bold text-slate-800 mb-2">Saksikan di YouTube</h3>
                            <p class="text-slate-600 mb-8 max-w-md">Kajian ini disiarkan secara langsung atau telah direkam dan dapat Anda saksikan melalui kanal YouTube kami.</p>
                            <a :href="kajian.video_url" target="_blank" class="px-8 py-3 bg-red-600 hover:bg-red-700 text-white font-semibold rounded-full shadow-md hover:shadow-lg transition-all flex items-center gap-2">
                                <PlayCircleIcon class="w-5 h-5" />
                                {{ kajian.status === 'akan_datang' ? 'Menunggu Live' : (kajian.status === 'berlangsung' ? 'Tonton Live Sekarang' : 'Tonton Rekaman') }}
                            </a>
                        </div>
                        <div v-else class="text-center py-8">
                            <div class="w-16 h-16 bg-slate-50 text-slate-300 rounded-full flex items-center justify-center mx-auto mb-4">
                                <PlayCircleIcon class="w-8 h-8" />
                            </div>
                            <p class="text-slate-500 font-medium">Live streaming atau rekaman belum tersedia untuk kajian ini.</p>
                        </div>
                    </div>

                </div>

                <!-- Sidebar -->
                <div class="lg:col-span-1 space-y-8">
                    <!-- Ustaz Profile Card -->
                    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden sticky top-24">
                        <div class="h-24 bg-emerald-600"></div>
                        <div class="px-6 pb-6 relative">
                            <!-- Avatar -->
                            <div class="w-24 h-24 rounded-full border-4 border-white overflow-hidden bg-white mx-auto -mt-12 mb-4 shadow-sm">
                                <img v-if="kajian.ustaz_photo" :src="kajian.ustaz_photo" :alt="kajian.ustaz_name" class="w-full h-full object-cover">
                                <div v-else class="w-full h-full flex items-center justify-center bg-slate-100 text-slate-400">
                                    <UserCircleIcon class="w-16 h-16" />
                                </div>
                            </div>
                            
                            <!-- Info -->
                            <div class="text-center">
                                <h3 class="text-xl font-bold text-slate-900 mb-1">{{ kajian.ustaz_name }}</h3>
                                <p v-if="kajian.ustaz_topic" class="text-emerald-600 font-medium text-sm mb-4">{{ kajian.ustaz_topic }}</p>
                                
                                <div v-if="kajian.ustaz_bio" class="text-slate-600 text-sm leading-relaxed whitespace-pre-wrap text-left bg-slate-50 p-4 rounded-xl border border-slate-100 mt-6">
                                    {{ kajian.ustaz_bio }}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>
