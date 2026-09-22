
# Command: /review-security

## Deskripsi
Melakukan audit khusus keamanan aplikasi (Secured Programming) untuk mendeteksi kerentanan SQL Injection, XSS pada parsing parameter, eksposur berkas sistem, dan celah upload berkas.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Berikan saran perbaikan kode yang mengutamakan keamanan dan sanitasi input/output.

## Aturan Kepatuhan Khusus
1. SQL Injection & Karakter Unik:
   - Dilarang merangkai variabel mentah ke dalam string query SQL.
   - Wajib menggunakan Parameterized Query / Prepared Statements via PDO atau MySQLi (object-oriented maupun procedural), atau Query Builder framework.
   - Jika menggunakan raw query legasi, wajib memanfaatkan fungsi pelolosan karakter (`addslashes` / escape string).
2. Sanitasi Parameter GET (XSS Prevention):
   - Setiap variabel `$_GET` yang dicetak langsung ke antarmuka/HTML wajib dibungkus fungsi `htmlentities()`.
3. Metode Download Berkas:
   - Dilarang memberikan path berkas langsung atau parameter GET seperti `?file=laporan.pdf`.
   - Wajib menggunakan ID dokumen (`?id=1` atau `/download/1`) disertai pengecekan otentikasi dan otorisasi akses pengguna.
4. Upload Berkas:
   - Nama berkas wajib di-rename menggunakan mekanisme hashing unik.
   - Wajib melakukan validasi whitelist ekstensi berkas yang diizinkan.
5. Otorisasi Konten:
   - Hak akses konten wajib berbasis peran (role) yang terdaftar di basis data.

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