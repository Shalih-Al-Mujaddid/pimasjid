<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Laporan Zakat {{ $year }}</title>
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
        
        .summary-box { margin-bottom: 20px; }
        .clearfix { clear: both; }
        
        .flex { display: flex; }
        .col-half { width: 48%; float: left; margin-right: 2%; }
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
    
    <h2 class="text-center">LAPORAN ZAKAT TAHUN {{ $year }}</h2>
    
    <!-- Summary -->
    <div class="summary-box">
        <h3>Ringkasan</h3>
        <table>
            <tr>
                <th>Total Muzakki</th>
                <th>Total Uang</th>
                <th>Total Beras</th>
                <th>Total Dist. Uang</th>
                <th>Total Dist. Beras</th>
            </tr>
            <tr>
                <td class="text-center">{{ $summary['total_muzakki'] ?? 0 }} Orang</td>
                <td class="text-right">Rp {{ number_format($summary['total_amount'] ?? 0, 0, ',', '.') }}</td>
                <td class="text-right">{{ $summary['total_rice'] ?? 0 }} Kg/Liter</td>
                <td class="text-right">Rp {{ number_format($summary['distributed_amount'] ?? 0, 0, ',', '.') }}</td>
                <td class="text-right">{{ $summary['distributed_rice'] ?? 0 }} Kg</td>
            </tr>
            <tr style="background-color: #e6fffa; font-weight: bold;">
                <td class="text-center">SISA SALDO</td>
                <td colspan="2" class="text-right">Rp {{ number_format($summary['remaining_amount'] ?? 0, 0, ',', '.') }}</td>
                <td colspan="2" class="text-right">{{ $summary['remaining_rice'] ?? 0 }} Kg (Beras)</td>
            </tr>
        </table>
    </div>

    <!-- Details Breakdown using Two Columns Logic (Simulated with div float) -->
    <div>
        <div class="col-half">
            <h3>Rincian Penyaluran (Distribusi)</h3>
            <table>
                <thead>
                    <tr>
                        <th>Asnaf / Golongan</th>
                        <th>Nominal (Rp)</th>
                        <th>Beras (Kg)</th>
                    </tr>
                </thead>
                <tbody>
                @if(isset($distribution_by_asnaf) && count($distribution_by_asnaf) > 0)
                    @foreach($distribution_by_asnaf as $dist)
                    <tr>
                        <td>{{ ucfirst(str_replace('_', ' ', $dist->mustahik_category)) }}</td>
                        <td class="text-right">Rp {{ number_format($dist->total_amount, 0, ',', '.') }}</td>
                        <td class="text-right">{{ $dist->total_rice > 0 ? $dist->total_rice : '-' }}</td>
                    </tr>
                    @endforeach
                @else
                    <tr><td colspan="3" class="text-center">Belum ada penyaluran</td></tr>
                @endif
                </tbody>
            </table>
        </div>
        <div class="clearfix"></div>
    </div>

    <!-- Zakat List -->
    <h3>Daftar Penerimaan Zakat</h3>
    <table>
        <thead>
            <tr>
                <th width="5%">No</th>
                <th width="20%">Nama Muzakki</th>
                <th width="15%">Jenis Zakat</th>
                <th width="10%">Jiwa</th>
                <th width="15%">Nominal (Rp)</th>
                <th width="15%">Beras (Kg/L)</th>
                <th width="10%">Tanggal</th>
                <th width="10%">Status</th>
            </tr>
        </thead>
        <tbody>
            @foreach($zakats as $index => $zakat)
            <tr>
                <td class="text-center">{{ $index + 1 }}</td>
                <td>
                    <b>{{ $zakat->muzakki_name }}</b>
                    @if($zakat->muzakki_phone) <br><small>{{ $zakat->muzakki_phone }}</small> @endif
                </td>
                <td>{{ ucwords(str_replace('_', ' ', $zakat->type)) }}</td>
                <td class="text-center">{{ $zakat->type === 'fitrah' ? $zakat->person_count : '-' }}</td>
                <td class="text-right">{{ $zakat->amount ? 'Rp ' . number_format($zakat->amount, 0, ',', '.') : '-' }}</td>
                <td class="text-right">{{ $zakat->rice_kg ? $zakat->rice_kg . ' Kg' : '-' }}</td>
                <td class="text-center">{{ \Carbon\Carbon::parse($zakat->date)->format('d/m/Y') }}</td>
                <td class="text-center" style="color: green; font-weight: bold;">Sudah Bayar</td>
            </tr>
            @endforeach
        </tbody>
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
