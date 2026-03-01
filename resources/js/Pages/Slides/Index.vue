<script setup>
import { ref, computed } from 'vue';
import { Head, useForm } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import Card from '@/Components/Card.vue';
import Badge from '@/Components/Badge.vue';
import { Switch } from '@headlessui/vue';
import { 
    PlusIcon, 
    PhotoIcon, 
    TrashIcon, 
    CheckCircleIcon, 
    TvIcon,
    ArrowUpTrayIcon,
    PencilSquareIcon,
    XMarkIcon
} from '@heroicons/vue/24/outline';

const props = defineProps({
    slides: Array,
});

// Form state
const slideForm = useForm({
    id: null,
    title: '',
    image: null,
    order: '',
});

const isEditing = computed(() => !!slideForm.id);
const imagePreview = ref(null);
const fileInput = ref(null);

// Handle file selection
const handleFileSelect = (event) => {
    const file = event.target.files[0];
    if (file) {
        slideForm.image = file;
        
        // Create preview
        const reader = new FileReader();
        reader.onload = (e) => {
            imagePreview.value = e.target.result;
        };
        reader.readAsDataURL(file);
    }
};

// Start editing a slide
const editSlide = (slide) => {
    slideForm.id = slide.id;
    slideForm.title = slide.title;
    slideForm.order = slide.order;
    slideForm.image = null; // Don't pre-fill with existing image file object
    imagePreview.value = slide.image_url;
    
    // Scroll to form
    window.scrollTo({ top: 0, behavior: 'smooth' });
};

// Cancel editing
const cancelEdit = () => {
    slideForm.reset();
    slideForm.id = null;
    imagePreview.value = null;
    if (fileInput.value) fileInput.value.value = '';
};

// Save or Update slide
const submitForm = () => {
    if (isEditing.value) {
        slideForm.post(route('slides.update', slideForm.id), {
            forceFormData: true,
            onSuccess: () => {
                cancelEdit();
            },
        });
    } else {
        slideForm.post(route('slides.store'), {
            forceFormData: true,
            onSuccess: () => {
                cancelEdit();
            },
        });
    }
};

// Toggle slide active status
const toggleSlide = (slideId) => {
    useForm({}).post(route('slides.toggle', slideId));
};

// Delete slide
const deleteSlide = (slideId) => {
    if (confirm('Hapus slide ini?')) {
        useForm({}).delete(route('slides.destroy', slideId));
    }
};
</script>

<template>
    <Head title="Kelola Slide TV" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex items-center gap-3">
                <div class="p-2 bg-emerald-100 rounded-xl">
                    <TvIcon class="w-6 h-6 text-emerald-600" />
                </div>
                <h2 class="font-black text-2xl text-slate-800 leading-tight">
                    Display TV Slides
                </h2>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-12">
                
                <!-- Slide Form (Create/Edit) -->
                <div :class="isEditing ? 'border-emerald-500 ring-4 ring-emerald-50' : 'border-slate-100'" 
                     class="bg-white rounded-[2.5rem] p-10 shadow-xl shadow-slate-200/60 border relative overflow-hidden transition-all duration-500">
                    <!-- Subtle Background Pattern -->
                    <div class="absolute top-0 right-0 p-12 opacity-[0.03] pointer-events-none">
                        <component :is="isEditing ? PencilSquareIcon : PlusIcon" class="w-64 h-64 -rotate-12" />
                    </div>

                    <div class="relative z-10 flex flex-col md:flex-row gap-12">
                        <!-- Left: Form Action -->
                        <div class="w-full md:w-1/2 space-y-6">
                            <div>
                                <div class="flex items-center justify-between mb-2">
                                    <h3 class="text-3xl font-black text-slate-800 flex items-center gap-3">
                                        {{ isEditing ? 'Edit Slide' : 'Tambah Slide Baru' }}
                                    </h3>
                                    <button v-if="isEditing" @click="cancelEdit" class="text-xs font-black text-rose-500 uppercase tracking-widest flex items-center gap-1 hover:text-rose-600 transition-colors">
                                        <XMarkIcon class="w-4 h-4" />
                                        Batal Edit
                                    </button>
                                </div>
                                <p class="text-slate-500 font-medium leading-relaxed">
                                    {{ isEditing ? 'Perbarui informasi slide yang sudah ada.' : 'Upload gambar pengumuman atau kegiatan untuk ditampilkan di layar TV Masjid secara real-time.' }}
                                </p>
                            </div>

                            <div class="space-y-5">
                                <div class="space-y-2">
                                    <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Judul Konten</label>
                                    <input
                                        v-model="slideForm.title"
                                        type="text"
                                        class="w-full rounded-2xl border-slate-200 py-3.5 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold transition-all bg-slate-50/50 hover:bg-white"
                                        placeholder="Misal: Kajian Subuh Rutin"
                                    />
                                </div>

                                <div class="space-y-2">
                                    <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">
                                        {{ isEditing ? 'Ganti Gambar (Opsional)' : 'Pilih Gambar' }}
                                    </label>
                                    <input
                                        ref="fileInput"
                                        type="file"
                                        @change="handleFileSelect"
                                        accept="image/*"
                                        class="hidden"
                                    />
                                    <div 
                                        @click="$refs.fileInput.click()"
                                        class="group cursor-pointer relative py-8 px-6 border-2 border-dashed border-slate-200 bg-slate-50/50 hover:bg-white hover:border-emerald-400 rounded-3xl transition-all duration-300 flex flex-col items-center justify-center text-center gap-3"
                                    >
                                        <div class="p-4 bg-white rounded-2xl shadow-sm text-slate-400 group-hover:text-emerald-500 group-hover:scale-110 transition-all">
                                            <ArrowUpTrayIcon class="w-8 h-8" />
                                        </div>
                                        <div>
                                            <p class="font-bold text-slate-700 group-hover:text-emerald-600 transition-colors">
                                                {{ slideForm.image ? slideForm.image.name : (isEditing ? 'Pilih gambar baru' : 'Klik untuk Unggah') }}
                                            </p>
                                            <p class="text-xs text-slate-400 mt-1 font-medium">PNG, JPG, JPEG (Maks. 5MB)</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="flex gap-4">
                                    <div class="flex-1 space-y-2">
                                        <label class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1">Urutan Tampil</label>
                                        <input
                                            v-model="slideForm.order"
                                            type="number"
                                            class="w-full rounded-2xl border-slate-200 py-3.5 text-slate-900 shadow-sm focus:border-emerald-500 focus:ring-emerald-500 font-bold transition-all bg-slate-50/50 hover:bg-white"
                                            placeholder="1, 2, 3..."
                                        />
                                    </div>
                                    <div class="flex items-end">
                                        <button
                                            @click="submitForm"
                                            :disabled="!slideForm.title || (!isEditing && !slideForm.image) || slideForm.processing"
                                            class="px-8 py-3.5 bg-emerald-600 text-white font-black rounded-2xl shadow-xl shadow-emerald-200 hover:bg-emerald-700 active:scale-95 transition-all disabled:opacity-50 disabled:grayscale"
                                        >
                                            <span v-if="slideForm.processing">Memproses...</span>
                                            <span v-else class="flex items-center gap-2">
                                                <CheckCircleIcon class="w-5 h-5" />
                                                {{ isEditing ? 'Perbarui Slide' : 'Simpan Slide' }}
                                            </span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right: Preview Space -->
                        <div class="flex-1 min-h-[300px]">
                            <div class="h-full flex flex-col">
                                <span class="text-xs font-black text-slate-400 uppercase tracking-widest pl-1 mb-3">Tampilan Pratinjau</span>
                                <div
                                    class="flex-1 bg-slate-100 rounded-[2rem] border-2 border-slate-100 overflow-hidden shadow-inner relative group"
                                >
                                    <div v-if="imagePreview" class="h-full w-full">
                                        <img :src="imagePreview" class="w-full h-full object-cover" />
                                        <div class="absolute inset-x-0 bottom-0 p-8 bg-gradient-to-t from-black/80 via-black/40 to-transparent">
                                            <h4 class="text-white text-3xl font-black mb-1 truncate">{{ slideForm.title || 'Judul Slide' }}</h4>
                                            <p class="text-white/80 font-medium">{{ isEditing ? 'Pratinjau Perubahan' : 'Draft Slide Baru' }}</p>
                                        </div>
                                    </div>
                                    <div v-else class="h-full w-full flex flex-col items-center justify-center text-slate-300 gap-4">
                                        <div class="p-8 bg-white/50 rounded-full">
                                            <TvIcon class="w-20 h-20 opacity-20" />
                                        </div>
                                        <p class="font-bold tracking-wide italic opacity-40">Preview slide tampil di sini</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Existing Slides List -->
                <div class="space-y-8">
                    <div class="flex items-end justify-between px-2">
                        <div>
                            <h3 class="text-2xl font-black text-slate-800">Konten Tersimpan</h3>
                            <p class="text-slate-500 font-medium">Klik pada kartu untuk mengedit konten.</p>
                        </div>
                        <Badge variant="neutral" size="lg" class="px-4 py-2 font-black rounded-xl">
                            TOTAL: {{ slides.length }}
                        </Badge>
                    </div>

                    <div v-if="slides.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                        <div
                            v-for="slide in slides"
                            :key="slide.id"
                            @click="editSlide(slide)"
                            :class="slideForm.id === slide.id ? 'ring-4 ring-emerald-500 border-emerald-500' : 'border-slate-100 hover:shadow-2xl hover:-translate-y-1'"
                            class="bg-white rounded-[2rem] p-4 shadow-lg shadow-slate-200/50 border transition-all duration-300 group cursor-pointer relative"
                        >
                            <!-- Edit Indicator Overlay -->
                            <div v-if="slideForm.id === slide.id" class="absolute inset-0 bg-emerald-500/10 rounded-[2rem] z-10 flex items-center justify-center pointer-events-none">
                                <div class="bg-white p-3 rounded-full shadow-lg text-emerald-600">
                                    <PencilSquareIcon class="w-6 h-6" />
                                </div>
                            </div>

                            <!-- Thumbnail Area -->
                            <div class="relative aspect-video rounded-3xl overflow-hidden bg-slate-100 mb-4">
                                <img
                                    :src="slide.image_url"
                                    :alt="slide.title"
                                    class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                                />
                                <!-- Quick Status Badge -->
                                <div 
                                    :class="slide.is_active ? 'bg-emerald-500' : 'bg-slate-400'"
                                    class="absolute top-4 left-4 flex items-center gap-2 px-3 py-1.5 rounded-full text-white text-[10px] font-black uppercase tracking-wider shadow-lg"
                                >
                                    <div class="w-1.5 h-1.5 rounded-full bg-white animate-pulse"></div>
                                    {{ slide.is_active ? 'Aktif' : 'Non-Aktif' }}
                                </div>

                                <!-- Slide Order Pin -->
                                <div class="absolute top-4 right-4 bg-white/90 backdrop-blur px-3 py-1.5 rounded-xl text-slate-800 text-[10px] font-black shadow-lg">
                                    #{{ slide.order }}
                                </div>
                            </div>

                            <!-- Content Area -->
                            <div class="px-2 pb-2 space-y-4">
                                <div>
                                    <h4 class="text-lg font-black text-slate-800 truncate line-clamp-1 h-7">{{ slide.title }}</h4>
                                    <p class="text-xs text-slate-400 font-medium italic">
                                        Diunggah pada {{ slide.formatted_date }}
                                    </p>
                                </div>

                                <div class="flex items-center justify-between gap-3 pt-2">
                                    <div class="flex items-center gap-2" @click.stop>
                                        <Switch
                                            :model-value="slide.is_active"
                                            @update:model-value="toggleSlide(slide.id)"
                                            :class="slide.is_active ? 'bg-emerald-600' : 'bg-slate-200'"
                                            class="relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-emerald-600 focus:ring-offset-2"
                                        >
                                            <span class="sr-only">Toggle slide active status</span>
                                            <span
                                                aria-hidden="true"
                                                :class="slide.is_active ? 'translate-x-5' : 'translate-x-0'"
                                                class="pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
                                            />
                                        </Switch>
                                        <span class="text-xs font-black text-slate-500">{{ slide.is_active ? 'Matikan' : 'Aktifkan' }}</span>
                                    </div>
                                    
                                    <button
                                        @click.stop="deleteSlide(slide.id)"
                                        class="p-2.5 bg-rose-50 text-rose-500 rounded-xl hover:bg-rose-500 hover:text-white transition-all duration-300"
                                        title="Hapus Slide"
                                    >
                                        <TrashIcon class="w-5 h-5" />
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Empty State -->
                    <div v-else class="bg-white rounded-[3rem] p-16 text-center border border-dashed border-slate-200">
                        <div class="w-24 h-24 bg-slate-50 rounded-full flex items-center justify-center mx-auto mb-6">
                            <TvIcon class="w-12 h-12 text-slate-200" />
                        </div>
                        <h3 class="text-2xl font-black text-slate-800 mb-2">Belum ada slide display</h3>
                        <p class="text-slate-400 font-medium max-w-sm mx-auto">Upload gambar pertama Anda untuk menghidupkan layar TV Masjid.</p>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<style scoped>
.line-clamp-1 {
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
</style>
