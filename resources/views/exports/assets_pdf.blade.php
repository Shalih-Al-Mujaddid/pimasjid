<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Laporan Inventaris Aset</title>
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
        .good { color: #059669; }
        .damaged { color: #f59e0b; }
        .lost { color: #dc2626; }
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
    
    <h2 class="text-center">LAPORAN INVENTARIS ASET</h2>
    <p class="text-center" style="margin-top: -10px; margin-bottom: 20px; font-size: 12px;">
        Per Tanggal: {{ date('d F Y') }}
    </p>

    <table>
        <thead>
            <tr>
                <th width="5%" class="text-center">No</th>
                <th width="30%">Nama Aset</th>
                <th width="12%" class="text-center">Kondisi</th>
                <th width="8%" class="text-center">Jumlah</th>
                <th width="15%" class="text-center">Tgl Beli</th>
                <th width="15%" class="text-right">Harga Beli</th>
                <th>Catatan</th>
            </tr>
        </thead>
        <tbody>
            @foreach($assets as $index => $asset)
            <tr>
                <td class="text-center">{{ $index + 1 }}</td>
                <td>{{ $asset->name }}</td>
                <td class="text-center">
                    <span class="{{ $asset->condition == 'good' ? 'good' : ($asset->condition == 'damaged' ? 'damaged' : 'lost') }}">
                        {{ $asset->condition == 'good' ? 'Baik' : ($asset->condition == 'damaged' ? 'Rusak' : 'Hilang') }}
                    </span>
                </td>
                <td class="text-center">{{ $asset->quantity }}</td>
                <td class="text-center">{{ $asset->purchase_date ? $asset->purchase_date->format('d/m/Y') : '-' }}</td>
                <td class="text-right">{{ $asset->purchase_price ? 'Rp ' . number_format($asset->purchase_price, 0, ',', '.') : '-' }}</td>
                <td>{{ $asset->notes ?? '-' }}</td>
            </tr>
            @endforeach
        </tbody>
        <tfoot>
            <tr class="total-row">
                <td colspan="3" class="text-right">Total Aset</td>
                <td class="text-center">{{ $totalQuantity }}</td>
                <td colspan="3"></td>
            </tr>
            <tr class="total-row">
                <td colspan="5" class="text-right">Total Nilai Aset</td>
                <td class="text-right" colspan="2">Rp {{ number_format($totalValue, 0, ',', '.') }}</td>
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
            <p>{{ $settings['location_city'] ?? 'Jakarta' }}, {{ date('d F Y') }}<br>Marbot</p>
            <br><br><br>
            <p><b>{{ $settings['marbot_name'] ?? '.........................' }}</b></p>
        </div>
        <div class="clearfix"></div>
    </div>
    
    <div class="footer">
        Dicetak pada: {{ date('d/m/Y H:i:s') }} | Website: {{ url('/') }} | Halaman <span class="page-number"></span>
    </div>
</body>
</html>
