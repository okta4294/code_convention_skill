---
name: review-all
description: Menjalankan audit menyeluruh terhadap kode, skema basis data, atau berkas konfigurasi berdasarkan standar konvensi enterprise (keamanan, integritas, arsitektur, penamaan objek, dokumentasi). Trigger dengan /review-all atau saat pengguna meminta audit kepatuhan menyeluruh.
---

# Command: /review-all

## Deskripsi
Menjalankan audit menyeluruh terhadap kode, skema basis data, atau berkas konfigurasi berdasarkan standar konvensi pengembangan enterprise. Audit mencakup aspek Keamanan, Integritas, Arsitektur, Penamaan Objek, dan Dokumentasi.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- JANGAN melakukan edit atau penimpaan berkas secara langsung.
- Susun temuan ke dalam format Implementation Plan terstruktur untuk ditinjau oleh developer.

## Daftar Periksa Audit
1. Keamanan (Security):
   - Penggunaan Parameterized Query / Prepared Statements / ORM resmi (dengan mitigasi alternatif: escaping, strict type casting, whitelist jika non-parameterized).
   - Sanitasi parameter input pengguna (seperti query parameter URL) saat dirender ke HTML/antarmuka (XSS prevention).
   - Pola unduh berkas berbasis ID dokumen terverifikasi (bukan direct filesystem path atau nama file di URL).
   - Validasi whitelist ekstensi serta MIME type dan hashing nama file upload.
2. Integritas Data (Integrity):
   - Transaksi database (commit & rollback) pada operasi penulisan data back-end (insert, update, delete).
   - Definisi relasi Foreign Key antar tabel.
   - Ketersediaan validasi di sisi Back End sebelum Front End.
3. Fleksibilitas & Skalabilitas:
   - URL pemanggilan API dan alur approval tersimpan di tabel database (tidak di-hardcode).
   - Server-side pagination untuk tabel data bervolume dinamis.
4. Standar Penamaan (Naming Convention):
   - Prefiks objek database (`t_`, `v_`, `fk_`, `f_`, `sp_`, `tr_`).
   - Format Git branch (`<kategori>/<modul>/<deskripsi>`).
5. Dokumentasi:
   - Ketersediaan blok komentar 3 poin wajib (fungsi, cara kerja singkat, cara pakai).

## Format Output Wajib
### 📋 Ringkasan Audit Kepatuhan (All-in-One)
- Status: [Lolos Standar / Perlu Tindakan Perbaikan]
- Berkas/Modul Terdampak: [Nama File / Fungsi]
- Ringkasan Pelanggaran: [Daftar ringkas kategori aturan yang dilanggar]

---

### 🔍 Temuan Ketidaksesuaian
[Uraikan detail temuan baris kode per kategori pelanggaran beserta risikonya]

---

### 🛠️ Implementation Plan
1. Langkah 1: ...
2. Langkah 2: ...
3. Langkah 3: ...

---

### 💻 Usulan Perubahan Kode (Proposed Diff / Snippet)
// Sebelum (Existing):
...

// Sesudah (Rekomendasi Sesuai Standar):
...

---

### ⚠️ Catatan Review untuk Developer
[Dampak perubahan arsitektur, dependensi variabel, atau hal yang wajib diverifikasi manual]
