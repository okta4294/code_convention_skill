---
name: comment
description: Menghasilkan atau memeriksa template blok dokumentasi komentar 3 poin wajib (fungsi, cara kerja singkat, cara pakai) untuk fungsi atau prosedur. Trigger dengan /comment.
---

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
Gunakan format komentar standar sesuai bahasa pemrograman target:

**Format DocBlock (PHP, JavaScript, TypeScript, Java):**
```javascript
/**
 * 1. FUNGSI:
 *    [Jelaskan tujuan fungsi ini]
 *
 * 2. CARA KERJA:
 *    [Jelaskan alur ringkas: parameter masuk, proses validasi/transaksi/query, nilai balik]
 *
 * 3. CARA PENGGUNAAN:
 *    [Contoh pemanggilan: const result = await f_hitung_total(orderId, items);]
 */
```

**Format Docstring (Python):**
```python
"""
1. FUNGSI:
   [Jelaskan tujuan fungsi ini]

2. CARA KERJA:
   [Jelaskan alur ringkas: parameter masuk, proses validasi/transaksi/query, nilai balik]

3. CARA PENGGUNAAN:
   [Contoh pemanggilan: result = f_hitung_total(order_id, items)]
"""
```

**Format Line Comment (Go, C#, Rust):**
```go
// 1. FUNGSI: [Jelaskan tujuan fungsi ini]
// 2. CARA KERJA: [Jelaskan alur ringkas: parameter masuk, proses, nilai balik]
// 3. CARA PENGGUNAAN: result, err := f_hitung_total(orderID, items)
```
