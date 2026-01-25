<script setup>
import { ref } from 'vue';
import { Head, router, Link } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';

const props = defineProps({
    qurbans: Object,
    summary: Object,
    filters: Object,
});

const search = ref(props.filters.search || '');
const animalTypeFilter = ref(props.filters.animal_type || '');
const statusFilter = ref(props.filters.status || '');
const shareTypeFilter = ref(props.filters.share_type || '');
const yearFilter = ref(props.filters.year || new Date().getFullYear());

const applyFilters = () => {
    router.get(route('qurban.index'), {
        search: search.value,
        animal_type: animalTypeFilter.value,
        status: statusFilter.value,
        share_type: shareTypeFilter.value,
        year: yearFilter.value,
    }, {
        preserveState: true,
        preserveScroll: true,
    });
};

const formatRupiah = (amount) => {
    return 'Rp ' + new Intl.NumberFormat('id-ID').format(amount);
};

const updateStatus = (qurbanId, newStatus) => {
    if (confirm(`Update status menjadi "${newStatus}"?`)) {
        router.patch(route('qurban.status', qurbanId), {
            status: newStatus,
        }, {
            preserveScroll: true,
        });
    }
};

const deleteQurban = (id) => {
    if (confirm('Hapus peserta qurban ini?')) {
        router.delete(route('qurban.destroy', id), {
            preserveScroll: true,
        });
    }
};
</script>

<template>
    <Head title="Data Qurban" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-2xl text-slate-800 leading-tight">
                🐑 Data Qurban
            </h2>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <!-- Summary Cards -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <div class="bg-gradient-to-br from-emerald-500 to-emerald-600 rounded-xl p-6 text-white shadow-lg">
                        <div class="text-sm opacity-90">Total Peserta</div>
                        <div class="text-3xl font-bold mt-2">{{ summary.total_participants }}</div>
                        <div class="text-sm opacity-75 mt-2">Tahun {{ yearFilter }}</div>
                    </div>

                    <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-6 text-white shadow-lg">
                        <div class="text-sm opacity-90">Total Harga</div>
                        <div class="text-2xl font-bold mt-2">{{ formatRupiah(summary.total_price) }}</div>
                    </div>

                    <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-6 text-white shadow-lg">
                        <div class="text-sm opacity-90">Hewan</div>
                        <div class="mt-2 space-y-1">
                            <div class="flex justify-between text-sm">
                                <span>🐐 Kambing:</span>
                                <span class="font-semibold">{{ summary.kambing_count }}</span>
                            </div>
                            <div class="flex justify-between text-sm">
                                <span>🐄 Sapi:</span>
                                <span class="font-semibold">{{ summary.sapi_count }}</span>
                            </div>
                        </div>
                    </div>

                    <div class="bg-gradient-to-br from-amber-500 to-amber-600 rounded-xl p-6 text-white shadow-lg">
                        <div class="text-sm opacity-90">Status</div>
                        <div class="mt-2 space-y-1 text-xs">
                            <div class="flex justify-between"><span>Terdaftar:</span><span>{{ summary.registered_count }}</span></div>
                            <div class="flex justify-between"><span>Lunas:</span><span>{{ summary.paid_count }}</span></div>
                            <div class="flex justify-between"><span>Disembelih:</span><span>{{ summary.slaughtered_count }}</span></div>
                        </div>
                    </div>
                </div>

                <!-- Filters & Actions -->
                <div class="bg-white rounded-xl shadow-sm p-6 mb-6">
                    <div class="grid grid-cols-1 md:grid-cols-6 gap-4">
                        <input
                            v-model="search"
                            @input="applyFilters"
                            type="text"
                            placeholder="Cari nama/NIK..."
                            class="px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-emerald-500"
                        />

                        <select v-model="animalTypeFilter" @change="applyFilters" class="px-4 py-2 border border-slate-300 rounded-lg">
                            <option value="">Semua Hewan</option>
                            <option value="kambing">Kambing</option>
                            <option value="domba">Domba</option>
                            <option value="sapi">Sapi</option>
                            <option value="kerbau">Kerbau</option>
                        </select>

                        <select v-model="statusFilter" @change="applyFilters" class="px-4 py-2 border border-slate-300 rounded-lg">
                            <option value="">Semua Status</option>
                            <option value="registered">Terdaftar</option>
                            <option value="paid">Lunas</option>
                            <option value="slaughtered">Disembelih</option>
                            <option value="distributed">Didistribusi</option>
                        </select>

                        <select v-model="shareTypeFilter" @change="applyFilters" class="px-4 py-2 border border-slate-300 rounded-lg">
                            <option value="">Individual & Patungan</option>
                            <option value="individual">Individual</option>
                            <option value="shared">Patungan</option>
                        </select>

                        <input v-model="yearFilter" @change="applyFilters" type="number" class="px-4 py-2 border border-slate-300 rounded-lg" />

                        <Link :href="route('qurban.create')" class="btn-primary text-center">
                            ➕ Daftar Qurban
                        </Link>
                    </div>
                </div>

                <!-- Table -->
                <div class="bg-white rounded-xl shadow-sm overflow-hidden">
                    <table class="min-w-full divide-y divide-slate-200">
                        <thead class="bg-slate-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase">Peserta</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase">Hewan</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase">Harga</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase">Status</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase">Aksi</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-slate-200">
                            <tr v-for="qurban in qurbans.data" :key="qurban.id" class="hover:bg-slate-50">
                                <td class="px-6 py-4">
                                    <div class="font-medium text-slate-900">{{ qurban.participant_name }}</div>
                                    <div v-if="qurban.participant_nik" class="text-sm text-slate-500">NIK: {{ qurban.participant_nik }}</div>
                                    <div class="text-sm text-slate-500">{{ qurban.participant_phone }}</div>
                                    <div v-if="qurban.is_shared" class="text-xs text-purple-600 mt-1">
                                        👥 Patungan: {{ qurban.share_position }}/{{ qurban.share_count }}
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm font-medium text-slate-900 flex items-center gap-2">
                                        <span class="text-xl">
                                            {{ qurban.animal_type === 'sapi' ? '🐄' : (qurban.animal_type === 'kambing' ? '🐐' : '🐑') }}
                                        </span>
                                        <span class="capitalize">{{ qurban.animal_type }}</span>
                                    </div>
                                    <div v-if="qurban.animal_weight" class="text-xs text-slate-500">
                                        ~{{ qurban.animal_weight }} kg
                                    </div>
                                    <div v-if="qurban.is_shared" class="mt-1">
                                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-purple-100 text-purple-800">
                                            👥 Grup #{{ qurban.share_group_id ? qurban.share_group_id.substr(0, 6) : '?' }}
                                        </span>
                                        <div class="text-xs text-purple-600 mt-0.5 ml-1">
                                            Posisi: {{ qurban.share_position }}/{{ qurban.share_count }}
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="font-semibold text-emerald-600">
                                        {{ formatRupiah(qurban.animal_price) }}
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="px-2 py-1 text-xs rounded-full"
                                          :class="{
                                              'bg-slate-100 text-slate-800': qurban.status === 'registered',
                                              'bg-emerald-100 text-emerald-800': qurban.status === 'paid',
                                              'bg-blue-100 text-blue-800': qurban.status === 'slaughtered',
                                              'bg-purple-100 text-purple-800': qurban.status === 'distributed',
                                          }">
                                        {{ qurban.status === 'registered' ? 'Terdaftar' : 
                                           qurban.status === 'paid' ? 'Lunas' :
                                           qurban.status === 'slaughtered' ? 'Disembelih' : 'Didistribusi' }}
                                    </span>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex gap-2">
                                        <button v-if="qurban.status === 'registered'"
                                                @click="updateStatus(qurban.id, 'paid')"
                                                class="text-xs px-3 py-1 bg-emerald-600 hover:bg-emerald-700 text-white rounded">
                                            ✓ Lunas
                                        </button>
                                        <button v-if="qurban.status === 'paid'"
                                                @click="updateStatus(qurban.id, 'slaughtered')"
                                                class="text-xs px-3 py-1 bg-blue-600 hover:bg-blue-700 text-white rounded">
                                            🔪 Sembelih
                                        </button>
                                        
                                        <!-- Edit Button -->
                                        <Link :href="route('qurban.edit', qurban.id)"
                                              class="text-xs px-3 py-1 bg-amber-600 hover:bg-amber-700 text-white rounded">
                                            ✏️ Edit
                                        </Link>
                                        
                                        <!-- Delete Button -->
                                        <button @click="deleteQurban(qurban.id)"
                                                class="text-xs px-3 py-1 bg-red-600 hover:bg-red-700 text-white rounded">
                                            🗑️ Hapus
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <div class="px-6 py-4 bg-slate-50 border-t">
                        <div class="flex justify-between items-center">
                            <div class="text-sm text-slate-600">
                                Showing {{ qurbans.from }} - {{ qurbans.to }} of {{ qurbans.total }}
                            </div>
                            <div class="flex gap-2">
                                <template v-for="link in qurbans.links" :key="link.label">
                                    <Link v-if="link.url"
                                          :href="link.url"
                                          :class="[
                                              'px-3 py-1 rounded',
                                              link.active ? 'bg-emerald-500 text-white' : 'bg-white text-slate-600 hover:bg-slate-100'
                                          ]"
                                          v-html="link.label">
                                    </Link>
                                    <span v-else
                                          :class="['px-3 py-1 rounded bg-slate-100 text-slate-400 cursor-not-allowed']"
                                          v-html="link.label">
                                    </span>
                                </template>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Links -->
                <div class="mt-6 flex gap-4">
                    <Link :href="route('qurban.distribute')" class="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg">
                        📦 Distribusi Daging
                    </Link>
                    <Link :href="route('qurban.reports')" class="px-6 py-3 bg-purple-600 hover:bg-purple-700 text-white font-semibold rounded-lg">
                        📊 Laporan
                    </Link>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
