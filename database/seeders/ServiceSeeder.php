<?php

namespace Database\Seeders;

use App\Models\Service;
use Illuminate\Database\Seeder;

class ServiceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $services = [
            [
                'title' => 'Bantuan Santunan Dhuafa & Anak Yatim',
                'slug' => 'bantuan-santunan-dhuafa-yatim',
                'category' => 'sosial',
                'icon' => 'HeartIcon',
                'short_description' => 'Program bantuan biaya hidup dan kebutuhan pokok bagi jamaah dhuafa dan anak yatim.',
                'description' => 'Program Santunan Dhuafa & Anak Yatim diselenggarakan oleh DKM Masjid PImasjid untuk meringankan beban perekonomian jamaah kurang mampu dan menjamin kelangsungan kehidupan anak-anak yatim di lingkungan sekitar masjid.',
                'terms' => "- Beragama Islam dan warga sekitar lingkungan masjid\n- Melampirkan Fotokopi KTP Pemohon & Kartu Keluarga (KK)\n- Melampirkan Surat Keterangan Tidak Mampu (SKTM) dari RT/RW setempat\n- Untuk santunan yatim, melampirkan Surat Keterangan Kematian Orang Tua",
                'how_to_apply' => "1. Isi formulir pengajuan online di bawah ini atau datang langsung ke Sekretariat DKM\n2. Unggah dokumen pendukung (KTP/KK/SKTM)\n3. DKM akan melakukan verifikasi berkas dan survei lapangan (jika diperlukan)\n4. Hasil verifikasi akan diinformasikan via WhatsApp & dapat dicek melalui Kode Resi Tracking",
                'external_link' => null,
                'is_active' => true,
                'is_featured' => true,
            ],
            [
                'title' => 'Layanan Ambulans & Mobil Jenazah Gratis',
                'slug' => 'layanan-ambulans-gratis',
                'category' => 'kesehatan',
                'icon' => 'TruckIcon',
                'short_description' => 'Layanan antar-jemput pasien darurat dan pengantaran jenazah 24 jam gratis bagi warga.',
                'description' => 'Masjid PImasjid menyediakan Armada Ambulans dan Mobil Jenazah 24 jam secara gratis bagi jamaah yang membutuhkan pengantaran darurat ke rumah sakit maupun pengantaran jenazah ke pemakaman.',
                'terms' => "- Terbuka untuk seluruh jamaah & warga masyarakat\n- Mengisi form pengajuan atau menghubungi Call Center DKM/Marbot 24 jam\n- Menyiapkan alamat penjemputan dan tujuan yang jelas",
                'how_to_apply' => "1. Hubungi kontak darurat marbot atau ajukan form online dengan nomor WhatsApp aktif\n2. Petugas ambulans akan mengonfirmasi lokasi penjemputan\n3. Armada siap meluncur ke lokasi",
                'external_link' => null,
                'is_active' => true,
                'is_featured' => true,
            ],
            [
                'title' => 'Pengurusan Kain Kafan & Perlengkapan Jenazah',
                'slug' => 'pengurusan-jenazah-kain-kafan',
                'category' => 'jenazah',
                'icon' => 'UserGroupIcon',
                'short_description' => 'Penyediaan perlengkapan fardhu kifayah jenazah secara gratis dan bantuan pemandian/pemakaman.',
                'description' => 'Masjid memberikan kemudahan bagi keluarga duka dalam menunaikan fardhu kifayah dengan menyediakan kain kafan lengkap, sabun, kapur barus, keranda, serta pendampingan tim pemulasaraan jenazah DKM.',
                'terms' => "- Beragama Islam\n- Melampirkan Surat Keterangan Kematian dari Rumah Sakit / RT / RW\n- Keluarga berkoordinasi langsung dengan Tim Pengurusan Jenazah DKM",
                'how_to_apply' => "1. Kirimkan pengajuan atau telepon tim DKM bidang Sosial & Jenazah\n2. Tim akan membawa paket kain kafan & perlengkapan ke rumah duka\n3. Pemulasaraan dilaksanakan sesuai syariat Islam",
                'external_link' => null,
                'is_active' => true,
                'is_featured' => true,
            ],
            [
                'title' => 'Beasiswa Pendidikan Santri Al-Qur\'an',
                'slug' => 'beasiswa-pendidikan-santri',
                'category' => 'pendidikan',
                'icon' => 'AcademicCapIcon',
                'short_description' => 'Bantuan beasiswa SPP dan alat tulis bagi santri TPA kurang mampu yang berprestasi.',
                'description' => 'Program beasiswa ini bertujuan memastikan setiap anak-anak jamaah tetap mendapatkan pendidikan Al-Qur\'an dan formal tanpa terkendala keterbatasan biaya.',
                'terms' => "- Santri terdaftar aktif di TPA Masjid PImasjid\n- Memiliki kemauan belajar yang tinggi dan kedisiplinan hadir\n- Melampirkan Surat Keterangan Tidak Mampu (SKTM) dari RT/RW",
                'how_to_apply' => "1. Orang tua/wali santri mengisi form pengajuan online\n2. Tim pengelola TPA dan DKM memverifikasi kelayakan\n3. Penerima beasiswa ditetapkan dan biaya pendidikan dibebaskan",
                'external_link' => null,
                'is_active' => true,
                'is_featured' => false,
            ],
            [
                'title' => 'Pinjam Fasilitas & Alat Serbaguna Masjid',
                'slug' => 'pinjam-fasilitas-masjid',
                'category' => 'fasilitas',
                'icon' => 'SparklesIcon',
                'short_description' => 'Peminjaman aula, tenda, sound system, dan perlengkapan untuk syukuran / acara jamaah.',
                'description' => 'Masjid menyediakan fasilitas berupa aula serbaguna, karpet, meja-kursi, dan sound system portable yang dapat dipinjam jamaah untuk kegiatan keagamaan dan kemasyarakatan.',
                'terms' => "- Acara tidak melanggar syariat Islam dan norma masyarakat\n- Wajib menjaga kebersihan, ketertiban, dan keutuhan barang yang dipinjam\n- Pengajuan dilakukan maksimal H-3 sebelum pelaksanaan kegiatan",
                'how_to_apply' => "1. Pengaju mengisi formulir peminjaman dengan rincian acara dan tanggal\n2. DKM memeriksa ketersediaan tanggal dan alat\n3. Pengaju menerima konfirmasi izin dan arahan dari marbot masjid",
                'external_link' => null,
                'is_active' => true,
                'is_featured' => false,
            ],
            // Integrated Modules (Zakat, Qurban, TPA)
            [
                'title' => 'Layanan Penerima Zakat (Mustahik)',
                'slug' => 'layanan-mustahik-zakat',
                'category' => 'zakat',
                'icon' => 'GiftIcon',
                'short_description' => 'Penyaluran Zakat Fitrah & Zakat Mal bagi 8 asnaf penerima zakat yang berhak.',
                'description' => 'Program pendataan dan penyaluran Zakat Masjid PImasjid secara transparan dan akuntabel kepada para Mustahik (Fakir, Miskin, Amil, Mualaf, Riqab, Gharimin, Fisabilillah, Ibnu Sabil).',
                'terms' => "- Berhak menerima zakat berdasarkan 8 Asnaf Al-Qur'an\n- Terdata dalam basis data Muzakki-Mustahik DKM",
                'how_to_apply' => 'Klik tombol di bawah untuk melihat kalkulator zakat dan informasi lengkap layanan Zakat PIMASJID.',
                'external_link' => '/info/zakat',
                'is_active' => true,
                'is_featured' => true,
            ],
            [
                'title' => 'Program Qurban & Distribusi Daging',
                'slug' => 'program-qurban-distribusi',
                'category' => 'qurban',
                'icon' => 'CakeIcon',
                'short_description' => 'Pendaftaran Shohibul Qurban (Sapi/Kambing) dan pengajuan kupon penerima daging.',
                'description' => 'Layanan pengelolaan ibadah Qurban Hari Raya Idul Adha mencakup penyediaan hewan, penyembelihan syar\'i, pemotongan hiegenis, dan pembagian daging qurban secara merata.',
                'terms' => "- Pendaftaran Shohibul Qurban dibuka menjelang bulan Dzulhijjah\n- Pengajuan penerima daging diutamakan untuk warga lingkungan masjid",
                'how_to_apply' => 'Klik tombol di bawah untuk mendaftar sebagai Shohibul Qurban atau melihat informasi Qurban PIMASJID.',
                'external_link' => '/info/qurban',
                'is_active' => true,
                'is_featured' => true,
            ],
            [
                'title' => 'Pendaftaran Santri TPA',
                'slug' => 'pendaftaran-tpa',
                'category' => 'tpa',
                'icon' => 'BookOpenIcon',
                'short_description' => 'Pendaftaran murid baru Taman Pendidikan Al-Qur\'an (Iqro, Al-Qur\'an, & Tahfidz).',
                'description' => 'TPA mendidik anak-anak menjadi generasi Qur\'ani yang berakhlak mulia melalui pembelajaran tajwid, tahsin, hafalan surah pendek, adab harian, dan doa.',
                'terms' => "- Usia minimal 4 tahun\n- Mengisi formulir pendaftaran santri baru dan melampirkan fotokopi Akta Lahir/KK",
                'how_to_apply' => 'Klik tombol di bawah untuk mengisi formulir pendaftaran santri TPA online secara langsung.',
                'external_link' => '/tpa/daftar',
                'is_active' => true,
                'is_featured' => true,
            ],
        ];

        foreach ($services as $service) {
            Service::updateOrCreate(
                ['slug' => $service['slug']],
                $service
            );
        }
    }
}
