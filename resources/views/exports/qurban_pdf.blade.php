<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Laporan Qurban {{ $year }}</title>
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
        
        .badge { padding: 2px 5px; border-radius: 4px; font-size: 10px; font-weight: bold; }
        .badge-success { background-color: #d1fae5; color: #065f46; } /* Emerald */
        .badge-warning { background-color: #fef3c7; color: #92400e; } /* Amber */
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
    
    <h2 class="text-center">LAPORAN HEWAN QURBAN TAHUN {{ $year }}</h2>
    
    <!-- Summary -->
    <div class="summary-box">
        <h3>Ringkasan</h3>
        <table>
            <tr>
                <th>Total Peserta</th>
                <th>Rincian Hewan</th>
                <th>Total Penerimaan Dana</th>
            </tr>
            <tr>
                <td class="text-center">{{ $summary['total_participants'] }} Orang</td>
                <td>
                    @foreach($by_animal_type as $type)
                        <div style="margin-bottom: 4px;">
                            <b>{{ $type['animal_type'] }}</b>: {{ $type['count'] }} Ekor
                            <br>
                            <span style="color: #666; font-size: 10px;">({{ $type['details'] }})</span>
                        </div>
                    @endforeach
                </td>
                <td class="text-right">Rp {{ number_format($summary['total_price'], 0, ',', '.') }}</td>
            </tr>
        </table>
    </div>

    <!-- Participants List -->
    <h3>Daftar Peserta Qurban</h3>
    <table>
        <thead>
            <tr>
                <th width="5%">No</th>
                <th width="25%">Nama Peserta</th>
                <th width="10%">Hewan</th>
                <th width="25%">Info Grup</th>
                <th width="15%">Biaya (Rp)</th>
                <th width="15%">Status Pembayaran</th>
            </tr>
        </thead>
        <tbody>
            @foreach($qurbans as $index => $qurban)
            @php
                // Calculate individual cost: If shared, divide total price by share count
                $cost = $qurban->is_shared && $qurban->share_count > 0 
                        ? $qurban->animal_price / $qurban->share_count 
                        : $qurban->animal_price;
                        
                // Status Translation
                $statusLabel = $qurban->status === 'paid' ? 'Sudah Bayar' : 'Belum Bayar';
                $statusClass = $qurban->status === 'paid' ? 'badge-success' : 'badge-warning';
            @endphp
            <tr>
                <td class="text-center">{{ $index + 1 }}</td>
                <td>
                    <b>{{ $qurban->participant_name }}</b>
                    @if($qurban->participant_nik) <br><small>NIK: {{ $qurban->participant_nik }}</small> @endif
                </td>
                <td>{{ ucfirst($qurban->animal_type) }}</td>
                <td>
                    @if($qurban->is_shared)
                        Grup #{{ substr($qurban->share_group_id, 0, 8) }}<br>
                        Urutan: {{ $qurban->share_position }}/{{ $qurban->share_count }}
                    @else
                        Individual
                    @endif
                </td>
                <td class="text-right">Rp {{ number_format($cost, 0, ',', '.') }}</td>
                <td class="text-center">
                    <span class="badge {{ $statusClass }}">
                        {{ $statusLabel }}
                    </span>
                </td>
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
