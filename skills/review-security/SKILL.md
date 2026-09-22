---
name: review-security
description: Melakukan audit kepatuhan keamanan aplikasi (Secured Programming) untuk mendeteksi kerentanan SQL Injection, sanitasi parameter input & XSS, ID download terproteksi, dan validasi upload berkas. Trigger dengan /review-security atau saat audit keamanan kode diminta.
---

# Command: /review-security

## Deskripsi
Melakukan audit khusus keamanan aplikasi (Secured Programming) untuk mendeteksi kerentanan SQL Injection, XSS pada parsing parameter, eksposur berkas sistem, dan celah upload berkas.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Berikan saran perbaikan kode yang mengutamakan keamanan dan sanitasi input/output.

## Aturan Kepatuhan Khusus
1. SQL Injection & Penanganan Database Tanpa Parameterized Query:
   - Dilarang merangkai variabel mentah ke dalam string query SQL.
   - Wajib memprioritaskan Parameterized Query / Prepared Statements (contoh: PDO/MySQLi pada PHP, query berparameter pada Node.js/pg/Prisma, SQLAlchemy/Django ORM pada Python, PreparedStatement pada Java, atau Query Builder resmi framework).
   - **Alternatif Jika Arsitektur Belum Menggunakan Parameterized Query:**
     Apabila aplikasi legasi belum memungkinkan prepared statements, AI wajib menyarankan strategi pengamanan alternatif:
     * **Fungsi Pelolosan Karakter (Escaping):** Gunakan fungsi pelolosan bawaan driver basis data aktif (misal `mysqli_real_escape_string`, driver-specific escape) atau utilitas sanitasi karakter bahasa terkait.
     * **Strict Type Casting:** Paksa parameter numerik menjadi bilangan bulat/desimal secara eksplisit (misal `(int)$id` di PHP, `Number.parseInt()` di JS/TS, `int()` di Python) agar payload karakter kutip tereliminasi.
     * **Whitelist Validation:** Untuk input dinamis non-parameterized (seperti nama kolom sorting, klausa `ORDER BY`, arah `ASC`/`DESC`), validasi ketat menggunakan daftar nilai putih (*whitelist*) sebelum query dieksekusi.
     * **Validasi Format (Regex/Filter):** Gunakan fungsi validasi format (misal `filter_var()` di PHP, validator library, atau regular expression pola aman) sebelum variabel disisipkan ke query.
     * **Protokol Konfirmasi:** AI wajib menanyakan apakah developer ingin menerapkan sanitasi alternatif tersebut atau melakukan migrasi bertahap ke prepared statements.
2. Sanitasi Parameter Input ke Tampilan (XSS Prevention):
   - Setiap parameter input pengguna (misal query parameter `$_GET` di PHP, `req.query` di Express/Node.js, `request.GET` di Django, atau URL query params lainnya) yang dicetak langsung ke antarmuka/HTML wajib dibungkus fungsi encoding/escaping HTML kontekstual (misal `htmlentities()` / `htmlspecialchars()` di PHP, atau template engine auto-escaping).
3. Metode Download Berkas:
   - Dilarang memberikan path berkas langsung atau parameter nama file sistem di URL (misal: `?file=laporan.pdf` atau `/files/laporan.pdf`).
   - Wajib menggunakan verifikasi ID dokumen (misal `?id=1` atau `/download/1`) disertai pengecekan otentikasi dan otorisasi akses pengguna sebelum berkas dialirkan (*stream*).
4. Upload Berkas:
   - Nama berkas wajib di-rename menggunakan mekanisme hashing unik (misal UUID atau hash acak).
   - Wajib melakukan validasi daftar putih (*whitelist*) ekstensi berkas dan MIME type yang diizinkan.
5. Otorisasi Konten:
   - Hak akses konten dan manipulasi data wajib berbasis peran (*role*) yang terdaftar di basis data.

## Format Output Wajib
### 📋 Ringkasan Audit Kepatuhan: Keamanan
- Status: [Aman / Celah Keamanan Terdeteksi]
- Tingkat Risiko: [Kritis / Sedang / Rendah]
- Titik Kerentanan: [Nama File, Baris Kode, atau Parameter]

---

### 🔍 Analisis Kerentanan
[Jelaskan potensi eksploitasi peretas, seperti eksekusi skrip berbahaya atau injeksi query]

---

### 🛠️ Implementation Plan
1. Langkah 1: [Sanitasi input / perbaikan query / penyesuaian route download]
2. Langkah 2: [Penerapan prepared statement atau validasi ekstensi]

---

### 💻 Usulan Perubahan Kode (Proposed Code)
// Sebelum (Rentan):
...

// Sesudah (Aman Sesuai Standar):
...

---

### ⚠️ Catatan Review untuk Developer
[Pengujian payload karakter unik, ketersediaan library hash, atau pengaturan otorisasi session]
