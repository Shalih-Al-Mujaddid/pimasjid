<script setup>
import { ref, computed } from 'vue';
import { Link } from '@inertiajs/vue3';
import { 
    HomeIcon, 
    ClockIcon, 
    QrCodeIcon, 
    CalendarIcon, 
    Bars3Icon 
} from '@heroicons/vue/24/outline';

const emit = defineEmits(['openDonation', 'openMenu']);

const activeTab = ref('beranda');

const scrollToSection = (sectionId) => {
    const element = document.getElementById(sectionId);
    if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
        activeTab.value = sectionId;
    }
};

const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
    activeTab.value = 'beranda';
};

const handleDonation = () => {
    emit('openDonation');
};

const handleMenu = () => {
    emit('openMenu');
};
</script>

<template>
    <!-- Mobile Bottom Navigation - Only visible on mobile/tablet -->
    <nav class="lg:hidden fixed bottom-4 left-4 right-4 z-40">
        <div class="bg-white/90 backdrop-blur-md rounded-2xl shadow-2xl border border-emerald-100 px-4 py-3">
            <div class="flex items-center justify-around relative">
                
                <!-- Beranda -->
                <button 
                    @click="scrollToTop"
                    :class="[
                        'flex flex-col items-center gap-1 transition-all duration-300 flex-1',
                        activeTab === 'beranda' ? 'text-emerald-600' : 'text-slate-500'
                    ]"
                >
                    <HomeIcon class="w-6 h-6" />
                    <span class="text-[10px] font-semibold">Beranda</span>
                </button>

                <!-- Jadwal -->
                <button 
                    @click="scrollToSection('prayer-times')"
                    :class="[
                        'flex flex-col items-center gap-1 transition-all duration-300 flex-1',
                        activeTab === 'prayer-times' ? 'text-emerald-600' : 'text-slate-500'
                    ]"
                >
                    <ClockIcon class="w-6 h-6" />
                    <span class="text-[10px] font-semibold">Jadwal</span>
                </button>

                <!-- Center Donasi Button (Larger, Floating) -->
                <div class="flex-1 flex justify-center">
                    <button 
                        @click="handleDonation"
                        class="relative -mt-8 bg-gradient-to-br from-amber-400 to-amber-600 text-white rounded-full p-4 shadow-2xl hover:shadow-amber-500/50 hover:scale-110 transition-all duration-300 animate-pulse-slow"
                    >
                        <QrCodeIcon class="w-7 h-7" />
                        <div class="absolute -bottom-6 left-1/2 -translate-x-1/2 whitespace-nowrap">
                            <span class="text-[10px] font-bold text-amber-600">DONASI</span>
                        </div>
                    </button>
                </div>

                <!-- Agenda -->
                <Link 
                    href="/ibadah/agenda"
                    :class="[
                        'flex flex-col items-center gap-1 transition-all duration-300 flex-1',
                        $page.url === '/ibadah/agenda' ? 'text-emerald-600' : 'text-slate-500'
                    ]"
                >
                    <CalendarIcon class="w-6 h-6" />
                    <span class="text-[10px] font-semibold">Agenda</span>
                </Link>

                <!-- Menu -->
                <button 
                    @click="handleMenu"
                    class="flex flex-col items-center gap-1 text-slate-500 hover:text-emerald-600 transition-all duration-300 flex-1"
                >
                    <Bars3Icon class="w-6 h-6" />
                    <span class="text-[10px] font-semibold">Menu</span>
                </button>

            </div>
        </div>
    </nav>
</template>

<style scoped>
@keyframes pulse-slow {
    0%, 100% {
        opacity: 1;
    }
    50% {
        opacity: 0.8;
    }
}

.animate-pulse-slow {
    animation: pulse-slow 3s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>
