---
name: comment
description: Use when generating or checking 3-point function doc comments (/comment). Do NOT use for editing code logic or reviews.
metadata:
  author: okta4294
  tags:
    - documentation
    - comments
    - code-convention
---

# Command: /comment

## Purpose
Menghasilkan atau memeriksa blok dokumentasi fungsi/prosedur agar memenuhi 3 aspek wajib standar komentar kode (Poin 6.1 & 6.2).

## Prerequisites
- Pengguna menyediakan kode fungsi, method, atau prosedur yang akan didokumentasikan atau diperiksa kelengkapan komentarnya.
- Tidak memerlukan tool eksternal, API key, atau konfigurasi tambahan.

## Instructions

### Mode Operasional
- ADVISORY ONLY (Read-Only).
- Menghasilkan blok komentar standar tanpa mengubah implementasi logika fungsi.

### 3 Aspek Wajib Dokumentasi Fungsi / Prosedur (Poin 6.1 & 6.2)
Setiap fungsi atau prosedur kode wajib memiliki blok komentar tepat di atas deklarasinya yang menjelaskan 3 hal:
1. **Fungsi:** Kode ini berfungsi untuk apa?
2. **Cara Kerja:** Bagaimana kode ini secara singkat melakukan fungsinya?
3. **Cara Penggunaan:** Bagaimana menggunakan/memanggil kode tersebut beserta parameternya?

### Format Output Wajib
#### Peninjauan Dokumentasi Kode
- Fungsi / Prosedur: [Nama Fungsi]
- Kelengkapan Aspek:
  - [x] 1. Code ini berfungsi untuk apa? (Fungsi)
  - [x] 2. Bagaimana code ini secara singkat melakukan fungsinya? (Cara Kerja)
  - [x] 3. Bagaimana menggunakan code tersebut? (Cara Penggunaan)

---

#### Template Blok Komentar yang Direkomendasikan
Gunakan format komentar standar sesuai bahasa pemrograman target:

**Format DocBlock (PHP, JavaScript, TypeScript, Java):**
```php
/**
 * 1. FUNGSI:
 *    [Jelaskan kode ini berfungsi untuk apa]
 *
 * 2. CARA KERJA:
 *    [Jelaskan secara singkat bagaimana kode ini melakukan fungsinya: parameter masuk, proses sanitasi/transaksi/query, nilai balik]
 *
 * 3. CARA PENGGUNAAN:
 *    [Contoh pemanggilan: $result = f_hitung_total($orderId, $items);]
 */
```

**Format Docstring (Python):**
```python
"""
1. FUNGSI:
   [Jelaskan kode ini berfungsi untuk apa]

2. CARA KERJA:
   [Jelaskan secara singkat bagaimana kode ini melakukan fungsinya: parameter masuk, proses validasi/transaksi/query, nilai balik]

3. CARA PENGGUNAAN:
   [Contoh pemanggilan: result = f_hitung_total(order_id, items)]
"""
```

**Format Line Comment (Golang, C#, Rust):**
```go
// 1. FUNGSI: [Jelaskan kode ini berfungsi untuk apa]
// 2. CARA KERJA: [Jelaskan secara singkat bagaimana kode ini melakukan fungsinya]
// 3. CARA PENGGUNAAN: result, err := f_hitung_total(orderID, items)
```

---

#### Implementation Plan
1. Salin blok komentar di atas dan letakkan tepat di atas baris deklarasi fungsi/prosedur pada berkas terkait.
2. Pastikan parameter input dan nilai kembalian (*return value*) sesuai dengan tanda tangan (*signature*) fungsi.

## Examples

### Membuat Komentar 3 Poin untuk Fungsi PHP
Input pengguna:
```php
function hitungDiskon($total, $persen) {
    return $total - ($total * ($persen / 100));
}
```

Output yang diharapkan:
```php
/**
 * 1. FUNGSI:
 *    Menghitung total harga akhir setelah potongan diskon persentase.
 *
 * 2. CARA KERJA:
 *    Menerima angka $total dan $persen, menghitung nilai potongan, lalu mengembalikan selisih harga akhir.
 *
 * 3. CARA PENGGUNAAN:
 *    $hargaAkhir = hitungDiskon(100000, 10);
 */
```

## Limitations
- Bersifat Read-Only (Advisory Only) dan tidak menyisipkan komentar langsung ke file sumber.
- Tidak melakukan audit keamanan, performa, atau perbaikan bug pada isi fungsi.

## Troubleshooting
- **Error:** Bahasa pemrograman dari potongan kode tidak teridentifikasi.
  - **Cause:** Potongan kode terlalu singkat atau tidak memiliki sintaks khas bahasa tertentu.
  - **Solution:** Tanyakan bahasa pemrograman yang dipakai atau sediakan format DocBlock default disertai catatan penyesuaian.
- **Error:** Fungsi tidak memiliki tipe parameter atau nilai balik yang jelas.
  - **Cause:** Kode memakai bahasa bertipe dinamis tanpa anotasi tipe.
  - **Solution:** Lacak pemakaian variabel di dalam tubuh fungsi untuk menuliskan contoh pemanggilan yang akurat pada poin 3.
