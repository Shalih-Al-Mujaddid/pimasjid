<script setup>
import { ref, onMounted } from 'vue';
import { Head, useForm } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { TabGroup, TabList, Tab, TabPanels, TabPanel } from '@headlessui/vue';
import { 
    CheckCircleIcon, 
    PhotoIcon, 
    MapPinIcon,
    AdjustmentsHorizontalIcon,
    HomeIcon,
    PhoneIcon,
    ShareIcon,
    InformationCircleIcon,
    DocumentTextIcon,
    HeartIcon,
    ViewColumnsIcon,
    ArrowPathIcon
} from '@heroicons/vue/24/outline';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

// Fix Leaflet marker icons
import markerIcon2x from 'leaflet/dist/images/marker-icon-2x.png';
import markerIcon from 'leaflet/dist/images/marker-icon.png';
import markerShadow from 'leaflet/dist/images/marker-shadow.png';

delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
    iconUrl: markerIcon,
    iconRetinaUrl: markerIcon2x,
    shadowUrl: markerShadow,
});

const props = defineProps({
    settings: Object
});

const groupItems = [
    { key: 'general', label: 'Umum', icon: AdjustmentsHorizontalIcon, desc: 'Logo, nama masjid, dan informasi dasar.' },
    { key: 'hero', label: 'Beranda (Hero)', icon: HomeIcon, desc: 'Pengaturan teks dan gambar latar utama.' },
    { key: 'contact', label: 'Kontak', icon: PhoneIcon, desc: 'Alamat, email, telepon, dan WhatsApp.' },
    { key: 'social', label: 'Media Sosial', icon: ShareIcon, desc: 'Tautan Facebook, Instagram, dan YouTube.' },
    { key: 'about', label: 'Tentang Kami', icon: InformationCircleIcon, desc: 'Visi, misi, dan sejarah singkat masjid.' },
    { key: 'report', label: 'Laporan', icon: DocumentTextIcon, desc: 'Nama penanda tangan untuk laporan keuangan.' },
    { key: 'location', label: 'Lokasi & Jadwal', icon: MapPinIcon, desc: 'Koordinat peta untuk akurasi jadwal shalat.' },
    { key: 'donation', label: 'Donasi & QRIS', icon: HeartIcon, desc: 'Informasi rekening dan gambar QRIS donasi.' },
    { key: 'footer', label: 'Footer', icon: ViewColumnsIcon, desc: 'Teks hak cipta dan deskripsi bagian bawah.' },
];

const form = useForm({
    settings: []
});

// Map instance
let map = null;
let marker = null;
const selectedTabIndex = ref(0);
const mapInitialized = ref(false);

// Helper to flatten settings for submission
const prepareForm = () => {
    let flatSettings = [];
    Object.values(props.settings).forEach(groupItems => {
        groupItems.forEach(item => {
            flatSettings.push({
                key: item.key,
                value: item.value,
                type: item.type,
                file: null // For image uploads
            });
        });
    });
    form.settings = flatSettings;
};

// Initialize form
prepareForm();

// Initialize map manually with button
const initializeMap = () => {
    if (map) {
        map.remove();
        map = null;
    }
    
    const mapContainer = document.getElementById('location-map');
    if (!mapContainer) return;

    try {
        const latSetting = form.settings.find(s => s.key === 'location_latitude');
        const lngSetting = form.settings.find(s => s.key === 'location_longitude');
        
        const lat = parseFloat(latSetting?.value || -6.200000);
        const lng = parseFloat(lngSetting?.value || 106.816666);
        
        map = L.map('location-map').setView([lat, lng], 13);
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);
        
        marker = L.marker([lat, lng], { draggable: true }).addTo(map);
        
        marker.on('dragend', function(e) {
            const position = marker.getLatLng();
            updateCoordinates(position.lat, position.lng);
        });
        
        map.on('click', function(e) {
            marker.setLatLng(e.latlng);
            updateCoordinates(e.latlng.lat, e.latlng.lng);
        });
        
        setTimeout(() => {
            if (map) map.invalidateSize();
        }, 100);
        
        mapInitialized.value = true;
    } catch (error) {
        console.error('Error initializing map:', error);
    }
};

const updateCoordinates = (lat, lng) => {
    const latSetting = form.settings.find(s => s.key === 'location_latitude');
    const lngSetting = form.settings.find(s => s.key === 'location_longitude');
    if (latSetting) latSetting.value = lat.toFixed(6);
    if (lngSetting) lngSetting.value = lng.toFixed(6);
};

const submit = () => {
    form.post(route('settings.update'), {
        preserveScroll: true,
    });
};

const handleImageUpload = (event, key) => {
    const file = event.target.files[0];
    if (file) {
        const index = form.settings.findIndex(s => s.key === key);
        if (index !== -1) {
            form.settings[index].file = file;
        }
    }
};

</script>

<template>
    <Head title="Pengaturan Web" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex justify-between items-center">
                <h2 class="font-black text-2xl text-slate-800 leading-tight">Pengaturan Web</h2>
                <button
                    @click="submit"
                    :disabled="form.processing"
                    class="hidden md:inline-flex items-center gap-2 px-6 py-2.5 bg-emerald-600 text-white font-bold rounded-xl shadow-lg shadow-emerald-200 hover:bg-emerald-700 active:scale-95 transition-all disabled:opacity-50"
                >
                    <ArrowPathIcon v-if="form.processing" class="w-5 h-5 animate-spin" />
                    <CheckCircleIcon v-else class="w-5 h-5" />
                    Simpan Semua
                </button>
            </div>
        </template>

        <div class="py-8">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                
                <TabGroup :vertical="true" as="div" class="flex flex-col md:flex-row gap-8" v-model="selectedTabIndex">
                    <!-- Vertical Tab List (Sidebar) -->
                    <div class="w-full md:w-80 flex-shrink-0">
                        <div class="bg-white rounded-3xl p-3 shadow-sm border border-slate-100 flex flex-col gap-1 sticky top-8">
                            <div class="px-4 py-3 mb-2">
                                <span class="text-xs font-black text-slate-400 uppercase tracking-widest">Kategori</span>
                            </div>
                            <TabList class="space-y-1">
                                <Tab
                                    v-for="group in groupItems"
                                    :key="group.key"
                                    as="template"
                                    v-slot="{ selected }"
                                >
                                    <button
                                        :class="[
                                            'w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-sm font-bold transition-all duration-200 text-left group',
                                            selected
                                                ? 'bg-emerald-600 text-white shadow-lg shadow-emerald-100'
                                                : 'text-slate-600 hover:bg-slate-50 hover:text-emerald-600',
                                        ]"
                                    >
                                        <component :is="group.icon" :class="['w-5 h-5', selected ? 'text-white' : 'text-slate-400 group-hover:text-emerald-500']" />
                                        {{ group.label }}
                                    </button>
                                </Tab>
                            </TabList>
                            
                            <!-- Mobile Save Button -->
                            <div class="mt-4 p-2 md:hidden">
                                <button
                                    @click="submit"
                                    :disabled="form.processing"
                                    class="w-full flex justify-center items-center gap-2 py-3 bg-emerald-600 text-white font-black rounded-2xl shadow-lg"
                                >
                                    Simpan Perubahan
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Main Panels (Content Area) -->
                    <div class="flex-1 min-w-0">
                        <TabPanels>
                            <TabPanel
                                v-for="group in groupItems"
                                :key="group.key"
                                class="focus:outline-none"
                            >
                                <div class="bg-white rounded-[2rem] shadow-xl shadow-slate-200/50 border border-slate-100 overflow-hidden">
                                    <!-- Header -->
                                    <div class="px-8 py-8 border-b border-slate-50 bg-gradient-to-r from-white to-slate-50/50">
                                        <div class="flex items-center gap-4 mb-2">
                                            <div class="p-3 bg-emerald-100 rounded-2xl text-emerald-600">
                                                <component :is="group.icon" class="w-8 h-8" />
                                            </div>
                                            <div>
                                                <h3 class="text-2xl font-black text-slate-800">{{ group.label }}</h3>
                                                <p class="text-slate-500 font-medium text-sm">{{ group.desc }}</p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Content -->
                                    <div class="px-8 py-8">
                                        <form @submit.prevent="submit" class="space-y-8">
                                            
                                            <!-- Special Section for Location -->
                                            <div v-if="group.key === 'location'" class="space-y-6">
                                                <div class="bg-blue-50/50 border border-blue-100 rounded-2xl p-6 flex gap-4">
                                                    <div class="text-blue-500 mt-1">
                                                        <MapPinIcon class="w-6 h-6" />
                                                    </div>
                                                    <div class="flex-1">
                                                        <p class="text-sm text-blue-800 leading-relaxed font-semibold">
                                                            <strong>Instruksi Lokasi:</strong> Tentukan posisi masjid Anda pada peta untuk mendapatkan data waktu shalat yang akurat sesuai koordinat yang tepat.
                                                        </p>
                                                        <button
                                                            type="button"
                                                            @click="initializeMap"
                                                            class="mt-4 inline-flex items-center gap-2 px-5 py-2.5 bg-blue-600 text-white font-bold rounded-xl shadow-md hover:bg-blue-700 transition-all active:scale-95"
                                                        >
                                                            {{ mapInitialized ? 'Muat Ulang Peta' : 'Aktifkan Peta Lokasi' }}
                                                        </button>
                                                    </div>
                                                </div>
                                                <div id="location-map" class="h-[400px] rounded-3xl border-2 border-slate-100 shadow-inner bg-slate-50 overflow-hidden transition-all duration-500"></div>
                                            </div>
                                            
                                            <!-- Dynamic Setting Fields -->
                                            <div v-if="settings[group.key]" class="grid grid-cols-1 gap-y-8">
                                                <div v-for="setting in settings[group.key]" :key="setting.id" class="group/field">
                                                    <div class="flex flex-col md:flex-row md:items-start gap-2 md:gap-8">
                                                        <div class="md:w-1/3 pt-2">
                                                            <label :for="setting.key" class="block text-sm font-black text-slate-700 mb-1 group-hover/field:text-emerald-600 transition-colors">
                                                                {{ setting.label || setting.key }}
                                                            </label>
                                                            <p v-if="setting.group === 'hero' && setting.key === 'hero_bg_image'" class="text-xs text-slate-400 leading-tight">
                                                                Gambar latar belakang utama di halaman depan.
                                                            </p>
                                                        </div>
                                                        
                                                        <div class="flex-1">
                                                            <!-- Text Input -->
                                                            <div v-if="setting.type === 'text'">
                                                                <input
                                                                    v-model="form.settings.find(s => s.key === setting.key).value"
                                                                    :id="setting.key"
                                                                    type="text"
                                                                    :readonly="group.key === 'location' && (setting.key === 'location_latitude' || setting.key === 'location_longitude')"
                                                                    class="block w-full rounded-2xl border-slate-200 py-3 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 sm:text-sm font-bold transition-all bg-slate-50/50 hover:bg-white"
                                                                    :placeholder="'Masukkan ' + (setting.label || setting.key)"
                                                                />
                                                            </div>

                                                            <!-- Text Area -->
                                                            <div v-else-if="setting.type === 'textarea'">
                                                                <textarea
                                                                    v-model="form.settings.find(s => s.key === setting.key).value"
                                                                    :id="setting.key"
                                                                    rows="4"
                                                                    class="block w-full rounded-2xl border-slate-200 py-3 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 sm:text-sm font-bold transition-all bg-slate-50/50 hover:bg-white"
                                                                    :placeholder="'Tulis ' + (setting.label || setting.key) + ' di sini...'"
                                                                />
                                                            </div>

                                                            <!-- Image Upload -->
                                                            <div v-else-if="setting.type === 'image'" class="flex flex-col sm:flex-row sm:items-center gap-6">
                                                                <div v-if="setting.value" class="h-24 w-40 flex-shrink-0 relative group/img rounded-2xl overflow-hidden border-2 border-slate-100 shadow-md">
                                                                     <img :src="setting.value" class="object-cover w-full h-full transition-transform duration-500 group-hover/img:scale-110" alt="Current Image" />
                                                                     <div class="absolute inset-0 bg-black/20 opacity-0 group-hover/img:opacity-100 transition-opacity flex items-center justify-center">
                                                                        <PhotoIcon class="w-8 h-8 text-white" />
                                                                     </div>
                                                                </div>
                                                                <div v-else class="h-24 w-40 flex-shrink-0 bg-slate-50 border-2 border-dashed border-slate-200 rounded-2xl flex items-center justify-center text-slate-300">
                                                                    <PhotoIcon class="w-10 h-10" />
                                                                </div>
                                                                
                                                                <label class="relative flex-1 group">
                                                                    <input
                                                                        type="file"
                                                                        @change="(e) => handleImageUpload(e, setting.key)"
                                                                        accept="image/*"
                                                                        class="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10"
                                                                    />
                                                                    <div class="flex items-center justify-center gap-2 py-4 px-6 border-2 border-dashed border-emerald-200 bg-emerald-50/30 rounded-2xl group-hover:bg-emerald-50 group-hover:border-emerald-400 transition-all">
                                                                        <PhotoIcon class="w-5 h-5 text-emerald-600" />
                                                                        <span class="text-sm font-black text-emerald-700">Pilih berkas baru</span>
                                                                    </div>
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Form Status -->
                                            <div v-if="form.recentlySuccessful" class="flex items-center justify-center p-4 bg-emerald-50 border border-emerald-100 rounded-2xl">
                                                <p class="text-sm font-black text-emerald-600 flex items-center gap-2">
                                                    <CheckCircleIcon class="h-5 w-5" />
                                                    Semua perubahan bagian ini berhasil disimpan!
                                                </p>
                                            </div>

                                            <div class="flex justify-end lg:hidden">
                                                <button
                                                    type="submit"
                                                    :disabled="form.processing"
                                                    class="w-full flex justify-center items-center gap-2 py-4 bg-emerald-600 text-white font-black rounded-2xl shadow-lg active:scale-95 transition-all disabled:opacity-50"
                                                >
                                                    <ArrowPathIcon v-if="form.processing" class="w-5 h-5 animate-spin" />
                                                    Simpan Bagian Ini
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </TabPanel>
                        </TabPanels>
                    </div>
                </TabGroup>

            </div>
        </div>
    </AuthenticatedLayout>
</template>

<style scoped>
.TabPanel-enter-active,
.TabPanel-leave-active {
  transition: all 0.3s ease-out;
}

.TabPanel-enter-from,
.TabPanel-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>

