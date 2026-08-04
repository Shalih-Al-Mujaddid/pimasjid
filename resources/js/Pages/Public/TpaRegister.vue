<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import {
    UserIcon,
    ClipboardDocumentListIcon,
    CheckCircleIcon,
    MagnifyingGlassIcon,
    PhoneIcon,
    AcademicCapIcon,
    CalendarDaysIcon,
    ClockIcon,
    MapPinIcon,
    UserGroupIcon
} from '@heroicons/vue/24/outline';

const props = defineProps({
    students: {
        type: Array,
        default: () => []
    }
});

const activeTab = ref('register');

const form = useForm({
    nama_anak: '',
    tempat_lahir: '',
    tanggal_lahir: '',
    jenis_kelamin: 'L',
    tingkat_sekolah: 'TK',
    nama_ortu: '',
    no_wa: '',
    alamat: ''
});

const isSubmitted = ref(false);
const isLoading = computed(() => form.processing);

const submitForm = () => {
    form.post(route('public.tpa.register.store'), {
        onSuccess: () => {
            isSubmitted.value = true;
        }
    });
};

const selectedClassFilter = ref('Semua Kelas');
const classes = ['Semua Kelas', 'Iqro 1-3', 'Iqro 4-6', 'Al-Quran', 'Tahfidz'];
const searchQuery = ref('');

const mockStudents = computed(() => props.students || []);

const filteredStudents = computed(() => {
    return mockStudents.value.filter(s => {
        const matchKelas = selectedClassFilter.value === 'Semua Kelas' || s.kelas === selectedClassFilter.value;
        const matchNama = s.nama.toLowerCase().includes(searchQuery.value.toLowerCase());
        return matchKelas && matchNama;
    });
});

const jadwalKelas = [
    { kelas: 'Iqro 1 - 3', hari: 'Senin & Rabu', waktu: '16.00 - 17.00 WIB', pengajar: 'Ust. Rahman', ket: 'Untuk usia 4-7 tahun' },
    { kelas: 'Iqro 4 - 6', hari: 'Selasa & Kamis', waktu: '16.00 - 17.00 WIB', pengajar: 'Usth. Nisa', ket: 'Untuk usia 7-10 tahun' },
    { kelas: 'Al-Quran', hari: 'Senin - Kamis', waktu: '17.00 - 17.30 WIB', pengajar: 'Ust. Hasan', ket: 'Sudah lulus Iqro 6' },
    { kelas: 'Tahfidz Juz 30', hari: 'Jumat', waktu: '08.00 - 10.00 WIB', pengajar: 'Usth. Maryam', ket: 'Seleksi khusus' },
];
</script>

<template>
    <Head title="Pusat Informasi TPA - Masjid Bakri" />
    <PublicLayout>

        <!-- Hero Header -->
        <div class="relative bg-bakri-navy overflow-hidden">
            <div class="absolute -top-20 -right-20 w-72 h-72 bg-bakri-teal/10 rounded-full pointer-events-none"></div>
            <div class="absolute -bottom-16 -left-16 w-56 h-56 bg-bakri-lime/10 rounded-full pointer-events-none"></div>
            <div class="relative max-w-5xl mx-auto px-4 sm:px-6 pt-32 pb-20 text-center">
                <span class="inline-flex items-center gap-1.5 text-xs font-semibold uppercase tracking-widest text-bakri-lime mb-4">
                    <AcademicCapIcon class="w-4 h-4" />
                    Masjid Bakri
                </span>
                <h1 class="text-3xl sm:text-4xl md:text-5xl font-bold text-white leading-tight mb-4">
                    Taman Pendidikan Al-Quran
                </h1>
                <p class="text-slate-300 text-base sm:text-lg max-w-xl mx-auto">
                    Mendampingi buah hati Anda mengenal dan mencintai Al-Quran sejak dini.
                </p>
            </div>
        </div>

        <!-- Main Content -->
        <div class="bg-slate-50 min-h-screen">
            <div class="max-w-5xl mx-auto px-4 sm:px-6 py-10 pb-28">

                <!-- Tab Switcher -->
                <div class="flex bg-white border border-slate-200 rounded-xl p-1 mb-8 shadow-sm w-full sm:w-fit mx-auto">
                    <button
                        @click="activeTab = 'register'"
                        class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-5 py-2.5 rounded-lg text-sm font-semibold transition-all duration-200"
                        :class="activeTab === 'register' ? 'bg-bakri-teal text-white shadow-sm' : 'text-slate-500 hover:text-slate-800'"
                    >
                        <UserIcon class="w-4 h-4" />
                        Pendaftaran
                    </button>
                    <button
                        @click="activeTab = 'mading'"
                        class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-5 py-2.5 rounded-lg text-sm font-semibold transition-all duration-200"
                        :class="activeTab === 'mading' ? 'bg-bakri-teal text-white shadow-sm' : 'text-slate-500 hover:text-slate-800'"
                    >
                        <ClipboardDocumentListIcon class="w-4 h-4" />
                        Mading Kelas
                    </button>
                    <button
                        @click="activeTab = 'jadwal'"
                        class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-5 py-2.5 rounded-lg text-sm font-semibold transition-all duration-200"
                        :class="activeTab === 'jadwal' ? 'bg-bakri-teal text-white shadow-sm' : 'text-slate-500 hover:text-slate-800'"
                    >
                        <CalendarDaysIcon class="w-4 h-4" />
                        Jadwal Kelas
                    </button>
                </div>

                <!-- ===== TAB: PENDAFTARAN ===== -->
                <div v-show="activeTab === 'register'">

                    <!-- Success State -->
                    <Transition
                        enter-active-class="transition duration-300 ease-out"
                        enter-from-class="opacity-0 translate-y-4"
                        enter-to-class="opacity-100 translate-y-0"
                    >
                        <div v-if="isSubmitted" class="bg-white rounded-2xl border border-slate-200 shadow-sm p-10 sm:p-14 text-center">
                            <div class="w-16 h-16 rounded-full bg-green-50 border-2 border-green-200 flex items-center justify-center mx-auto mb-6">
                                <CheckCircleIcon class="w-8 h-8 text-green-500" />
                            </div>
                            <h2 class="text-2xl font-bold text-slate-800 mb-2">Pendaftaran Diterima</h2>
                            <p class="text-slate-500 text-sm mb-8 max-w-sm mx-auto">
                                Terima kasih! Data ananda <strong class="text-bakri-teal">{{ form.nama_anak }}</strong> telah kami catat. Admin akan menghubungi Anda via WhatsApp dalam 1x24 jam.
                            </p>
                            <div class="flex flex-col sm:flex-row justify-center gap-3">
                                <button
                                    @click="isSubmitted = false; form.reset()"
                                    class="w-full sm:w-auto px-6 py-2.5 rounded-lg border border-bakri-teal text-bakri-teal text-sm font-semibold hover:bg-bakri-teal hover:text-white transition-colors"
                                >
                                    Daftarkan Anak Lainnya
                                </button>
                                <Link href="/" class="w-full sm:w-auto px-6 py-2.5 rounded-lg bg-bakri-teal text-white text-sm font-semibold hover:bg-bakri-navy transition-colors text-center">
                                    Kembali ke Beranda
                                </Link>
                            </div>
                        </div>
                    </Transition>

                    <!-- Registration Form -->
                    <div v-if="!isSubmitted" class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="h-1.5 w-full bg-gradient-to-r from-bakri-teal to-bakri-lime"></div>
                        <form @submit.prevent="submitForm" class="p-6 sm:p-8 md:p-10">

                            <!-- Section 1: Data Santri -->
                            <div class="mb-10">
                                <h3 class="text-base font-bold text-slate-800 mb-1 flex items-center gap-2">
                                    <span class="w-5 h-5 rounded-full bg-bakri-teal text-white text-xs flex items-center justify-center font-bold">1</span>
                                    Data Calon Santri
                                </h3>
                                <p class="text-xs text-slate-400 mb-6 ml-7">Isi sesuai data akte kelahiran anak.</p>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                                    <div class="sm:col-span-2">
                                        <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Nama Lengkap Anak <span class="text-red-400">*</span></label>
                                        <input v-model="form.nama_anak" type="text" class="w-full border border-slate-200 bg-slate-50 rounded-lg px-3.5 py-2.5 text-sm text-slate-800 placeholder-slate-300 focus:outline-none focus:border-bakri-teal focus:bg-white focus:ring-2 focus:ring-bakri-teal/20 transition" placeholder="Nama sesuai akte kelahiran" required>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Tempat Lahir <span class="text-red-400">*</span></label>
                                        <input v-model="form.tempat_lahir" type="text" class="w-full border border-slate-200 bg-slate-50 rounded-lg px-3.5 py-2.5 text-sm text-slate-800 placeholder-slate-300 focus:outline-none focus:border-bakri-teal focus:bg-white focus:ring-2 focus:ring-bakri-teal/20 transition" placeholder="Kota kelahiran" required>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Tanggal Lahir <span class="text-red-400">*</span></label>
                                        <input v-model="form.tanggal_lahir" type="date" class="w-full border border-slate-200 bg-slate-50 rounded-lg px-3.5 py-2.5 text-sm text-slate-800 focus:outline-none focus:border-bakri-teal focus:bg-white focus:ring-2 focus:ring-bakri-teal/20 transition" required>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Jenis Kelamin <span class="text-red-400">*</span></label>
                                        <div class="flex gap-3">
                                            <label class="flex-1 flex items-center justify-center py-2.5 border rounded-lg cursor-pointer text-sm font-medium transition"
                                                :class="form.jenis_kelamin === 'L' ? 'border-bakri-teal bg-bakri-teal/5 text-bakri-teal' : 'border-slate-200 bg-slate-50 text-slate-500 hover:border-slate-300'">
                                                <input type="radio" v-model="form.jenis_kelamin" value="L" class="hidden">
                                                Laki-laki
                                            </label>
                                            <label class="flex-1 flex items-center justify-center py-2.5 border rounded-lg cursor-pointer text-sm font-medium transition"
                                                :class="form.jenis_kelamin === 'P' ? 'border-rose-400 bg-rose-50 text-rose-500' : 'border-slate-200 bg-slate-50 text-slate-500 hover:border-slate-300'">
                                                <input type="radio" v-model="form.jenis_kelamin" value="P" class="hidden">
                                                Perempuan
                                            </label>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Pendidikan Saat Ini</label>
                                        <select v-model="form.tingkat_sekolah" class="w-full border border-slate-200 bg-slate-50 rounded-lg px-3.5 py-2.5 text-sm text-slate-800 focus:outline-none focus:border-bakri-teal focus:bg-white focus:ring-2 focus:ring-bakri-teal/20 transition">
                                            <option value="Belum Sekolah">Belum Sekolah</option>
                                            <option value="TK">PAUD / TK</option>
                                            <option value="SD">SD / Sederajat</option>
                                            <option value="SMP">SMP / Sederajat</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="border-t border-slate-100 mb-10"></div>

                            <!-- Section 2: Data Orang Tua -->
                            <div class="mb-10">
                                <h3 class="text-base font-bold text-slate-800 mb-1 flex items-center gap-2">
                                    <span class="w-5 h-5 rounded-full bg-bakri-teal text-white text-xs flex items-center justify-center font-bold">2</span>
                                    Data Orang Tua / Wali
                                </h3>
                                <p class="text-xs text-slate-400 mb-6 ml-7">Nomor WhatsApp akan digunakan untuk konfirmasi oleh pengurus.</p>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Nama Orang Tua / Wali <span class="text-red-400">*</span></label>
                                        <input v-model="form.nama_ortu" type="text" class="w-full border border-slate-200 bg-slate-50 rounded-lg px-3.5 py-2.5 text-sm text-slate-800 placeholder-slate-300 focus:outline-none focus:border-bakri-teal focus:bg-white focus:ring-2 focus:ring-bakri-teal/20 transition" placeholder="Nama Ayah / Ibu / Wali" required>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">No. WhatsApp Aktif <span class="text-red-400">*</span></label>
                                        <div class="relative">
                                            <PhoneIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                                            <input v-model="form.no_wa" type="tel" class="w-full border border-slate-200 bg-slate-50 rounded-lg pl-9 pr-3.5 py-2.5 text-sm text-slate-800 placeholder-slate-300 focus:outline-none focus:border-bakri-teal focus:bg-white focus:ring-2 focus:ring-bakri-teal/20 transition" placeholder="0812xxxxxxxx" required>
                                        </div>
                                    </div>
                                    <div class="sm:col-span-2">
                                        <label class="block text-xs font-semibold text-slate-600 mb-1.5 uppercase tracking-wide">Alamat Domisili <span class="text-red-400">*</span></label>
                                        <textarea v-model="form.alamat" rows="3" class="w-full border border-slate-200 bg-slate-50 rounded-lg px-3.5 py-2.5 text-sm text-slate-800 placeholder-slate-300 focus:outline-none focus:border-bakri-teal focus:bg-white focus:ring-2 focus:ring-bakri-teal/20 transition resize-none" placeholder="Jalan, RT/RW, Kelurahan, Kecamatan..." required></textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="flex flex-col-reverse sm:flex-row justify-between items-center gap-3 pt-6 border-t border-slate-100">
                                <p class="text-xs text-slate-400"><span class="text-red-400">*</span> Wajib diisi</p>
                                <div class="flex flex-col sm:flex-row gap-3 w-full sm:w-auto">
                                    <Link href="/" class="w-full sm:w-auto px-5 py-2.5 rounded-lg border border-slate-200 text-slate-500 text-sm font-semibold text-center hover:border-slate-300 hover:text-slate-700 transition">
                                        Batal
                                    </Link>
                                    <button type="submit" :disabled="isLoading" class="w-full sm:w-auto px-8 py-2.5 rounded-lg bg-bakri-teal text-white text-sm font-semibold hover:bg-bakri-navy transition disabled:opacity-60 flex items-center justify-center gap-2">
                                        <svg v-if="isLoading" class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/>
                                        </svg>
                                        {{ isLoading ? 'Mengirim...' : 'Kirim Pendaftaran' }}
                                    </button>
                                </div>
                            </div>

                        </form>
                    </div>
                </div>
                <!-- ===== END TAB: PENDAFTARAN ===== -->

                <!-- ===== TAB: MADING KELAS ===== -->
                <div v-show="activeTab === 'mading'">
                    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="h-1.5 w-full bg-gradient-to-r from-bakri-teal to-bakri-lime"></div>
                        <div class="p-6 sm:p-8 md:p-10">

                            <div class="mb-6">
                                <h2 class="text-lg font-bold text-slate-800 mb-1">Papan Informasi Santri</h2>
                                <p class="text-xs text-slate-400">Pantau progres dan catatan terbaru dari Ustadz/Ustadzah secara transparan.</p>
                            </div>

                            <!-- Search + Filter -->
                            <div class="flex flex-col sm:flex-row gap-3 mb-6">
                                <div class="relative flex-1">
                                    <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                                    <input v-model="searchQuery" type="text" placeholder="Cari nama santri..." class="w-full pl-9 pr-9 py-2.5 border border-slate-200 bg-slate-50 rounded-lg text-sm focus:outline-none focus:border-bakri-teal focus:bg-white focus:ring-2 focus:ring-bakri-teal/20 transition">
                                    <button v-if="searchQuery" @click="searchQuery = ''" class="absolute right-3 top-1/2 -translate-y-1/2 text-slate-300 hover:text-slate-500 transition">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                                    </button>
                                </div>
                                <select v-model="selectedClassFilter" class="border border-slate-200 bg-slate-50 rounded-lg px-3.5 py-2.5 text-sm text-slate-700 focus:outline-none focus:border-bakri-teal focus:ring-2 focus:ring-bakri-teal/20 transition">
                                    <option v-for="cls in classes" :key="cls" :value="cls">{{ cls }}</option>
                                </select>
                            </div>

                            <!-- Daftar Santri -->
                            <div v-if="filteredStudents.length > 0" class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div v-for="santri in filteredStudents" :key="santri.id" class="flex gap-4 p-4 sm:p-5 border border-slate-100 rounded-xl hover:border-bakri-teal/30 hover:bg-bakri-teal/[0.02] transition-all duration-200">
                                    <div class="w-10 h-10 shrink-0 rounded-full flex items-center justify-center font-bold text-sm text-white"
                                        :class="santri.jenis_kelamin === 'L' ? 'bg-bakri-teal' : 'bg-rose-400'">
                                        {{ santri.nama.charAt(0) }}
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <div class="flex items-center justify-between gap-2 mb-0.5">
                                            <h4 class="font-semibold text-slate-800 text-sm truncate">{{ santri.nama }}</h4>
                                            <span class="text-[10px] text-slate-400 shrink-0">{{ santri.update_terakhir }}</span>
                                        </div>
                                        <p class="text-xs text-slate-400 mb-3">{{ santri.detail_kelas }} &bull; {{ santri.ustadz }}</p>
                                        <div class="bg-slate-50 border-l-2 border-bakri-teal pl-3 pr-2 py-2 rounded-r-lg text-xs text-slate-600 italic leading-relaxed">
                                            "{{ santri.progres }}"
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Empty State -->
                            <div v-else class="text-center py-16">
                                <MagnifyingGlassIcon class="w-10 h-10 text-slate-300 mx-auto mb-3" />
                                <p class="text-slate-400 text-sm font-medium">Tidak ada santri ditemukan.</p>
                                <p class="text-slate-300 text-xs mt-1">Coba ubah kata kunci atau pilih kelas lain.</p>
                            </div>

                        </div>
                    </div>
                </div>
                <!-- ===== END TAB: MADING KELAS ===== -->

                <!-- ===== TAB: JADWAL KELAS ===== -->
                <div v-show="activeTab === 'jadwal'">
                    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="h-1.5 w-full bg-gradient-to-r from-bakri-teal to-bakri-lime"></div>
                        <div class="p-6 sm:p-8 md:p-10">

                            <div class="mb-8">
                                <h2 class="text-lg font-bold text-slate-800 mb-1">Jadwal Kegiatan TPA</h2>
                                <p class="text-xs text-slate-400">Jadwal berlaku untuk semester aktif. Hubungi pengurus untuk informasi lebih lanjut.</p>
                            </div>

                            <!-- Info Cepat -->
                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-10">
                                <div class="flex items-start gap-3 p-4 bg-slate-50 rounded-xl border border-slate-100">
                                    <div class="w-9 h-9 rounded-lg bg-bakri-teal/10 flex items-center justify-center shrink-0">
                                        <CalendarDaysIcon class="w-5 h-5 text-bakri-teal" />
                                    </div>
                                    <div>
                                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-0.5">Hari Aktif</p>
                                        <p class="text-sm font-bold text-slate-800">Senin - Jumat</p>
                                    </div>
                                </div>
                                <div class="flex items-start gap-3 p-4 bg-slate-50 rounded-xl border border-slate-100">
                                    <div class="w-9 h-9 rounded-lg bg-bakri-teal/10 flex items-center justify-center shrink-0">
                                        <ClockIcon class="w-5 h-5 text-bakri-teal" />
                                    </div>
                                    <div>
                                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-0.5">Jam Belajar</p>
                                        <p class="text-sm font-bold text-slate-800">16.00 - 17.30 WIB</p>
                                    </div>
                                </div>
                                <div class="flex items-start gap-3 p-4 bg-slate-50 rounded-xl border border-slate-100">
                                    <div class="w-9 h-9 rounded-lg bg-bakri-teal/10 flex items-center justify-center shrink-0">
                                        <MapPinIcon class="w-5 h-5 text-bakri-teal" />
                                    </div>
                                    <div>
                                        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-0.5">Lokasi</p>
                                        <p class="text-sm font-bold text-slate-800">Ruang TPA Lt. 2</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Jadwal Per Kelas -->
                            <div class="mb-8">
                                <h3 class="text-sm font-bold text-slate-700 mb-4 flex items-center gap-2">
                                    <UserGroupIcon class="w-4 h-4 text-bakri-teal" />
                                    Jadwal Per Kelas
                                </h3>

                                <!-- Mobile Card -->
                                <div class="sm:hidden space-y-3">
                                    <div v-for="j in jadwalKelas" :key="j.kelas" class="border border-slate-100 rounded-xl p-4">
                                        <div class="flex items-center justify-between mb-2">
                                            <span class="text-sm font-bold text-bakri-teal">{{ j.kelas }}</span>
                                            <span class="text-[10px] bg-slate-100 text-slate-500 px-2 py-0.5 rounded-full font-medium">{{ j.pengajar }}</span>
                                        </div>
                                        <p class="text-xs text-slate-600 mb-0.5">Hari: {{ j.hari }}</p>
                                        <p class="text-xs text-slate-600 mb-0.5">Waktu: {{ j.waktu }}</p>
                                        <p class="text-xs text-slate-400 mt-2 italic">{{ j.ket }}</p>
                                    </div>
                                </div>

                                <!-- Desktop Table -->
                                <div class="hidden sm:block overflow-x-auto">
                                    <table class="w-full text-sm">
                                        <thead>
                                            <tr class="bg-slate-50 border-b border-slate-100">
                                                <th class="text-left text-xs font-semibold text-slate-500 uppercase tracking-wide px-4 py-3">Kelas</th>
                                                <th class="text-left text-xs font-semibold text-slate-500 uppercase tracking-wide px-4 py-3">Hari</th>
                                                <th class="text-left text-xs font-semibold text-slate-500 uppercase tracking-wide px-4 py-3">Waktu</th>
                                                <th class="text-left text-xs font-semibold text-slate-500 uppercase tracking-wide px-4 py-3">Pengajar</th>
                                                <th class="text-left text-xs font-semibold text-slate-500 uppercase tracking-wide px-4 py-3">Keterangan</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-50">
                                            <tr v-for="j in jadwalKelas" :key="j.kelas" class="hover:bg-slate-50/50 transition-colors">
                                                <td class="px-4 py-3.5 font-semibold text-bakri-teal">{{ j.kelas }}</td>
                                                <td class="px-4 py-3.5 text-slate-700">{{ j.hari }}</td>
                                                <td class="px-4 py-3.5 text-slate-700">{{ j.waktu }}</td>
                                                <td class="px-4 py-3.5 text-slate-600">{{ j.pengajar }}</td>
                                                <td class="px-4 py-3.5 text-slate-400 text-xs italic">{{ j.ket }}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- CTA -->
                            <div class="bg-bakri-teal/5 border border-bakri-teal/20 rounded-xl p-5 flex flex-col sm:flex-row items-center justify-between gap-4">
                                <div>
                                    <p class="text-sm font-semibold text-slate-800 mb-0.5">Tertarik mendaftarkan anak Anda?</p>
                                    <p class="text-xs text-slate-500">Pendaftaran gratis. Isi formulir dan pengurus kami akan menghubungi Anda.</p>
                                </div>
                                <button @click="activeTab = 'register'" class="shrink-0 px-6 py-2.5 bg-bakri-teal text-white text-sm font-semibold rounded-lg hover:bg-bakri-navy transition-colors whitespace-nowrap">
                                    Daftar Sekarang
                                </button>
                            </div>

                        </div>
                    </div>
                </div>
                <!-- ===== END TAB: JADWAL KELAS ===== -->

            </div>
        </div>

    </PublicLayout>
</template>
