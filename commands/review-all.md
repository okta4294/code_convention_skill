# Command: /review-all

## Deskripsi
Menjalankan audit menyeluruh terhadap kode, skema basis data, atau berkas konfigurasi berdasarkan standar konvensi pengembangan enterprise. Audit mencakup seluruh bab konvensi: Konsep OOP & DRY, Keamanan (Secured Programming), Integritas Data, Fleksibilitas & Skalabilitas, Standar Penamaan & Alur Git, Dokumentasi 3 Poin, serta UI/UX.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- JANGAN melakukan edit atau penimpaan berkas secara langsung.
- Susun temuan ke dalam format Implementation Plan terstruktur untuk ditinjau oleh developer.

## Daftar Periksa Audit
1. Konsep Pemrograman & Framework (OOP & DRY):
   - Penerapan Object Oriented Programming (OOP) untuk kejelasan relasi objek.
   - Prinsip DRY (*Don't Repeat Yourself*): Proses yang digunakan lebih dari satu kali wajib dijadikan fungsi/prosedur `public` pada class induk yang di-`extends` oleh class pemanggil.
   - Kesesuaian penggunaan best practice framework (YII, CodeIgniter, Laravel, Golang Gorilla Mux & GORM).
2. Keamanan (Secured Programming):
   - Penggunaan Parameterized Query / Prepared Statements (MySQLi Object-Oriented/Procedural, PDO named/question mark parameter, atau Query Builder/ORM framework) untuk mencegah SQL Injection dan error karakter unik seperti tanda petik (`'`). Jika belum memungkinkan pada kode legasi, wajib ada mitigasi `mysqli_real_escape_string`/`addslashes`, strict type casting, dan whitelist validation.
   - Filtering parameter GET yang dicetak ke tampilan/label HTML menggunakan `htmlentities()` (mencegah XSS).
   - Metode download berkas berbasis ID dokumen (`?id=1` atau `/download/1`) disertai pengecekan autentikasi dan otorisasi akses pengguna (dilarang mengekspos path/nama file langsung di URL).
   - Upload berkas wajib di-rename menggunakan *hashing* (unique name), nama hasil hash disimpan di database (pisahkan kolom nama hash sistem dan nama asli jika nama asli perlu ditampilkan), serta validasi ekstensi file sesuai kesepakatan QMS.
   - Otorisasi akses konten data berbasis `role` yang disimpan di dalam database.
3. Integritas Data (Integrity):
   - Penggunaan Foreign Key (`fk_<singkatan_tabel>_<nama_kolom>`) pada relasi antar tabel sejak desain ERD.
   - Transaksi database (`trans_start`/`trans_commit`/`trans_rollback` pada CI, PDO `beginTransaction`, Laravel `DB::transaction`, GORM `Transaction`) pada setiap proses penyimpanan data di back end.
   - Validasi dua sisi (Back End & Front End) dengan mengutamakan Back End terlebih dahulu (antisipasi user mematikan JavaScript di browser; skenario QA wajib diuji tanpa JavaScript).
4. Fleksibilitas, Skalabilitas, & Performa:
   - Link URL API disimpan di dalam tabel database (misal kolom `url`, `aplikasi`, `nama_modul`) dan dipanggil via fungsi helper, tidak di-hardcode.
   - Tahapan dan pelaku approval disimpan di dalam tabel database (`approval_action`, `approval_step`, `approval_group`, `transaksional_log`, `transaksional_approval`).
   - Ketersediaan modul setting konfigurasi aplikasi agar perubahan variabel dapat diatur langsung oleh PIC user.
   - Tampilan tabel dengan data yang terus bertambah wajib menggunakan *server-side paging* (dilarang menggunakan plugin jQuery DataTables secara client-side).
   - High Performance: Respon cepat saat menampilkan maupun menyimpan data.
5. Standar Penamaan & Alur Git (Naming Convention & Git Workflow):
   - Database: Sesuai fungsi/isi data (`namadb`), versi migrasi lama diberi akhiran `namadbv2`, dst.
   - Prefiks objek database: Tabel (`t_`), View (`v_`), Foreign Key (`fk_<singkatan_tabel>_<nama_kolom>`), Function (`f_`), Stored Procedure (`sp_`), Trigger (`tr_`).
   - Git Branch: Format `<kategori>/<nama-modul>/<deskripsi-fitur>` dengan pemisah `-` untuk kata majemuk (kategori: `feature`, `develop`, `qa`, `release`, `master`, `hotfix`) serta kepatuhan pada 3 tahap alur kerja Git (Local -> QA -> Production).
6. Dokumentasi (Standard Commenting):
   - Setiap fungsi/prosedur wajib memiliki blok komentar di atas deklarasinya yang menjelaskan 3 hal: (1) Fungsi kode untuk apa, (2) Bagaimana cara kerja singkatnya, (3) Bagaimana cara menggunakan/memanggil kode tersebut.
7. Antarmuka Pengguna (UX Friendly):
   - Multiplatform & Mobile Friendly; posisi menu (Desktop: sidebar kiri, Mobile Web: kanan atas, Mobile Apps: kiri atas) dan logo di kiri atas.
   - Keseragaman 100% satu bahasa (Indonesia semua atau Inggris semua) pada label, button, menu, placeholder, notifikasi, dan inline error message.
   - Hierarki elemen: Warna tombol (Submit = Biru, Cancel = Pudar/Putih/Abu-abu, Delete = Merah), keseragaman ikon tombol (pena untuk edit, tempat sampah untuk delete), posisi tombol primary lebih menonjol, tata letak form banyak field wajib vertikal (1 kolom), pengelompokan informasi per kategori, serta kombinasi kontras warna teks vs background sesuai matriks pewarnaan.

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