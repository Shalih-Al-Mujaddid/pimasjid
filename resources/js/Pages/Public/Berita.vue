<script setup>
import { Head, Link } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { CalendarIcon, UserIcon, ArrowRightIcon } from '@heroicons/vue/24/outline';

defineProps({
    posts: Object, // Paginator object
});
</script>

<template>
    <Head title="Berita & Kegiatan" />

    <PublicLayout :transparent-nav="false">
        <div class="pt-32 pb-16 bg-slate-50 min-h-screen">
             <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                
                <div class="text-center mb-12">
                    <h1 class="text-3xl md:text-5xl font-bold text-slate-900 mb-4 font-serif">Arsip Berita & Kegiatan</h1>
                    <p class="text-lg text-slate-600 max-w-2xl mx-auto">
                        Informasi terbaru seputar kegiatan dan agenda Masjid Al-Hidayah.
                    </p>
                </div>

                <div v-if="posts.data.length > 0">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                         <Link v-for="post in posts.data" :key="post.id" :href="route('public.post', post.slug)" class="group bg-white rounded-2xl shadow-sm hover:shadow-xl transition-all duration-300 border border-slate-200 overflow-hidden flex flex-col h-full hover:-translate-y-1">
                            <!-- Image -->
                            <div class="relative h-56 overflow-hidden bg-slate-200">
                                <img :src="post.image_url" :alt="post.title" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
                                <div class="absolute top-4 left-4 bg-emerald-600 text-white text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wider">
                                    Berita
                                </div>
                            </div>
                            
                            <!-- Content -->
                            <div class="p-6 flex flex-col flex-grow">
                                <div class="flex items-center gap-4 text-xs text-slate-500 mb-4">
                                    <span class="flex items-center gap-1">
                                        <CalendarIcon class="w-4 h-4" />
                                        {{ post.published_at }}
                                    </span>
                                    <span class="flex items-center gap-1">
                                        <UserIcon class="w-4 h-4" />
                                        {{ post.author_name }}
                                    </span>
                                </div>
                                
                                <h3 class="text-xl font-bold text-slate-900 mb-3 group-hover:text-emerald-600 transition-colors line-clamp-2">
                                    {{ post.title }}
                                </h3>
                                
                                <p class="text-slate-600 text-sm mb-6 line-clamp-3">
                                    {{ post.excerpt }}
                                </p>
                                
                                <div class="mt-auto">
                                    <span class="inline-flex items-center text-emerald-600 font-bold text-sm group-hover:gap-2 transition-all">
                                        Baca Selengkapnya
                                        <ArrowRightIcon class="w-4 h-4 ml-1" />
                                    </span>
                                </div>
                            </div>
                        </Link>
                    </div>

                    <!-- Pagination -->
                    <div class="mt-12 flex justify-center gap-2">
                        <Link 
                            v-for="(link, key) in posts.links" 
                            :key="key"
                            :href="link.url"
                            v-html="link.label"
                            :class="[
                                'px-4 py-2 rounded-lg text-sm font-medium transition-colors',
                                link.active ? 'bg-emerald-600 text-white' : 'bg-white text-slate-700 hover:bg-slate-100 hover:text-emerald-600',
                                !link.url && 'opacity-50 cursor-not-allowed hidden'
                            ]"
                        />
                    </div>
                </div>

                <div v-else class="text-center py-20 bg-white rounded-2xl border border-dashed border-slate-300">
                    <p class="text-slate-500 text-lg">Belum ada berita yang diterbitkan.</p>
                </div>

             </div>
        </div>
    </PublicLayout>
</template>
