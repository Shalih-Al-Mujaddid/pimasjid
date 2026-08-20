# DEVELOPMENT.md — Panduan Development PIMASJID

---

## Setup & Menjalankan Lokal

### Prerequisites
- PHP 8.2+
- Composer
- Node.js + npm
- Laravel Herd (digunakan tim ini)

### Pertama kali
```bash
composer install
npm install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan db:seed
```

### Development server
```bash
composer run dev
# Menjalankan sekaligus: PHP server + Queue + Pail (log) + Vite
```

### URL Lokal (via Laravel Herd)
```
https://pimasjid.test
```
> Jangan jalankan `php artisan serve` manual jika sudah pakai Herd.

---

## Environment Variables Penting

| Key | Keterangan |
|---|---|
| `APP_ENV` | `local` atau `production` |
| `DB_*` | Konfigurasi database |
| `GEMINI_API_KEY` | API key Google Gemini (untuk AI Huda) |
| `CLOUDINARY_*` | Konfigurasi Cloudinary (jika digunakan) |

> **Catatan:** Jangan gunakan `env()` langsung di kode selain di `config/` files. Selalu akses via `config('services.gemini.api_key')`, dsb.

---

## Stack Conventions

### PHP / Laravel
- PHP 8.3 (dideklarasikan di `GEMINI.md`) — composer.json mengizinkan ^8.2
- Gunakan **PHP 8 constructor property promotion**
- Selalu gunakan **explicit return type declarations**
- Gunakan **curly braces** untuk semua control structures
- PHPDoc block lebih disukai daripada inline comment
- Enum keys dalam `TitleCase`
- Tidak boleh ada empty constructor dengan 0 parameter (kecuali private)

### Model
- Cast di method `casts()`, bukan property `$casts` (ikuti konvensi model existing)
- Gunakan Eloquent relationships dengan return type hints
- Hindari `DB::` — gunakan `Model::query()`
- Cegah N+1 dengan eager loading

### Controller & Validation
- Selalu buat **Form Request class** untuk validation — jangan validate di inline controller
- Cek konvensi sibling Form Request apakah menggunakan array atau string rules
- Gunakan Eloquent API Resources untuk API

### File Upload / Gambar
- Helper `storage_url()` untuk format path ke URL yang valid
- Kolom `cloudinary_public_id` tersedia di beberapa tabel (slides, posts, committee_members, transactions, settings)

---

## Frontend Conventions

### Vue / Inertia
- Komponen Inertia di `resources/js/Pages/`
- Navigasi via `<Link>` dari `@inertiajs/vue3` atau `router.visit()`
- Setiap komponen Vue harus punya **single root element**
- Gunakan `<Form>` component Inertia v2 untuk form (atau `useForm` jika lebih sesuai konvensi existing)

### Styling
- Tailwind CSS v3
- Gunakan `gap-*` untuk spacing di flex/grid, bukan margin
- Jika halaman lain support dark mode, halaman baru juga harus support `dark:`
- Jangan gunakan class yang tidak ada di Tailwind v3

### Komponen yang Tersedia
Cek `resources/js/Components/` sebelum membuat komponen baru:
- `Modal.vue`, `Card.vue`, `Badge.vue`, `StatCard.vue`
- `ModernTable.vue`, `Pagination.vue`
- `WysiwygEditor.vue` (Quill)
- `Sidebar.vue`, `AiAssistantModal.vue`
- Subdirektori: `Charts/`, `Dashboard/`, `Landing/`, `Public/`

---

## Authorization (Gates)

Gunakan gates yang sudah ada, jangan buat baru tanpa diskusi:

```php
Gate::authorize('manage_finance');   // super_admin, bendahara
Gate::authorize('manage_operations'); // super_admin, marbot
Gate::authorize('approve_transaction'); // super_admin, ketua
Gate::authorize('manage_users');     // super_admin only
Gate::authorize('manage_posts');     // super_admin, ketua
Gate::authorize('impersonate_user'); // super_admin only
```

Di route, gunakan middleware `can:`:
```php
->middleware('can:manage_operations')
```

---

## Testing

### Framework
- **PHPUnit** — semua test harus PHPUnit class
- Jika ada test Pest, convert ke PHPUnit
- Buat test via: `php artisan make:test --phpunit {name}`
- Unit test: tambah flag `--unit`

### Aturan Testing
- Setiap perubahan **wajib** ada test baru atau update test yang ada
- Test harus cover: happy path, failure path, dan edge cases
- Gunakan factories — cek custom states sebelum set manual
- **Jangan hapus file test tanpa persetujuan**

### Menjalankan Test
```bash
# Semua test
php artisan test --compact

# File spesifik
php artisan test --compact tests/Feature/LayananUmatTest.php

# Filter nama test
php artisan test --compact --filter=testNamaTest
```

### File Test yang Ada
- `tests/Feature/ExampleTest.php`
- `tests/Feature/KajianImageTest.php`
- `tests/Feature/LayananUmatTest.php`
- `tests/Feature/ProfileTest.php`
- `tests/Feature/Auth/` (direktori)

---

## Code Formatting

Selalu jalankan Pint setelah membuat perubahan kode:

```bash
vendor/bin/pint --dirty
```

> Jangan jalankan `--test` — langsung jalankan untuk fix.

---

## Artisan Commands Berguna

```bash
# Buat controller
php artisan make:controller NamaController --no-interaction

# Buat model + migration + factory + seeder
php artisan make:model NamaModel -mfs --no-interaction

# Buat Form Request
php artisan make:request NamaRequest --no-interaction

# Buat class generic
php artisan make:class NamaClass --no-interaction

# Lihat semua artisan commands
php artisan list

# Migrate
php artisan migrate

# Tinker (debugging)
php artisan tinker
```

---

## Struktur Routes

- Semua route di `routes/web.php`
- Route publik: tanpa middleware
- Route admin: dalam `Route::middleware('auth')->group()`
- Gunakan route names untuk semua link: `route('nama.route')`

---

## Settings System

Settings disimpan di tabel `settings` dan dapat diakses via helper:

```php
setting('key_name', 'default_value')
```

Settings di-cache 60 menit dan dibagikan ke semua halaman Vue via Inertia shared data (`usePage().props.settings`).

Untuk invalidate cache settings setelah update:
```php
Cache::forget('global_settings');
```

> Cache ini perlu di-forget di `SettingController@update` — pastikan sudah ada atau tambahkan.

---

## Hal-hal yang DILARANG

- Membuat migration, model, controller, route, atau component baru tanpa diskusi
- Menggunakan `env()` di luar config files
- Menggunakan `DB::` raw query tanpa alasan kuat
- Membuat file dokumentasi di luar folder `docs/` ini kecuali diminta eksplisit
- Menghapus test files
- Mengubah dependency (composer.json / package.json) tanpa persetujuan

---

## Deployment Notes

- Hosting via **Laravel Herd** (lokal) — URL: `https://pimasjid.test`
- Di production, `AppServiceProvider` akan otomatis jalankan `migrate --force` saat boot — ini pola non-standar, perlu dipertimbangkan untuk diubah
- Frontend: jalankan `npm run build` untuk production bundle
- Jika ada perubahan frontend yang tidak terlihat, coba `npm run build` atau `npm run dev`
