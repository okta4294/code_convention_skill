# Command: /comment

## Deskripsi
Menghasilkan atau memeriksa blok dokumentasi fungsi/prosedur agar memenuhi 3 aspek wajib standar komentar kode.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Menghasilkan blok komentar standar tanpa mengubah implementasi logika fungsi.

## 3 Aspek Wajib Dokumentasi Fungsi / Prosedur
Setiap fungsi atau prosedur wajib memiliki blok komentar yang menjelaskan:
1. Fungsi: Untuk apa potongan kode/fungsi tersebut dibuat.
2. Cara Kerja: Penjelasan ringkas alur atau mekanisme kerja di dalam fungsi.
3. Cara Penggunaan: Contoh nyata atau tata cara pemanggilan fungsi tersebut beserta parameternya.

## Format Output Wajib
### 📋 Peninjauan Dokumentasi Kode
- Fungsi / Prosedur: [Nama Fungsi]
- Kelengkapan Aspek:
  - [x] Fungsi kode
  - [x] Cara kerja singkat
  - [x] Cara pemanggilan / penggunaan

---

### 💻 Template Blok Komentar yang Direkomendasikan
```php
/**
 * 1. FUNGSI:
 *    [Jelaskan tujuan fungsi ini]
 *
 * 2. CARA KERJA:
 *    [Jelaskan alur singkat: parameter masuk, proses sanitasi/transaksi/query, nilai balik]
 *
 * 3. CARA PENGGUNAAN:
 *    [Contoh pemanggilan: $result = f_nama_fungsi($param1,$param2);]
 */
```
