<script setup>
import { ref } from 'vue';
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import { 
    ArrowLeftIcon, 
    CheckCircleIcon, 
    ShieldCheckIcon,
    DocumentTextIcon,
    PaperClipIcon,
    InformationCircleIcon
} from '@heroicons/vue/24/outline';

const props = defineProps({
    service: Object,
});

const page = usePage();
const fileInput = ref(null);
const documentPreview = ref(null);

const form = useForm({
    service_id: props.service.id,
    service_name: props.service.title,
    applicant_name: '',
    nik: '',
    phone: '',
    address: '',
    notes: '',
    document: null,
});

const handleFileUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
        form.document = file;
        documentPreview.value = file.name;
    }
};

const submitApplication = () => {
    form.post(route('public.layanan_umat.submit', { service: props.service.slug }), {
        preserveScroll: true,
        onSuccess: () => {
            form.reset('applicant_name', 'nik', 'phone', 'address', 'notes', 'document');
            documentPreview.value = null;
        },
    });
};
</script>

<template>
    <Head :title="`${service.title} - Layanan Umat`" />

    <PublicLayout>
        <!-- Top Header Banner -->
        <div class="bg-gradient-to-r from-emerald-800 to-teal-900 text-white pt-28 pb-12 px-4 sm:px-6 lg:px-8">
            <div class="max-w-5xl mx-auto">
                <Link 
                    :href="route('public.layanan_umat.index')"
                    class="inline-flex items-center gap-2 text-xs font-bold text-emerald-200 hover:text-white mb-4 transition-colors"
                >
                    <ArrowLeftIcon class="w-4 h-4" /> Kembali ke Portal Layanan Umat
                </Link>
                <div class="flex items-center gap-3 mb-2">
                    <span class="px-3 py-1 bg-white/20 backdrop-blur-sm text-emerald-100 rounded-full text-xs font-bold uppercase tracking-wider">
                        {{ service.category }}
                    </span>
                </div>
                <h1 class="text-2xl sm:text-4xl font-black tracking-tight text-white mb-3">
                    {{ service.title }}
                </h1>
                <p class="text-emerald-100/90 text-sm max-w-3xl leading-relaxed">
                    {{ service.short_description }}
                </p>
            </div>
        </div>

        <!-- Success Flash Alert -->
        <div v-if="page.props.flash?.message" class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 mt-6">
            <div class="p-4 bg-emerald-50 border-l-4 border-emerald-500 rounded-r-xl dark:bg-emerald-950/40 dark:border-emerald-400 flex items-start gap-3 shadow-md">
                <CheckCircleIcon class="w-6 h-6 text-emerald-600 dark:text-emerald-400 shrink-0 mt-0.5" />
                <div>
                    <h4 class="font-bold text-emerald-900 dark:text-emerald-200 text-sm">Pengajuan Berhasil Dikirim!</h4>
                    <p class="text-sm text-emerald-700 dark:text-emerald-300 mt-1">{{ page.props.flash.message }}</p>
                </div>
            </div>
        </div>

        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                
                <!-- Left Details & Instructions (2 Cols) -->
                <div class="lg:col-span-2 space-y-8">
                    <!-- Description Card -->
                    <div class="bg-white dark:bg-slate-800 rounded-2xl p-6 border border-slate-200 dark:border-slate-700 shadow-sm">
                        <h3 class="text-base font-bold text-slate-900 dark:text-white mb-3 flex items-center gap-2">
                            <InformationCircleIcon class="w-5 h-5 text-emerald-600" /> Deskripsi Layanan
                        </h3>
                        <p class="text-xs text-slate-600 dark:text-slate-300 leading-relaxed whitespace-pre-line">
                            {{ service.description || service.short_description }}
                        </p>
                    </div>

                    <!-- Terms & Conditions Card -->
                    <div v-if="service.terms" class="bg-white dark:bg-slate-800 rounded-2xl p-6 border border-slate-200 dark:border-slate-700 shadow-sm">
                        <h3 class="text-base font-bold text-slate-900 dark:text-white mb-3 flex items-center gap-2">
                            <DocumentTextIcon class="w-5 h-5 text-emerald-600" /> Syarat & Ketentuan
                        </h3>
                        <div class="text-xs text-slate-600 dark:text-slate-300 leading-relaxed whitespace-pre-line bg-slate-50 dark:bg-slate-900/50 p-4 rounded-xl border border-slate-200/60 dark:border-slate-700/60 font-mono">
                            {{ service.terms }}
                        </div>
                    </div>

                    <!-- How to Apply Card -->
                    <div v-if="service.how_to_apply" class="bg-white dark:bg-slate-800 rounded-2xl p-6 border border-slate-200 dark:border-slate-700 shadow-sm">
                        <h3 class="text-base font-bold text-slate-900 dark:text-white mb-3 flex items-center gap-2">
                            <ShieldCheckIcon class="w-5 h-5 text-emerald-600" /> Alur & Cara Pengajuan
                        </h3>
                        <div class="text-xs text-slate-600 dark:text-slate-300 leading-relaxed whitespace-pre-line">
                            {{ service.how_to_apply }}
                        </div>
                    </div>
                </div>

                <!-- Right Form Submission (1 Col) -->
                <div>
                    <!-- External Link Option -->
                    <div v-if="service.external_link" class="bg-indigo-50 dark:bg-indigo-950/40 border border-indigo-200 dark:border-indigo-800 rounded-2xl p-6 text-center">
                        <div class="text-3xl mb-2">🚀</div>
                        <h3 class="text-base font-bold text-indigo-900 dark:text-indigo-200 mb-2">Terintegrasi Ke Fitur Khusus</h3>
                        <p class="text-xs text-indigo-700 dark:text-indigo-300 mb-4">Layanan ini dikelola secara langsung pada modul khusus PIMASJID.</p>
                        <a 
                            :href="service.external_link"
                            class="inline-block w-full py-3 bg-indigo-600 hover:bg-indigo-500 text-white font-bold text-xs rounded-xl shadow-md transition-all text-center"
                        >
                            Buka Layanan Terkait →
                        </a>
                    </div>

                    <!-- Online Application Form -->
                    <div v-else class="bg-white dark:bg-slate-800 rounded-2xl p-6 border border-slate-200 dark:border-slate-700 shadow-xl sticky top-24">
                        <div class="mb-4">
                            <h3 class="text-base font-bold text-slate-900 dark:text-white">Form Pengajuan Online</h3>
                            <p class="text-xs text-slate-500 dark:text-slate-400">Isi data lengkap Anda di bawah ini.</p>
                        </div>

                        <form @submit.prevent="submitApplication" class="space-y-3">
                            <div>
                                <label class="block text-[11px] font-bold text-slate-700 dark:text-slate-300 mb-1">Nama Lengkap Pemohon *</label>
                                <input 
                                    v-model="form.applicant_name"
                                    type="text" 
                                    required
                                    placeholder="Nama sesuai KTP"
                                    class="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                                />
                                <div v-if="form.errors.applicant_name" class="text-rose-500 text-[10px] mt-0.5">{{ form.errors.applicant_name }}</div>
                            </div>

                            <div>
                                <label class="block text-[11px] font-bold text-slate-700 dark:text-slate-300 mb-1">No. WhatsApp / Telepon *</label>
                                <input 
                                    v-model="form.phone"
                                    type="text" 
                                    required
                                    placeholder="082346719219"
                                    class="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                                />
                                <div v-if="form.errors.phone" class="text-rose-500 text-[10px] mt-0.5">{{ form.errors.phone }}</div>
                            </div>

                            <div>
                                <label class="block text-[11px] font-bold text-slate-700 dark:text-slate-300 mb-1">NIK (KTP) <span class="font-normal text-slate-400">(Opsional)</span></label>
                                <input 
                                    v-model="form.nik"
                                    type="text" 
                                    placeholder="3275xxxxxxxxxxxx"
                                    class="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                                />
                            </div>

                            <div>
                                <label class="block text-[11px] font-bold text-slate-700 dark:text-slate-300 mb-1">Alamat Pemohon *</label>
                                <textarea 
                                    v-model="form.address"
                                    rows="2"
                                    required
                                    placeholder="Alamat domisili..."
                                    class="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                                ></textarea>
                            </div>

                            <div>
                                <label class="block text-[11px] font-bold text-slate-700 dark:text-slate-300 mb-1">Detail / Alasan *</label>
                                <textarea 
                                    v-model="form.notes"
                                    rows="3"
                                    required
                                    placeholder="Rincian kebutuhan pengajuan..."
                                    class="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-slate-900 dark:text-white text-xs focus:ring-2 focus:ring-emerald-500"
                                ></textarea>
                            </div>

                            <div>
                                <label class="block text-[11px] font-bold text-slate-700 dark:text-slate-300 mb-1">Lampiran Dokumen</label>
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
                                    class="w-full py-2 px-3 rounded-xl border border-dashed border-slate-300 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 hover:bg-slate-100 dark:hover:bg-slate-800 text-[11px] text-slate-600 dark:text-slate-400 flex items-center justify-center gap-1.5"
                                >
                                    <PaperClipIcon class="w-4 h-4 text-emerald-600" />
                                    {{ documentPreview || 'Pilih File (JPG/PNG/PDF)' }}
                                </button>
                            </div>

                            <button 
                                type="submit" 
                                :disabled="form.processing"
                                class="w-full mt-2 py-3 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl font-bold text-xs shadow-md transition-all disabled:opacity-50"
                            >
                                {{ form.processing ? 'Mengirim...' : 'Kirim Pengajuan' }}
                            </button>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </PublicLayout>
</template>
