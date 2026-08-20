# AI_HUDA.md — Arsitektur AI Assistant "Huda"

## Identitas

- **Nama:** Huda — Asisten Masjid
- **Sapaan default:** "Assalamu'alaikum Warahmatullahi Wabarakatuh! 🌿"
- **Deskripsi:** AI assistant masjid yang dapat menjawab pertanyaan jamaah terkait informasi, jadwal, keuangan, dan layanan masjid
- **Dapat diakses oleh:** Semua pengunjung publik (tanpa login), termasuk pengguna yang sudah login

---

## Entrypoint

| Komponen | Detail |
|---|---|
| **Frontend** | `resources/js/Components/AiAssistantModal.vue` (343 baris) |
| **Endpoint** | `POST /api/ai-assistant/chat` |
| **Route Name** | `public.ai.chat` |
| **Controller** | `app/Http/Controllers/AiAssistantController.php` (672 baris) |
| **Autentikasi** | Tidak diperlukan — endpoint publik |

---

## Alur Kerja (Flow)

```
User kirim pesan
       ↓
[1] isSensitiveQuery() — cek kata sensitif
       ↓ (lolos)
[2] isOffTopicQuery() — cek topik di luar masjid
       ↓ (lolos)
[3] buildMosqueContext() — ambil data real-time dari semua modul DB
       ↓
[4] Cek GEMINI_API_KEY di config/env
       ↓
    [Ada key] → queryGeminiApi() → Gemini 2.5 Flash API
    [Tidak ada / gagal] → queryLocalEngine() — Rule-based fallback
       ↓
Return JSON: { success, reply, source }
```

---

## Request / Response Schema

**Request (POST /api/ai-assistant/chat):**
```json
{
  "message": "string, required, max:1000",
  "history": [
    { "role": "user|assistant", "content": "string" }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "reply": "string (Markdown format)",
  "source": "gemini_api | local_engine | security_guard | offtopic_guard"
}
```

---

## Guard Layer 1: Sensitive Query Filter

Menolak query yang mengandung kata berikut (case-insensitive):
```
password, credential, api_key, apikey, secret, env, .env,
token, source code, database password, db_password, phpmyadmin,
root, access_token, private_key, struktur database, source_code
```
**Response:** "Maaf, demi keamanan sistem, informasi internal atau sensitif tidak dapat diakses."

---

## Guard Layer 2: Off-Topic Filter

Menolak query yang mengandung topik di luar lingkup masjid:
```
presiden, politik, pemilu, partai, pilpres, sepak bola,
klub bola, puisi, pantun, game, film,
meretas, hack, koding, kode php, javascript, python,
resep makanan, wifi, password wifi, cuaca, saham,
crypto, bitcoin, ramalan
```
**Response:** "Maaf, saya adalah Huda — Asisten Masjid. Saya hanya dapat membantu terkait informasi dan fitur yang tersedia di PIMASJID."

---

## Konteks Real-Time yang Dikumpulkan (buildMosqueContext)

Data berikut diambil dari database setiap kali ada request:

| # | Data | Sumber |
|---|---|---|
| 1 | Profil masjid (nama, alamat, telepon) | `settings` |
| 2 | Info rekening (bank_name, bank_account, bank_holder) | `settings` |
| 3 | Saldo kas, pemasukan/pengeluaran bulan ini | `transactions` |
| 4 | 5 transaksi terbaru | `transactions` |
| 5 | Jadwal Jumat terdekat (khatib, imam, muadzin, bilal) | `friday_schedules` |
| 6 | 5 agenda kegiatan mendatang | `agendas` |
| 7 | 5 kajian terbaru (ustaz, tema, waktu, lokasi) | `kajians` |
| 8 | 5 wishlist/kebutuhan terbaru | `wishlists` |
| 9 | 3 berita/post terbaru | `posts` |
| 10 | Statistik TPA (total, approved, pending, per-kelas) | `tpa_registrations` |
| 11 | Statistik zakat (fitrah uang/beras, mal, total muzakki) | `zakats` |
| 12 | Statistik qurban (total shohibul, per jenis hewan) | `qurbans` |
| 13 | Susunan pengurus DKM aktif | `committee_members` |
| 14 | Layanan umat aktif (title, category, terms) | `services` |
| 15 | Jadwal sholat (Subuh, Syuruq, Dzuhur, Ashar, Maghrib, Isya) | **Hardcoded static** di buildMosqueContext |

> **Catatan:** Jadwal sholat di context AI adalah **nilai statis hardcoded**, berbeda dengan halaman `/ibadah/jadwal` yang fetch dari API aladhan. Ini perlu diperbaiki.

---

## Gemini API Integration

- **Model:** `gemini-2.5-flash`
- **Endpoint:** `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent`
- **Config key:** `GEMINI_API_KEY` (env) atau `config('services.gemini.api_key')`
- **Temperature:** 0.3 (lebih deterministic)
- **Max output tokens:** 1000
- **Timeout:** 10 detik
- **Fallback:** Jika API gagal/tidak ada key, gunakan `queryLocalEngine()`

### System Instruction ke Gemini
Sistem instruction mengandung:
1. Identitas Huda sebagai asisten masjid
2. Aturan: DILARANG HALLUCINATE — hanya jawab berdasarkan data context
3. Daftar modul PIMASJID (Kajian, TPA, Keuangan, Zakat, Qurban, Agenda, Wishlist, Pengurus DKM, Sholat, Donasi, Berita)
4. Semua data real-time dari `buildMosqueContext()` dimasukkan ke system instruction

---

## Fallback Engine (queryLocalEngine)

Rule-based engine diaktifkan jika Gemini API tidak tersedia atau gagal.

Topik yang ditangani via keyword matching (regex):

| # | Pattern Regex | Topik |
|---|---|---|
| 1 | `assalamu\|salam\|halo\|hi\|hai\|pagi\|siang\|malam` | Sapaan/Greeting |
| 2 | `pengurus\|dkm\|ketua dkm\|struktur\|panitia\|organisasi\|divisi` | Pengurus DKM |
| 3 | `kajian\|ustadz\|ustaz\|pemateri\|pengajian\|ta'lim\|majelis\|penceramah\|tema` | Kajian & Ustaz |
| 4 | `tpa\|tpq\|santri\|mengaji\|pendaftaran tpa\|anak\|iqro\|tahfidz` | TPA/TPQ |
| 5 | `layanan\|service\|bantuan\|program sosial\|layanan umat` | Layanan Umat |
| 6 | `kas\|uang\|saldo\|keuangan\|pemasukan\|pengeluaran\|donasi\|laporan\|transaksi` | Keuangan & Kas |
| 7 | `zakat\|fitrah\|maal\|mal\|fidyah\|mustahik\|muzakki` | Zakat |
| 8 | `qurban\|kurban\|shohibul\|sapi\|kambing\|domba` | Qurban |
| 9 | `wishlist\|kebutuhan\|inventaris\|fasilitas\|pengadaan\|barang\|perlengkapan` | Wishlist |
| 10 | `kegiatan\|agenda\|acara` | Agenda |
| 11 | `sholat\|solat\|subuh\|dzuhur\|ashar\|maghrib\|isya\|jumat\|khatib\|imam\|muadzin` | Jadwal Sholat & Jumat |
| 12 | `pengumuman\|berita\|artikel\|post` | Berita & Pengumuman |
| 13 | `rekening\|donasi\|infaq\|infak\|transfer\|norek\|bank\|bsi` | Rekening & Donasi |

**Default response:** "Maaf, informasi yang Anda minta belum tersedia dalam data PIMASJID saat ini."

---

## Frontend Component (AiAssistantModal.vue)

- **Type:** Floating modal (chat bubble di sudut kanan bawah)
- **State:** `isOpen`, `messages[]`, `isLoading`, `isSpeaking`
- **Fitur:**
  - Chat history dikirim ke backend setiap request
  - Text-to-speech (SpeakerWaveIcon / SpeakerXMarkIcon)
  - Saran cepat (quick suggestions):
    1. "Kajian Terdekat"
    2. "Ustaz Pengisi Kajian"
    3. "Kegiatan Masjid"
    4. "Informasi Zakat"
    5. "Saldo Kas Masjid"
  - Format Markdown basic (bold, italic, code, newline) via `formatMarkdown()`
  - Auto-scroll ke bawah saat pesan baru masuk

---

## Perilaku Role-Aware

Jika user sudah login, `$request->user()->role` diambil dan dikirim sebagai `user_role` dalam context.

- Role `admin` / `super_admin`: respons local engine untuk query "laporan/detail/statistik/data" mengarahkan ke panel admin
- Role lain (jamaah / non-auth): respons umum

---

## Hal yang Perlu Diperhatikan AI

1. Huda sudah mengakses data wishlist tapi tidak ada UI admin untuk wishlist — data mungkin kosong atau stale
2. Jadwal sholat di context AI adalah **hardcoded**, bukan dari API real-time
3. Riwayat chat dikirim ke backend tapi Gemini API diimplementasikan tanpa multi-turn conversation (history tidak dimasukkan ke `contents` array secara benar — system instruction + userMessage digabung jadi satu pesan user)
