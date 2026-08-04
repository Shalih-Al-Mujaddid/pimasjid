<script setup>
import { ref, computed, onUnmounted, watch } from 'vue'
import { Head, useForm, router } from '@inertiajs/vue3'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import {
  AcademicCapIcon,
  CheckIcon,
  XMarkIcon,
  PencilSquareIcon,
  TrashIcon,
  MagnifyingGlassIcon,
  ArrowPathIcon,
  UserGroupIcon,
  UserIcon,
  PhoneIcon,
  MapPinIcon,
  ClockIcon
} from '@heroicons/vue/24/outline'

const props = defineProps({
  registrations: { type: Array, default: () => [] }
})

const activeTab = ref('pending')
const searchQuery = ref('')
const classFilter = ref('')
const showEditModal = ref(false)
const showDetailModal = ref(false)
const selectedSantri = ref(null)
const selectedDetailSantri = ref(null)

watch([showEditModal, showDetailModal], ([editOpen, detailOpen]) => {
  document.body.style.overflow = editOpen || detailOpen ? 'hidden' : ''
})

onUnmounted(() => {
  document.body.style.overflow = ''
})

const editForm = useForm({
  id: null,
  nama_anak: '',
  tempat_lahir: '',
  tanggal_lahir: '',
  jenis_kelamin: 'L',
  tingkat_sekolah: 'TK',
  nama_ortu: '',
  no_wa: '',
  alamat: '',
  kelas: 'Iqro 1-3',
  ustadz: '',
  progres: ''
})

const pendingRegistrations = computed(() => {
  return props.registrations.filter(r => r.status === 'pending' && r.nama_anak.toLowerCase().includes(searchQuery.value.toLowerCase()))
})

const approvedSantri = computed(() => {
  return props.registrations.filter(r => {
    const matchesStatus = r.status === 'approved'
    const matchesSearch = r.nama_anak.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesClass = !classFilter.value || r.kelas === classFilter.value
    return matchesStatus && matchesSearch && matchesClass
  })
})

const rejectedRegistrations = computed(() => {
  return props.registrations.filter(r => r.status === 'rejected' && r.nama_anak.toLowerCase().includes(searchQuery.value.toLowerCase()))
})

const stats = computed(() => {
  const totalPending = props.registrations.filter(r => r.status === 'pending').length
  const totalApproved = props.registrations.filter(r => r.status === 'approved').length
  const totalLaki = props.registrations.filter(r => r.status === 'approved' && r.jenis_kelamin === 'L').length
  const totalPerempuan = props.registrations.filter(r => r.status === 'approved' && r.jenis_kelamin === 'P').length
  return { pending: totalPending, approved: totalApproved, laki: totalLaki, perempuan: totalPerempuan }
})

const getInitials = (name = '') => {
  return name.trim().split(/\s+/).filter(Boolean).slice(0, 2).map(part => part.charAt(0).toUpperCase()).join('') || 'SA'
}

const profilePhoto = (santri) => santri?.photo_url || santri?.foto_url || santri?.profile_photo_url || santri?.photo_path

const hasProfilePhoto = (santri) => {
  const photo = profilePhoto(santri)
  return Boolean(photo && !String(photo).includes('ui-avatars.com'))
}

const iqroLabel = (kelas) => {
  if (!kelas || kelas === 'Iqro 1-3') return 'Iqro 1-3'
  if (kelas === 'Iqro 4-6') return 'Iqro 4-6'
  if (kelas === 'Al-Quran') return 'Al-Quran'
  if (kelas === 'Tahfidz') return 'Tahfidz'
  return kelas
}

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' })
}

const formatDateTime = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })
}

const isNewSantri = (santri) => {
  if (!santri.approved_at) return false
  const approvedDate = new Date(santri.approved_at)
  const now = new Date()
  return (now - approvedDate) / (1000 * 60 * 60 * 24) < 7
}

const isRecentProgress = (santri) => {
  if (!santri.updated_at) return false
  const updatedDate = new Date(santri.updated_at)
  const now = new Date()
  return (now - updatedDate) / (1000 * 60 * 60) < 24
}

const waMessage = (santri) => {
  const base = 'Assalamualaikum wr. wb.\n'
  const middle = `Bapak/Ibu ${santri.nama_ortu},\nKami ingin menginformasikan bahwa pendaftaran TPA/Tahfidz Masjid Bakri untuk anakanda ${santri.nama_anak} telah kami terima dan sedang dalam proses. Informasi selanjutnya akan kami sampaikan melalui WhatsApp ini.\n\nApabila ada pertanyaan, silakan balas pesan ini.\n\nWassalamualaikum wr. wb.`
  return encodeURIComponent(base + middle)
}

const updateStatus = (id, status) => {
  if (confirm('Apakah Anda yakin ingin mengubah status pendaftaran ini?')) {
    router.patch(route('admin.tpa.status', id), { status }, { preserveScroll: true })
  }
}

const openEditModal = (santri) => {
  selectedSantri.value = santri
  editForm.id = santri.id
  editForm.nama_anak = santri.nama_anak
  editForm.tempat_lahir = santri.tempat_lahir
  editForm.tanggal_lahir = santri.tanggal_lahir
  editForm.jenis_kelamin = santri.jenis_kelamin
  editForm.tingkat_sekolah = santri.tingkat_sekolah
  editForm.nama_ortu = santri.nama_ortu
  editForm.no_wa = santri.no_wa
  editForm.alamat = santri.alamat
  editForm.kelas = santri.kelas || 'Iqro 1-3'
  editForm.ustadz = santri.ustadz || ''
  editForm.progres = santri.progres || ''
  showEditModal.value = true
}

const openDetailModal = (santri) => {
  selectedDetailSantri.value = santri
  showDetailModal.value = true
}

const closeEditModal = () => {
  showEditModal.value = false
  editForm.reset()
  selectedSantri.value = null
}

const closeDetailModal = () => {
  showDetailModal.value = false
  selectedDetailSantri.value = null
}

const submitEdit = () => {
  editForm.put(route('admin.tpa.update', editForm.id), {
    preserveScroll: true,
    onSuccess: () => { closeEditModal() }
  })
}

const deleteRegistration = (id) => {
  if (confirm('Apakah Anda yakin ingin menghapus data ini secara permanen? Data yang dihapus tidak bisa dikembalikan.')) {
    router.delete(route('admin.tpa.destroy', id), { preserveScroll: true })
  }
}
</script>

<template>
  <Head title="Manajemen TPA - Admin" />
  <AuthenticatedLayout>
    <template #header>
      <h2 class="font-semibold text-2xl text-slate-800 dark:text-white leading-tight flex items-center gap-2">
        <AcademicCapIcon class="w-7 h-7 text-emerald-600" />
        Manajemen TPA / Tahfidz
      </h2>
    </template>

    <div class="py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Overview Stats Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">
          <div class="bg-white dark:bg-slate-800 rounded-xl p-5 border border-slate-100 dark:border-slate-700 shadow-sm flex items-center gap-4">
            <div class="p-3 bg-amber-50 dark:bg-amber-950/20 text-amber-600 rounded-xl">
              <ArrowPathIcon class="w-6 h-6 animate-spin-slow" />
            </div>
            <div>
              <div class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Menunggu Persetujuan</div>
              <div class="text-2xl font-bold text-slate-800 dark:text-white mt-0.5">{{ stats.pending }} anak</div>
            </div>
          </div>
          <div class="bg-white dark:bg-slate-800 rounded-xl p-5 border border-slate-100 dark:border-slate-700 shadow-sm flex items-center gap-4">
            <div class="p-3 bg-emerald-50 dark:bg-emerald-950/20 text-emerald-600 rounded-xl">
              <UserGroupIcon class="w-6 h-6" />
            </div>
            <div>
              <div class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Santri Aktif</div>
              <div class="text-2xl font-bold text-slate-800 dark:text-white mt-0.5">{{ stats.approved }} anak</div>
            </div>
          </div>
          <div class="bg-white dark:bg-slate-800 rounded-xl p-5 border border-slate-100 dark:border-slate-700 shadow-sm flex items-center gap-4">
            <div class="p-3 bg-blue-50 dark:bg-blue-950/20 text-blue-600 rounded-xl">
              <UserIcon class="w-6 h-6" />
            </div>
            <div>
              <div class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Santri Laki-laki</div>
              <div class="text-2xl font-bold text-slate-800 dark:text-white mt-0.5">{{ stats.laki }} anak</div>
            </div>
          </div>
          <div class="bg-white dark:bg-slate-800 rounded-xl p-5 border border-slate-100 dark:border-slate-700 shadow-sm flex items-center gap-4">
            <div class="p-3 bg-rose-50 dark:bg-rose-950/20 text-rose-600 rounded-xl">
              <UserIcon class="w-6 h-6" />
            </div>
            <div>
              <div class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Santri Perempuan</div>
              <div class="text-2xl font-bold text-slate-800 dark:text-white mt-0.5">{{ stats.perempuan }} anak</div>
            </div>
          </div>
        </div>

        <!-- Tabs & Filter Bar -->
        <div class="bg-white dark:bg-slate-800 border border-slate-100 dark:border-slate-700 rounded-xl shadow-sm overflow-hidden mb-6">
          <div class="p-5 flex flex-col md:flex-row md:items-center md:justify-between gap-4 border-b border-slate-100 dark:border-slate-700">
            <div class="flex border border-slate-200 dark:border-slate-700 rounded-lg p-1 w-full md:w-fit bg-slate-50 dark:bg-slate-900">
              <button @click="activeTab = 'pending'" class="flex-1 md:flex-none flex items-center justify-center gap-2 px-4 py-2 rounded-md text-xs font-bold transition" :class="activeTab === 'pending' ? 'bg-white dark:bg-slate-800 text-emerald-600 dark:text-emerald-400 shadow-sm' : 'text-slate-500 hover:text-slate-700'">
                Pendaftaran Baru
                <span class="bg-amber-100 text-amber-800 dark:bg-amber-950/40 dark:text-amber-400 px-2 py-0.5 rounded-full text-[10px]">{{ stats.pending }}</span>
              </button>
              <button @click="activeTab = 'approved'" class="flex-1 md:flex-none flex items-center justify-center gap-2 px-4 py-2 rounded-md text-xs font-bold transition" :class="activeTab === 'approved' ? 'bg-white dark:bg-slate-800 text-emerald-600 dark:text-emerald-400 shadow-sm' : 'text-slate-500 hover:text-slate-700'">
                Santri Aktif
                <span class="bg-emerald-100 text-emerald-800 dark:bg-emerald-950/40 dark:text-emerald-400 px-2 py-0.5 rounded-full text-[10px]">{{ stats.approved }}</span>
              </button>
              <button @click="activeTab = 'rejected'" class="flex-1 md:flex-none flex items-center justify-center gap-2 px-4 py-2 rounded-md text-xs font-bold transition" :class="activeTab === 'rejected' ? 'bg-white dark:bg-slate-800 text-emerald-600 dark:text-emerald-400 shadow-sm' : 'text-slate-500 hover:text-slate-700'">
                Ditolak / Batal
              </button>
            </div>

            <div class="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
              <div class="relative flex-1 sm:w-64">
                <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                <input v-model="searchQuery" type="text" placeholder="Cari nama santri..." class="w-full pl-9 pr-4 py-2 text-sm border border-slate-300 dark:border-slate-600 dark:bg-slate-900 dark:text-white rounded-lg focus:outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500" />
              </div>
              <select v-if="activeTab === 'approved'" v-model="classFilter" class="text-sm border border-slate-300 dark:border-slate-600 dark:bg-slate-900 dark:text-white rounded-lg focus:outline-none focus:border-emerald-500">
                <option value="">Semua Kelas</option>
                <option value="Iqro 1-3">Iqro 1-3</option>
                <option value="Iqro 4-6">Iqro 4-6</option>
                <option value="Al-Quran">Al-Quran</option>
                <option value="Tahfidz">Tahfidz</option>
              </select>
            </div>
          </div>

          <!-- TABLE CONTENT -->
          <div class="overflow-x-auto">
            <!-- ===== TAB: PENDING ===== -->
            <table v-if="activeTab === 'pending'" class="min-w-full divide-y divide-slate-200 dark:divide-slate-700">
              <thead class="bg-slate-50 dark:bg-slate-900/50">
                <tr>
                  <th class="px-6 py-3.5 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">Nama Anak / Gender</th>
                  <th class="px-6 py-3.5 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">Orang Tua / Kontak</th>
                  <th class="px-6 py-3.5 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">TTL / Sekolah</th>
                  <th class="px-6 py-3.5 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">Alamat</th>
                  <th class="px-6 py-3.5 text-right text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">Aksi</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-slate-100 dark:divide-slate-700">
                <tr v-for="item in pendingRegistrations" :key="item.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-800/30 transition-colors">
                  <td class="px-6 py-4">
                    <div class="font-bold text-slate-800 dark:text-slate-200">{{ item.nama_anak }}</div>
                    <span class="inline-block px-2 py-0.5 text-[10px] font-bold rounded-full mt-1" :class="item.jenis_kelamin === 'L' ? 'bg-blue-100 text-blue-800 dark:bg-blue-950/40 dark:text-blue-400' : 'bg-rose-100 text-rose-800 dark:bg-rose-950/40 dark:text-rose-400'">
                      {{ item.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan' }}
                    </span>
                  </td>
                  <td class="px-6 py-4">
                    <div class="font-medium text-slate-700 dark:text-slate-300">{{ item.nama_ortu }}</div>
                    <div class="flex items-center gap-1 text-xs text-slate-400 mt-0.5">
                      <PhoneIcon class="w-3 h-3" />
                      <a :href="'https://wa.me/' + item.no_wa.replace(/^0/, '62')" target="_blank" class="hover:text-emerald-600 hover:underline">{{ item.no_wa }}</a>
                    </div>
                  </td>
                  <td class="px-6 py-4">
                    <div class="text-sm text-slate-700 dark:text-slate-300">{{ item.tempat_lahir }}, {{ new Date(item.tanggal_lahir).toLocaleDateString('id-ID', { year: 'numeric', month: 'long', day: 'numeric' }) }}</div>
                    <div class="text-xs text-slate-400 mt-0.5">Sekolah: {{ item.tingkat_sekolah }}</div>
                  </td>
                  <td class="px-6 py-4 max-w-xs truncate text-sm text-slate-600 dark:text-slate-400" :title="item.alamat">{{ item.alamat }}</td>
                  <td class="px-6 py-4 text-right">
                    <div class="flex justify-end items-center gap-2">
                      <button @click="updateStatus(item.id, 'approved')" class="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-lg transition flex items-center gap-1 shadow-sm">
                        <CheckIcon class="w-3.5 h-3.5" /> Setujui
                      </button>
                      <button @click="updateStatus(item.id, 'rejected')" class="px-3 py-1.5 bg-rose-600 hover:bg-rose-700 text-white text-xs font-bold rounded-lg transition flex items-center gap-1 shadow-sm">
                        <XMarkIcon class="w-3.5 h-3.5" /> Tolak
                      </button>
                      <button @click="deleteRegistration(item.id)" class="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg transition" title="Hapus">
                        <TrashIcon class="w-4 h-4" />
                      </button>
                    </div>
                  </td>
                </tr>
                <tr v-if="pendingRegistrations.length === 0">
                  <td colspan="5" class="px-6 py-12 text-center text-slate-400 text-sm">Tidak ada pendaftaran baru yang menunggu persetujuan.</td>
                </tr>
              </tbody>
            </table>

            <!-- ===== TAB: APPROVED SANTRI ===== -->
            <div v-if="activeTab === 'approved'" class="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
              <article v-for="item in approvedSantri" :key="item.id" class="overflow-hidden rounded-2xl border border-emerald-100 bg-white shadow-sm transition hover:-translate-y-1 hover:shadow-lg dark:border-slate-700 dark:bg-slate-800">
                <!-- Header / Cover -->
                <div class="relative h-28 bg-gradient-to-br from-emerald-500 to-teal-600">
                  <div class="absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(255,255,255,0.35),transparent_35%)]"></div>
                  <div v-if="hasProfilePhoto(item)" class="absolute bottom-0 left-1/2 flex h-24 w-24 -translate-x-1/2 translate-y-1/2 items-center justify-center rounded-2xl border-4 border-white bg-slate-100 shadow-lg">
                    <img :src="profilePhoto(item)" :alt="item.nama_anak" class="h-full w-full rounded-2xl object-cover">
                  </div>
                  <div v-else class="absolute bottom-0 left-1/2 flex h-24 w-24 -translate-x-1/2 translate-y-1/2 items-center justify-center rounded-2xl border-4 border-white bg-white/90 text-lg font-black text-emerald-700 shadow-lg">
                    {{ getInitials(item.nama_anak) }}
                  </div>
                  <span v-if="isNewSantri(item)" class="absolute right-3 top-3 rounded-full bg-white/95 px-2.5 py-1 text-[10px] font-black text-emerald-700 shadow-sm tracking-wide">BARU</span>
                </div>

                <!-- Body (clickable for detail) -->
                <button type="button" @click="openDetailModal(item)" class="block w-full text-left pt-14 px-5 pb-3">
                  <div class="text-center">
                    <h3 class="text-base font-bold text-slate-900 dark:text-white">{{ item.nama_anak }}</h3>
                    <p class="mt-1 text-xs font-semibold text-emerald-700 dark:text-emerald-400">
                      {{ iqroLabel(item.kelas) }}
                      <span v-if="item.jenis_kelamin" class="ml-1 text-slate-400">• {{ item.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan' }}</span>
                    </p>
                  </div>

                  <div class="mt-5 grid grid-cols-2 gap-3">
                    <div class="rounded-xl bg-slate-50 p-3 dark:bg-slate-900/60">
                      <div class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Kelas TPA</div>
                      <div class="mt-1 text-sm font-bold text-slate-800 dark:text-slate-200">{{ item.kelas || 'Iqro 1-3' }}</div>
                    </div>
                    <div class="rounded-xl bg-slate-50 p-3 dark:bg-slate-900/60">
                      <div class="text-[10px] font-semibold uppercase tracking-wide text-slate-400">Pengajar</div>
                      <div class="mt-1 truncate text-sm font-bold text-slate-800 dark:text-slate-200" :title="item.ustadz || '-'">{{ item.ustadz || '-' }}</div>
                    </div>
                  </div>

                  <div class="mt-3 rounded-xl border border-emerald-100 bg-emerald-50 p-3 text-xs leading-5 text-slate-600 dark:border-emerald-900/40 dark:bg-emerald-950/20 dark:text-slate-300">
                    <span class="font-semibold text-emerald-700 dark:text-emerald-400">Progres:</span>
                    {{ item.progres ? `"${item.progres}"` : 'Belum ada catatan progres.' }}
                    <span v-if="isRecentProgress(item)" class="ml-2 inline-flex items-center gap-1 text-emerald-600 dark:text-emerald-400">
                      <ClockIcon class="h-3 w-3" /> baru
                    </span>
                  </div>

                  <div class="mt-3 flex flex-wrap items-center justify-between gap-2 text-[11px] text-slate-500 dark:text-slate-400">
                    <div class="flex items-center gap-1.5">
                      <UserIcon class="h-3.5 w-3.5" />
                      <span class="font-semibold text-slate-700 dark:text-slate-300">{{ item.nama_ortu }}</span>
                    </div>
                    <div v-if="item.approved_at" class="flex items-center gap-1 rounded-full bg-slate-100 px-2 py-0.5 dark:bg-slate-700">
                      <ClockIcon class="h-3 w-3" />
                      {{ formatDateTime(item.approved_at) }}
                    </div>
                  </div>

                  <div class="mt-3 flex gap-2">
                    <a :href="'https://wa.me/' + item.no_wa.replace(/^0/, '62')" target="_blank" rel="noopener" class="flex-1 flex items-center justify-center gap-2 rounded-xl bg-emerald-50 px-3 py-2 text-xs font-bold text-emerald-700 hover:bg-emerald-100 dark:bg-emerald-950/20 dark:text-emerald-400 dark:hover:bg-emerald-950/30">
                      <PhoneIcon class="h-3.5 w-3.5" /> Hubungi
                    </a>
                    <a :href="'https://wa.me/' + item.no_wa.replace(/^0/, '62') + '?text=' + waMessage(item)" target="_blank" rel="noopener" class="flex-1 flex items-center justify-center gap-2 rounded-xl bg-emerald-50 px-3 py-2 text-xs font-bold text-emerald-700 hover:bg-emerald-100 dark:bg-emerald-950/20 dark:text-emerald-400 dark:hover:bg-emerald-950/30">
                      <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 012-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 012 2h-5l-5 5v-5z"/></svg>
                      Pesan
                    </a>
                  </div>
                </button>

                <!-- Actions -->
                <div class="flex gap-2 border-t border-slate-100 px-5 py-4 dark:border-slate-700">
                  <button type="button" @click="openEditModal(item)" class="flex-1 rounded-xl bg-slate-800 px-3 py-2 text-xs font-bold text-white transition hover:bg-slate-700 dark:bg-slate-700 dark:hover:bg-slate-600">Edit / Catatan</button>
                  <button type="button" @click="updateStatus(item.id, 'pending')" class="flex-1 rounded-xl border border-amber-200 bg-amber-50 px-3 py-2 text-xs font-bold text-amber-700 transition hover:bg-amber-100 dark:border-amber-900/40 dark:bg-amber-950/20 dark:text-amber-400" title="Batalkan Persetujuan">Batalkan</button>
                  <button type="button" @click="deleteRegistration(item.id)" class="rounded-xl border border-rose-200 bg-rose-50 px-3 py-2 text-xs font-bold text-rose-600 transition hover:bg-rose-100 dark:border-rose-900/40 dark:bg-rose-950/20 dark:text-rose-400" title="Hapus">
                    <TrashIcon class="mx-auto w-4 h-4" />
                  </button>
                </div>
              </article>

              <div v-if="approvedSantri.length === 0" class="col-span-full rounded-2xl border border-dashed border-slate-300 bg-slate-50 p-10 text-center dark:border-slate-700 dark:bg-slate-900/40">
                <UserGroupIcon class="mx-auto h-10 w-10 text-slate-400" />
                <h3 class="mt-3 text-sm font-bold text-slate-700 dark:text-slate-200">Tidak ada santri aktif ditemukan.</h3>
                <p class="mt-1 text-xs text-slate-500">Setujui pendaftaran baru untuk menampilkan santri di sini.</p>
              </div>
            </div>

            <!-- ===== TAB: REJECTED ===== -->
            <table v-if="activeTab === 'rejected'" class="min-w-full divide-y divide-slate-200 dark:divide-slate-700">
              <thead class="bg-slate-50 dark:bg-slate-900/50">
                <tr>
                  <th class="px-6 py-3.5 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">Nama Anak</th>
                  <th class="px-6 py-3.5 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">Orang Tua</th>
                  <th class="px-6 py-3.5 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">No WA</th>
                  <th class="px-6 py-3.5 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">Alamat</th>
                  <th class="px-6 py-3.5 text-right text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase tracking-wide">Aksi</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-slate-100 dark:divide-slate-700">
                <tr v-for="item in rejectedRegistrations" :key="item.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-800/30 transition-colors">
                  <td class="px-6 py-4">
                    <div class="font-bold text-slate-800 dark:text-slate-200">{{ item.nama_anak }}</div>
                    <span class="inline-block px-2 py-0.5 text-[10px] font-bold rounded-full mt-1" :class="item.jenis_kelamin === 'L' ? 'bg-blue-100 text-blue-800' : 'bg-rose-100 text-rose-800'">
                      {{ item.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 text-sm text-slate-700 dark:text-slate-300 font-medium">{{ item.nama_ortu }}</td>
                  <td class="px-6 py-4 text-sm text-slate-600 dark:text-slate-400">{{ item.no_wa }}</td>
                  <td class="px-6 py-4 max-w-xs truncate text-sm text-slate-600 dark:text-slate-400" :title="item.alamat">{{ item.alamat }}</td>
                  <td class="px-6 py-4 text-right">
                    <div class="flex justify-end items-center gap-2">
                      <button @click="updateStatus(item.id, 'pending')" class="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-lg transition flex items-center gap-1 shadow-sm">
                        <ArrowPathIcon class="w-3.5 h-3.5" /> Pulihkan
                      </button>
                      <button @click="deleteRegistration(item.id)" class="px-3 py-1.5 bg-rose-600 hover:bg-rose-700 text-white text-xs font-bold rounded-lg transition flex items-center gap-1 shadow-sm">
                        <TrashIcon class="w-3.5 h-3.5" /> Hapus
                      </button>
                    </div>
                  </td>
                </tr>
                <tr v-if="rejectedRegistrations.length === 0">
                  <td colspan="5" class="px-6 py-12 text-center text-slate-400 text-sm">Tidak ada pendaftaran yang ditolak atau dibatalkan.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- DETAIL SANTRI MODAL -->
        <div v-if="showDetailModal && selectedDetailSantri" class="fixed inset-0 z-50 overflow-y-auto bg-slate-900/70 p-4 backdrop-blur-sm sm:p-6" @click.self="closeDetailModal">
          <div class="mx-auto my-6 w-full max-w-3xl">
            <div class="overflow-hidden rounded-3xl bg-white shadow-2xl ring-1 ring-slate-900/5 dark:bg-slate-800 dark:ring-white/10">
              <div class="relative bg-gradient-to-br from-emerald-500 via-teal-500 to-cyan-500 px-6 pb-24 pt-6 text-center">
                <button type="button" @click="closeDetailModal" class="absolute right-4 top-4 rounded-xl bg-white/20 p-2 text-white backdrop-blur transition hover:bg-white/30" aria-label="Tutup detail santri">
                  <XMarkIcon class="w-5 h-5" />
                </button>
                <div v-if="hasProfilePhoto(selectedDetailSantri)" class="mx-auto flex h-32 w-32 items-center justify-center rounded-3xl border-4 border-white bg-white shadow-xl">
                  <img :src="profilePhoto(selectedDetailSantri)" :alt="selectedDetailSantri.nama_anak" class="h-full w-full rounded-3xl object-cover">
                </div>
                <div v-else class="mx-auto flex h-32 w-32 items-center justify-center rounded-3xl border-4 border-white bg-white text-3xl font-black text-emerald-700 shadow-xl">
                  {{ getInitials(selectedDetailSantri.nama_anak) }}
                </div>
                <h3 class="mt-5 text-2xl font-black text-white">{{ selectedDetailSantri.nama_anak }}</h3>
                <p class="mt-2 inline-flex items-center justify-center rounded-full bg-white/20 px-4 py-1.5 text-sm font-bold text-white backdrop-blur">
                  {{ iqroLabel(selectedDetailSantri.kelas) }}
                  <span class="mx-2">•</span>
                  {{ selectedDetailSantri.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan' }}
                </p>
              </div>

              <div class="max-h-[calc(100vh-330px)] space-y-5 overflow-y-auto p-6">
                <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                  <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200 dark:bg-slate-900/60 dark:ring-slate-700">
                    <div class="flex items-center gap-2 text-xs font-bold uppercase tracking-wide text-slate-400">
                      <AcademicCapIcon class="h-4 w-4 text-emerald-600" /> Kelas TPA
                    </div>
                    <div class="mt-2 text-base font-bold text-slate-900 dark:text-white">{{ selectedDetailSantri.kelas || 'Iqro 1-3' }}</div>
                  </div>
                  <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200 dark:bg-slate-900/60 dark:ring-slate-700">
                    <div class="flex items-center gap-2 text-xs font-bold uppercase tracking-wide text-slate-400">
                      <UserIcon class="h-4 w-4 text-emerald-600" /> Pengajar
                    </div>
                    <div class="mt-2 text-base font-bold text-slate-900 dark:text-white">{{ selectedDetailSantri.ustadz || '-' }}</div>
                  </div>
                  <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200 dark:bg-slate-900/60 dark:ring-slate-700">
                    <div class="flex items-center gap-2 text-xs font-bold uppercase tracking-wide text-slate-400">
                      <UserIcon class="h-4 w-4 text-blue-600" /> Nama Wali
                    </div>
                    <div class="mt-2 text-base font-bold text-slate-900 dark:text-white">{{ selectedDetailSantri.nama_ortu }}</div>
                  </div>
                  <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200 dark:bg-slate-900/60 dark:ring-slate-700">
                    <div class="flex items-center gap-2 text-xs font-bold uppercase tracking-wide text-slate-400">
                      <PhoneIcon class="h-4 w-4 text-emerald-600" /> Kontak Wali
                    </div>
                    <a :href="'https://wa.me/' + selectedDetailSantri.no_wa.replace(/^0/, '62')" target="_blank" class="mt-2 block text-base font-bold text-emerald-700 hover:underline dark:text-emerald-400">
                      {{ selectedDetailSantri.no_wa }}
                    </a>
                  </div>
                  <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200 dark:bg-slate-900/60 dark:ring-slate-700">
                    <div class="flex items-center gap-2 text-xs font-bold uppercase tracking-wide text-slate-400">
                      <AcademicCapIcon class="h-4 w-4 text-blue-600" /> Sekolah
                    </div>
                    <div class="mt-2 text-base font-bold text-slate-900 dark:text-white">{{ selectedDetailSantri.tingkat_sekolah }}</div>
                  </div>
                  <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200 dark:bg-slate-900/60">
                    <div class="flex items-center gap-2 text-xs font-bold uppercase tracking-wide text-slate-400">
                      <UserIcon class="h-4 w-4 text-rose-600" /> TTL
                    </div>
                    <div class="mt-2 text-base font-bold text-slate-900 dark:text-white">
                      {{ selectedDetailSantri.tempat_lahir }}, {{ formatDate(selectedDetailSantri.tanggal_lahir) }}
                    </div>
                  </div>
                  <div class="rounded-2xl bg-slate-50 p-4 ring-1 ring-slate-200 md:col-span-2 dark:bg-slate-900/60 dark:ring-slate-700">
                    <div class="flex items-center gap-2 text-xs font-bold uppercase tracking-wide text-slate-400">
                      <MapPinIcon class="h-4 w-4 text-emerald-600" /> Alamat
                    </div>
                    <div class="mt-2 text-sm font-semibold leading-6 text-slate-700 dark:text-slate-300">{{ selectedDetailSantri.alamat }}</div>
                  </div>
                </div>

                <div class="rounded-2xl bg-emerald-50 p-5 ring-1 ring-emerald-100 dark:bg-emerald-950/20 dark:ring-emerald-900/40">
                  <h4 class="text-sm font-bold text-emerald-800 dark:text-emerald-300">Catatan Perkembangan</h4>
                  <p class="mt-3 text-sm leading-6 text-slate-700 dark:text-slate-300">
                    {{ selectedDetailSantri.progres || 'Belum ada catatan progres untuk santri ini.' }}
                  </p>
                  <div class="mt-4 text-xs font-medium text-slate-500 dark:text-slate-400">
                    Terakhir diperbarui: {{ formatDateTime(selectedDetailSantri.updated_at) }}
                  </div>
                </div>
              </div>

              <div class="sticky bottom-0 z-10 border-t border-slate-100 bg-white/95 px-6 py-4 backdrop-blur dark:border-slate-700 dark:bg-slate-800/95">
                <div class="flex flex-col gap-3 sm:flex-row sm:justify-end">
                  <button type="button" @click="openEditModal(selectedDetailSantri)" class="rounded-xl bg-slate-800 px-5 py-2.5 text-sm font-bold text-white transition hover:bg-slate-700 dark:bg-slate-700 dark:hover:bg-slate-600">Edit / Catatan</button>
                  <button type="button" @click="updateStatus(selectedDetailSantri.id, 'pending')" class="rounded-xl border border-amber-200 bg-amber-50 px-5 py-2.5 text-sm font-bold text-amber-700 transition hover:bg-amber-100 dark:border-amber-900/40 dark:bg-amber-950/20 dark:text-amber-400">Batalkan Persetujuan</button>
                  <button type="button" @click="deleteRegistration(selectedDetailSantri.id)" class="rounded-xl border border-rose-200 bg-rose-50 px-5 py-2.5 text-sm font-bold text-rose-600 transition hover:bg-rose-100 dark:border-rose-900/40 dark:bg-rose-950/20 dark:text-rose-400">Hapus Data</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- EDIT / UPDATE PROGRES MODAL -->
        <div v-if="showEditModal" class="fixed inset-0 z-50 overflow-y-auto bg-slate-900/70 p-4 backdrop-blur-sm sm:p-6" @click.self="closeEditModal">
          <div class="mx-auto my-6 w-full max-w-3xl">
            <div class="overflow-hidden rounded-3xl bg-white shadow-2xl ring-1 ring-slate-900/5 dark:bg-slate-800 dark:ring-white/10">
              <div class="sticky top-0 z-10 border-b border-slate-100 bg-white/95 px-6 py-5 backdrop-blur dark:border-slate-700 dark:bg-slate-800/95">
                <div class="flex items-start justify-between gap-4">
                  <div>
                    <h3 class="flex items-center gap-2 text-lg font-bold text-slate-900 dark:text-white">
                      <span class="flex h-9 w-9 items-center justify-center rounded-xl bg-emerald-50 text-emerald-600 dark:bg-emerald-950/40 dark:text-emerald-400">
                        <PencilSquareIcon class="w-5 h-5" />
                      </span>
                      Edit Data & Catatan Belajar Santri
                    </h3>
                    <p class="mt-2 text-xs font-medium text-slate-500 dark:text-slate-400">
                      {{ selectedSantri?.nama_anak }}
                      <span v-if="selectedSantri?.kelas">• {{ selectedSantri.kelas }}</span>
                    </p>
                  </div>
                  <button type="button" @click="closeEditModal" class="rounded-xl p-2 text-slate-400 transition hover:bg-slate-100 hover:text-slate-700 focus:outline-none focus:ring-2 focus:ring-emerald-500 dark:hover:bg-slate-700 dark:hover:text-slate-200" aria-label="Tutup modal">
                    <XMarkIcon class="w-5 h-5" />
                  </button>
                </div>
              </div>

              <form @submit.prevent="submitEdit">
                <div class="max-h-[calc(100vh-210px)] space-y-6 overflow-y-auto p-6">
                  <div class="rounded-2xl bg-slate-50 p-5 ring-1 ring-slate-200 dark:bg-slate-900/60 dark:ring-slate-700">
                    <h4 class="mb-4 text-xs font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400">Biodata Santri</h4>
                    <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                      <div>
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Nama Lengkap Anak</label>
                        <input v-model="editForm.nama_anak" type="text" class="h-10 w-full rounded-xl border border-slate-200 px-3 text-sm text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white" required>
                      </div>
                      <div>
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Jenis Kelamin</label>
                        <select v-model="editForm.jenis_kelamin" class="h-10 w-full rounded-xl border border-slate-200 px-3 text-sm text-slate-800 outline-none transition focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white" required>
                          <option value="L">Laki-laki</option>
                          <option value="P">Perempuan</option>
                        </select>
                      </div>
                      <div>
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Tempat Lahir</label>
                        <input v-model="editForm.tempat_lahir" type="text" class="h-10 w-full rounded-xl border border-slate-200 px-3 text-sm text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white" required>
                      </div>
                      <div>
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Tanggal Lahir</label>
                        <input v-model="editForm.tanggal_lahir" type="date" class="h-10 w-full rounded-xl border border-slate-200 px-3 text-sm text-slate-800 outline-none transition focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white" required>
                      </div>
                      <div>
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Pendidikan Formal</label>
                        <input v-model="editForm.tingkat_sekolah" type="text" class="h-10 w-full rounded-xl border border-slate-200 px-3 text-sm text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white">
                      </div>
                      <div>
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Nama Wali</label>
                        <input v-model="editForm.nama_ortu" type="text" class="h-10 w-full rounded-xl border border-slate-200 px-3 text-sm text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white" required>
                      </div>
                      <div>
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">No. WhatsApp</label>
                        <input v-model="editForm.no_wa" type="text" inputmode="tel" class="h-10 w-full rounded-xl border border-slate-200 px-3 text-sm text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white" required>
                      </div>
                      <div class="md:col-span-2">
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Alamat Domisili</label>
                        <textarea v-model="editForm.alamat" rows="2" class="w-full resize-y rounded-xl border border-slate-200 px-3 py-2 text-sm text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white" required></textarea>
                      </div>
                    </div>
                  </div>

                  <div class="rounded-2xl bg-emerald-50/70 p-5 ring-1 ring-emerald-100 dark:bg-emerald-950/20 dark:ring-emerald-900/40">
                    <h4 class="mb-4 text-xs font-bold uppercase tracking-wider text-emerald-700 dark:text-emerald-400">Administrasi & Belajar TPA</h4>
                    <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                      <div>
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Kelas TPA</label>
                        <select v-model="editForm.kelas" class="h-10 w-full rounded-xl border border-emerald-200 px-3 text-sm text-slate-800 outline-none transition focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white">
                          <option value="Iqro 1-3">Iqro 1-3</option>
                          <option value="Iqro 4-6">Iqro 4-6</option>
                          <option value="Al-Quran">Al-Quran</option>
                          <option value="Tahfidz">Tahfidz</option>
                        </select>
                      </div>
                      <div>
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Ustadz Pengajar</label>
                        <input v-model="editForm.ustadz" type="text" placeholder="Ust. Rahman / Usth. Nisa" class="h-10 w-full rounded-xl border border-emerald-200 px-3 text-sm text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white">
                      </div>
                      <div class="md:col-span-2">
                        <label class="mb-1.5 block text-xs font-semibold text-slate-600 dark:text-slate-300">Catatan Perkembangan (Progres)</label>
                        <textarea v-model="editForm.progres" rows="3" class="w-full resize-y rounded-xl border border-emerald-200 px-3 py-2 text-sm text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 dark:border-slate-700 dark:bg-slate-950 dark:text-white" placeholder="Contoh: Sudah hafal juz 1, aktif di kelas..."></textarea>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="sticky bottom-0 z-10 border-t border-slate-100 bg-white/95 px-6 py-4 backdrop-blur dark:border-slate-700 dark:bg-slate-800/95">
                  <div class="flex flex-col-reverse sm:flex-row justify-end gap-3">
                    <button type="button" @click="closeEditModal" class="rounded-xl border border-slate-200 bg-white px-5 py-2.5 text-sm font-semibold text-slate-600 transition hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-300 dark:hover:bg-slate-700">Batal</button>
                    <button type="submit" :disabled="editForm.processing" class="rounded-xl bg-emerald-600 px-5 py-2.5 text-sm font-bold text-white transition hover:bg-emerald-700 disabled:opacity-60">
                      {{ editForm.processing ? 'Menyimpan...' : 'Simpan Perubahan' }}
                    </button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>
