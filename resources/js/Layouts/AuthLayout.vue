<script setup>
import { Link, usePage } from '@inertiajs/vue3';
import ApplicationLogo from '@/Components/ApplicationLogo.vue';
import { ArrowLeftIcon } from '@heroicons/vue/24/outline';

const page = usePage();
</script>

<template>
    <div class="min-h-screen grid grid-cols-1 lg:grid-cols-2">
        <!-- Left Side: Decorative / Islamic Theme -->
        <div class="relative hidden lg:flex flex-col items-center justify-center p-10 bg-gradient-to-br from-teal-700 to-teal-900 overflow-hidden text-white">
            <!-- Background Patterns -->
            <div class="absolute inset-0 bg-pattern-islamic opacity-20 animate-scale-in"></div>
            <div class="absolute inset-0 bg-primary-600/70"></div>
            
            <!-- Content -->
            <div class="relative z-10 w-full max-w-md text-center space-y-6">
                <Link href="/">
                   <img 
                        v-if="page.props.settings?.logo_path" 
                        :src="page.props.settings.logo_path" 
                        alt="Logo" 
                        class="w-32 h-32 mx-auto object-contain drop-shadow-lg"
                   />
                   <ApplicationLogo v-else class="w-24 h-24 mx-auto fill-white drop-shadow-lg" />
                </Link>
                
                <div class="space-y-4 animate-slide-up">
                    <h2 class="text-4xl font-bold font-arabic tracking-wide">
                        {{ page.props.settings?.site_name || 'Start Your Journey' }}
                    </h2>
                    <p class="text-lg text-primary-50 font-light leading-relaxed">
                        "Sesungguhnya yang memakmurkan masjid-masjid Allah hanyalah orang-orang yang beriman kepada Allah dan hari kemudian..."
                        <br>
                        <span class="text-sm opacity-80 mt-2 block">(QS. At-Taubah: 18)</span>
                    </p>
                </div>
            </div>

            <!-- Footer Decorative -->
            <div class="absolute bottom-0 left-0 right-0 p-6 text-center text-xs text-primary-200 opacity-60">
                {{ page.props.settings?.copyright_text || 'MasjidVision Platform &copy; 2024' }}
            </div>
        </div>

        <!-- Right Side: Form / Content -->
        <div class="flex flex-col justify-center items-center p-6 bg-white dark:bg-gray-900 relative">
            <!-- Mobile Header (Visible only on small screens) -->
            <div class="lg:hidden absolute top-0 left-0 right-0 h-48 bg-gradient-to-br from-teal-700 to-teal-900">
                <div class="absolute inset-0 bg-pattern-islamic opacity-20"></div>
                 <div class="flex items-center justify-center h-full">
                    <Link href="/">
                        <img 
                            v-if="page.props.settings?.logo_path" 
                            :src="page.props.settings.logo_path" 
                            alt="Logo" 
                            class="w-20 h-20 object-contain drop-shadow-md"
                        />
                        <ApplicationLogo v-else class="w-16 h-16 fill-white drop-shadow-md" />
                    </Link>
                 </div>
            </div>

            <div class="w-full max-w-md lg:mt-0 mt-32 bg-white dark:bg-gray-800 p-8 rounded-2xl shadow-soft lg:shadow-none animate-fade-in z-10">
                <Link href="/" class="inline-flex items-center gap-2 text-sm font-bold text-slate-400 hover:text-primary-600 transition-colors mb-8 group">
                    <ArrowLeftIcon class="w-4 h-4 transition-transform group-hover:-translate-x-1" />
                    Kembali ke Beranda
                </Link>
                <slot />
            </div>

             <!-- Mobile Footer -->
             <div class="lg:hidden mt-8 text-center text-xs text-gray-400">
                MasjidVision Platform &copy; 2024
            </div>
        </div>
    </div>
</template>

<style scoped>
/* Ensure arabic font loads well */
.font-arabic {
    font-family: 'Amiri', 'Scheherazade New', serif;
}
</style>
