# FEATURES.md — Status Fitur PIMASJID

Status: **[SELESAI]** / **[SEBAGIAN]** / **[BELUM TERSEDIA]**

---

## PORTAL PUBLIK

### [SELESAI] Landing Page (`/`)
- Controller: `LandingController@index`
- Page: `Welcome.vue`
- Data: jadwal sholat (API aladhan), saldo kas publik, slides, pengurus DKM, jadwal Jumat, berita terbaru (3 post), pengumuman terbaru (1 post via `latestAnnouncement`)
- Fitur: tombol "Donasi" — memanggil `openDonationModal()` via ref ke PublicLayout
- **Catatan:** Jadwal Jumat di landing page adalah data statis hardcoded, bukan dari DB

**Struktur 3 Card Utama (overlapping di bawah hero):**
1. Waktu Sholat — menampilkan sholat berikutnya, countdown, dan tombol lokasi presisi
2. Kas Masjid — saldo kas realtime dari tabel `transactions`
3. Pengumuman Masjid — judul + cuplikan post terbaru yang dipublish (dinamis)

**Section Layanan & Fasilitas (4 card):**
1. Layanan Umat → `/layanan-umat` (menggantikan Ambulans Gratis)
2. Lumbung Pangan
3. TPA / Tahfidz → `/tpa/daftar`
4. Kajian Rutin → `/kajian`

### [SELESAI] Jadwal Sholat (`/ibadah/jadwal`)
- Controller: `PublicController@jadwal`
- Page: `Public/Jadwal.vue`
- Sumber: API aladhan.com (method 11), fallback static jika API gagal
- Koordinat: ambil dari `settings` (`location_latitude`, `location_longitude`), default Jakarta

### [SELESAI] Arah Kiblat (`/ibadah/kiblat`)
- Controller: `PublicController@kiblat`
- Page: `Public/Kiblat.vue` (295 baris)
- Menggunakan Geolocation API browser + DeviceOrientationEvent untuk kompas
- Kalkulasi bearing Kiblat (Mekah: 21.422487°N, 39.826206°E) via formula haversine

### [SELESAI] Jadwal Sholat Jumat (`/ibadah/jumat`)
- Controller: `PublicController@jumat`
- Page: `Public/Jumat.vue`
- Data: dari tabel `friday_schedules`, cari jadwal hari Jumat terdekat

### [SELESAI] Agenda Kegiatan (`/ibadah/agenda`)
- Controller: `PublicController@agenda`
- Page: `Public/Agenda.vue`
- Data: dari tabel `agendas`, hanya agenda `is_active=true` dengan tanggal >= hari ini

### [SELESAI] Kajian Rutin (`/kajian`, `/kajian/{id}`)
- Controller: `KajianController@publicIndex`, `publicShow`
- Pages: `Public/Kajian/Index.vue`, `Public/Kajian/Show.vue`
- Data: tabel `kajians` dengan status (akan_datang / berlangsung / selesai)

### [SELESAI] Berita (`/berita`, `/berita/{slug}`)
- Controller: `PublicController@berita`, `post`
- Pages: `Public/Berita.vue`, `Public/Post.vue`
- Data: tabel `posts`, hanya yang `is_published=true` dan `published_at <= now()`

### [SELESAI] Layanan Umat (`/layanan-umat`, `/layanan-umat/{slug}`)
- Controller: `LayananUmatController@publicIndex`, `publicShow`
- Pages: `Public/LayananUmat/Index.vue`, `Public/LayananUmat/Show.vue`
- Kategori tersedia: sosial, kesehatan, jenazah, pendidikan, fasilitas, zakat, qurban, tpa
- Fitur pencarian dan filter kategori

### [SELESAI] Tracking Layanan Umat (`/layanan-umat/tracking`)
- Controller: `LayananUmatController@trackApplication`
- Tracking via `tracking_code` (format: LU-YYYYMMDD-XXXX)

### [SELESAI] Pendaftaran TPA (`/tpa/daftar`)
- Controller: `TpaRegistrationController@publicIndex`, `store`
- Page: `Public/TpaRegister.vue` (30389 bytes — form sangat lengkap)
- Data disimpan ke `tpa_registrations`

### [SELESAI] Info Zakat (`/info/zakat`)
- Page: `Public/Zakat.vue`
- Halaman informasi + kalkulator zakat (frontend only)

### [SELESAI] Info Qurban (`/info/qurban`)
- Page: `Public/Qurban.vue`
- Halaman informasi + form pendaftaran Shohibul Qurban publik
- Controller: `QurbanController@publicRegister` (POST `/info/qurban/register`)

### [SELESAI] Transparansi Keuangan Publik (`/transparansi/keuangan`)
- Controller: `PublicController@keuangan`
- Page: `Public/Keuangan.vue`
- Hanya tampilkan transaksi dengan `status=approved`

### [SELESAI] Aset Publik (`/transparansi/aset`)
- Controller: `PublicController@aset`
- Page: `Public/Aset.vue`

### [SELESAI] Profil Masjid — Tentang (`/profil/tentang`)
- Controller: `PublicController@tentang`
- Data: dari `settings` (group: `about`) — `about_vision`, `about_mission`, `about_history`, `about_image`

### [SELESAI] Profil Masjid — Struktur Pengurus (`/profil/struktur`)
- Controller: `PublicController@structure`
- Data: dari tabel `committee_members` (is_active=true), digroup per divisi

### [SELESAI] Galeri (`/galeri`)
- Controller: `PublicController@galeri`
- Page: `Public/Galeri.vue`
- **Catatan: galeri bukan foto kegiatan tersendiri — hanya menampilkan data dari tabel `slides` (is_active=true)**

### [SELESAI] Al-Quran Online (`/quran`, `/quran/{nomor}`)
- Pages: `Public/QuranIndex.vue`, `Public/QuranShow.vue`
- Belum ditemukan API backend — kemungkinan menggunakan API publik dari frontend

### [SELESAI] TV Display (`/display`)
- Controller: `DisplayController@index`
- Page: `Display/Index.vue`
- Tidak memerlukan autentikasi
- Data: prayer times (API + fallback), slides, transaksi pemasukan terbaru, wishlist progress, monthly stats
- **Catatan: `fridaySchedule` di DisplayController masih hardcoded, bukan dari DB**

### [SELESAI] AI Assistant Huda (Floating Widget di semua halaman publik)
- Endpoint: POST `/api/ai-assistant/chat`
- Component: `AiAssistantModal.vue`
- Detail arsitektur: lihat `AI_HUDA.md`

---

## PANEL ADMIN (Requires Auth)

### [SELESAI] Dashboard Multi-Role (`/dashboard`)
- Controller: `DashboardController@index`
- Dashboard type berdasarkan role: admin, executive, finance, sekretaris, operations, default
- Data berbeda per role (stats, chart, transactions)

### [SELESAI] Manajemen Transaksi (`/transactions`)
- Controller: `TransactionController`
- Fitur: CRUD, export, approval workflow
- Pengeluaran wajib ada bukti foto (`proof_image_path`)

### [SELESAI] Sistem Approval (`/approvals`)
- Controller: `ApprovalController`
- Approve/reject transaksi pending oleh Ketua
- Badge `pendingApprovalsCount` dibagikan ke semua halaman via Inertia shared data

### [SELESAI] Manajemen Zakat (`/zakat`)
- Controller: `ZakatController`
- Fitur: input zakat (fitrah uang/beras/mal), distribusi, laporan, export

### [SELESAI] Manajemen Qurban (`/qurban`)
- Controller: `QurbanController`
- Fitur: CRUD, update status (registered/paid/slaughtered/distributed), distribusi, laporan, export
- Support sistem patungan sapi (is_shared, share_group_id)

### [SELESAI] Manajemen Layanan Umat Admin (`/admin/layanan-umat`)
- Controller: `LayananUmatController@adminIndex`, `storeService`, `updateService`, `deleteService`, `updateApplicationStatus`

### [SELESAI] Manajemen TPA (`/admin/tpa`)
- Controller: `TpaRegistrationController@index`, `updateStatus`, `update`, `destroy`
- Gate: `can:manage_operations`

### [SELESAI] Manajemen Kajian Admin (`/admin/kajian`)
- Controller: `KajianController` (index, store, update, destroy)
- Gate: `can:manage_operations`

### [SELESAI] Manajemen Agenda (`/agendas`)
- Controller: `AgendaController`
- Gate: `can:manage_operations`

### [SELESAI] Manajemen Slides / TV (`/slides`)
- Controller: `SlideController`
- Fitur: CRUD, toggle active, update order

### [SELESAI] Manajemen Aset (`/assets`)
- Controller: `AssetController`
- Fitur: CRUD + export

### [SELESAI] Manajemen Jadwal Jumat (`/friday-schedules`)
- Controller: `FridayScheduleController`

### [SELESAI] Manajemen Pengurus DKM (`/committee-members`)
- Controller: `CommitteeMemberController`
- Gate: `can:manage_users`

### [SELESAI] Manajemen Berita/Post (`/posts`)
- Controller: `PostController`
- Gate: `can:manage_posts`
- WYSIWYG editor: `WysiwygEditor.vue` (Quill)

### [SELESAI] Manajemen User (`/users`)
- Controller: `UserController`
- Fitur: CRUD user + impersonasi (super_admin only)

### [SELESAI] Global Settings (`/settings`)
- Controller: `SettingController`
- Setting groups: general, hero, about, contact, social, footer

### [SELESAI] Wishlist & Donasi Barang Masjid (Publik & Admin)
- **Controller:** `WishlistController`
- **Publik:**
  - `/wishlist`: Katalog pengadaan sarana/prasarana masjid, filter status, target vs capaian, agregasi KPI donasi.
  - `/wishlist/{wishlist}`: Detail kebutuhan, informasi rekening/QRIS transfer dana, formulir kontribusi donatur (barang fisik/dana transfer, upload bukti struk/foto, pesan doa, opsi Hamba Allah), dan riwayat donatur terverifikasi.
  - `POST /wishlist/{wishlist}/kontribusi`: Endpoint submit donasi jamaah.
- **Admin (`/admin/wishlists`):**
  - KPI Dashboard ringkasan barang & donasi pending.
  - Tab 1: CRUD Kebutuhan Barang (`store`, `update`, `destroy`) + Catat Donasi Masuk Offline (`storeManualContribution`).
  - Tab 2: Verifikasi & Penolakan Kontribusi Jamaah (`verifyContribution`, `rejectContribution`) dengan preview bukti transfer dan auto-increment progress pemenuhan unit pada wishlist.
- **Model:** `Wishlist.php` & `WishlistContribution.php`.
- **Gate:** `can:manage_operations` & `can:manage_finance`.

---

## BELUM TERSEDIA (Model/Tabel ada, UI/Route tidak ada)

### [BELUM TERSEDIA] Galeri Foto Kegiatan Tersendiri
- Saat ini `/galeri` hanya menampilkan slides TV
- Tidak ada model `Gallery`, tidak ada tabel gallery, tidak ada upload foto kegiatan

### [BELUM TERSEDIA] Tabel `prayer_times` (Diisi via DB)
- Tabel `prayer_times` ada di migration tapi tidak ada seeder/controller yang mengisinya
- Saat ini jadwal sholat di-fetch live dari API aladhan.com setiap request

---

## FITUR SEBAGIAN

### [SEBAGIAN] Jadwal Jumat di Landing & Display — Masih Hardcoded
- `LandingController` mengirim data Jumat statis (nama khatib/imam hardcoded)
- `DisplayController` juga menggunakan data statis jika hari Jumat
- Hanya `PublicController@jumat` yang benar-benar baca dari DB (`friday_schedules`)

### [SEBAGIAN] Donasi Online — Frontend Only
- Tombol donasi di landing page ada (`openDonationModal()`) tapi tidak ada endpoint POST untuk menyimpan data donatur
- Hanya menampilkan nomor rekening dari settings

### [SEBAGIAN] FlyonUI Integration
- Package `flyonui: ^2.4.1` terpasang di package.json
- Ada halaman test `/flyonui-test` (FlyonUITest.vue)
- Belum ditemukan penggunaan FlyonUI component di halaman production
