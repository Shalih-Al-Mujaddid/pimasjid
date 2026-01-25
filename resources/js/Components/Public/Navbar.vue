<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { Link } from '@inertiajs/vue3';
import { Menu, MenuButton, MenuItems, MenuItem, Dialog, DialogPanel, TransitionChild, TransitionRoot } from '@headlessui/vue';

// No props needed for modal anymore as it's internal
const props = defineProps(['activePage']);

const isScrolled = ref(false);
const isMobileMenuOpen = ref(false);
const showDonationModal = ref(false);

const handleScroll = () => {
    isScrolled.value = window.scrollY > 50;
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});

const navigationItems = [
    { name: 'Beranda', href: '/', type: 'link' },
    {
        name: 'Profil',
        type: 'dropdown',
        items: [
            { name: 'Tentang Kami', href: '/profil/tentang' },
            { name: 'Struktur Pengurus', href: '/profil/struktur' },
        ],
    },
    {
        name: 'Transparansi',
        type: 'dropdown',
        items: [
            { name: 'Laporan Keuangan', href: '/transparansi/keuangan' },
            { name: 'Daftar Aset & Wakaf', href: '/transparansi/aset' },
        ],
    },
    {
        name: 'Layanan',
        type: 'dropdown',
        items: [
            { name: 'Galeri Kegiatan', href: '/galeri' },
            { name: 'Jadwal Sholat', href: '/ibadah/jadwal' },
            { name: 'Agenda', href: '/ibadah/agenda' },
            { name: 'Petugas Jumat', href: '/ibadah/jumat' },
            { name: '🕌 Info Zakat', href: '/info/zakat' },
            { name: '🐑 Daftar Qurban', href: '/info/qurban' },
        ],
    },
];

// Expose open modal function for parent components if needed (optional)
defineExpose({ openDonationModal: () => showDonationModal.value = true });
</script>

<template>
    <!-- Desktop & Mobile Navbar -->
    <nav
        :class="[
            'fixed top-0 left-0 right-0 z-50 transition-all duration-300',
            isScrolled ? 'bg-white shadow-lg' : 'bg-white/95 backdrop-blur-md',
        ]"
    >
        <div class="max-w-7xl mx-auto px-4">
            <div class="flex justify-between items-center h-16">
                <!-- Logo -->
                <Link href="/" class="flex items-center gap-2 font-bold text-emerald-700 hover:text-emerald-800 transition-colors">
                    <img 
                        v-if="$page.props.settings?.logo_path" 
                        :src="$page.props.settings.logo_path" 
                        alt="Logo" 
                        class="h-8 w-auto"
                    />
                    <span v-else class="text-2xl">🕌</span>
                    <span class="hidden sm:block">{{ $page.props.settings?.site_name || 'MasjidVision' }}</span>
                </Link>

                <!-- Desktop Menu -->
                <div class="hidden md:flex items-center gap-1">
                    <template v-for="item in navigationItems" :key="item.name">
                        <!-- Simple Link -->
                        <Link
                            v-if="item.type === 'link'"
                            :href="item.href"
                            class="px-4 py-2 rounded-lg text-slate-700 hover:text-emerald-600 hover:bg-emerald-50 transition-colors font-medium"
                        >
                            {{ item.name }}
                        </Link>

                        <!-- Dropdown Menu -->
                        <Menu v-else as="div" class="relative">
                            <MenuButton class="px-4 py-2 rounded-lg text-slate-700 hover:text-emerald-600 hover:bg-emerald-50 transition-colors font-medium flex items-center gap-1">
                                {{ item.name }}
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                </svg>
                            </MenuButton>
                            <MenuItems class="absolute left-0 mt-2 w-56 origin-top-left rounded-xl bg-white shadow-xl ring-1 ring-black ring-opacity-5 focus:outline-none py-2">
                                <MenuItem v-for="subItem in item.items" :key="subItem.name" v-slot="{ active }">
                                    <Link
                                        :href="subItem.href.startsWith('#') && $page.url !== '/' ? '/' + subItem.href : subItem.href"
                                        :class="[
                                            active ? 'bg-emerald-50 text-emerald-700' : 'text-slate-700',
                                            'block px-4 py-2 text-sm font-medium',
                                        ]"
                                    >
                                        {{ subItem.name }}
                                    </Link>
                                </MenuItem>
                            </MenuItems>
                        </Menu>
                    </template>

                    <!-- Donasi Button -->
                    <button
                        @click="showDonationModal = true"
                        class="ml-2 bg-gradient-to-r from-amber-500 to-amber-600 hover:from-amber-600 hover:to-amber-700 text-white px-6 py-2 rounded-full font-bold shadow-md hover:shadow-lg transition-all"
                    >
                        💰 Donasi
                    </button>

                    <!-- Admin Login -->
                    <Link href="/login" class="ml-2 p-2 text-slate-600 hover:text-emerald-600 transition-colors">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
                        </svg>
                    </Link>
                </div>

                <!-- Mobile Hamburger -->
                <button
                    @click="isMobileMenuOpen = !isMobileMenuOpen"
                    class="md:hidden p-2 text-slate-700 hover:text-emerald-600"
                >
                    <svg v-if="!isMobileMenuOpen" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
                    <svg v-else class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <!-- Mobile Menu -->
            <div
                v-if="isMobileMenuOpen"
                class="md:hidden border-t border-slate-200 py-4 space-y-2 bg-white rounded-b-xl shadow-lg absolute left-0 right-0 px-4"
            >
                <template v-for="item in navigationItems" :key="item.name">
                    <Link
                        v-if="item.type === 'link'"
                        :href="item.href"
                        class="block px-4 py-2 text-slate-700 hover:bg-emerald-50 hover:text-emerald-600 rounded-lg font-medium"
                        @click="isMobileMenuOpen = false"
                    >
                        {{ item.name }}
                    </Link>
                    
                    <div v-else class="space-y-1">
                        <div class="px-4 py-2 text-slate-800 font-bold text-sm">{{ item.name }}</div>
                        <Link
                            v-for="subItem in item.items"
                            :key="subItem.name"
                            :href="subItem.href.startsWith('#') && $page.url !== '/' ? '/' + subItem.href : subItem.href"
                            class="block pl-8 pr-4 py-2 text-sm text-slate-600 hover:bg-emerald-50 hover:text-emerald-600 rounded-lg"
                            @click="isMobileMenuOpen = false"
                        >
                            {{ subItem.name }}
                        </Link>
                    </div>
                </template>
                
                <button
                    @click="showDonationModal = true; isMobileMenuOpen = false"
                    class="w-full bg-gradient-to-r from-amber-500 to-amber-600 text-white px-4 py-3 rounded-lg font-bold mt-4"
                >
                    💰 Donasi Sekarang
                </button>
            </div>
        </div>
    </nav>

    <!-- Donation Modal (Self-Contained) -->
    <TransitionRoot as="template" :show="showDonationModal">
        <Dialog as="div" class="relative z-[60]" @close="showDonationModal = false">
            <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0" enter-to="opacity-100" leave="ease-in duration-200" leave-from="opacity-100" leave-to="opacity-0">
                <div class="fixed inset-0 bg-slate-900/75 transition-opacity" />
            </TransitionChild>

            <div class="fixed inset-0 z-10 overflow-y-auto">
                <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
                    <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95" enter-to="opacity-100 translate-y-0 sm:scale-100" leave="ease-in duration-200" leave-from="opacity-100 translate-y-0 sm:scale-100" leave-to="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95">
                        <DialogPanel class="relative transform overflow-hidden rounded-2xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
                            <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                                <div class="sm:flex sm:items-start">
                                    <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-emerald-100 sm:mx-0 sm:h-10 sm:w-10">
                                        <span class="text-2xl">💰</span>
                                    </div>
                                    <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                                        <h3 class="text-lg font-semibold leading-6 text-slate-900" id="modal-title">Infaq & Shodaqoh</h3>
                                        <div class="mt-2">
                                            <p class="text-sm text-slate-500 mb-4">
                                                Salurkan donasi terbaik Anda untuk kemakmuran masjid melalui scan QRIS berikut:
                                            </p>
                                            <div class="bg-slate-100 p-4 rounded-xl flex items-center justify-center border-2 border-dashed border-slate-300">
                                                <!-- QR Code -->
                                                <div class="text-center w-full">
                                                    <img 
                                                        v-if="$page.props.settings?.donation_qris_image"
                                                        :src="$page.props.settings.donation_qris_image" 
                                                        alt="QRIS Masjid" 
                                                        class="mx-auto w-48 h-auto object-contain mb-3 rounded-lg shadow-sm" 
                                                    />
                                                    <img 
                                                        v-else
                                                        src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=example-donation-link" 
                                                        alt="QRIS Placeholder" 
                                                        class="mx-auto mix-blend-multiply w-48 h-48 opacity-50" 
                                                    />
                                                    
                                                    <p class="text-xs font-bold text-slate-500 mt-2 whitespace-pre-line leading-relaxed">
                                                        {{ $page.props.settings?.donation_bank_info || 'Bank Syariah Indonesia (BSI)\nNo. Rek: -\nA.n Masjid Al-Hidayah' }}
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-slate-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                                <button type="button" class="mt-3 inline-flex w-full justify-center rounded-md bg-emerald-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-emerald-500 sm:mt-0 sm:w-auto" @click="showDonationModal = false">Tutup</button>
                            </div>
                        </DialogPanel>
                    </TransitionChild>
                </div>
            </div>
        </Dialog>
    </TransitionRoot>
</template>
