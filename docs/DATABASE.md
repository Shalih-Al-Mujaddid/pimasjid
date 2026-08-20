# DATABASE.md — Skema Database PIMASJID

> Semua informasi diambil dari file migration di `database/migrations/`.
> Total: **27 migration files**, menghasilkan kurang lebih **20 tabel aktif**.

---

## Tabel: `users`
Migration: `0001_01_01_000000_create_users_table.php`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `name` | string | |
| `email` | string unique | |
| `email_verified_at` | timestamp nullable | |
| `role` | enum | `super_admin`, `ketua`, `bendahara`, `sekretaris`, `marbot`. Default: `marbot` |
| `is_active` | boolean | Default: true |
| `password` | string | Hashed |
| `remember_token` | string | |
| `created_at`, `updated_at` | timestamps | |

> Tidak ada role `jamaah` — hanya 5 role untuk internal pengelola masjid.

---

## Tabel: `transactions`
Migration: `2026_01_20_064744_create_transactions_table.php` + Cloudinary migration

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `uuid` | uuid unique | Identifier publik untuk share link |
| `type` | enum | `income`, `expense` |
| `category` | string(100) | Misal: Kotak Jumat, Renovasi, Operasional |
| `amount` | decimal(15,2) | |
| `description` | text nullable | |
| `proof_image_path` | string nullable | Wajib diisi untuk expense |
| `cloudinary_public_id` | string nullable | |
| `verified_by` | FK → users nullable | User yang input transaksi |
| `date` | date | |
| `status` | enum | `approved`, `pending`, `rejected`. Default: `approved` |
| `approved_by` | FK → users nullable | User yang approve (Ketua) |
| `approved_at` | timestamp nullable | |
| `rejection_reason` | text nullable | |
| `created_at`, `updated_at` | timestamps | |

**Index:** `(type, date)`, `category`, `date`, `status`

**Scopes di Model:** `income()`, `expense()`, `approved()`, `pending()`, `rejected()`, `thisMonth()`

---

## Tabel: `slides`
Migration: `2026_01_20_064745_create_slides_table.php` + Cloudinary

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `title` | string(200) | |
| `content` | text nullable | |
| `image_path` | string nullable | |
| `cloudinary_public_id` | string nullable | |
| `is_active` | boolean | Default: true |
| `order` | integer | Default: 0, ascending |
| `created_at`, `updated_at` | timestamps | |

**Index:** `(is_active, order)`

---

## Tabel: `wishlists`
Migration: `2026_01_20_064747_create_wishlists_table.php`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `item_name` | string(200) | |
| `target_qty` | integer | Default: 1 |
| `fulfilled_qty` | integer | Default: 0 |
| `unit_price` | decimal(15,2) | |
| `status` | enum | `active`, `pending`, `completed`, `cancelled`. Default: `active` |
| `description` | text nullable | |
| `created_at`, `updated_at` | timestamps | |

**Relasi & Accessors:** Model `Wishlist.php` berelasi `hasMany(WishlistContribution::class)` dan memiliki method `recalculateProgress()`. Accessors: `total_target`, `total_fulfilled`, `remaining_qty`, `progress_percentage`, `formatted_unit_price`, `status_label`. Dikelola via `WishlistController`.

---

## Tabel: `wishlist_contributions`
Migration: `2026_08_18_100000_create_wishlist_contributions_table.php`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `wishlist_id` | FK → wishlists cascadeOnDelete | Target kebutuhan barang |
| `donor_name` | string | Nama donatur / penyumbang |
| `donor_phone` | string(25) nullable | Nomor kontak/WhatsApp |
| `donor_email` | string nullable | Email donatur |
| `quantity` | integer | Jumlah unit barang (default: 1) |
| `amount` | decimal(15,2) nullable | Nominal uang jika transfer dana |
| `type` | enum indexed | `barang`, `dana`. Default: `barang` |
| `proof_image_path` | string nullable | Foto struk transfer atau foto serah terima barang |
| `notes` | text nullable | Pesan dan doa kebaikan |
| `is_anonymous` | boolean | Sembunyikan nama (Hamba Allah). Default: false |
| `status` | enum indexed | `pending`, `verified`, `rejected`. Default: `pending` |
| `verified_by` | FK → users nullable nullOnDelete | User pengurus yang memverifikasi |
| `verified_at` | timestamp nullable | Waktu verifikasi |
| `admin_notes` | text nullable | Catatan verifikator |
| `created_at`, `updated_at` | timestamps | |

**Index composite:** `(wishlist_id, status)`

---

## Tabel: `assets`
Migration: `2026_01_20_074421_create_assets_table.php`

> Detail kolom: Belum dilihat isi migration. Dikelola via `AssetController`.

---

## Tabel: `committee_members`
Migration: `2026_01_20_080247_create_committee_members_table.php` + Cloudinary

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `name` | string | |
| `position` | string | Jabatan |
| `division` | string | Divisi (Inti, Dakwah, dll) |
| `order` | integer | Urutan tampil |
| `is_active` | boolean | |
| `photo_path` | string nullable | |
| `cloudinary_public_id` | string nullable | |
| `created_at`, `updated_at` | timestamps | |

---

## Tabel: `settings`
Migration: `2026_01_20_091803_create_settings_table.php` + about migration

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `key` | string unique | |
| `value` | text nullable | |
| `cloudinary_public_id` | string nullable | |
| `type` | enum | `text`, `textarea`, `image`, `boolean` |
| `group` | string indexed | `general`, `hero`, `contact`, `social`, `footer`, `about` |
| `label` | string nullable | Label human-readable |
| `created_at`, `updated_at` | timestamps | |

**Setting keys yang diketahui (dari source code):**
- `app_name`, `location_name`, `location_latitude`, `location_longitude`
- `contact_phone`, `phone`
- `bank_name`, `bank_account`, `bank_number`, `bank_holder`
- `about_hero_title`, `about_hero_subtitle`, `about_vision`, `about_mission`, `about_history`, `about_image`

---

## Tabel: `agendas`
Migration: `2026_01_20_104429_create_agendas_table.php`

> Detail kolom: Belum dilihat isi migration. Model `Agenda.php` memiliki scope `active()`.

---

## Tabel: `zakats`
Migration: `2026_01_21_204111_create_zakats_table.php`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `uuid` | uuid unique | |
| `muzakki_name` | string | Nama pembayar zakat |
| `muzakki_nik` | string nullable indexed | |
| `muzakki_phone` | string nullable | |
| `muzakki_address` | text nullable | |
| `type` | enum indexed | `fitrah`, `mal`, `profesi` |
| `amount` | decimal(15,2) | Jumlah rupiah |
| `payment_type` | enum | `uang`, `beras`. Default: `uang` |
| `rice_kg` | decimal(10,2) nullable | Untuk pembayaran beras |
| `person_count` | integer nullable | Jumlah jiwa (untuk fitrah) |
| `year` | integer indexed | Tahun hijriah |
| `date` | date indexed | |
| `notes` | text nullable | |
| `collected_by` | FK → users | |
| `created_at`, `updated_at` | timestamps | |

**Index composite:** `(type, year)`, `(year, date)`

---

## Tabel: `zakat_distributions`
Migration: `2026_01_21_204112_create_zakat_distributions_table.php`

> Detail kolom: Belum dilihat isi migration. Dikelola via `ZakatController@distribute`.

---

## Tabel: `qurbans`
Migration: `2026_01_21_204114_create_qurbans_table.php`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `uuid` | uuid unique | |
| `participant_name` | string | |
| `participant_nik` | string nullable indexed | |
| `participant_phone` | string | |
| `participant_address` | text nullable | |
| `animal_type` | enum indexed | `kambing`, `domba`, `sapi`, `kerbau`, `unta` |
| `animal_weight` | decimal(10,2) nullable | Estimasi berat kg |
| `animal_price` | decimal(15,2) | |
| `is_shared` | boolean indexed | Patungan atau tidak |
| `share_count` | integer | Default: 1 (max 7 untuk sapi) |
| `share_position` | integer nullable | Posisi ke-berapa dalam group |
| `share_group_id` | string nullable indexed | UUID grup patungan |
| `status` | enum indexed | `registered`, `paid`, `slaughtered`, `distributed` |
| `year` | integer indexed | Tahun hijriah |
| `registration_date` | date indexed | |
| `notes` | text nullable | |
| `registered_by` | FK → users | |
| `created_at`, `updated_at` | timestamps | |

---

## Tabel: `qurban_distributions`
Migration: `2026_01_21_204115_create_qurban_distributions_table.php`

> Detail kolom: Belum dilihat isi migration.

---

## Tabel: `performance_logs`
Migration: `2026_01_22_134436_create_performance_logs_table.php`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `request_path` | string | |
| `response_time_ms` | integer | |
| `memory_usage_mb` | decimal(8,2) | |
| `query_count` | integer | Default: 0 |
| `user_id` | FK → users nullable | |
| `ip_address` | string(45) nullable | IPv4 dan IPv6 |
| `user_agent` | string(500) nullable | |
| `created_at`, `updated_at` | timestamps | |

**Diisi oleh:** `TrackPerformance` middleware

---

## Tabel: `friday_schedules`
Migration: `2026_01_22_183734_create_friday_schedules_table.php` + add_time migration

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `date` | date | Tanggal Jumat |
| `time` | time (ditambah via migration) | Waktu sholat Jumat |
| `khatib` | string | |
| `imam` | string | |
| `muadzin` | string | |
| `bilal` | string | |
| `title` | string nullable | Judul khutbah (dari model) |
| `created_at`, `updated_at` | timestamps | |

---

## Tabel: `posts`
Migration: `2026_01_22_193346_create_posts_table.php` + Cloudinary

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `title` | string | |
| `slug` | string unique | Auto-generated dari title |
| `excerpt` | text nullable | |
| `content` | longText | |
| `image_path` | string nullable | |
| `cloudinary_public_id` | string nullable | |
| `author_id` | FK → users | |
| `published_at` | timestamp nullable | |
| `is_published` | boolean | Default: false |
| `views` | integer | Default: 0 |
| `created_at`, `updated_at` | timestamps | |

**Scope:** `published()` — `is_published=true AND published_at <= now()`

---

## Tabel: `tpa_registrations`
Migration: `2026_06_16_075226_create_tpa_registrations_table.php` + approved_at migration

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `nama_anak` | string | |
| `tempat_lahir` | string | |
| `tanggal_lahir` | date | |
| `jenis_kelamin` | char(1) | |
| `tingkat_sekolah` | string | |
| `nama_ortu` | string | |
| `no_wa` | string | |
| `alamat` | text | |
| `photo_path` | string nullable | |
| `status` | string | `pending`, `approved`, etc. Default: `pending` |
| `approved_at` | timestamp nullable | |
| `kelas` | string nullable | Default: `Iqro 1-3` |
| `ustadz` | string nullable | |
| `progres` | text nullable | |
| `created_at`, `updated_at` | timestamps | |

---

## Tabel: `kajians`
Migration: `2026_08_05_073700_create_kajians_table.php`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `title` | string | |
| `theme` | string nullable | |
| `ustaz_name` | string | |
| `ustaz_photo` | string nullable | |
| `ustaz_photo_public_id` | string nullable | Cloudinary |
| `ustaz_topic` | string nullable | |
| `ustaz_bio` | text nullable | |
| `date` | date | |
| `time` | time | |
| `location` | string | |
| `description` | text nullable | |
| `banner` | string nullable | |
| `banner_public_id` | string nullable | Cloudinary |
| `video_url` | string nullable | |
| `status` | string | `akan_datang`, `berlangsung`, `selesai`. Default: `akan_datang` |
| `created_at`, `updated_at` | timestamps | |

---

## Tabel: `services` & `service_applications`
Migration: `2026_08_13_000000_create_layanan_umat_tables.php`

**`services`:**

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `title` | string | |
| `slug` | string unique | |
| `category` | string | `sosial`, `kesehatan`, `pendidikan`, `jenazah`, `zakat`, `qurban`, `tpa`, `fasilitas`. Default: `sosial` |
| `icon` | string nullable | Nama HeroIcon |
| `short_description` | text nullable | |
| `description` | longText nullable | |
| `terms` | longText nullable | Syarat & Ketentuan |
| `how_to_apply` | longText nullable | Alur Pengajuan |
| `external_link` | string nullable | Link ke modul lain |
| `is_active` | boolean | Default: true |
| `is_featured` | boolean | Default: false |
| `created_at`, `updated_at` | timestamps | |

**`service_applications`:**

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `service_id` | FK → services nullable | |
| `tracking_code` | string unique | Format: LU-YYYYMMDD-XXXX |
| `applicant_name` | string | |
| `nik` | string nullable | |
| `phone` | string | |
| `address` | text nullable | |
| `service_name` | string | Nama layanan saat pengajuan |
| `notes` | text nullable | |
| `document_path` | string nullable | |
| `status` | enum | `pending`, `approved`, `rejected`, `completed` |
| `admin_notes` | text nullable | |
| `processed_by` | FK → users nullable | |
| `processed_at` | timestamp nullable | |
| `created_at`, `updated_at` | timestamps | |

---

## Tabel Sistem Laravel

| Tabel | Keterangan |
|---|---|
| `cache` | Laravel cache store |
| `jobs` | Queue jobs |
| `sessions` | Session storage |
| `password_reset_tokens` | Token reset password |
| `personal_access_tokens` | Sanctum tokens |

---

## Tabel: `prayer_times`
Migration: `2026_01_20_064742_create_prayer_times_table.php`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | bigint PK | |
| `date` | date unique | Tanggal Gregorian |
| `hijri_date` | string(50) nullable | |
| `subuh` | time | |
| `sunrise` | time | |
| `dhuhr` | time | |
| `asr` | time | |
| `maghrib` | time | |
| `isha` | time | |
| `created_at`, `updated_at` | timestamps | |

**Catatan:** Tabel ini ada tapi tidak ditemukan controller/seeder yang mengisinya secara reguler. Aplikasi saat ini fetch live dari API aladhan.com.

---

## Tabel: `activities`
Migration: `2026_05_13_080249_create_activities_table.php`
Model: `Activity.php` (111 bytes — sangat minimal)
> Detail kolom: Belum dilihat. Controller: `ActivityController.php` (95 bytes — sangat minimal).
