<script setup>
import { Head } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';

const props = defineProps({
    agendas: Array
});
</script>

<template>
    <Head title="Agenda Kegiatan" />

    <PublicLayout>
        <div class="bg-emerald-700 pt-32 pb-16 text-center text-white">
            <h1 class="text-4xl font-bold mb-4">Agenda Kegiatan</h1>
            <p class="text-emerald-100">Ikuti kegiatan bermanfaat di {{ $page.props.settings?.site_name || 'Masjid' }}</p>
        </div>

        <div class="max-w-5xl mx-auto px-4 py-12">
            <div class="grid gap-6">
                <!-- Empty State -->
                <div v-if="agendas.length === 0" class="text-center py-12 bg-white rounded-xl shadow-sm border border-slate-100">
                    <p class="text-slate-500">Belum ada agenda kegiatan mendatang.</p>
                </div>

                <div v-for="(agenda, index) in agendas" :key="index" class="bg-white rounded-xl shadow-md p-6 border-l-4 border-emerald-500 flex flex-col md:flex-row gap-6 hover:shadow-lg transition-shadow">
                    <!-- Date Box -->
                    <div class="flex-shrink-0 w-full md:w-32 bg-slate-100 rounded-lg flex flex-col items-center justify-center p-4 text-center">
                        <span class="text-2xl">📅</span>
                        <span class="text-sm font-bold text-slate-700 mt-2">{{ agenda.date }}</span>
                        <span class="text-xs text-slate-500">{{ agenda.time }}</span>
                    </div>
                    
                    <!-- Content -->
                    <div class="flex-grow">
                        <h3 class="text-xl font-bold text-slate-800 mb-2">{{ agenda.title }}</h3>
                        <p class="text-slate-600 mb-3 whitespace-pre-line">{{ agenda.description }}</p>
                        
                        <div class="flex items-center gap-2 text-sm text-emerald-700 font-medium bg-emerald-50 inline-block px-3 py-1 rounded-full">
                            <span>📍</span>
                            <span>{{ agenda.location }}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>
