---
name: comment
description: Menghasilkan atau memeriksa template blok dokumentasi komentar 3 poin wajib (1. Fungsi kode untuk apa, 2. Bagaimana kode bekerja secara singkat, 3. Bagaimana menggunakan kode tersebut) untuk fungsi atau prosedur. Trigger dengan /comment.
---

# Command: /comment

## Deskripsi
Menghasilkan atau memeriksa blok dokumentasi fungsi/prosedur agar memenuhi 3 aspek wajib standar komentar kode (Poin 6.1 & 6.2).

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Menghasilkan blok komentar standar tanpa mengubah implementasi logika fungsi.

## 3 Aspek Wajib Dokumentasi Fungsi / Prosedur (Poin 6.1 & 6.2)
Setiap fungsi atau prosedur kode wajib memiliki blok komentar tepat di atas deklarasinya yang menjelaskan 3 hal:
1. **Fungsi:** Kode ini berfungsi untuk apa?
2. **Cara Kerja:** Bagaimana kode ini secara singkat melakukan fungsinya?
3. **Cara Penggunaan:** Bagaimana menggunakan/memanggil kode tersebut beserta parameternya?

## Format Output Wajib
### 📋 Peninjauan Dokumentasi Kode
- Fungsi / Prosedur: [Nama Fungsi]
- Kelengkapan Aspek:
  - [x] 1. Code ini berfungsi untuk apa? (Fungsi)
  - [x] 2. Bagaimana code ini secara singkat melakukan fungsinya? (Cara Kerja)
  - [x] 3. Bagaimana menggunakan code tersebut? (Cara Penggunaan)

---

### 💻 Template Blok Komentar yang Direkomendasikan
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

### 🛠️ Implementation Plan
1. Salin blok komentar di atas dan letakkan tepat di atas baris deklarasi fungsi/prosedur pada berkas terkait.
2. Pastikan parameter input dan nilai kembalian (*return value*) sesuai dengan tanda tangan (*signature*) fungsi.
