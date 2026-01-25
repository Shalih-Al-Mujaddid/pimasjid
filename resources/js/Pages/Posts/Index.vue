<script setup>
import { ref } from 'vue';
import { Head, useForm } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import ModernTable from '@/Components/ModernTable.vue';
import Modal from '@/Components/Modal.vue';
import { PlusIcon, PencilSquareIcon, TrashIcon } from '@heroicons/vue/20/solid';

const props = defineProps({
    posts: Array,
});

const isModalOpen = ref(false);
const isEditing = ref(false);
const editingId = ref(null);

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
    form.reset();
    form.is_published = true;
    form.published_at = new Date().toISOString().slice(0, 16); // Set to current datetime
    form.transform((data) => data); // Reset transform to prevent sticky _method: put
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
    form.photo = null; // Reset photo input
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
    form.photo = e.target.files[0];
};
</script>

<template>
    <Head title="Manajemen Berita & Kegiatan" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex justify-between items-center">
                <h2 class="font-semibold text-xl text-slate-800 leading-tight">Manajemen Berita & Kegiatan</h2>
                <button @click="openCreateModal" class="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-lg text-sm flex items-center gap-2 transition-colors shadow-sm">
                    <PlusIcon class="w-5 h-5" />
                    Tambah Berita
                </button>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6">
                         <ModernTable 
                            :columns="columns" 
                            :data="posts"
                        >
                            <template #cell-image_url="{ value }">
                                <div class="h-12 w-20 rounded-md overflow-hidden bg-slate-100">
                                    <img 
                                        v-if="value" 
                                        :src="value" 
                                        class="h-full w-full object-cover" 
                                        alt="Thumbnail" 
                                    />
                                    <div v-else class="h-full w-full flex items-center justify-center text-slate-400 text-xs">
                                        No Img
                                    </div>
                                </div>
                            </template>

                            <template #cell-is_published="{ value }">
                                <span 
                                    :class="[
                                        'px-2 py-1 rounded-full text-xs font-semibold',
                                        value 
                                            ? 'bg-emerald-100 text-emerald-800' 
                                            : 'bg-slate-100 text-slate-800'
                                    ]"
                                >
                                    {{ value ? 'Terbit' : 'Draft' }}
                                </span>
                            </template>

                            <template #cell-actions="{ row }">
                                <div class="flex items-center gap-2">
                                    <button 
                                        @click="openEditModal(row)" 
                                        class="p-1 text-blue-600 hover:bg-blue-50 rounded transition-colors"
                                        title="Edit"
                                    >
                                        <PencilSquareIcon class="w-5 h-5" />
                                    </button>
                                    <button 
                                        @click="deleteResult(row.id)" 
                                        class="p-1 text-red-600 hover:bg-red-50 rounded transition-colors"
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
        <Modal :show="isModalOpen" maxWidth="2xl" @close="closeModal">
            <div class="p-6">
                <h2 class="text-lg font-medium text-slate-900 mb-6">
                    {{ isEditing ? 'Edit Berita' : 'Tambah Berita Baru' }}
                </h2>

                <form @submit.prevent="submitForm" class="space-y-4">
                    <!-- Title -->
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Judul</label>
                        <input v-model="form.title" type="text" required class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500" placeholder="Judul Berita/Kegiatan">
                        <div v-if="form.errors.title" class="text-red-500 text-sm mt-1">{{ form.errors.title }}</div>
                    </div>

                    <!-- Excerpt -->
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Ringkasan (Pendek)</label>
                        <textarea v-model="form.excerpt" rows="2" class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500" placeholder="Ringkasan singkat untuk tampilan awal..."></textarea>
                    </div>

                    <!-- Content -->
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Isi Berita</label>
                        <textarea v-model="form.content" rows="6" required class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500" placeholder="Tulis isi berita selengkapnya di sini..."></textarea>
                        <div v-if="form.errors.content" class="text-red-500 text-sm mt-1">{{ form.errors.content }}</div>
                    </div>

                    <!-- Image -->
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Gambar Utama</label>
                        <div class="flex items-center gap-4">
                            <input type="file" @change="handleImageUpload" accept="image/*" class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-emerald-50 file:text-emerald-700 hover:file:bg-emerald-100">
                        </div>
                         <div v-if="form.errors.photo" class="text-red-500 text-sm mt-1">{{ form.errors.photo }}</div>
                    </div>

                    <!-- Published At -->
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Tanggal & Waktu Publish</label>
                        <input v-model="form.published_at" type="datetime-local" class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500">
                        <div v-if="form.errors.published_at" class="text-red-500 text-sm mt-1">{{ form.errors.published_at }}</div>
                    </div>

                    <!-- Status -->
                    <div class="flex items-center gap-2">
                        <input v-model="form.is_published" type="checkbox" id="is_published" class="rounded text-emerald-600 focus:ring-emerald-500">
                        <label for="is_published" class="text-sm text-slate-700">Terbitkan Langsung</label>
                    </div>

                    <div class="mt-6 flex justify-end gap-3">
                        <button type="button" @click="closeModal" class="px-4 py-2 border border-slate-300 rounded-lg text-slate-700 hover:bg-slate-50">Batal</button>
                        <button type="submit" :disabled="form.processing" class="px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 disabled:opacity-50">
                            {{ form.processing ? 'Menyimpan...' : 'Simpan' }}
                        </button>
                    </div>
                </form>
            </div>
        </Modal>
    </AuthenticatedLayout>
</template>
