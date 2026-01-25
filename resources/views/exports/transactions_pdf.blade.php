<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Laporan Keuangan</title>
    <style>
        body { font-family: sans-serif; }
        .header { text-align: center; margin-bottom: 20px; border-bottom: 2px solid #000; padding-bottom: 10px; }
        .header img { height: 80px; float: left; }
        .header-text { margin-top: 10px; }
        .header h1 { margin: 0; font-size: 24px; text-transform: uppercase; }
        .header p { margin: 5px 0; font-size: 12px; }
        
        table { width: 100%; border-collapse: collapse; margin-bottom: 15px; font-size: 11px; }
        th, td { border: 1px solid #ddd; padding: 6px; }
        th { background-color: #f4f4f4; text-align: left; }
        
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        
        .signatures { margin-top: 50px; width: 100%; }
        .signature-box { width: 40%; float: left; text-align: center; }
        .signature-box.right { float: right; }
        
        .footer { position: fixed; bottom: 0; left: 0; right: 0; font-size: 10px; text-align: center; color: #666; border-top: 1px solid #ddd; padding-top: 5px; }
        
        .total-row { font-weight: bold; background-color: #f9fafb; }
        .income { color: #059669; }
        .expense { color: #dc2626; }
        .clearfix { clear: both; }
    </style>
</head>
<body>
    <div class="header">
        @if(isset($settings['logo_path']) && $settings['logo_path'])
            <img src="{{ public_path($settings['logo_path']) }}" alt="Logo">
        @endif
        <div class="header-text">
            <h1>{{ $settings['site_name'] ?? 'Masjid App' }}</h1>
            <p>{{ $settings['address'] ?? '' }}</p>
            <p>Telp: {{ $settings['phone'] ?? '' }} | Email: {{ $settings['email'] ?? '' }}</p>
        </div>
        <div class="clearfix"></div>
    </div>
    
    <h2 class="text-center">LAPORAN KEUANGAN</h2>
    <p class="text-center" style="margin-top: -10px; margin-bottom: 20px; font-size: 12px;">
        Periode: {{ \Carbon\Carbon::parse($startDate)->isoFormat('D MMMM Y') }} - {{ \Carbon\Carbon::parse($endDate)->isoFormat('D MMMM Y') }}
    </p>

    <table>
        <thead>
            <tr>
                <th width="12%">Tanggal</th>
                <th width="10%">Tipe</th>
                <th width="15%">Kategori</th>
                <th>Keterangan</th>
                <th width="18%" class="text-right">Jumlah</th>
            </tr>
        </thead>
        <tbody>
            @foreach($transactions as $t)
            <tr>
                <td class="text-center">{{ \Carbon\Carbon::parse($t->date)->format('d/m/Y') }}</td>
                <td class="text-center">
                    <span class="{{ $t->type == 'income' ? 'income' : 'expense' }}">
                        {{ $t->type == 'income' ? 'Pemasukan' : 'Pengeluaran' }}
                    </span>
                </td>
                <td>{{ $t->category }}</td>
                <td>{{ $t->description }}</td>
                <td class="text-right">Rp {{ number_format($t->amount, 0, ',', '.') }}</td>
            </tr>
            @endforeach
        </tbody>
        <tfoot>
            <tr class="total-row">
                <td colspan="4" class="text-right">Total Pemasukan</td>
                <td class="text-right income">Rp {{ number_format($totalIncome, 0, ',', '.') }}</td>
            </tr>
            <tr class="total-row">
                <td colspan="4" class="text-right">Total Pengeluaran</td>
                <td class="text-right expense">Rp {{ number_format($totalExpense, 0, ',', '.') }}</td>
            </tr>
            <tr class="total-row">
                <td colspan="4" class="text-right">Saldo Akhir (Periode Ini)</td>
                <td class="text-right">Rp {{ number_format($totalIncome - $totalExpense, 0, ',', '.') }}</td>
            </tr>
        </tfoot>
    </table>
    
    <!-- Signatures -->
    <div class="signatures">
        <div class="signature-box">
            <p>Mengetahui,<br>Ketua DKM</p>
            <br><br><br>
            <p><b>{{ $settings['chairman_name'] ?? '.........................' }}</b></p>
        </div>
        
        <div class="signature-box right">
            <p>{{ $settings['location_city'] ?? 'Jakarta' }}, {{ date('d F Y') }}<br>Bendahara</p>
            <br><br><br>
            <p><b>{{ $settings['treasurer_name'] ?? '.........................' }}</b></p>
        </div>
        <div class="clearfix"></div>
    </div>
    
    <div class="footer">
        Dicetak pada: {{ date('d/m/Y H:i:s') }} | Website: {{ url('/') }} | Halaman <span class="page-number"></span>
    </div>
</body>
</html>
