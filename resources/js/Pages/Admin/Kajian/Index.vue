<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm, router, Link } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { 
    PlusIcon, 
    PencilSquareIcon, 
    TrashIcon, 
    MagnifyingGlassIcon,
    XMarkIcon,
    PhotoIcon
} from '@heroicons/vue/24/outline';
import { Dialog, DialogPanel, DialogTitle, TransitionChild, TransitionRoot } from '@headlessui/vue';

const props = defineProps({
    kajians: Object,
});

const showModal = ref(false);
const editingKajian = ref(null);
const imagePreview = ref(null);
const ustazPreview = ref(null);

const form = useForm({
    title: '',
    theme: '',
    ustaz_name: '',
    ustaz_topic: '',
    ustaz_bio: '',
    date: '',
    time: '',
    location: '',
    description: '',
    video_url: '',
    status: 'akan_datang',
    banner_image: null,
    ustaz_image: null,
});

const openModal = (kajian = null) => {
    editingKajian.value = kajian;
    imagePreview.value = null;
    ustazPreview.value = null;
    
    if (kajian) {
        form.title = kajian.title;
        form.theme = kajian.theme || '';
        form.ustaz_name = kajian.ustaz_name;
        form.ustaz_topic = kajian.ustaz_topic || '';
        form.ustaz_bio = kajian.ustaz_bio || '';
        form.date = kajian.date;
        form.time = kajian.time.substring(0, 5);
        form.location = kajian.location;
        form.description = kajian.description || '';
        form.video_url = kajian.video_url || '';
        form.status = kajian.status;
        form.banner_image = null;
        form.ustaz_image = null;
        imagePreview.value = kajian.banner || null;
        ustazPreview.value = kajian.ustaz_photo || null;
    } else {
        form.reset();
        form.status = 'akan_datang';
    }
    showModal.value = true;
};

const closeModal = () => {
    showModal.value = false;
    editingKajian.value = null;
    form.reset();
};

const handleImageChange = (e, type) => {
    const file = e.target.files[0];
    if (file) {
        if (type === 'banner') {
            form.banner_image = file;
        } else {
            form.ustaz_image = file;
        }
        const reader = new FileReader();
        reader.onload = (e) => {
            if (type === 'banner') {
                imagePreview.value = e.target.result;
            } else {
                ustazPreview.value = e.target.result;
            }
        };
        reader.readAsDataURL(file);
    } else {
        if (type === 'banner') {
            imagePreview.value = null;
            form.banner_image = null;
        } else {
            ustazPreview.value = null;
            form.ustaz_image = null;
        }
    }
};

const submit = () => {
    if (editingKajian.value) {
        form
            .transform(data => ({
                ...data,
                _method: 'PUT',
            }))
            .post(route('admin.kajian.update', editingKajian.value.id), {
                forceFormData: true,
                preserveScroll: true,
                onSuccess: () => closeModal(),
            });
    } else {
        form.post(route('admin.kajian.store'), {
            forceFormData: true,
            preserveScroll: true,
            onSuccess: () => closeModal(),
        });
    }
};

const deleteKajian = (id) => {
    if (confirm('Apakah Anda yakin ingin menghapus kajian ini?')) {
        router.delete(route('admin.kajian.destroy', id));
    }
};
</script>

<template>
    <Head title="Kelola Kajian Rutin" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
                <h2 class="font-semibold text-xl text-slate-800 leading-tight">Kelola Kajian Rutin</h2>
                <button 
                    @click="openModal()"
                    class="px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-sm font-medium flex items-center justify-center gap-2 transition-colors"
                >
                    <PlusIcon class="w-5 h-5" />
                    Tambah Kajian
                </button>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <!-- Data Table -->
                <div class="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-slate-50 border-b border-slate-100">
                                    <th class="px-6 py-4 text-sm font-semibold text-slate-600">Judul Kajian</th>
                                    <th class="px-6 py-4 text-sm font-semibold text-slate-600">Pemateri</th>
                                    <th class="px-6 py-4 text-sm font-semibold text-slate-600">Jadwal</th>
                                    <th class="px-6 py-4 text-sm font-semibold text-slate-600">Status</th>
                                    <th class="px-6 py-4 text-sm font-semibold text-slate-600 text-right">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="kajian in kajians.data" :key="kajian.id" class="border-b border-slate-50 hover:bg-slate-50 transition-colors">
                                    <td class="px-6 py-4">
                                        <div class="font-medium text-slate-800">{{ kajian.title }}</div>
                                        <div class="text-xs text-slate-500">{{ kajian.theme }}</div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="text-sm text-slate-700">{{ kajian.ustaz_name }}</div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div class="text-sm text-slate-700">{{ kajian.date }}</div>
                                        <div class="text-xs text-slate-500">{{ kajian.time.substring(0,5) }} WIB</div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium capitalize"
                                            :class="{
                                                'bg-blue-100 text-blue-800': kajian.status === 'akan_datang',
                                                'bg-emerald-100 text-emerald-800': kajian.status === 'berlangsung',
                                                'bg-slate-100 text-slate-800': kajian.status === 'selesai'
                                            }">
                                            {{ kajian.status.replace('_', ' ') }}
                                        </span>
                                    </td>
                                    <td class="px-6 py-4 text-right">
                                        <div class="flex justify-end gap-2">
                                            <button @click="openModal(kajian)" class="p-2 text-amber-500 hover:bg-amber-50 rounded-lg transition-colors">
                                                <PencilSquareIcon class="w-5 h-5" />
                                            </button>
                                            <button @click="deleteKajian(kajian.id)" class="p-2 text-rose-500 hover:bg-rose-50 rounded-lg transition-colors">
                                                <TrashIcon class="w-5 h-5" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr v-if="kajians.data.length === 0">
                                    <td colspan="5" class="px-6 py-12 text-center text-slate-500">
                                        Belum ada data kajian.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Pagination -->
                <div v-if="kajians.links && kajians.links.length > 3" class="mt-6 flex justify-center">
                    <div class="flex flex-wrap gap-1">
                        <template v-for="(link, k) in kajians.links" :key="k">
                            <div v-if="link.url === null" class="px-4 py-2 text-sm text-slate-400 border rounded-lg bg-white" v-html="link.label"></div>
                            <Link v-else :href="link.url" class="px-4 py-2 text-sm border rounded-lg bg-white hover:bg-slate-50" :class="{'bg-emerald-50 text-emerald-600 border-emerald-200 font-bold': link.active}" v-html="link.label"></Link>
                        </template>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <TransitionRoot as="template" :show="showModal">
            <Dialog as="div" class="relative z-50" @close="closeModal">
                <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0" enter-to="opacity-100" leave="ease-in duration-200" leave-from="opacity-100" leave-to="opacity-0">
                    <div class="fixed inset-0 bg-slate-900/75 transition-opacity" />
                </TransitionChild>

                <div class="fixed inset-0 z-10 overflow-y-auto">
                    <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
                        <TransitionChild as="template" enter="ease-out duration-300" enter-from="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95" enter-to="opacity-100 translate-y-0 sm:scale-100" leave="ease-in duration-200" leave-from="opacity-100 translate-y-0 sm:scale-100" leave-to="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95">
                            <DialogPanel class="relative transform overflow-hidden rounded-2xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-2xl">
                                <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                                    <div class="flex justify-between items-center mb-5 border-b pb-3">
                                        <DialogTitle as="h3" class="text-lg font-semibold leading-6 text-slate-900">
                                            {{ editingKajian ? 'Edit Kajian' : 'Tambah Kajian Baru' }}
                                        </DialogTitle>
                                        <button @click="closeModal" class="text-slate-400 hover:text-slate-600">
                                            <XMarkIcon class="w-6 h-6" />
                                        </button>
                                    </div>
                                    
                                    <form @submit.prevent="submit" class="space-y-4">
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-1">Judul Kajian</label>
                                                <input v-model="form.title" type="text" class="w-full rounded-lg border-slate-300 focus:border-emerald-500" required>
                                                <div v-if="form.errors.title" class="text-red-500 text-xs mt-1">{{ form.errors.title }}</div>
                                            </div>
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-1">Tema (Opsional)</label>
                                                <input v-model="form.theme" type="text" class="w-full rounded-lg border-slate-300 focus:border-emerald-500">
                                            </div>
                                        </div>

                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-1">Nama Ustaz</label>
                                                <input v-model="form.ustaz_name" type="text" class="w-full rounded-lg border-slate-300 focus:border-emerald-500" required>
                                                <div v-if="form.errors.ustaz_name" class="text-red-500 text-xs mt-1">{{ form.errors.ustaz_name }}</div>
                                            </div>
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-1">Bidang / Topik Ustaz (Opsional)</label>
                                                <input v-model="form.ustaz_topic" type="text" class="w-full rounded-lg border-slate-300 focus:border-emerald-500">
                                            </div>
                                        </div>

                                        <div class="grid grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-1">Tanggal</label>
                                                <input v-model="form.date" type="date" class="w-full rounded-lg border-slate-300 focus:border-emerald-500" required>
                                            </div>
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-1">Waktu</label>
                                                <input v-model="form.time" type="time" class="w-full rounded-lg border-slate-300 focus:border-emerald-500" required>
                                            </div>
                                        </div>

                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-1">Lokasi</label>
                                                <input v-model="form.location" type="text" class="w-full rounded-lg border-slate-300 focus:border-emerald-500" required>
                                            </div>
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-1">Status</label>
                                                <select v-model="form.status" class="w-full rounded-lg border-slate-300 focus:border-emerald-500">
                                                    <option value="akan_datang">Akan Datang</option>
                                                    <option value="berlangsung">Berlangsung</option>
                                                    <option value="selesai">Selesai</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div>
                                            <label class="block text-sm font-medium text-slate-700 mb-1">Deskripsi & Biografi Singkat</label>
                                            <textarea v-model="form.description" rows="3" class="w-full rounded-lg border-slate-300 focus:border-emerald-500"></textarea>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-medium text-slate-700 mb-1">URL YouTube Live / Rekaman (Opsional)</label>
                                            <input v-model="form.video_url" type="url" placeholder="https://youtube.com/..." class="w-full rounded-lg border-slate-300 focus:border-emerald-500">
                                        </div>

                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-2">
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">Upload Banner</label>
                                                <div class="border-2 border-dashed border-slate-300 rounded-lg p-4 text-center hover:bg-slate-50 transition-colors relative" :class="{'bg-slate-50': imagePreview}">
                                                    <input
                                                        type="file"
                                                        accept="image/*"
                                                        @change="(e) => handleImageChange(e, 'banner')"
                                                        class="absolute inset-0 w-full h-full opacity-0 cursor-pointer">
                                                    <div v-if="!imagePreview">
                                                        <PhotoIcon class="mx-auto h-12 w-12 text-slate-400" />
                                                        <span class="mt-2 block text-sm font-semibold text-slate-900">Pilih gambar</span>
                                                    </div>
                                                    <img v-else :src="imagePreview" class="mx-auto h-32 object-contain rounded-md" />
                                                </div>
                                            </div>
                                            <div>
                                                <label class="block text-sm font-medium text-slate-700 mb-2">Upload Foto Ustaz</label>
                                                <div class="border-2 border-dashed border-slate-300 rounded-lg p-4 text-center hover:bg-slate-50 transition-colors relative" :class="{'bg-slate-50': ustazPreview}">
                                                    <input
                                                        type="file"
                                                        accept="image/*"
                                                        @change="(e) => handleImageChange(e, 'ustaz')"
                                                        class="absolute inset-0 w-full h-full opacity-0 cursor-pointer">
                                                    <div v-if="!ustazPreview">
                                                        <PhotoIcon class="mx-auto h-12 w-12 text-slate-400" />
                                                        <span class="mt-2 block text-sm font-semibold text-slate-900">Pilih gambar</span>
                                                    </div>
                                                    <img v-else :src="ustazPreview" class="mx-auto h-32 object-contain rounded-md" />
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mt-6 flex justify-end gap-3 pt-4 border-t">
                                            <button type="button" class="px-4 py-2 bg-slate-100 text-slate-700 rounded-lg hover:bg-slate-200 transition-colors font-medium" @click="closeModal">Batal</button>
                                            <button type="submit" class="px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors font-medium" :disabled="form.processing">
                                                {{ editingKajian ? 'Simpan Perubahan' : 'Buat Kajian' }}
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </DialogPanel>
                        </TransitionChild>
                    </div>
                </div>
            </Dialog>
        </TransitionRoot>
    </AuthenticatedLayout>
</template>
