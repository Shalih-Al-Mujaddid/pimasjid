<script setup>
import { ref } from 'vue';
import { Head } from '@inertiajs/vue3';
import PublicLayout from '@/Layouts/PublicLayout.vue';

const selectedType = ref('fitrah');

// Calculator states
const ricePricePerLiter = ref(15000);
const personCount = ref(1);
const goldPricePerGram = ref(1000000);
const harta = ref(0);
const hutang = ref(0);
const penghasilan = ref(0);

const calculatedFitrah = () => {
    return 3.5 * ricePricePerLiter.value * personCount.value;
};

const calculatedMal = () => {
    const nisab = 85 * goldPricePerGram.value;
    const nettWealth = harta.value - hutang.value;
    return nettWealth >= nisab ? nettWealth * 0.025 : 0;
};

const nisab = () => {
    return 85 * goldPricePerGram.value;
};

const isAboveNisab = () => {
    return (harta.value - hutang.value) >= nisab();
};

const calculatedProfesi = () => {
    return penghasilan.value * 0.025;
};

const formatRupiah = (amount) => {
    return 'Rp ' + new Intl.NumberFormat('id-ID').format(amount);
};
</script>

<template>
    <Head title="Info Zakat" />

    <PublicLayout>
        <div class="py-12 pt-24 bg-gradient-to-b from-emerald-50 to-white">
            <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Hero Section -->
                <div class="text-center mb-12">
                    <h1 class="text-4xl font-bold text-slate-900 mb-4">🕌 Zakat</h1>
                    <p class="text-lg text-slate-600 max-w-2xl mx-auto">
                        Tunaikan kewajiban zakat Anda dengan mudah. Hitung zakat fitrah, mal, dan profesi dengan kalkulator otomatis.
                    </p>
                </div>

                <!-- Zakat Type Selector -->
                <div class="flex justify-center gap-4 mb-8">
                    <button @click="selectedType = 'fitrah'"
                            :class="['px-6 py-3 rounded-lg font-semibold transition', 
                                     selectedType === 'fitrah' ? 'bg-emerald-600 text-white' : 'bg-white text-slate-700 border border-slate-300']">
                        Zakat Fitrah
                    </button>
                    <button @click="selectedType = 'mal'"
                            :class="['px-6 py-3 rounded-lg font-semibold transition',
                                     selectedType === 'mal' ? 'bg-blue-600 text-white' : 'bg-white text-slate-700 border border-slate-300']">
                        Zakat Mal
                    </button>
                    <button @click="selectedType = 'profesi'"
                            :class="['px-6 py-3 rounded-lg font-semibold transition',
                                     selectedType === 'profesi' ? 'bg-purple-600 text-white' : 'bg-white text-slate-700 border border-slate-300']">
                        Zakat Profesi
                    </button>
                </div>

                <!-- Fitrah Calculator -->
                <div v-if="selectedType === 'fitrah'" class="bg-white rounded-xl shadow-lg p-8">
                    <h3 class="text-2xl font-bold text-emerald-600 mb-6">Kalkulator Zakat Fitrah</h3>
                    
                    <div class="space-y-4 mb-6">
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">Harga Beras per Liter</label>
                            <input v-model.number="ricePricePerLiter" type="number"
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg text-lg" />
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">Jumlah Jiwa</label>
                            <input v-model.number="personCount" type="number" min="1"
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg text-lg" />
                        </div>
                    </div>

                    <div class="bg-emerald-50 border border-emerald-200 rounded-lg p-6">
                        <div class="text-sm text-slate-600 mb-2">Zakat yang harus dibayar:</div>
                        <div class="text-3xl font-bold text-emerald-600">{{ formatRupiah(calculatedFitrah()) }}</div>
                        <div class="text-xs text-slate-500 mt-2">
                            Kalkulasi: 3.5L x {{ formatRupiah(ricePricePerLiter) }} x {{ personCount }} jiwa
                        </div>
                    </div>

                    <div class="mt-6 p-4 bg-blue-50 rounded-lg">
                        <h4 class="font-semibold text-blue-900 mb-2">📌 Keterangan</h4>
                        <ul class="text-sm text-blue-800 space-y-1">
                            <li>• Zakat fitrah wajib dibayarkan sebelum sholat Idul Fitri</li>
                            <li>• Ukuran: 2.5 kg atau 3.5 liter beras per jiwa</li>
                            <li>• Boleh dibayar dengan uang senilai beras</li>
                        </ul>
                    </div>
                </div>

                <!-- Mal Calculator -->
                <div v-if="selectedType === 'mal'" class="bg-white rounded-xl shadow-lg p-8">
                    <h3 class="text-2xl font-bold text-blue-600 mb-6">Kalkulator Zakat Mal</h3>
                    
                    <div class="space-y-4 mb-6">
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">Total Harta (Rp)</label>
                            <input v-model.number="harta" type="number"
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg text-lg" />
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">Total Hutang (Rp)</label>
                            <input v-model.number="hutang" type="number"
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg text-lg" />
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">Harga Emas per Gram</label>
                            <input v-model.number="goldPricePerGram" type="number"
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg text-lg" />
                        </div>
                    </div>

                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-6 space-y-3">
                        <div class="flex justify-between">
                            <span class="text-slate-600">Nisab (85 gram emas):</span>
                            <strong>{{ formatRupiah(nisab()) }}</strong>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-slate-600">Harta Bersih:</span>
                            <strong>{{ formatRupiah(harta - hutang) }}</strong>
                        </div>
                        <div class="flex justify-between text-lg font-bold"
                             :class="isAboveNisab() ? 'text-emerald-600' : 'text-red-600'">
                            <span>Zakat (2.5%):</span>
                            <span>{{ formatRupiah(calculatedMal()) }}</span>
                        </div>
                        <div v-if="!isAboveNisab()" class="text-red-600 text-sm mt-2">
                            ⚠️ Harta belum mencapai nisab. Zakat mal tidak wajib.
                        </div>
                    </div>

                    <div class="mt-6 p-4 bg-blue-50 rounded-lg">
                        <h4 class="font-semibold text-blue-900 mb-2">📌 Keterangan</h4>
                        <ul class="text-sm text-blue-800 space-y-1">
                            <li>• Zakat mal wajib jika harta >= nisab (85 gram emas)</li>
                            <li>• Harta telah dimiliki selama 1 tahun (haul)</li>
                            <li>• Zakat: 2.5% dari harta yang wajib dizakati</li>
                        </ul>
                    </div>
                </div>

                <!-- Profesi Calculator -->
                <div v-if="selectedType === 'profesi'" class="bg-white rounded-xl shadow-lg p-8">
                    <h3 class="text-2xl font-bold text-purple-600 mb-6">Kalkulator Zakat Profesi</h3>
                    
                    <div class="space-y-4 mb-6">
                        <div>
                            <label class="block text-sm font-medium text-slate-700 mb-2">Penghasilan Bulanan (Rp)</label>
                            <input v-model.number="penghasilan" type="number"
                                   class="w-full px-4 py-3 border border-slate-300 rounded-lg text-lg" />
                        </div>
                    </div>

                    <div class="bg-purple-50 border border-purple-200 rounded-lg p-6">
                        <div class="text-sm text-slate-600 mb-2">Zakat yang harus dibayar:</div>
                        <div class="text-3xl font-bold text-purple-600">{{ formatRupiah(calculatedProfesi()) }}</div>
                        <div class="text-xs text-slate-500 mt-2">
                            Kalkulasi: {{ formatRupiah(penghasilan) }} x 2.5%
                        </div>
                    </div>

                    <div class="mt-6 p-4 bg-blue-50 rounded-lg">
                        <h4 class="font-semibold text-blue-900 mb-2">📌 Keterangan</h4>
                        <ul class="text-sm text-blue-800 space-y-1">
                            <li>• Zakat profesi/penghasilan: 2.5% dari penghasilan</li>
                            <li>• Dapat dibayarkan setiap bulan</li>
                            <li>• Wajib jika penghasilan >= nisab</li>
                        </ul>
                    </div>
                </div>

                <!-- Contact Info -->
                <div class="mt-12 text-center p-8 bg-gradient-to-r from-emerald-500 to-emerald-600 rounded-xl text-white">
                    <h3 class="text-2xl font-bold mb-4">Siap Menunaikan Zakat?</h3>
                    <p class="mb-6">Hubungi pengurus masjid atau datang langsung ke sekretariat masjid</p>
                    <a :href="$page.props.settings?.whatsapp ? `https://wa.me/${$page.props.settings.whatsapp}` : '#'" target="_blank" class="inline-block px-8 py-3 bg-white text-emerald-600 font-bold rounded-lg hover:bg-emerald-50 transition">
                        Hubungi via WhatsApp
                    </a>
                </div>
            </div>
        </div>
    </PublicLayout>
</template>
