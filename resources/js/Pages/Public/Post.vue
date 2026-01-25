<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { CalendarIcon, UserIcon, ArrowLeftIcon, EnvelopeIcon, LinkIcon, CheckIcon } from '@heroicons/vue/24/outline';

const props = defineProps({
    post: Object,
});

const currentUrl = ref('');
const copied = ref(false);

onMounted(() => {
    currentUrl.value = window.location.href;
});

const copyLink = () => {
    navigator.clipboard.writeText(currentUrl.value).then(() => {
        copied.value = true;
        setTimeout(() => {
            copied.value = false;
        }, 2000);
    });
};
</script>

<template>
    <Head :title="post.title" />

    <PublicLayout>
        <div class="pt-24 pb-16 bg-slate-50 min-h-screen">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
                
                <!-- Breadcrumb / Back -->
                <div class="mb-8">
                    <Link href="/" class="inline-flex items-center text-slate-500 hover:text-emerald-600 transition-colors">
                        <ArrowLeftIcon class="w-4 h-4 mr-2" />
                        Kembali ke Beranda
                    </Link>
                </div>

                <!-- Article Content -->
                <article class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
                    <!-- Hero Image -->
                    <div class="h-64 md:h-96 w-full overflow-hidden bg-slate-200 relative">
                         <img 
                            v-if="post.image_url" 
                            :src="post.image_url" 
                            :alt="post.title" 
                            class="w-full h-full object-cover"
                        />
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                        <div class="absolute bottom-0 left-0 p-6 md:p-8 text-white">
                             <div class="flex items-center gap-4 text-sm md:text-base font-medium text-emerald-100 mb-3">
                                <span class="flex items-center gap-1.5">
                                    <CalendarIcon class="w-5 h-5" />
                                    {{ post.published_at }}
                                </span>
                                <span class="flex items-center gap-1.5">
                                    <UserIcon class="w-5 h-5" />
                                    {{ post.author_name }}
                                </span>
                            </div>
                            <h1 class="text-3xl md:text-5xl font-bold font-serif leading-tight text-shadow-lg">
                                {{ post.title }}
                            </h1>
                        </div>
                    </div>

                    <!-- Content Body -->
                    <div class="p-6 md:p-10">
                        <div class="prose prose-lg prose-emerald max-w-none text-slate-700 leading-relaxed whitespace-pre-line">
                            {{ post.content }}
                        </div>

                        <!-- Share / Footer -->
                        <div class="mt-12 pt-8 border-t border-slate-100 flex flex-col sm:flex-row justify-between items-center gap-4">
                            <span class="text-slate-400 text-sm font-medium">Bagikan kebaikan ini:</span>
                            <div class="flex gap-2">
                                <!-- Facebook -->
                                <a 
                                    :href="`https://www.facebook.com/sharer/sharer.php?u=${currentUrl}`" 
                                    target="_blank"
                                    class="p-2.5 rounded-full bg-[#1877F2]/10 text-[#1877F2] hover:bg-[#1877F2] hover:text-white transition-all duration-300"
                                    title="Share to Facebook"
                                >
                                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path fill-rule="evenodd" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" clip-rule="evenodd" /></svg>
                                </a>

                                <!-- WhatsApp -->
                                <a 
                                    :href="`https://wa.me/?text=${encodeURIComponent(post.title)}%20${currentUrl}`" 
                                    target="_blank"
                                    class="p-2.5 rounded-full bg-[#25D366]/10 text-[#25D366] hover:bg-[#25D366] hover:text-white transition-all duration-300"
                                    title="Share to WhatsApp"
                                >
                                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path fill-rule="evenodd" d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.468 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z" clip-rule="evenodd" /></svg>
                                </a>

                                <!-- Email -->
                                <a 
                                    :href="`mailto:?subject=${encodeURIComponent(post.title)}&body=Assalamu'alaikum,%0D%0ASilakan baca artikel ini: ${currentUrl}`"
                                    class="p-2.5 rounded-full bg-slate-100 text-slate-600 hover:bg-slate-200 hover:text-slate-900 transition-all duration-300"
                                    title="Share via Email"
                                >
                                    <EnvelopeIcon class="w-5 h-5" />
                                </a>

                                <!-- Copy Link -->
                                <button 
                                    @click="copyLink"
                                    class="p-2.5 rounded-full bg-slate-100 text-slate-600 hover:bg-slate-200 hover:text-slate-900 transition-all duration-300 relative group"
                                    title="Copy Link"
                                >
                                    <LinkIcon v-if="!copied" class="w-5 h-5" />
                                    <CheckIcon v-else class="w-5 h-5 text-emerald-600" />
                                    
                                    <!-- Tooltip -->
                                    <span v-if="copied" class="absolute -top-8 left-1/2 -translate-x-1/2 bg-slate-800 text-white text-xs px-2 py-1 rounded shadow-lg whitespace-nowrap">
                                        Tersalin!
                                    </span>
                                </button>
                            </div>
                        </div>
                    </div>
                </article>

            </div>
        </div>
    </PublicLayout>
</template>
