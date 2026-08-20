<script setup>
import { ref, computed } from 'vue';
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';
import {
    GiftIcon,
    SparklesIcon,
    CheckCircleIcon,
    ClockIcon,
    HeartIcon,
    ArrowLeftIcon,
    BuildingLibraryIcon,
    BanknotesIcon,
    UserGroupIcon,
    QrCodeIcon,
    PhotoIcon,
    ShieldCheckIcon,
    ChatBubbleBottomCenterTextIcon,
    CheckBadgeIcon,
    InformationCircleIcon
} from '@heroicons/vue/24/outline';

const props = defineProps({
    wishlist: Object,
    contributions: Array,
    bankInfo: Object,
});

const page = usePage();
const flashSuccess = computed(() => page.props.flash?.success);

const form = useForm({
    donor_name: '',
    donor_phone: '',
    donor_email: '',
    quantity: 1,
    type: 'dana', // 'dana' or 'barang'
    amount: props.wishlist.unit_price || 0,
    notes: '',
    is_anonymous: false,
    proof_image: null,
});

const proofPreview = ref(null);

const handleQuantityChange = () => {
    if (form.quantity < 1) form.quantity = 1;
    if (form.type === 'dana') {
        form.amount = form.quantity * props.wishlist.unit_price;
    }
};

const handleTypeChange = (newType) => {
    form.type = newType;
    if (newType === 'dana') {
        form.amount = form.quantity * props.wishlist.unit_price;
    } else {
        form.amount = null;
    }
};

const handleProofChange = (e) => {
    const file = e.target.files[0];
    if (file) {
        form.proof_image = file;
        const reader = new FileReader();
        reader.onload = (e) => {
            proofPreview.value = e.target.result;
        };
        reader.readAsDataURL(file);
    } else {
        form.proof_image = null;
        proofPreview.value = null;
    }
};

const submit = () => {
    form.post(route('public.wishlist.contribute', props.wishlist.id), {
        preserveScroll: true,
        onSuccess: () => {
            form.reset('proof_image', 'notes');
            proofPreview.value = null;
        },
    });
};

const formatRupiah = (val) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0
    }).format(val || 0);
};

const formatDate = (dateString) => {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleDateString('id-ID', {
        day: 'numeric',
        month: 'short',
        year: 'numeric'
    });
};
</script>

<template>
    <Head :title="`${wishlist.item_name} — Kebutuhan Masjid`" />

    <PublicLayout :transparent-nav="true">
        <!-- Hero Header -->
        <div class="relative bg-gradient-to-br from-emerald-950 via-emerald-900 to-teal-900 text-white pt-28 pb-16 overflow-hidden">
            <div class="absolute inset-0 opacity-10 bg-[radial-gradient(#34d399_1px,transparent_1px)] [background-size:16px_16px]"></div>
            
            <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Breadcrumb -->
                <div class="flex items-center gap-2 text-xs font-semibold text-emerald-200/80 mb-6">
                    <Link href="/" class="hover:text-white transition">Beranda</Link>
                    <span>/</span>
                    <Link :href="route('public.wishlist.index')" class="hover:text-white transition">Kebutuhan Masjid</Link>
                    <span>/</span>
                    <span class="text-white truncate max-w-xs">{{ wishlist.item_name }}</span>
                </div>

                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div>
                        <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-800/80 border border-emerald-700/60 text-emerald-200 text-xs font-bold uppercase tracking-wider mb-3">
                            <SparklesIcon class="w-3.5 h-3.5 text-amber-400" />
                            Program Pengadaan Sarana Ibadah
                        </div>
                        <h1 class="text-2xl sm:text-4xl font-extrabold text-white">
                            {{ wishlist.item_name }}
                        </h1>
                    </div>

                    <Link
                        :href="route('public.wishlist.index')"
                        class="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-white/10 hover:bg-white/20 text-white text-xs font-bold uppercase tracking-wider transition self-start md:self-auto border border-white/10"
                    >
                        <ArrowLeftIcon class="w-4 h-4" />
                        Kembali ke Katalog
                    </Link>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
            <!-- Flash Message -->
            <div
                v-if="flashSuccess"
                class="mb-8 p-4 sm:p-5 bg-emerald-50 dark:bg-emerald-950/80 border border-emerald-200 dark:border-emerald-800 rounded-2xl flex items-start gap-3 text-emerald-800 dark:text-emerald-200 shadow-sm"
            >
                <CheckCircleIcon class="w-6 h-6 text-emerald-600 dark:text-emerald-400 shrink-0 mt-0.5" />
                <div>
                    <h4 class="font-bold text-sm">Alhamdulillah, Kontribusi Terkirim!</h4>
                    <p class="text-xs sm:text-sm mt-0.5 text-emerald-700 dark:text-emerald-300">
                        {{ flashSuccess }}
                    </p>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-10">
                <!-- Left Column: Details & Contributions (7 cols) -->
                <div class="lg:col-span-7 space-y-8">
                    <!-- Progress Card -->
                    <div class="bg-white dark:bg-slate-900 rounded-3xl p-6 sm:p-8 border border-slate-100 dark:border-slate-800 shadow-sm">
                        <div class="flex items-center justify-between mb-6">
                            <span
                                v-if="wishlist.status === 'completed'"
                                class="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-bold bg-teal-50 text-teal-700 dark:bg-teal-950/80 dark:text-teal-300 border border-teal-200 dark:border-teal-800"
                            >
                                <CheckCircleIcon class="w-4 h-4" />
                                Target Terpenuhi
                            </span>
                            <span
                                v-else
                                class="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-bold bg-amber-50 text-amber-700 dark:bg-amber-950/80 dark:text-amber-300 border border-amber-200 dark:border-amber-800"
                            >
                                <ClockIcon class="w-4 h-4" />
                                Sedang Membutuhkan Donasi
                            </span>

                            <div class="text-xs font-bold text-slate-400">
                                Target: {{ wishlist.target_qty }} Unit
                            </div>
                        </div>

                        <!-- Progress Bar Large -->
                        <div class="space-y-3 mb-6">
                            <div class="flex justify-between items-baseline">
                                <div>
                                    <div class="text-3xl font-black text-slate-900 dark:text-white">
                                        {{ wishlist.fulfilled_qty }} <span class="text-base font-normal text-slate-500 dark:text-slate-400">/ {{ wishlist.target_qty }} unit</span>
                                    </div>
                                    <div class="text-xs text-emerald-600 dark:text-emerald-400 font-semibold mt-0.5">
                                        Sisa yang dibutuhkan: <strong>{{ wishlist.remaining_qty }} unit</strong>
                                    </div>
                                </div>

                                <div class="text-2xl font-black text-emerald-600 dark:text-emerald-400">
                                    {{ wishlist.progress_percentage }}%
                                </div>
                            </div>

                            <div class="w-full bg-slate-100 dark:bg-slate-800 h-4 rounded-full overflow-hidden p-0.5">
                                <div
                                    class="h-full rounded-full transition-all duration-1000 ease-out"
                                    :class="wishlist.status === 'completed' ? 'bg-teal-500' : 'bg-gradient-to-r from-emerald-500 via-teal-400 to-amber-400'"
                                    :style="{ width: `${wishlist.progress_percentage}%` }"
                                ></div>
                            </div>
                        </div>

                        <!-- Metrics Grid -->
                        <div class="grid grid-cols-2 sm:grid-cols-3 gap-4 pt-4 border-t border-slate-100 dark:border-slate-800 text-xs">
                            <div class="p-3 bg-slate-50 dark:bg-slate-800/50 rounded-xl">
                                <div class="text-slate-500 dark:text-slate-400 mb-1">Estimasi Harga Satuan</div>
                                <div class="font-bold text-slate-800 dark:text-slate-200 text-sm">
                                    {{ wishlist.formatted_unit_price }}
                                </div>
                            </div>

                            <div class="p-3 bg-slate-50 dark:bg-slate-800/50 rounded-xl">
                                <div class="text-slate-500 dark:text-slate-400 mb-1">Total Kebutuhan Dana</div>
                                <div class="font-bold text-slate-800 dark:text-slate-200 text-sm">
                                    {{ wishlist.formatted_total_target }}
                                </div>
                            </div>

                            <div class="p-3 bg-slate-50 dark:bg-slate-800/50 rounded-xl col-span-2 sm:col-span-1">
                                <div class="text-slate-500 dark:text-slate-400 mb-1">Total Dana Terkumpul</div>
                                <div class="font-bold text-emerald-600 dark:text-emerald-400 text-sm">
                                    {{ wishlist.formatted_total_fulfilled }}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Description & Specification Card -->
                    <div class="bg-white dark:bg-slate-900 rounded-3xl p-6 sm:p-8 border border-slate-100 dark:border-slate-800 shadow-sm">
                        <h3 class="text-lg font-bold text-slate-900 dark:text-white mb-4 flex items-center gap-2">
                            <InformationCircleIcon class="w-5 h-5 text-emerald-600" />
                            Deskripsi & Keterangan Pengadaan
                        </h3>
                        <p class="text-slate-600 dark:text-slate-300 text-sm leading-relaxed whitespace-pre-line">
                            {{ wishlist.description || 'Barang ini dibutuhkan untuk melengkapi fasilitas dan sarana ibadah di masjid. Kami membuka kesempatan seluas-luasnya bagi para jamaah dan donatur yang ingin berkontribusi baik dalam bentuk barang langsung maupun dana pembelian.' }}
                        </p>

                        <div class="mt-6 p-4 bg-amber-50 dark:bg-amber-950/40 border border-amber-200/80 dark:border-amber-800/60 rounded-2xl flex items-start gap-3">
                            <ShieldCheckIcon class="w-5 h-5 text-amber-600 dark:text-amber-400 shrink-0 mt-0.5" />
                            <div class="text-xs text-amber-900 dark:text-amber-200 leading-relaxed">
                                <strong>Akuntabilitas Terbuka:</strong> Seluruh kontribusi yang masuk akan tercatat dan dapat dipantau di halaman ini serta diverifikasi langsung oleh bendahara/pengurus DKM.
                            </div>
                        </div>
                    </div>

                    <!-- Verified Donors History -->
                    <div class="bg-white dark:bg-slate-900 rounded-3xl p-6 sm:p-8 border border-slate-100 dark:border-slate-800 shadow-sm">
                        <div class="flex items-center justify-between mb-6">
                            <h3 class="text-lg font-bold text-slate-900 dark:text-white flex items-center gap-2">
                                <UserGroupIcon class="w-5 h-5 text-emerald-600" />
                                Donatur & Kontributor ({{ contributions ? contributions.length : 0 }})
                            </h3>
                            <span class="text-xs text-slate-400">Hanya yang terverifikasi</span>
                        </div>

                        <div v-if="contributions && contributions.length > 0" class="space-y-4">
                            <div
                                v-for="c in contributions"
                                :key="c.id"
                                class="p-4 rounded-2xl bg-slate-50 dark:bg-slate-800/50 border border-slate-100 dark:border-slate-800/80 transition-all hover:bg-emerald-50/30"
                            >
                                <div class="flex items-start justify-between gap-3">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-full bg-emerald-600 flex items-center justify-center text-white font-bold text-sm shadow-sm">
                                            {{ c.display_donor_name.charAt(0) }}
                                        </div>
                                        <div>
                                            <div class="font-bold text-slate-900 dark:text-white text-sm">
                                                {{ c.display_donor_name }}
                                            </div>
                                            <div class="text-xs text-slate-500 dark:text-slate-400 flex items-center gap-2 mt-0.5">
                                                <span>{{ formatDate(c.created_at) }}</span>
                                                <span>•</span>
                                                <span class="font-semibold text-emerald-600 dark:text-emerald-400">
                                                    {{ c.quantity }} Unit ({{ c.type_label }})
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                    <div v-if="c.amount" class="text-right">
                                        <div class="text-xs font-bold text-slate-800 dark:text-slate-200">
                                            {{ c.formatted_amount }}
                                        </div>
                                        <span class="inline-flex items-center gap-1 text-[10px] text-teal-600 font-semibold">
                                            <CheckBadgeIcon class="w-3.5 h-3.5" />
                                            Lunas
                                        </span>
                                    </div>
                                </div>

                                <!-- Donor's prayer/notes -->
                                <div
                                    v-if="c.notes"
                                    class="mt-3 text-xs text-slate-600 dark:text-slate-300 bg-white dark:bg-slate-900/60 p-3 rounded-xl border border-slate-100 dark:border-slate-800 italic"
                                >
                                    "{{ c.notes }}"
                                </div>
                            </div>
                        </div>

                        <div v-else class="text-center py-8 text-slate-400 text-sm">
                            <HeartIcon class="w-10 h-10 mx-auto mb-2 text-slate-300 opacity-60" />
                            Belum ada kontribusi terverifikasi. Jadilah donatur pertama untuk barang ini!
                        </div>
                    </div>
                </div>

                <!-- Right Column: Sticky Contribution Form (5 cols) -->
                <div class="lg:col-span-5">
                    <div class="sticky top-28 space-y-6">
                        <!-- Form Card -->
                        <div class="bg-white dark:bg-slate-900 rounded-3xl p-6 sm:p-8 border-2 border-emerald-500/20 dark:border-emerald-500/30 shadow-xl shadow-emerald-900/5">
                            <div class="mb-6">
                                <span class="text-xs font-extrabold uppercase tracking-widest text-emerald-600 dark:text-emerald-400">Formulir Donasi</span>
                                <h3 class="text-2xl font-black text-slate-900 dark:text-white mt-1">
                                    Salurkan Kebaikan
                                </h3>
                                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">
                                    Pilih jenis kontribusi dan isi data diri Anda di bawah ini.
                                </p>
                            </div>

                            <form @submit.prevent="submit" class="space-y-4">
                                <!-- Type Selector -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-2">
                                        Bentuk Kontribusi
                                    </label>
                                    <div class="grid grid-cols-2 gap-2">
                                        <button
                                            type="button"
                                            @click="handleTypeChange('dana')"
                                            :class="[
                                                'py-2.5 px-3 rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 transition-all border',
                                                form.type === 'dana'
                                                    ? 'bg-emerald-600 text-white border-emerald-600 shadow-md shadow-emerald-600/20'
                                                    : 'bg-slate-50 dark:bg-slate-800 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-700 hover:bg-slate-100'
                                            ]"
                                        >
                                            <BanknotesIcon class="w-4 h-4" />
                                            Transfer Dana
                                        </button>
                                        <button
                                            type="button"
                                            @click="handleTypeChange('barang')"
                                            :class="[
                                                'py-2.5 px-3 rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 transition-all border',
                                                form.type === 'barang'
                                                    ? 'bg-emerald-600 text-white border-emerald-600 shadow-md shadow-emerald-600/20'
                                                    : 'bg-slate-50 dark:bg-slate-800 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-700 hover:bg-slate-100'
                                            ]"
                                        >
                                            <GiftIcon class="w-4 h-4" />
                                            Barang Fisik
                                        </button>
                                    </div>
                                </div>

                                <!-- Bank Info Alert when type is dana -->
                                <div
                                    v-if="form.type === 'dana'"
                                    class="p-4 bg-emerald-50 dark:bg-emerald-950/60 rounded-2xl border border-emerald-200/80 dark:border-emerald-800/60 text-xs text-emerald-900 dark:text-emerald-200 space-y-2"
                                >
                                    <div class="font-bold flex items-center gap-1.5">
                                        <BuildingLibraryIcon class="w-4 h-4 text-emerald-600" />
                                        Rekening Resmi Masjid
                                    </div>
                                    <div class="bg-white dark:bg-slate-900 p-2.5 rounded-xl border border-emerald-100 dark:border-emerald-900/60 font-mono">
                                        <div class="text-slate-500 dark:text-slate-400 text-[10px] uppercase">{{ bankInfo.bank_name }}</div>
                                        <div class="text-sm font-black text-slate-900 dark:text-white tracking-wider">{{ bankInfo.bank_account }}</div>
                                        <div class="text-[11px] text-slate-600 dark:text-slate-300">a.n {{ bankInfo.bank_holder }}</div>
                                    </div>
                                </div>

                                <!-- Quantity Input -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1.5">
                                        Jumlah Unit Yang Disumbangkan
                                    </label>
                                    <div class="flex items-center gap-3">
                                        <input
                                            v-model.number="form.quantity"
                                            @input="handleQuantityChange"
                                            type="number"
                                            min="1"
                                            class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/80 text-slate-900 dark:text-white text-sm font-bold focus:ring-2 focus:ring-emerald-500"
                                            required
                                        />
                                        <span class="text-xs font-bold text-slate-500 shrink-0">Unit</span>
                                    </div>
                                    <div v-if="form.errors.quantity" class="text-rose-500 text-xs mt-1">{{ form.errors.quantity }}</div>
                                </div>

                                <!-- Nominal Calculation (if Dana) -->
                                <div v-if="form.type === 'dana'">
                                    <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1.5">
                                        Nominal Donasi (Rp)
                                    </label>
                                    <input
                                        v-model.number="form.amount"
                                        type="number"
                                        min="0"
                                        class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/80 text-slate-900 dark:text-white text-sm font-bold focus:ring-2 focus:ring-emerald-500"
                                        required
                                    />
                                    <div class="text-[11px] text-slate-400 mt-1">
                                        Estimasi: {{ form.quantity }} x {{ wishlist.formatted_unit_price }} = <strong>{{ formatRupiah(form.amount) }}</strong>
                                    </div>
                                </div>

                                <!-- Donor Name -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1.5">
                                        Nama Lengkap
                                    </label>
                                    <input
                                        v-model="form.donor_name"
                                        type="text"
                                        placeholder="Contoh: H. Abdullah"
                                        class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/80 text-slate-900 dark:text-white text-sm focus:ring-2 focus:ring-emerald-500"
                                        required
                                    />
                                    <div v-if="form.errors.donor_name" class="text-rose-500 text-xs mt-1">{{ form.errors.donor_name }}</div>
                                </div>

                                <!-- Donor Phone & Email -->
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1.5">
                                            No. WhatsApp / HP
                                        </label>
                                        <input
                                            v-model="form.donor_phone"
                                            type="tel"
                                            placeholder="082346719219"
                                            class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/80 text-slate-900 dark:text-white text-sm focus:ring-2 focus:ring-emerald-500"
                                            required
                                        />
                                        <div v-if="form.errors.donor_phone" class="text-rose-500 text-xs mt-1">{{ form.errors.donor_phone }}</div>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1.5">
                                            Email (Opsional)
                                        </label>
                                        <input
                                            v-model="form.donor_email"
                                            type="email"
                                            placeholder="nama@email.com"
                                            class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/80 text-slate-900 dark:text-white text-sm focus:ring-2 focus:ring-emerald-500"
                                        />
                                    </div>
                                </div>

                                <!-- Proof of Transfer / Item Photo Upload -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1.5">
                                        Bukti Transfer / Foto Barang (Opsional)
                                    </label>
                                    <div class="border-2 border-dashed border-slate-200 dark:border-slate-700 rounded-2xl p-3 text-center relative hover:bg-slate-50 dark:hover:bg-slate-800/50 transition">
                                        <input
                                            type="file"
                                            accept="image/*"
                                            @change="handleProofChange"
                                            class="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                                        />
                                        <div v-if="!proofPreview" class="py-2 text-slate-400">
                                            <PhotoIcon class="w-6 h-6 mx-auto mb-1 text-slate-400" />
                                            <span class="text-xs">Klik untuk upload bukti struk / barang</span>
                                        </div>
                                        <div v-else class="relative inline-block">
                                            <img :src="proofPreview" class="h-20 w-auto rounded-lg mx-auto object-contain" />
                                            <span class="text-[10px] text-emerald-600 font-bold block mt-1">Foto siap diupload</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Doa / Catatan -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider mb-1.5">
                                        Pesan & Doa Kebaikan
                                    </label>
                                    <textarea
                                        v-model="form.notes"
                                        rows="2"
                                        placeholder="Tuliskan doa atau pesan untuk jamaah dan kemakmuran masjid..."
                                        class="w-full rounded-xl border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/80 text-slate-900 dark:text-white text-sm focus:ring-2 focus:ring-emerald-500"
                                    ></textarea>
                                </div>

                                <!-- Anonymous Checkbox -->
                                <div class="flex items-center gap-2.5 pt-1">
                                    <input
                                        id="anonymous"
                                        v-model="form.is_anonymous"
                                        type="checkbox"
                                        class="w-4 h-4 rounded text-emerald-600 focus:ring-emerald-500 border-slate-300 dark:border-slate-700"
                                    />
                                    <label for="anonymous" class="text-xs text-slate-600 dark:text-slate-400 select-none cursor-pointer">
                                        Tampilkan sebagai <strong>Hamba Allah</strong> di daftar publik
                                    </label>
                                </div>

                                <!-- Submit Button -->
                                <div class="pt-4">
                                    <button
                                        type="submit"
                                        :disabled="form.processing"
                                        class="w-full py-3.5 px-6 rounded-2xl font-black text-sm uppercase tracking-wider text-white bg-gradient-to-r from-emerald-600 via-emerald-700 to-teal-700 hover:from-emerald-700 hover:to-teal-800 shadow-lg shadow-emerald-600/30 hover:shadow-emerald-600/50 hover:-translate-y-0.5 active:scale-98 transition-all flex items-center justify-center gap-2"
                                    >
                                        <HeartIcon class="w-5 h-5 text-amber-300 animate-pulse" />
                                        <span>{{ form.processing ? 'Mengirim...' : 'Kirim Niat Donasi' }}</span>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>
