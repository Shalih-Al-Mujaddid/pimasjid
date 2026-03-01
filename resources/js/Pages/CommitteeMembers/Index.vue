<script setup>
import { ref } from 'vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import Modal from '@/Components/Modal.vue';
import ModernTable from '@/Components/ModernTable.vue';
import Pagination from '@/Components/Pagination.vue';
import { useToast } from '@/Composables/useToast';
import { 
    PlusIcon, 
    PencilSquareIcon, 
    TrashIcon,
    MagnifyingGlassIcon,
    PhotoIcon,
    UserGroupIcon,
    XMarkIcon,
    CheckCircleIcon
} from '@heroicons/vue/24/outline';

const props = defineProps({
    members: Object,
});

const toast = useToast();
const showModal = ref(false);
const isEditing = ref(false);
const editingId = ref(null);
const previewImage = ref(null);

const form = useForm({
    name: '',
    position: '',
    division: 'Inti',
    photo: null,
    order: 0,
    is_active: true,
});

const divisionOptions = [
    'Inti',
    'Ibadah',
    'Pembangunan',
    'Pendidikan',
    'Sosial',
    'Humas',
    'Keamanan',
    'Kebersihan'
];

const openCreateModal = () => {
    isEditing.value = false;
    editingId.value = null;
    previewImage.value = null;
    form.reset();
    // Auto-arrange order for new members
    form.order = (props.members.total || 0) + 1;
    form.clearErrors();
    showModal.value = true;
};

const openEditModal = (member) => {
    isEditing.value = true;
    editingId.value = member.id;
    form.name = member.name;
    form.position = member.position;
    form.division = member.division;
    form.order = member.order;
    form.is_active = !!member.is_active;
    form.photo = null;
    previewImage.value = member.photo_url;
    form.clearErrors();
    showModal.value = true;
};

const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
        form.photo = file;
        previewImage.value = URL.createObjectURL(file);
    }
};

const submitForm = () => {
    if (isEditing.value) {
        form.transform((data) => ({
            ...data,
            _method: 'put',
        })).post(route('committee-members.update', editingId.value), {
            onSuccess: () => {
                showModal.value = false;
                toast.success('Pengurus berhasil diperbarui');
                form.reset();
            },
            forceFormData: true, 
        });
    } else {
        form.post(route('committee-members.store'), {
            onSuccess: () => {
                showModal.value = false;
                toast.success('Pengurus berhasil ditambahkan');
                form.reset();
            },
        });
    }
};

const deleteMember = (id) => {
    if (confirm('Apakah Anda yakin ingin menghapus pengurus ini?')) {
        router.delete(route('committee-members.destroy', id), {
            onSuccess: () => toast.success('Pengurus berhasil dihapus'),
        });
    }
};

const columns = [
    { key: 'photo', label: 'Profil' },
    { key: 'name', label: 'Informasi Pengurus' },
    { key: 'division', label: 'Bidang' },
    { key: 'order', label: 'Urutan' },
    { key: 'status', label: 'Status' },
    { key: 'actions', label: 'Aksi' },
];
</script>

<template>
    <Head title="Manajemen Pengurus" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex justify-between items-center">
                <div class="flex items-center gap-3">
                    <div class="p-2 bg-emerald-100 rounded-xl">
                        <UserGroupIcon class="w-6 h-6 text-emerald-600" />
                    </div>
                    <h2 class="font-black text-2xl text-slate-800 leading-tight">
                        Struktur Pengurus
                    </h2>
                </div>
                <button 
                    @click="openCreateModal"
                    class="bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-2.5 rounded-xl font-bold flex items-center gap-2 transition-all shadow-lg shadow-emerald-100 active:scale-95"
                >
                    <PlusIcon class="w-5 h-5 stroke-2" />
                    <span>Tambah Pengurus</span>
                </button>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6">
                
                <div class="bg-white overflow-hidden shadow-xl shadow-slate-200/50 rounded-[2rem] border border-slate-100">
                    <div class="p-8">
                        <ModernTable
                            :columns="columns"
                            :data="members.data"
                        >
                            <template #cell-photo="{ row }">
                                <div class="relative w-12 h-12 rounded-2xl overflow-hidden border border-slate-100 shadow-sm">
                                    <img :src="row.photo_url" :alt="row.name" class="w-full h-full object-cover" />
                                </div>
                            </template>

                            <template #cell-name="{ row }">
                                <div class="flex flex-col">
                                    <span class="font-bold text-slate-800">{{ row.name }}</span>
                                    <span class="text-xs text-slate-500 font-medium italic">{{ row.position }}</span>
                                </div>
                            </template>
                            
                            <template #cell-division="{ value }">
                                <span class="px-3 py-1 bg-slate-50 text-slate-600 rounded-lg text-xs font-bold border border-slate-100">
                                    {{ value }}
                                </span>
                            </template>

                            <template #cell-order="{ value }">
                                <div class="flex items-center justify-center w-8 h-8 rounded-lg bg-emerald-50 text-emerald-700 text-xs font-black border border-emerald-100">
                                    {{ value }}
                                </div>
                            </template>
                            
                            <template #cell-status="{ row }">
                                <span 
                                    class="px-3 py-1 text-[10px] font-black uppercase tracking-widest rounded-full shadow-sm"
                                    :class="row.is_active ? 'bg-emerald-500 text-white' : 'bg-slate-100 text-slate-400'"
                                >
                                    {{ row.is_active ? 'Aktif' : 'Off' }}
                                </span>
                            </template>

                            <template #cell-actions="{ row }">
                                <div class="flex gap-1">
                                    <button 
                                        @click="openEditModal(row)"
                                        class="p-2 text-blue-600 hover:bg-blue-50 rounded-xl transition-all"
                                        title="Edit"
                                    >
                                        <PencilSquareIcon class="w-5 h-5" />
                                    </button>
                                    <button 
                                        @click="deleteMember(row.id)"
                                        class="p-2 text-rose-500 hover:bg-rose-50 rounded-xl transition-all"
                                        title="Hapus"
                                    >
                                        <TrashIcon class="w-5 h-5" />
                                    </button>
                                </div>
                            </template>

                            <template #empty>
                                <div class="flex flex-col items-center justify-center py-16 text-slate-400">
                                    <div class="p-6 bg-slate-50 rounded-full mb-4">
                                        <UserGroupIcon class="w-12 h-12 opacity-20" />
                                    </div>
                                    <p class="text-xl font-black text-slate-800">Belum ada pengurus</p>
                                    <p class="text-slate-400 font-medium max-w-xs text-center mt-2">Daftarkan pengurus masjid Anda untuk mulai mengelola struktur organisasi.</p>
                                </div>
                            </template>

                             <template #pagination>
                                <div class="pt-6">
                                    <Pagination :links="members.links" />
                                </div>
                            </template>
                        </ModernTable>
                    </div>
                </div>

            </div>
        </div>

        <!-- Modal -->
        <Modal :show="showModal" maxWidth="2xl" @close="showModal = false">
            <div class="bg-white rounded-[2.5rem] overflow-hidden shadow-2xl">
                <!-- Modal Header -->
                <div class="px-8 py-6 border-b border-slate-50 flex justify-between items-center bg-slate-50/50">
                    <div class="flex items-center gap-4">
                        <div :class="isEditing ? 'bg-blue-100 text-blue-600' : 'bg-emerald-100 text-emerald-600'" class="p-3 rounded-2xl">
                            <UserGroupIcon class="w-6 h-6" />
                        </div>
                        <div>
                            <h2 class="text-xl font-black text-slate-900 leading-none">
                                {{ isEditing ? 'Edit Profil Pengurus' : 'Tambah Pengurus Baru' }}
                            </h2>
                            <p class="text-sm text-slate-500 font-medium mt-1">Lengkapi data profil dan jabatan pengurus masjid.</p>
                        </div>
                    </div>
                    <button @click="showModal = false" class="p-2 hover:bg-slate-100 rounded-xl transition-colors">
                        <XMarkIcon class="w-6 h-6 text-slate-400" />
                    </button>
                </div>

                <form @submit.prevent="submitForm" class="p-8 space-y-8">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <!-- Left Side: Photo -->
                        <div class="space-y-4">
                             <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Foto Profil</label>
                             <div class="relative group w-full aspect-square bg-slate-50 rounded-[2rem] overflow-hidden border-2 border-dashed border-slate-200 hover:border-emerald-400 transition-all flex items-center justify-center">
                                <img v-if="previewImage" :src="previewImage" class="w-full h-full object-cover" />
                                <div v-if="previewImage" class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                                    <button type="button" @click="$refs.photoInput.click()" class="bg-white h-12 w-12 rounded-full shadow-lg flex items-center justify-center text-slate-600 hover:scale-110 transition-transform">
                                        <PhotoIcon class="w-6 h-6" />
                                    </button>
                                </div>
                                <label v-else @click="$refs.photoInput.click()" class="flex flex-col items-center justify-center cursor-pointer gap-2">
                                    <div class="p-4 bg-white rounded-2xl shadow-sm text-slate-300 group-hover:text-emerald-500 transition-colors">
                                        <UserGroupIcon class="w-10 h-10" />
                                    </div>
                                    <span class="text-xs font-black text-slate-400">Pilih Foto</span>
                                </label>
                                <input ref="photoInput" type="file" @change="handleImageUpload" accept="image/*" class="hidden">
                             </div>
                             <p v-if="form.errors.photo" class="text-rose-500 text-xs font-bold">{{ form.errors.photo }}</p>
                        </div>

                        <!-- Right Side: Details -->
                        <div class="space-y-5">
                            <div class="space-y-1.5">
                                <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Nama Lengkap</label>
                                <input v-model="form.name" type="text" required class="w-full rounded-2xl border-slate-200 py-3 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 hover:bg-white transition-all" placeholder="Misal: H. Ahmad Yani, S.Ag">
                                <p v-if="form.errors.name" class="text-rose-500 text-[10px] font-bold">{{ form.errors.name }}</p>
                            </div>

                            <div class="space-y-1.5">
                                <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Jabatan</label>
                                <input v-model="form.position" type="text" required class="w-full rounded-2xl border-slate-200 py-3 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 hover:bg-white transition-all" placeholder="Contoh: Ketua DKM">
                                <p v-if="form.errors.position" class="text-rose-500 text-[10px] font-bold">{{ form.errors.position }}</p>
                            </div>

                            <div class="grid grid-cols-2 gap-4">
                                <div class="space-y-1.5">
                                    <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Bidang</label>
                                    <select v-model="form.division" class="w-full rounded-2xl border-slate-200 py-3 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 transition-all">
                                        <option v-for="opt in divisionOptions" :key="opt" :value="opt">{{ opt }}</option>
                                        <option value="Lainnya">Lainnya</option>
                                    </select>
                                </div>
                                <div class="space-y-1.5">
                                    <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Urutan</label>
                                    <input v-model="form.order" type="number" class="w-full rounded-2xl border-slate-200 py-3 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 transition-all" />
                                </div>
                            </div>

                            <div class="flex items-center gap-3 p-4 bg-slate-50 rounded-2xl border border-slate-100">
                                <input v-model="form.is_active" type="checkbox" id="is_active" class="w-6 h-6 border-slate-300 rounded-lg text-emerald-600 focus:ring-emerald-500 cursor-pointer" />
                                <label for="is_active" class="text-sm font-black text-slate-700 cursor-pointer">Status Pengurus Aktif</label>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Footer -->
                    <div class="pt-8 border-t border-slate-100 flex justify-end gap-4">
                        <button type="button" @click="showModal = false" class="px-8 py-3.5 bg-slate-100 text-slate-600 font-black rounded-2xl hover:bg-slate-200 transition-all active:scale-95">
                            Batal
                        </button>
                        <button type="submit" :disabled="form.processing" class="px-10 py-3.5 bg-emerald-600 text-white font-black rounded-2xl shadow-xl shadow-emerald-100 hover:bg-emerald-700 disabled:opacity-50 transition-all active:scale-95 flex items-center gap-2">
                             <span v-if="form.processing" class="animate-spin h-5 w-5 border-2 border-white border-t-transparent rounded-full"></span>
                             <CheckCircleIcon class="w-5 h-5 stroke-2" />
                             Simpan Pengurus
                        </button>
                    </div>

                </form>
            </div>
        </Modal>

        <!-- Toast -->
        <Transition name="fade">
            <div v-if="toast.show.value" :class="['fixed bottom-8 right-8 z-50 px-8 py-5 rounded-[2rem] shadow-2xl max-w-sm flex items-center gap-4 transform transition-all', toast.type.value === 'success' ? 'bg-slate-900 text-white' : 'bg-rose-600 text-white']">
                <div :class="toast.type.value === 'success' ? 'bg-emerald-500' : 'bg-white/20'" class="p-2 rounded-xl">
                    <CheckCircleIcon v-if="toast.type.value === 'success'" class="w-6 h-6 text-white" />
                    <XMarkIcon v-else class="w-6 h-6 text-white" />
                </div>
                <div>
                    <p class="font-black text-sm tracking-tight leading-tight">{{ toast.message.value }}</p>
                </div>
            </div>
        </Transition>

    </AuthenticatedLayout>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1); }
.fade-enter-from, .fade-leave-to { opacity: 0; transform: translateY(2rem) scale(0.95); }
</style>
