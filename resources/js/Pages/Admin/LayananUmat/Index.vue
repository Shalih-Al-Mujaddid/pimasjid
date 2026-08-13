<script setup>
import { ref, computed } from 'vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
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
    PlusIcon,
    PencilSquareIcon,
    TrashIcon,
    CheckCircleIcon,
    ClockIcon,
    XCircleIcon,
    PaperClipIcon,
    XMarkIcon,
    MagnifyingGlassIcon
} from '@heroicons/vue/24/outline';

const props = defineProps({
    services: Array,
    applications: Object,
});

const activeTab = ref('applications'); // 'applications' | 'services'
const searchQuery = ref('');
const statusFilter = ref('all');

// Application status process modal
const showStatusModal = ref(false);
const selectedApp = ref(null);
const statusForm = useForm({
    status: 'pending',
    admin_notes: '',
});

// Service create/edit modal
const showServiceModal = ref(false);
const isEditingService = ref(false);
const editingServiceId = ref(null);

const serviceForm = useForm({
    title: '',
    category: 'sosial',
    icon: 'HeartIcon',
    short_description: '',
    description: '',
    terms: '',
    how_to_apply: '',
    external_link: '',
    is_active: true,
    is_featured: false,
});

const openStatusModal = (app) => {
    selectedApp.value = app;
    statusForm.status = app.status;
    statusForm.admin_notes = app.admin_notes || '';
    showStatusModal.value = true;
};

const submitStatusUpdate = () => {
    statusForm.patch(route('admin.layanan_umat.application.status', { application: selectedApp.value.id }), {
        preserveScroll: true,
        onSuccess: () => {
            showStatusModal.value = false;
        },
    });
};

const openCreateServiceModal = () => {
    isEditingService.value = false;
    editingServiceId.value = null;
    serviceForm.reset();
    serviceForm.category = 'sosial';
    serviceForm.icon = 'HeartIcon';
    serviceForm.is_active = true;
    serviceForm.is_featured = false;
    showServiceModal.value = true;
};

const openEditServiceModal = (service) => {
    isEditingService.value = true;
    editingServiceId.value = service.id;
    serviceForm.title = service.title;
    serviceForm.category = service.category;
    serviceForm.icon = service.icon || 'HeartIcon';
    serviceForm.short_description = service.short_description || '';
    serviceForm.description = service.description || '';
    serviceForm.terms = service.terms || '';
    serviceForm.how_to_apply = service.how_to_apply || '';
    serviceForm.external_link = service.external_link || '';
    serviceForm.is_active = service.is_active;
    serviceForm.is_featured = service.is_featured;
    showServiceModal.value = true;
};

const submitService = () => {
    if (isEditingService.value) {
        serviceForm.put(route('admin.layanan_umat.service.update', { service: editingServiceId.value }), {
            preserveScroll: true,
            onSuccess: () => showServiceModal.value = false,
        });
    } else {
        serviceForm.post(route('admin.layanan_umat.service.store'), {
            preserveScroll: true,
            onSuccess: () => showServiceModal.value = false,
        });
    }
};

const deleteService = (service) => {
    if (confirm(`Apakah Anda yakin ingin menghapus layanan '${service.title}'?`)) {
        router.delete(route('admin.layanan_umat.service.destroy', { service: service.id }), {
            preserveScroll: true,
        });
    }
};

const getStatusBadge = (status) => {
    switch (status) {
        case 'approved':
            return { class: 'bg-emerald-100 text-emerald-800 border-emerald-300 dark:bg-emerald-950/50 dark:text-emerald-300 dark:border-emerald-800', label: 'Disetujui', icon: CheckCircleIcon };
        case 'rejected':
            return { class: 'bg-rose-100 text-rose-800 border-rose-300 dark:bg-rose-950/50 dark:text-rose-300 dark:border-rose-800', label: 'Ditolak', icon: XCircleIcon };
        case 'completed':
            return { class: 'bg-blue-100 text-blue-800 border-blue-300 dark:bg-blue-950/50 dark:text-blue-300 dark:border-blue-800', label: 'Selesai', icon: CheckCircleIcon };
        default:
            return { class: 'bg-amber-100 text-amber-800 border-amber-300 dark:bg-amber-950/50 dark:text-amber-300 dark:border-amber-800', label: 'Menunggu', icon: ClockIcon };
    }
};

const filteredApplications = computed(() => {
    return props.applications.data.filter(app => {
        const matchesStatus = statusFilter.value === 'all' || app.status === statusFilter.value;
        const matchesSearch = !searchQuery.value ||
            app.applicant_name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
            app.tracking_code.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
            app.phone.includes(searchQuery.value) ||
            app.service_name.toLowerCase().includes(searchQuery.value.toLowerCase());
        return matchesStatus && matchesSearch;
    });
});

const pendingCount = computed(() => props.applications.data.filter(a => a.status === 'pending').length);
</script>

<template>
    <Head title="Kelola Layanan Umat - Admin PIMASJID" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h2 class="font-black text-2xl text-slate-900 dark:text-white tracking-tight flex items-center gap-2">
                        🤝 Kelola Layanan Umat
                    </h2>
                    <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">
                        Pusat pengelolaan permohonan bantuan jamaah & master data layanan sosial masjid.
                    </p>
                </div>
                
                <div class="flex items-center gap-2">
                    <button
                        @click="openCreateServiceModal"
                        class="px-4 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl font-bold text-xs shadow-md transition-all flex items-center gap-1.5"
                    >
                        <PlusIcon class="w-4 h-4" /> Tambah Layanan Baru
                    </button>
                </div>
            </div>
        </template>

        <!-- Stats Overview Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm">
                <div class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Total Permohonan</div>
                <div class="text-2xl font-black text-slate-900 dark:text-white">{{ applications.data.length }}</div>
            </div>

            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm">
                <div class="text-xs font-bold text-amber-500 uppercase tracking-wider mb-1">Menunggu Verifikasi</div>
                <div class="text-2xl font-black text-amber-600 dark:text-amber-400">{{ pendingCount }}</div>
            </div>

            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm">
                <div class="text-xs font-bold text-emerald-500 uppercase tracking-wider mb-1">Master Layanan Aktif</div>
                <div class="text-2xl font-black text-emerald-600 dark:text-emerald-400">{{ services.filter(s => s.is_active).length }}</div>
            </div>

            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm">
                <div class="text-xs font-bold text-indigo-500 uppercase tracking-wider mb-1">Total Layanan Masjid</div>
                <div class="text-2xl font-black text-indigo-600 dark:text-indigo-400">{{ services.length }}</div>
            </div>
        </div>

        <!-- Main Navigation Tabs -->
        <div class="flex border-b border-slate-200 dark:border-slate-700 mb-6">
            <button
                @click="activeTab = 'applications'"
                :class="[
                    'py-3 px-5 text-xs font-bold border-b-2 transition-all flex items-center gap-2',
                    activeTab === 'applications'
                        ? 'border-emerald-600 text-emerald-600 dark:text-emerald-400'
                        : 'border-transparent text-slate-500 hover:text-slate-700 dark:text-slate-400 dark:hover:text-slate-200'
                ]"
            >
                📋 Permohonan Jamaah
                <span v-if="pendingCount > 0" class="px-2 py-0.5 text-[10px] bg-amber-500 text-white rounded-full font-bold animate-pulse">
                    {{ pendingCount }}
                </span>
            </button>

            <button
                @click="activeTab = 'services'"
                :class="[
                    'py-3 px-5 text-xs font-bold border-b-2 transition-all flex items-center gap-2',
                    activeTab === 'services'
                        ? 'border-emerald-600 text-emerald-600 dark:text-emerald-400'
                        : 'border-transparent text-slate-500 hover:text-slate-700 dark:text-slate-400 dark:hover:text-slate-200'
                ]"
            >
                ⚙️ Master Layanan Sosial
            </button>
        </div>

        <!-- TAB 1: APPLICATIONS LIST -->
        <div v-if="activeTab === 'applications'" class="space-y-4">
            <!-- Filter Bar -->
            <div class="bg-white dark:bg-slate-800 p-4 rounded-2xl border border-slate-200 dark:border-slate-700 flex flex-col sm:flex-row items-center justify-between gap-4">
                <div class="relative w-full sm:w-80">
                    <MagnifyingGlassIcon class="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                    <input 
                        v-model="searchQuery"
                        type="text" 
                        placeholder="Cari pemohon / tracking code / WA..."
                        class="w-full pl-9 pr-3 py-2 text-xs rounded-xl border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                    />
                </div>

                <div class="flex items-center gap-2 w-full sm:w-auto">
                    <span class="text-xs font-bold text-slate-500 dark:text-slate-400">Status:</span>
                    <select 
                        v-model="statusFilter"
                        class="px-3 py-2 text-xs rounded-xl border border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 text-slate-900 dark:text-white focus:ring-2 focus:ring-emerald-500"
                    >
                        <option value="all">Semua Status</option>
                        <option value="pending">Menunggu Verifikasi</option>
                        <option value="approved">Disetujui</option>
                        <option value="completed">Selesai</option>
                        <option value="rejected">Ditolak</option>
                    </select>
                </div>
            </div>

            <!-- Table -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 overflow-hidden shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 dark:bg-slate-900/60 text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider border-b border-slate-200 dark:border-slate-700">
                                <th class="py-3 px-4">Resi / Tanggal</th>
                                <th class="py-3 px-4">Pemohon</th>
                                <th class="py-3 px-4">Layanan</th>
                                <th class="py-3 px-4">Detail Pengajuan</th>
                                <th class="py-3 px-4">Dokumen</th>
                                <th class="py-3 px-4">Status</th>
                                <th class="py-3 px-4 text-right">Aksi</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 dark:divide-slate-700/60 text-xs">
                            <tr v-for="app in filteredApplications" :key="app.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-700/30">
                                <td class="py-3.5 px-4">
                                    <div class="font-mono font-bold text-emerald-600 dark:text-emerald-400 text-[11px]">{{ app.tracking_code }}</div>
                                    <div class="text-[10px] text-slate-400 mt-0.5">{{ app.created_at }}</div>
                                </td>
                                <td class="py-3.5 px-4">
                                    <div class="font-bold text-slate-900 dark:text-white">{{ app.applicant_name }}</div>
                                    <div class="text-[11px] text-slate-500">WA: {{ app.phone }}</div>
                                    <div v-if="app.nik" class="text-[10px] text-slate-400">NIK: {{ app.nik }}</div>
                                </td>
                                <td class="py-3.5 px-4">
                                    <span class="font-bold text-slate-800 dark:text-slate-200">{{ app.service_name }}</span>
                                </td>
                                <td class="py-3.5 px-4 max-w-xs">
                                    <p class="line-clamp-2 text-slate-600 dark:text-slate-300 text-[11px]">{{ app.notes }}</p>
                                    <p class="text-[10px] text-slate-400 truncate mt-0.5">Alamat: {{ app.address }}</p>
                                </td>
                                <td class="py-3.5 px-4">
                                    <a 
                                        v-if="app.document_path"
                                        :href="app.document_path"
                                        target="_blank"
                                        class="inline-flex items-center gap-1 text-emerald-600 hover:text-emerald-700 dark:text-emerald-400 font-bold text-[11px]"
                                    >
                                        <PaperClipIcon class="w-3.5 h-3.5" /> Lihat Lampiran
                                    </a>
                                    <span v-else class="text-slate-400 text-[11px]">-</span>
                                </td>
                                <td class="py-3.5 px-4">
                                    <span :class="['px-2.5 py-1 rounded-full text-[10px] font-bold border inline-flex items-center gap-1', getStatusBadge(app.status).class]">
                                        <component :is="getStatusBadge(app.status).icon" class="w-3 h-3" />
                                        {{ getStatusBadge(app.status).label }}
                                    </span>
                                </td>
                                <td class="py-3.5 px-4 text-right">
                                    <button 
                                        @click="openStatusModal(app)"
                                        class="px-3 py-1.5 bg-slate-100 hover:bg-slate-200 dark:bg-slate-700 dark:hover:bg-slate-600 text-slate-800 dark:text-slate-200 font-bold rounded-lg text-xs transition-all"
                                    >
                                        Proses
                                    </button>
                                </td>
                            </tr>
                            <tr v-if="filteredApplications.length === 0">
                                <td colspan="7" class="py-8 text-center text-slate-400 text-xs">
                                    Tidak ada data permohonan jamaah.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- TAB 2: MASTER SERVICES LIST -->
        <div v-if="activeTab === 'services'" class="space-y-4">
            <div class="bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 overflow-hidden shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 dark:bg-slate-900/60 text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider border-b border-slate-200 dark:border-slate-700">
                                <th class="py-3 px-4">Layanan</th>
                                <th class="py-3 px-4">Kategori</th>
                                <th class="py-3 px-4">Deskripsi Ringkas</th>
                                <th class="py-3 px-4">Jumlah Pengajuan</th>
                                <th class="py-3 px-4">Status</th>
                                <th class="py-3 px-4 text-right">Aksi</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 dark:divide-slate-700/60 text-xs">
                            <tr v-for="service in services" :key="service.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-700/30">
                                <td class="py-3.5 px-4 font-bold text-slate-900 dark:text-white">
                                    <div class="flex items-center gap-2">
                                        <span class="w-7 h-7 rounded-lg bg-emerald-100 dark:bg-emerald-900/40 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-xs">
                                            🕌
                                        </span>
                                        {{ service.title }}
                                    </div>
                                </td>
                                <td class="py-3.5 px-4">
                                    <span class="px-2.5 py-0.5 bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-300 rounded-full font-bold text-[10px] uppercase">
                                        {{ service.category }}
                                    </span>
                                </td>
                                <td class="py-3.5 px-4 text-slate-600 dark:text-slate-400 max-w-xs truncate">
                                    {{ service.short_description || '-' }}
                                </td>
                                <td class="py-3.5 px-4 font-bold text-slate-900 dark:text-white">
                                    {{ service.applications_count }}
                                </td>
                                <td class="py-3.5 px-4">
                                    <span :class="[
                                        'px-2 py-0.5 rounded-full text-[10px] font-bold',
                                        service.is_active ? 'bg-emerald-100 text-emerald-800' : 'bg-slate-100 text-slate-500'
                                    ]">
                                        {{ service.is_active ? 'Aktif' : 'Non-Aktif' }}
                                    </span>
                                </td>
                                <td class="py-3.5 px-4 text-right space-x-1">
                                    <button 
                                        @click="openEditServiceModal(service)"
                                        class="p-1.5 text-slate-600 hover:text-emerald-600 dark:text-slate-400 dark:hover:text-emerald-400"
                                    >
                                        <PencilSquareIcon class="w-4 h-4" />
                                    </button>
                                    <button 
                                        @click="deleteService(service)"
                                        class="p-1.5 text-slate-600 hover:text-rose-600 dark:text-slate-400 dark:hover:text-rose-400"
                                    >
                                        <TrashIcon class="w-4 h-4" />
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- APPLICATION STATUS PROCESS MODAL -->
        <div v-if="showStatusModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div class="bg-white dark:bg-slate-800 rounded-2xl max-w-md w-full p-6 shadow-2xl relative">
                <button @click="showStatusModal = false" class="absolute top-4 right-4 text-slate-400 hover:text-slate-600">
                    <XMarkIcon class="w-6 h-6" />
                </button>

                <h3 class="text-base font-bold text-slate-900 dark:text-white mb-1">
                    Proses Pengajuan {{ selectedApp?.tracking_code }}
                </h3>
                <p class="text-xs text-slate-500 dark:text-slate-400 mb-4">
                    Pemohon: {{ selectedApp?.applicant_name }} ({{ selectedApp?.service_name }})
                </p>

                <form @submit.prevent="submitStatusUpdate" class="space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Pilih Status *</label>
                        <select 
                            v-model="statusForm.status"
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        >
                            <option value="pending">Menunggu Verifikasi</option>
                            <option value="approved">Disetujui / Dalam Proses</option>
                            <option value="completed">Selesai / Terdistribusi</option>
                            <option value="rejected">Ditolak</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Catatan Admin / Verifikator</label>
                        <textarea 
                            v-model="statusForm.admin_notes"
                            rows="3"
                            placeholder="Alasan persetujuan / penolakan atau instruksi pencairan..."
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        ></textarea>
                    </div>

                    <div class="pt-4 border-t border-slate-200 dark:border-slate-700 flex justify-end gap-2">
                        <button 
                            type="button" 
                            @click="showStatusModal = false"
                            class="px-4 py-2 bg-slate-100 text-slate-700 rounded-xl font-bold text-xs hover:bg-slate-200"
                        >
                            Batal
                        </button>
                        <button 
                            type="submit" 
                            :disabled="statusForm.processing"
                            class="px-5 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl font-bold text-xs shadow-md transition-all disabled:opacity-50"
                        >
                            Simpan Perubahan
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- CREATE / EDIT SERVICE MODAL -->
        <div v-if="showServiceModal" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div class="bg-white dark:bg-slate-800 rounded-2xl max-w-xl w-full p-6 shadow-2xl relative max-h-[90vh] overflow-y-auto">
                <button @click="showServiceModal = false" class="absolute top-4 right-4 text-slate-400 hover:text-slate-600">
                    <XMarkIcon class="w-6 h-6" />
                </button>

                <h3 class="text-base font-bold text-slate-900 dark:text-white mb-4">
                    {{ isEditingService ? 'Edit Layanan Umat' : 'Tambah Layanan Umat Baru' }}
                </h3>

                <form @submit.prevent="submitService" class="space-y-3">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Judul Layanan *</label>
                        <input 
                            v-model="serviceForm.title"
                            type="text" 
                            required
                            placeholder="Contoh: Layanan Ambulans Gratis"
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        />
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div>
                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Kategori *</label>
                            <select 
                                v-model="serviceForm.category"
                                class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                            >
                                <option value="sosial">Sosial</option>
                                <option value="kesehatan">Kesehatan</option>
                                <option value="jenazah">Jenazah</option>
                                <option value="pendidikan">Pendidikan</option>
                                <option value="fasilitas">Fasilitas</option>
                                <option value="zakat">Zakat</option>
                                <option value="qurban">Qurban</option>
                                <option value="tpa">TPA</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">External Link <span class="font-normal text-slate-400">(Opsional)</span></label>
                            <input 
                                v-model="serviceForm.external_link"
                                type="text" 
                                placeholder="/info/zakat"
                                class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                            />
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Deskripsi Ringkas</label>
                        <input 
                            v-model="serviceForm.short_description"
                            type="text" 
                            placeholder="Ringkasan 1-2 kalimat..."
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        />
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Deskripsi Lengkap</label>
                        <textarea 
                            v-model="serviceForm.description"
                            rows="2"
                            placeholder="Penjelasan lengkap layanan..."
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        ></textarea>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Syarat & Ketentuan</label>
                        <textarea 
                            v-model="serviceForm.terms"
                            rows="2"
                            placeholder="- Syarat 1..."
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        ></textarea>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">Alur / Cara Pengajuan</label>
                        <textarea 
                            v-model="serviceForm.how_to_apply"
                            rows="2"
                            placeholder="1. Isi form..."
                            class="w-full px-3.5 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                        ></textarea>
                    </div>

                    <div class="flex items-center gap-4 pt-2">
                        <label class="inline-flex items-center gap-2 cursor-pointer">
                            <input v-model="serviceForm.is_active" type="checkbox" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500" />
                            <span class="text-xs font-bold text-slate-700 dark:text-slate-300">Aktif</span>
                        </label>
                        <label class="inline-flex items-center gap-2 cursor-pointer">
                            <input v-model="serviceForm.is_featured" type="checkbox" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500" />
                            <span class="text-xs font-bold text-slate-700 dark:text-slate-300">Tampilkan di Highlight</span>
                        </label>
                    </div>

                    <div class="pt-4 border-t border-slate-200 dark:border-slate-700 flex justify-end gap-2">
                        <button 
                            type="button" 
                            @click="showServiceModal = false"
                            class="px-4 py-2 bg-slate-100 text-slate-700 rounded-xl font-bold text-xs hover:bg-slate-200"
                        >
                            Batal
                        </button>
                        <button 
                            type="submit" 
                            :disabled="serviceForm.processing"
                            class="px-5 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl font-bold text-xs shadow-md transition-all disabled:opacity-50"
                        >
                            Simpan Layanan
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
