<?php

namespace App\Http\Controllers;

use App\Models\Agenda;
use App\Models\CommitteeMember;
use App\Models\FridaySchedule;
use App\Models\Kajian;
use App\Models\Post;
use App\Models\Qurban;
use App\Models\Service;
use App\Models\TpaRegistration;
use App\Models\Transaction;
use App\Models\Wishlist;
use App\Models\Zakat;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class AiAssistantController extends Controller
{
    /**
     * Handle incoming AI chat requests.
     */
    public function chat(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'message' => 'required|string|max:1000',
            'history' => 'nullable|array',
            'history.*.role' => 'required_with:history|string|in:user,assistant',
            'history.*.content' => 'required_with:history|string',
        ]);

        $userMessage = trim($validated['message']);
        $history = $validated['history'] ?? [];

        // 1. Guard against Security / System / Sensitive Data queries
        if ($this->isSensitiveQuery($userMessage)) {
            return response()->json([
                'success' => true,
                'reply' => 'Maaf, demi keamanan sistem, informasi internal atau sensitif tidak dapat diakses.',
                'source' => 'security_guard',
            ]);
        }

        // 2. Guard against Off-Topic Queries (Non-PIMASJID questions)
        if ($this->isOffTopicQuery($userMessage)) {
            return response()->json([
                'success' => true,
                'reply' => 'Maaf, saya adalah Huda — Asisten Masjid. Saya hanya dapat membantu terkait informasi dan fitur yang tersedia di PIMASJID.',
                'source' => 'offtopic_guard',
            ]);
        }

        // 3. Prepare Real-Time Mosque Context from Database
        $user = $request->user();
        $role = $user ? $user->role : 'jamaah';
        $context = $this->buildMosqueContext();
        $context['user_role'] = $role;

        // 4. Try Gemini API first if API key exists
        $geminiApiKey = config('services.gemini.api_key') ?? env('GEMINI_API_KEY');

        if (! empty($geminiApiKey)) {
            $aiResponse = $this->queryGeminiApi($geminiApiKey, $userMessage, $history, $context);
            if ($aiResponse) {
                return response()->json([
                    'success' => true,
                    'reply' => $aiResponse,
                    'source' => 'gemini_api',
                ]);
            }
        }

        // 5. Intelligent Local Rule & Context Engine (Fallback)
        $localReply = $this->queryLocalEngine($userMessage, $context);

        return response()->json([
            'success' => true,
            'reply' => $localReply,
            'source' => 'local_engine',
        ]);
    }

    /**
     * Check if query is asking for sensitive system credentials or internal data.
     */
    private function isSensitiveQuery(string $message): bool
    {
        $msg = strtolower($message);
        $sensitiveKeywords = [
            'password', 'credential', 'api_key', 'apikey', 'secret', 'env', '.env',
            'token', 'source code', 'database password', 'db_password', 'phpmyadmin',
            'root', 'access_token', 'private_key', 'struktur database', 'source_code',
        ];

        foreach ($sensitiveKeywords as $kw) {
            if (str_contains($msg, $kw)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Check if query is strictly outside PIMASJID mosque scope.
     */
    private function isOffTopicQuery(string $message): bool
    {
        $msg = strtolower($message);

        // Allow queries that are related to mosque features even if phrasing varies.
        // Only block clearly unrelated topics like politics, gaming, etc.
        $offTopicKeywords = [
            'presiden', 'politik', 'pemilu', 'partai', 'pilpres', 'sepak bola',
            'klub bola', 'puisi', 'pantun', 'game', 'film',
            'meretas', 'hack', 'koding', 'kode php', 'javascript', 'python',
            'resep makanan', 'wifi', 'password wifi', 'cuaca', 'saham',
            'crypto', 'bitcoin', 'ramalan',
        ];

        foreach ($offTopicKeywords as $kw) {
            if (str_contains($msg, $kw)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Build comprehensive real-time context data from all PIMASJID modules.
     */
    private function buildMosqueContext(): array
    {
        $now = now();

        // 1. Informasi & Profil Masjid
        $mosqueName = setting('app_name', 'Masjid');
        $address = setting('location_name', 'Jl. Utama Masjid');
        $phone = setting('contact_phone', setting('phone', '-'));
        $bankName = setting('bank_name', 'Bank Syariah Indonesia (BSI)');
        $bankAccount = setting('bank_account', setting('bank_number', '123-456-7890'));
        $bankHolder = setting('bank_holder', 'DKM '.$mosqueName);

        // 2. Keuangan & Transaksi Real-time
        $totalIncome = Transaction::where('type', 'income')->sum('amount');
        $totalExpense = Transaction::where('type', 'expense')->sum('amount');
        $balance = $totalIncome - $totalExpense;

        $incomeThisMonth = Transaction::where('type', 'income')
            ->whereMonth('date', $now->month)
            ->whereYear('date', $now->year)
            ->sum('amount');

        $expenseThisMonth = Transaction::where('type', 'expense')
            ->whereMonth('date', $now->month)
            ->whereYear('date', $now->year)
            ->sum('amount');

        $recentTransactions = Transaction::orderBy('date', 'desc')
            ->take(5)
            ->get()
            ->map(fn ($t) => [
                'type' => $t->type === 'income' ? 'Pemasukan' : 'Pengeluaran',
                'category' => $t->category,
                'amount' => 'Rp '.number_format($t->amount, 0, ',', '.'),
                'description' => $t->description,
                'date' => $t->date ? $t->date->format('d M Y') : '-',
            ])->toArray();

        // 3. Petugas & Jadwal Jum'at
        $fridaySchedule = FridaySchedule::where('date', '>=', $now->toDateString())
            ->orderBy('date', 'asc')
            ->first();

        // 4. Agenda Kegiatan Masjid
        $agendas = Agenda::where('is_active', true)
            ->where('date', '>=', $now->toDateString())
            ->orderBy('date', 'asc')
            ->take(5)
            ->get();

        // 5. Jadwal Kajian Rutin & Tematik
        $kajians = Kajian::latest()
            ->take(5)
            ->get();

        // 6. Wishlist / Kebutuhan Inventaris & Fasilitas
        $wishlists = Wishlist::latest()
            ->take(5)
            ->get();

        // 7. Pengumuman & Berita Terbaru
        $posts = Post::latest()->take(3)->get();

        // 8. TPA / TPQ (Pendidikan Al-Qur'an Anak)
        $totalTpa = TpaRegistration::count();
        $approvedTpa = TpaRegistration::where('status', 'approved')->count();
        $pendingTpa = TpaRegistration::where('status', 'pending')->count();
        $tpaClasses = TpaRegistration::where('status', 'approved')
            ->selectRaw('kelas, count(*) as count')
            ->groupBy('kelas')
            ->pluck('count', 'kelas')
            ->toArray();

        // 9. Data Zakat Fitrah & Mal
        $zakatFitrahUang = Zakat::where('type', 'fitrah')->where('payment_type', 'uang')->sum('amount');
        $zakatFitrahBeras = Zakat::where('type', 'fitrah')->where('payment_type', 'beras')->sum('rice_kg');
        $zakatMal = Zakat::where('type', 'mal')->sum('amount');
        $totalMuzakki = Zakat::count();

        // 10. Program Qurban
        $totalShohibulQurban = Qurban::count();
        $qurbanAnimals = Qurban::selectRaw('animal_type, count(*) as count')
            ->groupBy('animal_type')
            ->pluck('count', 'animal_type')
            ->toArray();

        // 11. Pengurus DKM Masjid
        $committee = CommitteeMember::where('is_active', true)
            ->orderBy('order')
            ->get()
            ->map(fn ($m) => [
                'name' => $m->name,
                'position' => $m->position,
                'division' => $m->division,
            ])->toArray();

        // 12. Jadwal Sholat Standard
        $prayerTimes = [
            'Subuh' => '04:35',
            'Syuruq' => '05:50',
            'Dzuhur' => '12:08',
            'Ashar' => '15:25',
            'Maghrib' => '18:12',
            'Isya' => '19:24',
        ];

        // 13. Layanan Umat / Bantuan Sosial Masjid
        $services = Service::where('is_active', true)
            ->get()
            ->map(fn ($s) => [
                'title' => $s->title,
                'category' => $s->category,
                'short_description' => $s->short_description,
                'terms' => $s->terms,
            ])->toArray();

        return [
            'mosque_name' => $mosqueName,
            'address' => $address,
            'phone' => $phone,
            'bank_name' => $bankName,
            'bank_account' => $bankAccount,
            'bank_holder' => $bankHolder,
            'balance_formatted' => 'Rp '.number_format($balance, 0, ',', '.'),
            'income_this_month' => 'Rp '.number_format($incomeThisMonth, 0, ',', '.'),
            'expense_this_month' => 'Rp '.number_format($expenseThisMonth, 0, ',', '.'),
            'recent_transactions' => $recentTransactions,
            'friday_schedule' => $fridaySchedule ? [
                'date' => $fridaySchedule->date ? $fridaySchedule->date->format('d M Y') : '-',
                'khatib' => $fridaySchedule->khatib ?? '-',
                'imam' => $fridaySchedule->imam ?? '-',
                'muadzin' => $fridaySchedule->muadzin ?? '-',
                'bilal' => $fridaySchedule->bilal ?? '-',
            ] : null,
            'agendas' => $agendas->map(fn ($a) => [
                'title' => $a->title,
                'date' => $a->date ? $a->date->format('d M Y') : '-',
                'time' => $a->time ?? '-',
                'location' => $a->location ?? 'Masjid',
            ])->toArray(),
            'kajians' => $kajians->map(fn ($k) => [
                'title' => $k->title ?? 'Kajian Rutin',
                'theme' => $k->theme ?? '-',
                'ustaz' => $k->ustaz_name ?? 'Ustadz',
                'date' => $k->date ? \Carbon\Carbon::parse($k->date)->translatedFormat('l, d F Y') : '-',
                'time' => $k->time ?? '-',
                'location' => $k->location ?? 'Masjid',
                'status' => $k->status ?? 'akan_datang',
            ])->toArray(),
            'wishlists' => $wishlists->map(fn ($w) => [
                'item_name' => $w->item_name,
                'target_qty' => $w->target_qty,
                'fulfilled_qty' => $w->fulfilled_qty,
                'unit_price' => 'Rp '.number_format($w->unit_price, 0, ',', '.'),
                'status' => $w->statusLabel,
            ])->toArray(),
            'posts' => $posts->map(fn ($p) => [
                'title' => $p->title,
                'date' => $p->created_at ? $p->created_at->format('d M Y') : '-',
            ])->toArray(),
            'tpa' => [
                'total' => $totalTpa,
                'approved' => $approvedTpa,
                'pending' => $pendingTpa,
                'classes' => $tpaClasses,
            ],
            'zakat' => [
                'total_muzakki' => $totalMuzakki,
                'fitrah_uang' => 'Rp '.number_format($zakatFitrahUang, 0, ',', '.'),
                'fitrah_beras' => $zakatFitrahBeras.' kg',
                'zakat_mal' => 'Rp '.number_format($zakatMal, 0, ',', '.'),
            ],
            'qurban' => [
                'total_shohibul' => $totalShohibulQurban,
                'animals' => $qurbanAnimals,
            ],
            'services' => $services,
            'committee' => $committee,
            'prayer_times' => $prayerTimes,
            'today_date' => $now->translatedFormat('l, d F Y'),
        ];
    }

    /**
     * Query Google Gemini API with comprehensive system architecture context.
     */
    private function queryGeminiApi(string $apiKey, string $userMessage, array $history, array $context): ?string
    {
        try {
            $systemInstruction = "Anda adalah 'Huda — Asisten Masjid', asisten pintar resmi untuk aplikasi ".$context['mosque_name'].".\n\n"
                ."Tugas utama Anda adalah memberikan informasi akurat, ramah, dan Islami tentang seluruh fitur dan data masjid.\n\n"
                ."POLA PROSES MANDATORY RETRIEVAL & REASONING (PERTANYAAN -> CEK DATA -> ANALISIS -> JAWAB):\n"
                ."1. PAHAMI PERTANYAAN: Tentukan maksud & maksud spesifik pertanyaan jamaah.\n"
                ."2. RETRIEVAL DATA AKTUAL: Cek data real-time terbaru dari database PIMASJID pada konteks di bawah.\n"
                ."3. ANALISIS FITUR RELEVAN: Petakan pertanyaan dengan modul PIMASJID yang sesuai (Kajian, TPA, Keuangan, Zakat, Qurban, Agenda, Wishlist, Pengurus DKM, Sholat, Donasi, Berita).\n"
                ."4. JAWAB BERDASARKAN HASIL RETRIEVAL:\n"
                ."   - DILARANG MENJAWAB BERDASARKAN ASUMSI ATAU MENGARANG DATA (HALLUCINATE).\n"
                ."   - JIKA DATA DITEMUKAN PADA HASIL RETRIEVAL: Berikan jawaban berbasis data aktual secara presisi, ramah, dan bersahabat dengan format Markdown rapi.\n"
                ."   - JIKA DATA TIDAK DITEMUKAN PADA HASIL RETRIEVAL: Katakan secara jujur dan sopan: 'Maaf, informasi tersebut belum tersedia di data PIMASJID.'\n\n"
                ."PEMAHAMAN STRUKTUR MODUL PIMASJID:\n"
                ."1. KAJIAN: Ceramah/kajian rutin & tematik, Ustadz pemateri, tema, waktu, lokasi.\n"
                ."2. TPA: Pendaftaran santri (Iqro 1-3, Iqro 4-6, Al-Qur'an, Tahfidz), status approved/pending.\n"
                ."3. KEUANGAN & TRANSAKSI: Kas masjid, total saldo, pemasukan/pengeluaran bulan ini, dan riwayat transaksi.\n"
                ."4. ZAKAT: Perhitungan dan rekap Zakat Fitrah (Uang/Beras) & Zakat Mal.\n"
                ."5. QURBAN: Shohibul Qurban (Sapi, Kambing, Domba) dan pendistribusian daging.\n"
                ."6. AGENDA: Acara & kegiatan mendatang masjid.\n"
                ."7. BERITA/PENGUMUMAN: Berita dan pengumuman DKM masjid.\n"
                ."8. WISHLIST: Kebutuhan pengadaan barang/fasilitas masjid.\n"
                ."9. SHOLAT & JUM'AT: Jadwal sholat 5 waktu & petugas Jum'at (Khatib, Imam, Muadzin, Bilal).\n"
                ."10. PENGURUS DKM: Pengurus masjid (Ketua, Sekretaris, Bendahara, Divisi Dakwah, Pendidikan, Umum, dsb).\n"
                ."11. REKENING & DONASI: Rekening resmi BSI masjid untuk infaq/donasi.\n\n"
                ."DATA REAL-TIME SYSTEM PIMASJID SAAT INI (HASIL RETRIEVAL DB):\n"
                .'- Nama Masjid: '.$context['mosque_name']."\n"
                .'- Hari/Tanggal: '.$context['today_date']."\n"
                .'- Alamat: '.$context['address']."\n"
                .'- Kontak: '.$context['phone']."\n"
                .'- Rekening Infaq/Donasi: '.$context['bank_name'].' '.$context['bank_account'].' a.n '.$context['bank_holder']."\n"
                .'- Saldo Kas Masjid: '.$context['balance_formatted'].' (Pemasukan bulan ini: '.$context['income_this_month'].', Pengeluaran bulan ini: '.$context['expense_this_month'].")\n"
                .'- Jadwal Sholat Hari Ini: Subuh '.$context['prayer_times']['Subuh'].', Dzuhur '.$context['prayer_times']['Dzuhur'].', Ashar '.$context['prayer_times']['Ashar'].', Maghrib '.$context['prayer_times']['Maghrib'].', Isya '.$context['prayer_times']['Isya']."\n";

            if (! empty($context['friday_schedule'])) {
                $systemInstruction .= "- Petugas Jum'at Terdekat (".$context['friday_schedule']['date'].'): Khatib: '.$context['friday_schedule']['khatib'].', Imam: '.$context['friday_schedule']['imam'].', Muadzin: '.$context['friday_schedule']['muadzin']."\n";
            }

            if (! empty($context['kajians'])) {
                $systemInstruction .= "- Daftar Kajian Rutin/Tematik:\n";
                foreach ($context['kajians'] as $kj) {
                    $systemInstruction .= '  * '.$kj['title'].' | Ustaz: '.$kj['ustaz'].' | Hari/Tgl: '.$kj['date'].' Jam '.$kj['time'].' | Tema: '.$kj['theme']."\n";
                }
            }

            if (! empty($context['agendas'])) {
                $systemInstruction .= "- Agenda Kegiatan Mendatang:\n";
                foreach ($context['agendas'] as $ag) {
                    $systemInstruction .= '  * '.$ag['title'].' ('.$ag['date'].' jam '.$ag['time'].') di '.$ag['location']."\n";
                }
            }

            if (! empty($context['tpa'])) {
                $systemInstruction .= '- Data TPA: Total Santri: '.$context['tpa']['total'].' (Disetujui: '.$context['tpa']['approved'].', Pending: '.$context['tpa']['pending'].")\n";
            }

            if (! empty($context['zakat'])) {
                $systemInstruction .= '- Data Zakat: Total Muzakki: '.$context['zakat']['total_muzakki'].' | Fitrah Uang: '.$context['zakat']['fitrah_uang'].' | Fitrah Beras: '.$context['zakat']['fitrah_beras'].' | Zakat Mal: '.$context['zakat']['zakat_mal']."\n";
            }

            if (! empty($context['qurban'])) {
                $systemInstruction .= '- Data Qurban: Total Shohibul Qurban: '.$context['qurban']['total_shohibul']."\n";
            }

            if (! empty($context['wishlists'])) {
                $systemInstruction .= "- Wishlist / Kebutuhan Inventaris Masjid:\n";
                foreach ($context['wishlists'] as $w) {
                    $systemInstruction .= '  * '.$w['item_name'].' (Target: '.$w['target_qty'].', Terpenuhi: '.$w['fulfilled_qty'].', Harga/unit: '.$w['unit_price'].') - Status: '.$w['status']."\n";
                }
            }

            if (! empty($context['committee'])) {
                $systemInstruction .= "- Susunan Pengurus DKM:\n";
                foreach ($context['committee'] as $c) {
                    $systemInstruction .= '  * '.$c['name'].' - '.$c['position'].' (Divisi '.$c['division'].")\n";
                }
            }

            if (! empty($context['posts'])) {
                $systemInstruction .= "- Berita/Pengumuman Terbaru:\n";
                foreach ($context['posts'] as $p) {
                    $systemInstruction .= '  * '.$p['title'].' ('.$p['date'].")\n";
                }
            }

            $contents = [];
            $contents[] = [
                'role' => 'user',
                'parts' => [['text' => $systemInstruction."\n\nPertanyaan Jamaah: ".$userMessage]],
            ];

            $url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key='.$apiKey;

            $response = Http::timeout(10)->post($url, [
                'contents' => $contents,
                'generationConfig' => [
                    'temperature' => 0.3,
                    'maxOutputTokens' => 1000,
                ],
            ]);

            if ($response->successful()) {
                $data = $response->json();
                $reply = $data['candidates'][0]['content']['parts'][0]['text'] ?? null;
                if ($reply) {
                    return trim($reply);
                }
            }
        } catch (\Exception $e) {
            Log::warning('Gemini API Error: '.$e->getMessage());
        }

        return null;
    }

    /**
     * Intelligent Local Rule & Context Engine (Fallback)
     */
    private function queryLocalEngine(string $message, array $context): string
    {
        $msg = strtolower($message);

        // 1. Salam / Greeting
        if (preg_match('/^(assalamu|assalam|salam|halo|hi|hai|pagi|siang|malam)/i', $msg)) {
            return "Assalamu'alaikum Warahmatullahi Wabarakatuh! 🌿\n\nSaya adalah **Huda — Asisten Masjid**. Ada yang bisa saya bantu terkait jadwal sholat, saldo kas, agenda kajian, zakat, qurban, atau info masjid?\n\nSaya dapat membantu memberikan informasi terkait:\n"
                ."• **Kajian & Ustaz**\n"
                ."• **Transparansi Keuangan & Kas**\n"
                ."• **Pendaftaran Santri TPA**\n"
                ."• **Layanan Zakat & Program Qurban**\n"
                ."• **Agenda Kegiatan & Berita**\n"
                ."• **Pengurus DKM & Wishlist Inventaris**\n"
                ."• **Jadwal Sholat & Petugas Jum'at**";
        }

        // Role-based handling based on user role
        $role = $context['user_role'] ?? 'jamaah';
        if (in_array($role, ['admin', 'super_admin', 'superadmin'])) {
            // Provide role-specific guidance for data/report queries
            if (preg_match('/(laporan|detail|statistik|data)/i', $msg)) {
                if ($role === 'admin') {
                    return 'Sebagai **admin**, Anda dapat mengakses laporan detail dan statistik melalui panel admin. Gunakan menu **Manajemen** untuk melihat data lengkap.';
                } elseif (in_array($role, ['super_admin', 'superadmin'])) {
                    return 'Sebagai **Super Admin**, Anda memiliki akses penuh ke pengaturan sistem. Gunakan menu **Pengaturan Sistem** untuk mengelola konfigurasi dan data tingkat tinggi.';
                }
            }
        }

        // 5. Layanan Umat / Bantuan Sosial Masjid (Services)
        if (preg_match('/(layanan|service|bantuan|program|program sosial|layanan umat)/i', $msg)) {
            if (! empty($context['services'])) {
                $reply = '📖 **Daftar Layanan Umat '.$context['mosque_name']."**\n\n";
                foreach ($context['services'] as $s) {
                    $reply .= "• **{$s['title']}** ({$s['category']})\n  {$s['short_description']}\n";
                    if (! empty($s['terms'])) {
                        $reply .= "  *Syarat:* {$s['terms']}\n";
                    }
                }

                return trim($reply);
            }

            return 'Maaf, data layanan umat belum tersedia di sistem.';
        }

        // 2. Pengurus DKM / DKM Structure
        if (preg_match('/(pengurus|dkm|ketua dkm|struktur|panitia|organisasi|divisi)/i', $msg)) {
            if (! empty($context['committee'])) {
                $reply = '🕌 **Struktur Pengurus DKM '.$context['mosque_name']."**\n\n";
                foreach ($context['committee'] as $c) {
                    $reply .= '• **'.$c['name'].'** — '.$c['position'].' *(Divisi '.$c['division'].")*\n";
                }
                $reply .= "\n*Pengurus DKM bertugas mengelola seluruh kegiatan ibadah, pendidikan, keuangan, dan sosial di masjid.*";

                return $reply;
            }

            return 'Maaf, data struktur pengurus DKM belum tersedia di sistem.';
        }

        // 3. Kajian Rutin & Ustaz
        if (preg_match('/(kajian|ustadz|ustaz|pemateri|pengajian|ta\'lim|majelis|penceramah|tema)/i', $msg)) {
            if (! empty($context['kajians'])) {
                $reply = '📚 **Jadwal & Informasi Kajian '.$context['mosque_name']."**\n\n";
                foreach ($context['kajians'] as $k) {
                    $reply .= '• **'.$k['title']."**\n"
                        .'  *Pemateri*: '.$k['ustaz']."\n"
                        .'  *Waktu*: '.$k['date'].' (Pukul '.$k['time'].")\n"
                        .'  *Lokasi*: '.$k['location']."\n"
                        .($k['theme'] !== '-' ? '  *Tema*: '.$k['theme']."\n" : '')."\n";
                }

                return trim($reply);
            }

            return 'Maaf, informasi kajian rutin/tematik belum tersedia di sistem PIMASJID.';
        }

        // 4. TPA / TPQ (Pendidikan Al-Qur'an)
        if (preg_match('/(tpa|tpq|santri|mengaji|pendaftaran tpa|anak|iqro|tahfidz)/i', $msg)) {
            $tpa = $context['tpa'];
            $reply = '📖 **Fitur & Informasi TPA/TPQ '.$context['mosque_name']."**\n\n"
                .'• **Total Pendaftar Santri**: '.$tpa['total']." anak\n"
                .'• **Santri Resmi (Disetujui)**: '.$tpa['approved']." santri\n"
                .'• **Menunggu Persetujuan**: '.$tpa['pending']." santri\n\n"
                ."**Pembagian Kelas Santri**:\n";

            if (! empty($tpa['classes'])) {
                foreach ($tpa['classes'] as $kelas => $count) {
                    $reply .= '• Kelas **'.$kelas.'**: '.$count." santri\n";
                }
            } else {
                $reply .= "• Iqro 1-3, Iqro 4-6, Al-Qur'an, & Tahfidz\n";
            }

            $reply .= "\nPendaftaran santri baru dapat diakses melalui menu **Pendaftaran TPA**.";

            return $reply;
        }

        // 5. Saldo Kas & Transparansi Keuangan
        if (preg_match('/(kas|uang|saldo|keuangan|pemasukan|pengeluaran|donasi|laporan|transaksi)/i', $msg)) {
            $reply = "💰 **Laporan Keuangan & Kas Masjid**\n\n"
                .'• **Total Saldo Kas Saat Ini**: *'.$context['balance_formatted']."*\n"
                .'• **Pemasukan Bulan Ini**: '.$context['income_this_month']."\n"
                .'• **Pengeluaran Bulan Ini**: '.$context['expense_this_month']."\n\n";

            if (! empty($context['recent_transactions'])) {
                $reply .= "**5 Transaksi Terakhir**:\n";
                foreach ($context['recent_transactions'] as $t) {
                    $reply .= '• ['.$t['date'].'] '.$t['type'].' ('.$t['category'].'): **'.$t['amount']."** — *{$t['description']}*\n";
                }
            }

            $reply .= "\nLaporan lengkap dan bukti fisik transaksi dapat dilihat pada menu **Transparansi Keuangan**.";

            return $reply;
        }

        // 6. Zakat Fitrah & Zakat Mal
        if (preg_match('/(zakat|fitrah|maal|mal|fidyah|mustahik|muzakki)/i', $msg)) {
            $z = $context['zakat'];

            return "🌾 **Layanan Zakat PIMASJID**\n\n"
                .'• **Total Transaksi Zakat**: '.$z['total_muzakki']." Muzakki\n"
                .'• **Penerimaan Zakat Fitrah (Uang)**: '.$z['fitrah_uang']."\n"
                .'• **Penerimaan Zakat Fitrah (Beras)**: '.$z['fitrah_beras']."\n"
                .'• **Penerimaan Zakat Mal**: '.$z['zakat_mal']."\n\n"
                .'Jamaah dapat menggunakan **Kalkulator Zakat** di menu **Info -> Zakat** untuk menghitung kewajiban zakat fitrah dan zakat mal secara presisi.';
        }

        // 7. Program Qurban
        if (preg_match('/(qurban|kurban|shohibul|sapi|kambing|domba)/i', $msg)) {
            $q = $context['qurban'];
            $reply = '🐑 **Program Qurban '.$context['mosque_name']."**\n\n"
                .'• **Total Shohibul Qurban Terdaftar**: '.$q['total_shohibul']." peserta\n\n"
                ."**Rekap Hewan Qurban**:\n";

            if (! empty($q['animals'])) {
                foreach ($q['animals'] as $type => $count) {
                    $reply .= '• Hewan **'.ucfirst($type).'**: '.$count." ekor\n";
                }
            } else {
                $reply .= "• Sapi Kolektif & Kambing/Domba Mandiri\n";
            }

            $reply .= "\nPendaftaran Shohibul Qurban dibuka pada menu **Info -> Qurban**.";

            return $reply;
        }

        // 8. Wishlist / Kebutuhan Inventaris & Fasilitas
        if (preg_match('/(wishlist|kebutuhan|inventaris|fasilitas|pengadaan|barang|perlengkapan)/i', $msg)) {
            if (! empty($context['wishlists'])) {
                $reply = "📦 **Wishlist & Kebutuhan Pengadaan Masjid**\n\n";
                foreach ($context['wishlists'] as $w) {
                    $reply .= '• **'.$w['item_name']."**\n"
                        .'  Harga/unit: '.$w['unit_price']." | Target: {$w['target_qty']} unit (Terpenuhi: {$w['fulfilled_qty']})\n"
                        .'  Status: *'.$w['status']."*\n\n";
                }
                $reply .= 'Jamaah dapat berpartisipasi mewujudkan fasilitas di atas melalui infaq ke rekening resmi masjid.';

                return trim($reply);
            }

            return 'Saat ini belum ada daftar wishlist barang yang diajukan.';
        }

        // 9. Agenda & Kegiatan
        if (preg_match('/(kegiatan|agenda|acara)/i', $msg)) {
            if (! empty($context['agendas'])) {
                $reply = "📅 **Agenda Kegiatan PIMASJID Mendatang**\n\n";
                foreach ($context['agendas'] as $a) {
                    $reply .= '• **'.$a['title']."**\n  Tanggal: ".$a['date'].' (Pukul '.$a['time'].")\n  Lokasi: ".$a['location']."\n\n";
                }

                return trim($reply);
            }

            return 'Maaf, agenda kegiatan mendatang belum tersedia di sistem PIMASJID.';
        }

        // 10. Jadwal Sholat & Petugas Jum'at
        if (preg_match('/(sholat|solat|subuh|dzuhur|zuhur|ashar|maghrib|isya|jumat|jum\'at|khatib|imam|muadzin)/i', $msg)) {
            $pt = $context['prayer_times'];
            $reply = '🕌 **Jadwal Sholat Hari Ini ('.$context['today_date'].")**\n\n"
                .'• **Subuh**: '.$pt['Subuh']." WIB\n"
                .'• **Syuruq**: '.$pt['Syuruq']." WIB\n"
                .'• **Dzuhur**: '.$pt['Dzuhur']." WIB\n"
                .'• **Ashar**: '.$pt['Ashar']." WIB\n"
                .'• **Maghrib**: '.$pt['Maghrib']." WIB\n"
                .'• **Isya**: '.$pt['Isya']." WIB\n\n";

            if ($context['friday_schedule']) {
                $fs = $context['friday_schedule'];
                $reply .= "**Petugas Sholat Jum'at (".$fs['date'].")**:\n"
                    .'• Khatib: '.$fs['khatib']."\n"
                    .'• Imam: '.$fs['imam']."\n"
                    .'• Muadzin: '.$fs['muadzin']."\n";
            }

            return $reply;
        }

        // 11. Pengumuman & Berita
        if (preg_match('/(pengumuman|berita|artikel|post)/i', $msg)) {
            if (! empty($context['posts'])) {
                $reply = "📢 **Berita & Pengumuman Terbaru**\n\n";
                foreach ($context['posts'] as $p) {
                    $reply .= '• **'.$p['title'].'** ('.$p['date'].")\n";
                }

                return $reply;
            }

            return 'Maaf, berita atau pengumuman terbaru belum tersedia.';
        }

        // 12. Donasi & Rekening Bank
        if (preg_match('/(rekening|donasi|infaq|infak|transfer|norek|bank|bsi)/i', $msg)) {
            return '💳 **Rekening Resmi Infaq & Donasi '.$context['mosque_name']."**\n\n"
                .'• **Bank**: '.$context['bank_name']."\n"
                .'• **No. Rekening**: `'.$context['bank_account']."`\n"
                .'• **Atas Nama**: '.$context['bank_holder']."\n\n"
                .'*Setiap infaq dan sedekah yang masuk akan dicatat secara transparan di Laporan Keuangan PIMASJID.*';
        }

        // Default Response
        return 'Maaf, informasi yang Anda minta belum tersedia dalam data PIMASJID saat ini.';
    }
}
