<script setup>
import { ref } from 'vue';
import { Head, useForm } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import ModernTable from '@/Components/ModernTable.vue';
import Modal from '@/Components/Modal.vue';
import WysiwygEditor from '@/Components/WysiwygEditor.vue';
import { 
    PlusIcon, 
    PencilSquareIcon, 
    TrashIcon, 
    PhotoIcon, 
    CalendarIcon,
    DocumentTextIcon,
    XMarkIcon
} from '@heroicons/vue/24/outline';

const props = defineProps({
    posts: Array,
});

const isModalOpen = ref(false);
const isEditing = ref(false);
const editingId = ref(null);
const imagePreview = ref(null);

const form = useForm({
    title: '',
    excerpt: '',
    content: '',
    photo: null,
    is_published: true,
    published_at: '',
});

const openCreateModal = () => {
    isEditing.value = false;
    editingId.value = null;
    imagePreview.value = null;
    form.reset();
    form.is_published = true;
    form.published_at = new Date().toISOString().slice(0, 16);
    form.transform((data) => data);
    isModalOpen.value = true;
};

const openEditModal = (post) => {
    isEditing.value = true;
    editingId.value = post.id;
    form.title = post.title;
    form.excerpt = post.excerpt;
    form.content = post.content;
    form.is_published = Boolean(post.is_published);
    form.published_at = post.published_at ? new Date(post.published_at).toISOString().slice(0, 16) : '';
    form.photo = null;
    imagePreview.value = post.image_url;
    isModalOpen.value = true;
};

const closeModal = () => {
    isModalOpen.value = false;
    form.reset();
};

const submitForm = () => {
    if (isEditing.value) {
        form.transform((data) => ({
            ...data,
            _method: 'put',
        })).post(route('posts.update', editingId.value), {
            onSuccess: () => closeModal(),
            forceFormData: true,
        });
    } else {
        form.post(route('posts.store'), {
            onSuccess: () => closeModal(),
            forceFormData: true,
        });
    }
};

const deleteResult = (id) => {
    if (confirm('Apakah Anda yakin ingin menghapus berita ini?')) {
        form.delete(route('posts.destroy', id));
    }
};

const columns = [
    { key: 'image_url', label: 'Gambar', type: 'image' },
    { key: 'title', label: 'Judul' },
    { key: 'excerpt', label: 'Ringkasan' },
    { key: 'is_published', label: 'Status', type: 'boolean' },
    { key: 'author_name', label: 'Penulis' },
    { key: 'actions', label: 'Aksi' }
];

const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
        form.photo = file;
        const reader = new FileReader();
        reader.onload = (e) => {
            imagePreview.value = e.target.result;
        };
        reader.readAsDataURL(file);
    }
};
</script>

<template>
    <Head title="Manajemen Berita & Kegiatan" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex justify-between items-center">
                <div class="flex items-center gap-3">
                    <div class="p-2 bg-emerald-100 rounded-xl">
                        <DocumentTextIcon class="w-6 h-6 text-emerald-600" />
                    </div>
                    <h2 class="font-black text-2xl text-slate-800 leading-tight">Berita & Kegiatan</h2>
                </div>
                <button @click="openCreateModal" class="bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-2.5 rounded-xl font-bold flex items-center gap-2 transition-all shadow-lg shadow-emerald-100 active:scale-95">
                    <PlusIcon class="w-5 h-5 stroke-2" />
                    Tambah Berita
                </button>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-xl shadow-slate-200/50 rounded-[2rem] border border-slate-100">
                    <div class="p-8">
                         <ModernTable 
                            :columns="columns" 
                            :data="posts"
                        >
                            <template #cell-image_url="{ value }">
                                <div class="h-14 w-24 rounded-2xl overflow-hidden bg-slate-50 border border-slate-100 p-1">
                                    <img 
                                        v-if="value" 
                                        :src="value" 
                                        class="h-full w-full object-cover rounded-xl shadow-sm" 
                                        alt="Thumbnail" 
                                    />
                                    <div v-else class="h-full w-full flex items-center justify-center text-slate-300">
                                        <PhotoIcon class="w-6 h-6" />
                                    </div>
                                </div>
                            </template>

                            <template #cell-is_published="{ value }">
                                <span 
                                    :class="[
                                        'px-4 py-1.5 rounded-full text-xs font-black uppercase tracking-wider shadow-sm',
                                        value 
                                            ? 'bg-emerald-500 text-white' 
                                            : 'bg-slate-100 text-slate-500'
                                    ]"
                                >
                                    {{ value ? 'Terbit' : 'Draft' }}
                                </span>
                            </template>

                            <template #cell-actions="{ row }">
                                <div class="flex items-center gap-1">
                                    <button 
                                        @click="openEditModal(row)" 
                                        class="p-2 text-blue-600 hover:bg-blue-50 rounded-xl transition-all"
                                        title="Edit"
                                    >
                                        <PencilSquareIcon class="w-5 h-5" />
                                    </button>
                                    <button 
                                        @click="deleteResult(row.id)" 
                                        class="p-2 text-rose-500 hover:bg-rose-50 rounded-xl transition-all"
                                        title="Hapus"
                                    >
                                        <TrashIcon class="w-5 h-5" />
                                    </button>
                                </div>
                            </template>
                        </ModernTable>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <Modal :show="isModalOpen" maxWidth="3xl" @close="closeModal">
            <div class="bg-white rounded-[2.5rem] overflow-hidden shadow-2xl">
                <!-- Modal Header -->
                <div class="px-8 py-6 border-b border-slate-50 flex justify-between items-center bg-slate-50/50">
                    <div class="flex items-center gap-4">
                        <div :class="isEditing ? 'bg-blue-100 text-blue-600' : 'bg-emerald-100 text-emerald-600'" class="p-3 rounded-2xl">
                            <DocumentTextIcon class="w-6 h-6" />
                        </div>
                        <div>
                            <h2 class="text-xl font-black text-slate-900 leading-none">
                                {{ isEditing ? 'Edit Berita' : 'Tambah Berita' }}
                            </h2>
                            <p class="text-sm text-slate-500 font-medium mt-1">Lengkapi informasi konten Anda di bawah ini.</p>
                        </div>
                    </div>
                    <button @click="closeModal" class="p-2 hover:bg-slate-100 rounded-xl transition-colors">
                        <XMarkIcon class="w-6 h-6 text-slate-400" />
                    </button>
                </div>

                <form @submit.prevent="submitForm" class="p-8 space-y-8">
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                        <!-- Left Side: Basic Info -->
                        <div class="space-y-6">
                            <!-- Title -->
                            <div class="space-y-2">
                                <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Judul Konten</label>
                                <input v-model="form.title" type="text" required class="w-full rounded-2xl border-slate-200 py-3.5 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 hover:bg-white transition-all" placeholder="Misal: Laporan Kegiatan Qurban">
                                <div v-if="form.errors.title" class="text-rose-500 text-xs mt-1 font-bold">{{ form.errors.title }}</div>
                            </div>

                            <!-- Excerpt -->
                            <div class="space-y-2">
                                <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Ringkasan Pendek</label>
                                <textarea v-model="form.excerpt" rows="3" class="w-full rounded-2xl border-slate-200 py-3 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 hover:bg-white transition-all" placeholder="Tuliskan intisari berita di sini..."></textarea>
                            </div>

                            <!-- Published At -->
                            <div class="space-y-2">
                                <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1 flex items-center gap-1">
                                    <CalendarIcon class="w-3 h-3" />
                                    Jadwal Publish
                                </label>
                                <input v-model="form.published_at" type="datetime-local" class="w-full rounded-2xl border-slate-200 py-3.5 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold bg-slate-50/50 hover:bg-white transition-all">
                                <div v-if="form.errors.published_at" class="text-rose-500 text-xs mt-1 font-bold">{{ form.errors.published_at }}</div>
                            </div>

                            <!-- Status -->
                            <div class="flex items-center gap-3 p-4 bg-slate-50 rounded-2xl border border-slate-100">
                                <input v-model="form.is_published" type="checkbox" id="is_published" class="w-6 h-6 border-slate-300 rounded-lg text-emerald-600 focus:ring-emerald-500 cursor-pointer">
                                <label for="is_published" class="text-sm font-black text-slate-700 cursor-pointer">Terbitkan Konten Sekarang</label>
                            </div>
                        </div>

                        <!-- Right Side: Content & Media -->
                        <div class="space-y-6">
                            <!-- Image -->
                            <div class="space-y-2">
                                <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Gambar Utama</label>
                                <div class="relative group aspect-video bg-slate-50 rounded-3xl overflow-hidden border-2 border-dashed border-slate-200 hover:border-emerald-400 transition-all">
                                    <div v-if="imagePreview" class="w-full h-full">
                                        <img :src="imagePreview" class="w-full h-full object-cover" />
                                        <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                                            <button type="button" @click="$refs.photoInput.click()" class="bg-white h-12 w-12 rounded-full shadow-lg flex items-center justify-center text-slate-600 hover:scale-110 transition-transform">
                                                <PhotoIcon class="w-6 h-6" />
                                            </button>
                                        </div>
                                    </div>
                                    <label v-else @click="$refs.photoInput.click()" class="w-full h-full flex flex-col items-center justify-center cursor-pointer gap-2">
                                        <div class="p-4 bg-white rounded-2xl shadow-sm text-slate-300 group-hover:text-emerald-500 transition-colors">
                                            <PhotoIcon class="w-8 h-8" />
                                        </div>
                                        <span class="text-sm font-black text-slate-400">Pilih Gambar Utama</span>
                                    </label>
                                    <input ref="photoInput" type="file" @change="handleImageUpload" accept="image/*" class="hidden">
                                </div>
                                <div v-if="form.errors.photo" class="text-rose-500 text-xs mt-1 font-bold">{{ form.errors.photo }}</div>
                            </div>

                            <!-- Content -->
                            <div class="space-y-2">
                                <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Isi Berita Lengkap</label>
                                <WysiwygEditor 
                                    v-if="isModalOpen"
                                    :key="editingId || 'new'"
                                    v-model="form.content" 
                                    placeholder="Tuliskan narasi lengkap kegiatan atau informasi di sini..." 
                                />
                                <div v-if="form.errors.content" class="text-rose-500 text-xs mt-1 font-bold">{{ form.errors.content }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Footer -->
                    <div class="pt-8 border-t border-slate-100 flex justify-end gap-4">
                        <button type="button" @click="closeModal" class="px-8 py-3.5 bg-slate-100 text-slate-600 font-black rounded-2xl hover:bg-slate-200 transition-all active:scale-95">
                            Batal
                        </button>
                        <button type="submit" :disabled="form.processing" class="px-10 py-3.5 bg-emerald-600 text-white font-black rounded-2xl shadow-xl shadow-emerald-100 hover:bg-emerald-700 disabled:opacity-50 transition-all active:scale-95 flex items-center gap-2">
                            <span v-if="form.processing" class="animate-spin h-5 w-5 border-2 border-white border-t-transparent rounded-full"></span>
                            Simpan Perubahan
                        </button>
                    </div>
                </form>
            </div>
        </Modal>
    </AuthenticatedLayout>
</template>
