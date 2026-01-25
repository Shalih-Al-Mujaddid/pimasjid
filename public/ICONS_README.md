# PWA Icons - Placeholder Instructions

Saat ini aplikasi menggunakan icon SVG placeholder. Untuk production, Anda perlu membuat icon PNG dengan ukuran berikut:

## Required Icons:

1. **icon-192x192.png** - Icon untuk Android (192x192 pixels)
2. **icon-512x512.png** - Icon untuk splash screen (512x512 pixels)  
3. **apple-touch-icon.png** - Icon untuk iOS (180x180 pixels)
4. **favicon.ico** - Favicon untuk browser

## Cara Membuat Icons:

### Opsi 1: Menggunakan Online Tool
1. Buka https://realfavicongenerator.net/
2. Upload logo masjid Anda (minimal 512x512 px)
3. Download semua icon yang dihasilkan
4. Letakkan di folder `public/`

### Opsi 2: Menggunakan Icon.svg yang Sudah Ada
File `icon.svg` sudah tersedia di `public/icon.svg`. Anda bisa convert ke PNG:

#### Menggunakan ImageMagick:
```bash
# Install ImageMagick terlebih dahulu
# Windows: choco install imagemagick
# Mac: brew install imagemagick

# Generate icons
magick convert -background none icon.svg -resize 192x192 icon-192x192.png
magick convert -background none icon.svg -resize 512x512 icon-512x512.png
magick convert -background none icon.svg -resize 180x180 apple-touch-icon.png
```

#### Menggunakan Online Converter:
1. Buka https://cloudconvert.com/svg-to-png
2. Upload `icon.svg`
3. Set dimensions (192x192, 512x512, 180x180)
4. Download dan rename sesuai kebutuhan

### Opsi 3: Design Custom di Figma/Canva
Buat design custom dengan:
- Ukuran: 512x512 px
- Logo/simbol masjid di tengah
- Background: putih atau gradient
- Warna theme: emerald green (#10b981)
- Export sebagai PNG dengan berbagai ukuran

## Note:
Icon SVG yang ada sekarang akan ditampilkan browser yang support SVG, tapi untuk kompatibilitas maksimal (terutama iOS), PNG diperlukan.
