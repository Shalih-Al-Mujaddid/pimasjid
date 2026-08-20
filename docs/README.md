# PIMASJID — Dokumentasi Konteks AI

> Dokumentasi ini digenerate dari audit source code aktual pada 2026-08-18.
> Tujuan utama: sebagai **context file untuk AI assistant** agar memahami project secara cepat dan akurat.

---

## Tentang Project

**PIMASJID** adalah aplikasi manajemen masjid berbasis web yang dibangun dengan Laravel 12 + Inertia.js v2 + Vue 3 + Tailwind CSS v3.

Aplikasi ini melayani dua sisi:
1. **Portal publik** — jamaah/pengunjung bisa akses info masjid tanpa login
2. **Panel admin** — pengelola masjid (multi-role) bisa kelola seluruh data

---

## Dokumen Tersedia

| File | Isi |
|---|---|
| `PROJECT.md` | Stack teknis, struktur direktori, middleware, observer |
| `FEATURES.md` | Daftar fitur — selesai, sebagian, belum tersedia |
| `DATABASE.md` | Semua tabel, kolom, relasi, status migrasi |
| `ROUTES.md` | Semua route publik & admin beserta controller |
| `AI_HUDA.md` | Arsitektur, alur kerja, dan konteks AI Huda |
| `DEVELOPMENT.md` | Aturan development, konvensi, testing, deployment |

---

## Quick Reference

- **Serve lokal:** `composer run dev` (PHP server + queue + pail + vite)
- **URL via Herd:** `https://pimasjid.test`
- **Format kode:** `vendor/bin/pint --dirty`
- **Jalankan test:** `php artisan test --compact`
- **Lihat semua route:** `php artisan route:list`
