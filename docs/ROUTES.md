# ROUTES.md — Daftar Route PIMASJID

> Sumber: `routes/web.php` (220 baris), `routes/api.php`, `routes/auth.php`

---

## ROUTE PUBLIK (Tanpa Auth)

### Landing & Navigasi Utama
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/` | `LandingController@index` | `welcome` |
| GET | `/display` | `DisplayController@index` | `display.index` |

### Profil Masjid
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/profil/struktur` | `PublicController@structure` | `public.struktur` |
| GET | `/profil/tentang` | `PublicController@tentang` | `public.tentang` |

### Transparansi
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/transparansi/keuangan` | `PublicController@keuangan` | `public.keuangan` |
| GET | `/transparansi/aset` | `PublicController@aset` | `public.aset` |
| GET | `/keuangan` | `TransactionController@publicIndex` | `keuangan.index` |

### Ibadah
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/ibadah/jumat` | `PublicController@jumat` | `public.jumat` |
| GET | `/ibadah/jadwal` | `PublicController@jadwal` | `public.jadwal` |
| GET | `/ibadah/agenda` | `PublicController@agenda` | `public.agenda` |
| GET | `/ibadah/kiblat` | `PublicController@kiblat` | `public.kiblat` |

### Konten
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/galeri` | `PublicController@galeri` | `public.galeri` |
| GET | `/berita` | `PublicController@berita` | `public.berita` |
| GET | `/berita/{post:slug}` | `PublicController@post` | `public.post` |

### Al-Quran
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/quran` | Closure → `Public/QuranIndex` | `public.quran` |
| GET | `/quran/{nomor}` | Closure → `Public/QuranShow` | `public.quran.show` |

### Kajian
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/kajian` | `KajianController@publicIndex` | `public.kajian.index` |
| GET | `/kajian/{kajian}` | `KajianController@publicShow` | `public.kajian.show` |

### Info & Registrasi
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/info/zakat` | Closure → `Public/Zakat` | `public.zakat` |
| GET | `/info/qurban` | Closure → `Public/Qurban` | `public.qurban` |
| POST | `/info/qurban/register` | `QurbanController@publicRegister` | `public.qurban.register` |
| GET | `/tpa/daftar` | `TpaRegistrationController@publicIndex` | `public.tpa.register` |
| POST | `/tpa/daftar` | `TpaRegistrationController@store` | `public.tpa.register.store` |

### Layanan Umat
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/layanan-umat` | `LayananUmatController@publicIndex` | `public.layanan_umat.index` |
| GET | `/layanan-umat/tracking` | `LayananUmatController@trackApplication` | `public.layanan_umat.track` |
| GET | `/layanan-umat/{service:slug}` | `LayananUmatController@publicShow` | `public.layanan_umat.show` |
| POST | `/layanan-umat/{service:slug}/ajukan` | `LayananUmatController@storeApplication` | `public.layanan_umat.submit` |

### Kebutuhan & Wishlist Masjid
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/wishlist` | `WishlistController@publicIndex` | `public.wishlist.index` |
| GET | `/wishlist/{wishlist}` | `WishlistController@publicShow` | `public.wishlist.show` |
| POST | `/wishlist/{wishlist}/kontribusi` | `WishlistController@publicContribute` | `public.wishlist.contribute` |

### AI Assistant
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| POST | `/api/ai-assistant/chat` | `AiAssistantController@chat` | `public.ai.chat` |

---

## ROUTE AUTH (middleware: auth, verified)

### Dashboard
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/dashboard` | `DashboardController@index` | `dashboard` |

### Profil User
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/profile` | `ProfileController@edit` | `profile.edit` |
| PATCH | `/profile` | `ProfileController@update` | `profile.update` |
| DELETE | `/profile` | `ProfileController@destroy` | `profile.destroy` |

### User Management (Super Admin)
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/users` | `UserController@index` | `users.index` |
| POST | `/users` | `UserController@store` | `users.store` |
| DELETE | `/users/{user}` | `UserController@destroy` | `users.destroy` |
| POST | `/users/{user}/impersonate` | `UserController@impersonate` | `users.impersonate` |
| POST | `/users/stop-impersonation` | `UserController@stopImpersonation` | `users.stopImpersonation` |

### Settings
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/settings` | `SettingController@index` | `settings.index` |
| POST | `/settings` | `SettingController@update` | `settings.update` |

### Transaksi
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/transactions` | `TransactionController@index` | `transactions.index` |
| GET | `/transactions/export` | `TransactionController@export` | `transactions.export` |
| POST | `/transactions` | `TransactionController@store` | `transactions.store` |
| DELETE | `/transactions/{id}` | `TransactionController@destroy` | `transactions.destroy` |

### Approval
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/approvals` | `ApprovalController@index` | `approvals.index` |
| POST | `/approvals/{transaction}/approve` | `ApprovalController@approve` | `approvals.approve` |
| POST | `/approvals/{transaction}/reject` | `ApprovalController@reject` | `approvals.reject` |

### Slides
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/slides` | `SlideController@index` | `slides.index` |
| POST | `/slides` | `SlideController@store` | `slides.store` |
| POST | `/slides/{slide}/toggle` | `SlideController@toggleActive` | `slides.toggle` |
| POST | `/slides/{slide}/update` | `SlideController@update` | `slides.update` |
| DELETE | `/slides/{slide}` | `SlideController@destroy` | `slides.destroy` |

### Aset
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/assets/export` | `AssetController@export` | `assets.export` |
| Resource | `/assets` | `AssetController` | `assets.*` |

### Agenda (Gate: manage_operations)
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| Resource | `/agendas` | `AgendaController` | `agendas.*` |

### Jadwal Jumat
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| Resource | `/friday-schedules` | `FridayScheduleController` | `friday-schedules.*` |

### TPA Admin (Gate: manage_operations)
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/admin/tpa` | `TpaRegistrationController@index` | `admin.tpa.index` |
| PATCH | `/admin/tpa/{tpa}/status` | `TpaRegistrationController@updateStatus` | `admin.tpa.status` |
| PUT | `/admin/tpa/{tpa}` | `TpaRegistrationController@update` | `admin.tpa.update` |
| DELETE | `/admin/tpa/{tpa}` | `TpaRegistrationController@destroy` | `admin.tpa.destroy` |

### Kajian Admin (Gate: manage_operations)
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/admin/kajian` | `KajianController@index` | `admin.kajian.index` |
| POST | `/admin/kajian` | `KajianController@store` | `admin.kajian.store` |
| PUT/PATCH | `/admin/kajian/{kajian}` | `KajianController@update` | `admin.kajian.update` |
| DELETE | `/admin/kajian/{kajian}` | `KajianController@destroy` | `admin.kajian.destroy` |

### Pengurus DKM (Gate: manage_users)
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| Resource | `/committee-members` | `CommitteeMemberController` | `committee-members.*` |

### Berita/Posts (Gate: manage_posts)
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| Resource | `/posts` | `PostController` | `posts.*` |

### Zakat
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/zakat` | `ZakatController@index` | `zakat.index` |
| GET | `/zakat/create` | `ZakatController@create` | `zakat.create` |
| POST | `/zakat` | `ZakatController@store` | `zakat.store` |
| POST | `/zakat/calculate` | `ZakatController@calculate` | `zakat.calculate` |
| GET | `/zakat/distribute` | `ZakatController@distribute` | `zakat.distribute` |
| POST | `/zakat/distribute` | `ZakatController@storeDistribution` | `zakat.distribution.store` |
| GET | `/zakat/reports` | `ZakatController@reports` | `zakat.reports` |
| GET | `/zakat/export` | `ZakatController@export` | `zakat.export` |

### Qurban
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/qurban` | `QurbanController@index` | `qurban.index` |
| GET | `/qurban/create` | `QurbanController@create` | `qurban.create` |
| POST | `/qurban` | `QurbanController@store` | `qurban.store` |
| PATCH | `/qurban/{qurban}/status` | `QurbanController@updateStatus` | `qurban.status` |
| GET | `/qurban/{qurban}/edit` | `QurbanController@edit` | `qurban.edit` |
| PUT | `/qurban/{qurban}` | `QurbanController@update` | `qurban.update` |
| DELETE | `/qurban/{qurban}` | `QurbanController@destroy` | `qurban.destroy` |
| GET | `/qurban/distribute` | `QurbanController@distribute` | `qurban.distribute` |
| POST | `/qurban/distribute` | `QurbanController@storeDistribution` | `qurban.distribution.store` |
| GET | `/qurban/reports` | `QurbanController@reports` | `qurban.reports` |
| GET | `/qurban/export` | `QurbanController@export` | `qurban.export` |

### Layanan Umat Admin
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/admin/layanan-umat` | `LayananUmatController@adminIndex` | `admin.layanan_umat.index` |
| POST | `/admin/layanan-umat/services` | `LayananUmatController@storeService` | `admin.layanan_umat.service.store` |
| PUT | `/admin/layanan-umat/services/{service}` | `LayananUmatController@updateService` | `admin.layanan_umat.service.update` |
| DELETE | `/admin/layanan-umat/services/{service}` | `LayananUmatController@deleteService` | `admin.layanan_umat.service.destroy` |
| PATCH | `/admin/layanan-umat/applications/{application}/status` | `LayananUmatController@updateApplicationStatus` | `admin.layanan_umat.application.status` |

### Kebutuhan & Wishlist Admin (Gate: manage_operations / manage_finance)
| Method | URI | Controller@Method | Route Name |
|---|---|---|---|
| GET | `/admin/wishlists` | `WishlistController@index` | `admin.wishlist.index` |
| POST | `/admin/wishlists` | `WishlistController@store` | `admin.wishlist.store` |
| PUT | `/admin/wishlists/{wishlist}` | `WishlistController@update` | `admin.wishlist.update` |
| DELETE | `/admin/wishlists/{wishlist}` | `WishlistController@destroy` | `admin.wishlist.destroy` |
| POST | `/admin/wishlists/{wishlist}/contributions` | `WishlistController@storeManualContribution` | `admin.wishlist.contribution.store` |
| PATCH | `/admin/wishlist-contributions/{contribution}/verify` | `WishlistController@verifyContribution` | `admin.wishlist.contribution.verify` |
| PATCH | `/admin/wishlist-contributions/{contribution}/reject` | `WishlistController@rejectContribution` | `admin.wishlist.contribution.reject` |

---

## ROUTE API

| Method | URI | Controller@Method | Keterangan |
|---|---|---|---|
| GET | `/api/prayer-times` | `Api\PrayerTimeController` | API jadwal sholat |

---

## ROUTE AUTH (routes/auth.php — Laravel Breeze)

Route standar Breeze: `/login`, `/register`, `/logout`, `/forgot-password`, `/reset-password`, `/verify-email`, `/confirm-password`.

---

## Route Khusus (Dev/Test)

| URI | Keterangan |
|---|---|
| `/components-showcase` | Showcase komponen UI (auth required) |
| `/flyonui-test` | Test integrasi FlyonUI (tanpa auth) |
| `/up` | Health check Laravel |
