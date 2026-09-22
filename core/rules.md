# Aturan Konvensi Rekayasa Perangkat Lunak (Corporate Engineering Rules)

## 1. Pemrograman Aman (Security)
- **SQL Injection Prevention:** Dilarang merangkai variabel mentah ke dalam string query SQL. Wajib mengutamakan Parameterized Query / Prepared Statements via PDO atau MySQLi (object-oriented maupun procedural), atau Query Builder framework.
  * **Mitigasi Alternatif (Jika Aplikasi Belum Menggunakan PDO/MySQLi):** Jika arsitektur aplikasi legasi belum memungkinkan PDO/mysqli, AI wajib menyarankan mitigasi alternatif: (1) Fungsi escaping bawaan driver basis data atau `addslashes()`, (2) Strict type casting numerik `(int)$id`, (3) Whitelist validation untuk klausa dinamis via `in_array()`, (4) Filter/Regex validasi karakter via `filter_var()`, serta (5) Tanyakan konfirmasi kepada developer apakah ingin solusi sanitasi alternatif ini atau migrasi bertahap.
- **Sanitasi Parameter GET (XSS Prevention):** Setiap variabel `$_GET` yang dicetak langsung ke antarmuka/HTML wajib dibungkus fungsi `htmlentities()`.
- **Download Berkas Terproteksi:** Dilarang memberikan path berkas langsung atau parameter GET seperti `?file=laporan.pdf`. Wajib menggunakan ID dokumen (`?id=1` atau `/download/1`) disertai pengecekan otentikasi dan otorisasi akses pengguna.
- **Upload Berkas:** Nama berkas wajib di-rename menggunakan mekanisme hashing unik dan wajib melakukan validasi whitelist ekstensi berkas yang diizinkan.
- **Otorisasi Berbasis Peran:** Hak akses modul/konten wajib berbasis peran (*role*) yang terdaftar di basis data.

## 2. Integritas Data & Validasi (Integrity)
- **Database Transactions (Commit & Rollback):** Setiap operasi penulisan basis data di back end (insert, update, delete) wajib dibungkus blok transaksi (`trans_start` / `commit` & `rollback`).
- **Relasi Tabel & Foreign Key:** Relasi antar tabel yang berhubungan wajib menggunakan Foreign Key sejak pembuatan skema/ERD. Penamaan constraint: `fk_<singkatan_tabel>_<nama_kolom>`.
- **Dual-Layer Validation:** Validasi data WAJIB diterapkan pada Back End terlebih dahulu. Validasi Front End hanya bertindak sebagai pelengkap.

## 3. Arsitektur & Skalabilitas
- **Decoupled Settings:** URL pemanggilan API eksternal/internal dan alur persetujuan (*approval workflow*) wajib tersimpan di tabel database (tidak di-hardcode di kode).
- **Server-Side Pagination:** Tampilan tabel data bervolume dinamis wajib menggunakan server-side pagination.

## 4. Standar Penamaan (Naming Conventions)
- **Tabel:** Awalan `t_` (contoh: `t_transaksi`, `t_pemakaian`).
- **View:** Awalan `v_` (contoh: `v_rekap_harian`).
- **Foreign Key:** `fk_<singkatan_tabel>_<nama_kolom>` (contoh: `fk_tio_id_invoice_online`).
- **Function:** Awalan `f_` (contoh: `f_hitung_total`).
- **Stored Procedure:** Awalan `sp_` (contoh: `sp_proses_approval`).
- **Trigger:** Awalan `tr_` (contoh: `tr_after_insert_pemakaian`).
- **Git Branch:** Format `<kategori>/<nama-modul>/<deskripsi-fitur>` dengan pemisah kata tanda hubung `-` (kategori: `feature`, `develop`, `qa`, `release`, `master`, `hotfix`).

## 5. Dokumentasi Fungsi (Comment Block)
Setiap fungsi atau prosedur wajib memiliki blok komentar berisi 3 aspek wajib:
1. **Fungsi:** Untuk apa potongan kode/fungsi tersebut dibuat.
2. **Cara Kerja:** Penjelasan ringkas alur kerja di dalam fungsi.
3. **Cara Penggunaan:** Contoh pemanggilan fungsi beserta parameternya.

## 6. Antarmuka Pengguna (UI/UX)
- **Tata Letak Form:** Form dengan banyak field wajib disusun secara vertikal (satu kolom ke bawah).
- **Hierarki & Pewarnaan Tombol:** Submit = Biru (Primary), Delete = Merah (Danger), Cancel = Netral/Pudar/Abu-abu (Secondary).
- **Navigasi & Logo:** Desktop di sidebar kiri, mobile web di kanan atas, mobile app di kiri atas. Logo di pojok kiri atas.
- **Konsistensi Bahasa:** 100% seragam satu bahasa (Bahasa Indonesia seluruhnya atau Bahasa Inggris seluruhnya).
