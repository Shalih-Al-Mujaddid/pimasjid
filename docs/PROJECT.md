# PROJECT.md — Stack & Arsitektur PIMASJID

## Tech Stack

### Backend
| Paket | Versi |
|---|---|
| PHP | ^8.2 |
| Laravel Framework | ^12.0 |
| Inertia Laravel | ^2.0 |
| Laravel Sanctum | ^4.0 |
| Tightenco Ziggy | ^2.0 |
| barryvdh/laravel-dompdf | ^3.1 |
| maatwebsite/excel | ^3.1 |
| Laravel Tinker | ^2.10.1 |

### Dev Dependencies
| Paket | Versi |
|---|---|
| laravel/boost | ^1.8 |
| laravel/breeze | ^2.3 |
| laravel/pint | ^1.13 |
| laravel/pail | ^1.2.2 |
| laravel/sail | ^1.41 |
| phpunit/phpunit | ^11.5.3 |

### Frontend
| Paket | Versi |
|---|---|
| Vue 3 | ^3.4.0 |
| @inertiajs/vue3 | ^2.0.0 |
| Tailwind CSS | ^3.2.1 |
| @tailwindcss/forms | ^0.5.3 |
| @tailwindcss/vite | ^4.0.0 (plugin) |
| FlyonUI | ^2.4.1 (UI komponen, Belum ditemukan penggunaan penuh) |
| @headlessui/vue | ^1.7.23 |
| @heroicons/vue | ^2.2.0 |
| chart.js + vue-chartjs | ^4.5.1 / ^5.3.3 |
| quill | ^2.0.2 (WYSIWYG editor) |
| leaflet | ^1.9.4 |
| @vueuse/core | ^14.1.0 |
| ziggy-js | ^2.6.3 |
| axios | ^1.7.4 |

---

## Struktur Direktori Utama

```
pimasjid/
├── app/
│   ├── Http/
│   │   ├── Controllers/       # 23 controllers + Api/ + Auth/
│   │   ├── Middleware/        # HandleInertiaRequests, TrackPerformance
│   │   └── Requests/          # Belum ditemukan Form Request classes
│   ├── Models/                # 21 Eloquent models
│   ├── Observers/             # TransactionObserver
│   └── Providers/             # AppServiceProvider (Gates)
│
├── database/
│   ├── migrations/            # 27 migration files
│   ├── seeders/               # Belum ditemukan listing lengkap
│   └── factories/             # Belum ditemukan listing lengkap
│
├── resources/
│   └── js/
│       ├── Pages/             # Inertia pages (17 direktori + 4 file)
│       ├── Layouts/           # 4 layout: Auth, Authenticated, Guest, Public
│       ├── Components/        # ~21 component + 4 subdirektori
│       └── Composables/       # usePrayerTimes ditemukan
│
├── routes/
│   ├── web.php                # 220 baris, semua route
│   ├── api.php                # Minimal (hanya PrayerTimeController)
│   ├── auth.php               # Breeze auth routes
│   └── console.php            # Console routes
│
├── docs/                      # Dokumentasi konteks AI (folder ini)
└── bootstrap/app.php          # Laravel 12 app config
```

---

## Layouts

| Layout | Digunakan untuk |
|---|---|
| `AuthenticatedLayout.vue` | Semua halaman admin (auth) |
| `PublicLayout.vue` | Semua halaman publik |
| `AuthLayout.vue` | Halaman login/register |
| `GuestLayout.vue` | Belum ditemukan penggunaan aktif |

---

## Middleware

| Middleware | Tujuan |
|---|---|
| `HandleInertiaRequests` | Share `auth.user`, `settings`, `isImpersonating`, `pendingApprovalsCount` ke semua halaman |
| `TrackPerformance` | Catat response time, memory usage, query count ke tabel `performance_logs` |

> `settings` di-cache 60 menit via `Cache::remember('global_settings', ...)`.

---

## Observer

| Observer | Model | Tujuan |
|---|---|---|
| `TransactionObserver` | `Transaction` | Logika otomatis saat transaksi dibuat/diupdate |

---

## Authorization Gates (AppServiceProvider)

| Gate | Role yang diizinkan |
|---|---|
| `manage_finance` | super_admin, bendahara |
| `manage_operations` | super_admin, marbot |
| `approve_transaction` | super_admin, ketua |
| `view_dashboard_executive` | super_admin, ketua |
| `impersonate_user` | super_admin |
| `manage_users` | super_admin |
| `manage_posts` | super_admin, ketua |

---

## Global Helper Functions (app/helpers.php)

| Fungsi | Deskripsi |
|---|---|
| `setting(key, default)` | Ambil nilai dari tabel `settings` |
| `storage_url(path, fallback)` | Format path file menjadi URL storage yang valid, support Cloudinary URL |

---

## Catatan Khusus

- **Auto-migrate di production:** `AppServiceProvider` memanggil `migrate --force` saat `APP_ENV=production`. Ini pola non-standar.
- **Cloudinary:** Kolom `cloudinary_public_id` ditambahkan ke beberapa tabel (`slides`, `posts`, `committee_members`, `transactions`, `settings`). Integrasi Cloudinary tersedia tapi belum ditemukan package-nya di composer.json — kemungkinan via manual HTTP atau sudah dihapus.
- **FlyonUI:** Terdapat `FlyonUITest.vue` dan route `/flyonui-test` — tampaknya sedang dalam evaluasi/testing, bukan production-ready.
