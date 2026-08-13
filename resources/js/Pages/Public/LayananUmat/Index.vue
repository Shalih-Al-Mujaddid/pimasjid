<script setup>
import { ref, computed } from 'vue';
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { 
    HeartIcon, 
    TruckIcon, 
    UserGroupIcon, 
    AcademicCapIcon, 
    SparklesIcon, 
    GiftIcon, 
    CakeIcon, 
    BookOpenIcon, 
    BuildingLibraryIcon,
    MagnifyingGlassIcon,
    PaperClipIcon,
    CheckCircleIcon,
    ClockIcon,
    XCircleIcon,
    XMarkIcon,
    ShieldCheckIcon
} from '@heroicons/vue/24/outline';
import axios from 'axios';

const props = defineProps({
    services: Array,
    categories: Array,
    filters: Object,
});

const page = usePage();
const activeCategory = ref(props.filters.category || 'semua');
const searchQuery = ref(props.filters.search || '');

// Tracking modal states
const showTrackingModal = ref(false);
const trackingInput = ref('');
const isTrackingLoading = ref(false);
const trackingResults = ref(null);
const trackingError = ref('');

// Application modal states
const showApplyModal = ref(false);
const selectedService = ref(null);
const fileInput = ref(null);
const documentPreview = ref(null);

const form = useForm({
    service_id: null,
    service_name: '',
    applicant_name: '',
    nik: '',
    phone: '',
    address: '',
    notes: '',
    document: null,
});

const filteredServices = computed(() => {
    return props.services.filter(service => {
        const matchesCategory = activeCategory.value === 'semua' || service.category === activeCategory.value;
        const matchesSearch = !searchQuery.value || 
            service.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
            (service.short_description && service.short_description.toLowerCase().includes(searchQuery.value.toLowerCase()));
        return matchesCategory && matchesSearch;
    });
});

const getCategoryIcon = (iconName) => {
    switch (iconName) {
        case 'HeartIcon': return HeartIcon;
        case 'TruckIcon': return TruckIcon;
        case 'UserGroupIcon': return UserGroupIcon;
        case 'AcademicCapIcon': return AcademicCapIcon;
        case 'SparklesIcon': return SparklesIcon;
        case 'GiftIcon': return GiftIcon;
        case 'CakeIcon': return CakeIcon;
        case 'BookOpenIcon': return BookOpenIcon;
        default: return BuildingLibraryIcon;
    }
};

const openApplyModal = (service) => {
    selectedService.value = service;
    form.service_id = service.id;
    form.service_name = service.title;
    form.applicant_name = '';
    form.nik = '';
    form.phone = '';
    form.address = '';
    form.notes = '';
    form.document = null;
    documentPreview.value = null;
    showApplyModal.value = true;
};

const handleFileUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
        form.document = file;
        documentPreview.value = file.name;
    }
};

const submitApplication = () => {
    form.post(route('public.layanan_umat.submit', { service: selectedService.value.slug }), {
        preserveScroll: true,
        onSuccess: () => {
            showApplyModal.value = false;
        },
    });
};

const performTracking = async () => {
    if (!trackingInput.value.trim()) return;
    
    isTrackingLoading.value = true;
    trackingError.value = '';
    trackingResults.value = null;

    try {
        const res = await axios.get(route('public.layanan_umat.track'), {
            params: { q: trackingInput.value.trim() }
        });
        if (res.data.success) {
            trackingResults.value = res.data.applications;
        }
    } catch (err) {
        trackingError.value = err.response?.data?.message || 'Data pengajuan belum ditemukan di PIMASJID.';
    } finally {
        isTrackingLoading.value = false;
    }
};

const getStatusBadge = (status) => {
    switch (status) {
        case 'approved':
            return { class: 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-300', label: 'Disetujui', icon: CheckCircleIcon };
        case 'rejected':
            return { class: 'bg-rose-100 text-rose-800 dark:bg-rose-900/30 dark:text-rose-300', label: 'Ditolak', icon: XCircleIcon };
        case 'completed':
            return { class: 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-300', label: 'Selesai', icon: CheckCircleIcon };
        default:
            return { class: 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-300', label: 'Menunggu Verifikasi', icon: ClockIcon };
    }
};
</script>

<template>
    <Head title="Layanan Umat - PIMASJID" />

    <PublicLayout>
        <!-- Hero Header -->
        <div class="bg-gradient-to-br from-emerald-800 via-teal-900 to-slate-900 text-white pt-32 pb-20 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
            <div class="absolute inset-0 bg-[radial-gradient(#34d399_1px,transparent_1px)] [background-size:16px_16px] opacity-10"></div>
            <div class="max-w-7xl mx-auto relative z-10 text-center">
                <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/20 text-emerald-300 text-xs font-semibold uppercase tracking-wider mb-4 border border-emerald-500/30">
                    <ShieldCheckIcon class="w-4 h-4" /> Pusat Pelayanan Sosial Masjid
                </div>
                <h1 class="text-3xl md:text-5xl font-black tracking-tight mb-4">
                    🤝 Layanan & Pelayanan Umat
                </h1>
                <p class="text-emerald-100/90 text-base md:text-lg max-w-3xl mx-auto leading-relaxed mb-8">
                    Portal terpadu pengajuan bantuan sosial, layanan ambulans 24 jam, pengurusan jenazah, beasiswa santri, serta integrasi layanan Zakat, Qurban, dan TPA.
                </p>

                <!-- Action Bar: Search & Track Button -->
                <div class="max-w-2xl mx-auto flex flex-col sm:flex-row items-center gap-3">
                    <div class="relative flex-1 w-full">
                        <MagnifyingGlassIcon class="w-5 h-5 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                        <input 
                            v-model="searchQuery"
                            type="text" 
                            placeholder="Cari layanan (ambulans, santunan, jenazah, beasiswa)..."
                            class="w-full pl-10 pr-4 py-3.5 rounded-xl bg-white/10 backdrop-blur-md border border-white/20 text-white placeholder-slate-300 focus:outline-none focus:ring-2 focus:ring-emerald-400 text-sm"
                        />
                    </div>
                    <button 
                        @click="showTrackingModal = true"
                        class="w-full sm:w-auto px-6 py-3.5 bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-bold rounded-xl shadow-lg transition-all flex items-center justify-center gap-2 text-sm whitespace-nowrap"
                    >
                        <ClockIcon class="w-5 h-5" /> Cek Status Resi
                    </button>
                </div>
            </div>
        </div>

        <!-- Success Flash Alert -->
        <div v-if="page.props.flash?.message" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-6">
            <div class="p-4 bg-emerald-50 border-l-4 border-emerald-500 rounded-r-xl dark:bg-emerald-950/40 dark:border-emerald-400 flex items-start gap-3 shadow-md">
                <CheckCircleIcon class="w-6 h-6 text-emerald-600 dark:text-emerald-400 shrink-0 mt-0.5" />
                <div>
                    <h4 class="font-bold text-emerald-900 dark:text-emerald-200 text-sm">Pengajuan Berhasil Dikirim!</h4>
                    <p class="text-sm text-emerald-700 dark:text-emerald-300 mt-1">{{ page.props.flash.message }}</p>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            
            <!-- Category Filter Tabs -->
            <div class="flex items-center gap-2 overflow-x-auto pb-4 mb-8 custom-scrollbar">
                <button
                    v-for="cat in categories"
                    :key="cat.key"
                    @click="activeCategory = cat.key"
                    :class="[
                        'px-4 py-2.5 rounded-xl font-semibold text-xs transition-all whitespace-nowrap flex items-center gap-2',
                        activeCategory === cat.key
                            ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/30'
                            : 'bg-white dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 border border-slate-200 dark:border-slate-700'
                    ]"
                >
                    <component :is="getCategoryIcon(cat.icon)" class="w-4 h-4" />
                    {{ cat.label }}
                </button>
            </div>

            <!-- Services Grid -->
            <div v-if="filteredServices.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <div 
                    v-for="service in filteredServices" 
                    :key="service.id"
                    class="bg-white dark:bg-slate-800 rounded-2xl p-6 border border-slate-200/80 dark:border-slate-700/80 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between group"
                >
                    <div>
                        <!-- Header Icon & Badge -->
                        <div class="flex items-start justify-between gap-4 mb-4">
                            <div class="w-12 h-12 rounded-xl bg-emerald-50 dark:bg-emerald-900/30 text-emerald-600 dark:text-emerald-400 flex items-center justify-center shadow-inner group-hover:scale-110 transition-transform">
                                <component :is="getCategoryIcon(service.icon)" class="w-6 h-6" />
                            </div>
                            <span :class="[
                                'px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider',
                                service.external_link ? 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/40 dark:text-indigo-300' : 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-300'
                            ]">
                                {{ service.category }}
                            </span>
                        </div>

                        <!-- Title & Description -->
                        <h3 class="text-lg font-bold text-slate-900 dark:text-white mb-2 group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-colors">
                            {{ service.title }}
                        </h3>
                        <p class="text-xs text-slate-600 dark:text-slate-400 line-clamp-3 leading-relaxed mb-6">
                            {{ service.short_description }}
                        </p>
                    </div>

                    <!-- Action Button -->
                    <div class="pt-4 border-t border-slate-100 dark:border-slate-700/60 flex items-center justify-between">
                        <Link 
                            :href="route('public.layanan_umat.show', { service: service.slug })"
                            class="text-xs font-bold text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-slate-200 flex items-center gap-1"
                        >
                            Syarat & Detail →
                        </Link>

                        <a 
                            v-if="service.external_link"
                            :href="service.external_link"
                            class="px-4 py-2 bg-indigo-600 hover:bg-indigo-500 text-white rounded-lg font-bold text-xs shadow-md transition-all flex items-center gap-1"
                        >
                            Ke Fitur →
                        </a>

                        <button 
                            v-else
                            @click="openApplyModal(service)"
                            class="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-lg font-bold text-xs shadow-md transition-all"
                        >
                            Ajukan Layanan
                        </button>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div v-else class="text-center py-16 bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700">
                <div class="text-4xl mb-3">🔍</div>
                <h3 class="text-base font-bold text-slate-800 dark:text-slate-200">Layanan Tidak Ditemukan</h3>
                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Coba gunakan kata kunci lain atau pilih kategori Semua Layanan.</p>
            </div>
        </div>

        <!-- Tracking Status Modal -->
        <div v-if="showTrackingModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div class="bg-white dark:bg-slate-800 rounded-2xl max-w-lg w-full p-6 shadow-2xl relative">
                <button @click="showTrackingModal = false" class="absolute top-4 right-4 text-slate-400 hover:text-slate-600">
                    <XMarkIcon class="w-6 h-6" />
                </button>

                <h3 class="text-lg font-bold text-slate-900 dark:text-white flex items-center gap-2 mb-1">
                    <ClockIcon class="w-5 h-5 text-emerald-600" /> Cek Status Resi Layanan
                </h3>
                <p class="text-xs text-slate-500 dark:text-slate-400 mb-4">Masukkan Kode Tracking (misal: LU-20260813-XXXX) atau Nomor WhatsApp Anda.</p>

                <div class="flex gap-2 mb-4">
                    <input 
                        v-model="trackingInput"
                        @keyup.enter="performTracking"
                        type="text" 
                        placeholder="Kode Resi / No. WhatsApp..."
                        class="flex-1 px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 text-slate-900 dark:text-white text-sm focus:ring-2 focus:ring-emerald-500"
                    />
                    <button 
                        @click="performTracking"
                        :disabled="isTrackingLoading"
                        class="px-5 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl shadow-md transition-all disabled:opacity-50"
                    >
                        {{ isTrackingLoading ? 'Mencari...' : 'Cari' }}
                    </button>
                </div>

                <!-- Error Message -->
                <div v-if="trackingError" class="p-3 bg-rose-50 dark:bg-rose-950/40 text-rose-700 dark:text-rose-300 text-xs rounded-xl border border-rose-200 dark:border-rose-800 mb-4">
                    {{ trackingError }}
                </div>

                <!-- Results -->
                <div v-if="trackingResults" class="space-y-3 max-h-60 overflow-y-auto pr-1">
                    <div 
                        v-for="item in trackingResults" 
                        :key="item.tracking_code"
                        class="p-4 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-900/50"
                    >
                        <div class="flex items-center justify-between mb-2">
                            <span class="font-mono text-xs font-bold text-emerald-600 dark:text-emerald-400">{{ item.tracking_code }}</span>
                            <span :class="['px-2.5 py-0.5 rounded-full text-[10px] font-bold flex items-center gap-1', getStatusBadge(item.status).class]">
                                <component :is="getStatusBadge(item.status).icon" class="w-3 h-3" />
                                {{ item.status_label }}
                            </span>
                        </div>
                        <h4 class="text-xs font-bold text-slate-800 dark:text-slate-200">{{ item.service_name }}</h4>
                        <p class="text-[11px] text-slate-500 dark:text-slate-400">Pemohon: {{ item.applicant_name }} ({{ item.created_at }})</p>
                        
                        <div v-if="item.admin_notes" class="mt-2 p-2 bg-amber-50 dark:bg-amber-950/30 text-amber-800 dark:text-amber-300 text-[11px] rounded-lg border border-amber-200 dark:border-amber-800">
                            <strong>Catatan DKM:</strong> {{ item.admin_notes }}
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Application Submission Form Modal -->
        <div v-if="showApplyModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div class="bg-white dark:bg-slate-800 rounded-2xl max-w-xl w-full p-6 shadow-2xl relative max-h-[90vh] overflow-y-auto">
                <button @click="showApplyModal = false" class="absolute top-4 right-4 text-slate-400 hover:text-slate-600">
                    <XMarkIcon class="w-6 h-6" />
                </button>

                <div class="mb-4">
                    <span class="text-[10px] font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-widest">Formulir Pengajuan Online</span>
                    <h3 class="text-xl font-bold text-slate-900 dark:text-white">{{ selectedService?.title }}</h3>
                </div>

                <form @submit.prevent="submitApplication" class="space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Nama Lengkap Pemohon *</label>
                        <input 
                            v-model="form.applicant_name"
                            type="text" 
                            required
                            placeholder="Contoh: H. Ahmad Subardjo"
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        />
                        <div v-if="form.errors.applicant_name" class="text-rose-500 text-[11px] mt-1">{{ form.errors.applicant_name }}</div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div>
                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">No. WhatsApp / Telepon *</label>
                            <input 
                                v-model="form.phone"
                                type="text" 
                                required
                                placeholder="08123456789"
                                class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                            />
                            <div v-if="form.errors.phone" class="text-rose-500 text-[11px] mt-1">{{ form.errors.phone }}</div>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">NIK (KTP) <span class="font-normal text-slate-400">(Opsional)</span></label>
                            <input 
                                v-model="form.nik"
                                type="text" 
                                placeholder="3275xxxxxxxxxxxx"
                                class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                            />
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Alamat Lengkap Pemohon *</label>
                        <textarea 
                            v-model="form.address"
                            rows="2"
                            required
                            placeholder="Jl. Merdeka No. 12, RT 03/RW 05..."
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        ></textarea>
                        <div v-if="form.errors.address" class="text-rose-500 text-[11px] mt-1">{{ form.errors.address }}</div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Detail / Alasan Pengajuan *</label>
                        <textarea 
                            v-model="form.notes"
                            rows="3"
                            required
                            placeholder="Jelaskan kebutuhan atau alasan pengajuan bantuan..."
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        ></textarea>
                        <div v-if="form.errors.notes" class="text-rose-500 text-[11px] mt-1">{{ form.errors.notes }}</div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Lampiran Dokumen <span class="font-normal text-slate-400">(KTP/KK/Surat Keterangan, Max 5MB)</span></label>
                        <input 
                            type="file" 
                            ref="fileInput"
                            @change="handleFileUpload"
                            accept=".jpg,.jpeg,.png,.pdf"
                            class="hidden"
                        />
                        <button 
                            type="button" 
                            @click="$refs.fileInput.click()"
                            class="w-full py-2.5 px-3 rounded-xl border border-dashed border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 hover:bg-slate-100 dark:hover:bg-slate-800 text-xs text-slate-600 dark:text-slate-400 flex items-center justify-center gap-2"
                        >
                            <PaperClipIcon class="w-4 h-4 text-emerald-600" />
                            {{ documentPreview || 'Pilih File Dokumen (JPG/PNG/PDF)' }}
                        </button>
                    </div>

                    <div class="pt-4 border-t border-slate-200 dark:border-slate-700 flex justify-end gap-3">
                        <button 
                            type="button" 
                            @click="showApplyModal = false"
                            class="px-4 py-2 bg-slate-100 text-slate-700 rounded-xl font-bold text-xs hover:bg-slate-200"
                        >
                            Batal
                        </button>
                        <button 
                            type="submit" 
                            :disabled="form.processing"
                            class="px-6 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl font-bold text-xs shadow-md transition-all disabled:opacity-50"
                        >
                            {{ form.processing ? 'Mengirim...' : 'Kirim Pengajuan' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </PublicLayout>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
    height: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
    background: #cbd5e1;
    border-radius: 10px;
}
</style>
