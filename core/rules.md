# Aturan Konvensi Rekayasa Perangkat Lunak (Corporate Engineering Rules)

## 1. Konsep & Framework Pemrograman (Programming Concepts & Frameworks)
- **Object Oriented Programming (OOP):** Pengembangan sistem wajib menerapkan konsep OOP untuk memudahkan pemahaman relasi antar objek dan menjaga keberlanjutan pengembangan aplikasi saat terjadi pergantian developer.
- **DRY (*Don't Repeat Yourself*):** Setiap proses atau logika yang digunakan lebih dari satu kali wajib dibuatkan fungsi atau prosedur. Dalam konsep OOP, fungsi/prosedur tersebut wajib dideklarasikan secara `public` pada class induk/helper, kemudian class yang akan menjalankan proses tersebut dinyatakan sebagai perpanjangan (`extends`) dari class tersebut.
- **Standar Framework & ORM:**
  * **PHP:** YII, CodeIgniter (CI), dan Laravel (untuk integrasi API serta aplikasi web modern).
  * **Golang:** Gorilla Mux sebagai standar framework routing API dan GORM sebagai standar ORM untuk transaksi database.
- **Functional Quality:** Kode yang dikembangkan harus memenuhi seluruh fungsi inti kebutuhan bisnis dan wajib divalidasi melalui tahapan *internal testing*, QA, serta UAT bersama pengguna.

## 2. Pemrograman Aman (Secured Programming)
- **SQL Injection & Antisipasi Karakter Unik Parsing Data (Poin 4.6.3):** Dilarang merangkai variabel mentah langsung ke dalam string query SQL (terutama pada pemanggilan API atau input yang mengandung karakter unik seperti tanda petik `'` yang dapat merusak sintaks query dan membuka celah injeksi). Wajib mengutamakan **Parameterized Query / Prepared Statements**:
  * **Native PHP:** Gunakan driver **MySQLi** (Object-Oriented `$mysqli->prepare()` + `$stmt->bind_param()` atau Procedural `mysqli_prepare()` + `mysqli_stmt_bind_param()`) atau **PDO** (`$dbh->prepare()` + `$sth->execute()` baik dengan named parameter `:nama` maupun positional question mark `?`).
  * **Framework (YII / CodeIgniter / Laravel / Golang GORM / lainnya):** Wajib mengikuti *best practice* Query Builder atau ORM bawaan framework. Jika terpaksa menggunakan raw query pada framework, wajib menggunakan fitur parameter binding dari framework tersebut.
  * **Mitigasi Alternatif pada Kode Legasi:** Apabila arsitektur legasi belum memungkinkan prepared statements, wajib menerapkan:
    1. **Fungsi Pelolosan Karakter (Escaping):** Gunakan `mysqli_real_escape_string()` / `mysql_real_escape_string()` atau `addslashes()` pada setiap parsing data.
    2. **Strict Type Casting:** Paksa parameter numerik menjadi bilangan bulat/desimal secara eksplisit (misal `(int)$id` di PHP, `Number.parseInt()` di JS/TS, `int()` di Python).
    3. **Whitelist Validation:** Validasi ketat menggunakan daftar putih (*whitelist*) untuk input dinamis seperti nama kolom sorting atau arah `ASC`/`DESC`.
    4. **Validasi Format (Filter / Regex):** Validasi format data sebelum disisipkan ke dalam query.
    5. **Protokol Konfirmasi:** AI wajib menanyakan konfirmasi kepada developer apakah ingin menerapkan sanitasi alternatif tersebut atau melakukan migrasi bertahap ke prepared statements.
- **Filtering Parsing Data ke Tampilan / XSS Prevention (Poin 4.6.2):** Setiap variabel dari parsing data (seperti `$_GET` pada PHP, `req.query` pada Node.js, dll.) yang dicetak ke label/HTML wajib difilter menggunakan `htmlentities()` (contoh: `<?php echo htmlentities($_GET['title']); ?>`) atau auto-escaping template engine. Dilarang mencetak langsung `echo $_GET['...']` karena memungkinkan penyisipan skrip JavaScript berbahaya.
- **Metode Download Berkas Terproteksi (Poin 4.6.1):**
  * **Wajib Dilakukan:** Berikan tautan download menggunakan **ID dokumen** yang tersimpan (contoh: `http://www.site.com/report/download.php?id=1` atau `http://www.site.com/report/download/1`) serta wajib melakukan pengecekan **autentikasi dan otorisasi akses** terhadap user yang melakukan download.
  * **Dilarang Dilakukan:** Dilarang menggunakan parameter GET yang menunjuk nama atau path file secara langsung (contoh salah: `?file=sales_report.pdf` atau `/product/file/download/sales_report.pdf`) karena membuka celah bagi peretas untuk mengakses index file hingga konfigurasi koneksi database.
  * **Arsitektur Penyimpanan ID Download:** Dapat memanfaatkan *Primary Key* dari tabel transaksi/dokumen untuk memetakan ID ke kolom nama file hasil hash di database. Jika tanpa tabel khusus (untuk file statis), dapat menggunakan array mapping di kode, nama hash sebagai ID parameter, atau token terenkripsi (JWT), namun tetap wajib memvalidasi autentikasi dan otorisasi pengguna.
- **Penamaan & Validasi Upload Berkas (Poin 4.6.5):**
  * Nama berkas yang diunggah wajib melalui proses **rename menggunakan hashing (unique name)** dan nama hasil hash tersebut wajib disimpan ke kolom database agar sinkron saat dicari di server (jika perlu menampilkan nama asli ke pengguna, pisahkan antara kolom nama hash sistem dan kolom nama asli file).
  * Wajib melakukan validasi ekstensi file upload (dan MIME type) sesuai daftar ekstensi yang disepakati di QMS.
- **Otorisasi Akses Konten Data (Poin 4.6.4):** Otorisasi hak akses untuk memvalidasi apakah suatu konten/data dapat diakses atau tidak oleh pengguna wajib disimpan di dalam database dalam bentuk **role**.

## 3. Integritas Data & Validasi (Integrity)
- **Database Foreign Key (Poin 4.2.1):** Aplikasi wajib menggunakan *Foreign Key* apabila melibatkan relasi antara dua tabel atau lebih yang saling berhubungan. Pembuatan Foreign Key wajib dilakukan sejak tahap desain ERD dengan mengikuti standar penamaan `fk_<singkatan_tabel>_<nama_kolom>`.
- **Database Transactions - Commit & Rollback (Poin 4.2.2):** Setiap proses penyimpanan/penulisan database di back end (insert, update, delete) wajib menggunakan sistem **commit dan rollback**:
  * **CodeIgniter:** Gunakan `$this->db->trans_start();`, `$this->db->trans_strict(FALSE);`, lalu periksa `if ($this->db->trans_status() === TRUE) { $this->db->trans_commit(); } else { $this->db->trans_rollback(); }`.
  * **PHP (PDO / Laravel / YII):** PDO `beginTransaction()` / `commit()` / `rollBack()`, Laravel `DB::transaction()`, YII `beginTransaction()`.
  * **Golang / Node.js / Python / Java / .NET:** GORM `db.Transaction()`, `db.Begin()` / `tx.Commit()` / `tx.Rollback()`, Prisma `$transaction()`, Django `transaction.atomic()`, Spring `@Transactional`.
- **Validasi Front End dan Back End (Poin 4.2.3):** Proses validasi jenis data dan kualitas data wajib dilakukan pada dua sisi (Front End dan Back End). **Utamakan validasi di Back End terlebih dahulu**, baru kemudian fokus pada validasi Front End. Hal ini untuk mengantisipasi pengguna yang mematikan JavaScript di browser sehingga validasi Front End dapat ditembus. **Proses QA wajib diskenariokan dengan mematikan JavaScript di browser.**

## 4. Fleksibilitas, Skalabilitas & Performa (Flexibility, Scalability & High Performance)
- **Proses Pemanggilan API (Poin 4.3.1):** Link URL API wajib disimpan di dalam tabel database (misal tabel `api` dengan kolom `no`, `url`, `aplikasi`, `nama_modul`) dan diambil melalui fungsi pembantu (misal `getApi($nama_modul)`) sebelum mengeksekusi request. Dengan demikian, jika terjadi perubahan URL API di kemudian hari, penyesuaian cukup dilakukan di data tabel tanpa mengubah kode aplikasi.
- **Proses Standard Approval (Poin 4.3.2):** Tahapan dan pelaku approval wajib disimpan di dalam tabel database (seperti tabel `approval_action`, `approval_step`, `approval_group`, `transaksional_log`, dan `transaksional_approval`) agar perubahan alur persetujuan cukup dilakukan melalui penyesuaian data tabel.
- **Proses Setting Konfigurasi Aplikasi (Poin 4.3.3):** Aplikasi wajib menyediakan modul konfigurasi sehingga perubahan variabel operasional dalam aplikasi dapat langsung dikerjakan oleh PIC user yang ditunjuk tanpa perlu diubah secara manual oleh tim IT Operation / developer.
- **Paging Tampilan Tabel (Poin 4.4.1):** Apabila data yang ditampilkan di dalam tabel akan terus bertambah, tampilan tabel wajib menggunakan **server-side paging** dan **dilarang menggunakan plugin jQuery DataTables secara client-side**.
- **High Performance (Poin 4.7):** Aplikasi wajib dirancang agar tidak memberikan respon yang lambat, baik dalam proses menampilkan data maupun dalam proses penyimpanan data.

## 5. Standar Penamaan (Naming Conventions)
- **Database (Poin 5.1):** Nama database disesuaikan dengan nama fungsinya atau isi datanya (misal: `naker` untuk tenaga kerja). Apabila ada perubahan struktur tabel dan mengharuskan mengganti/menyalin data database lama ke database baru tanpa mengubah nama tabel, maka penamaan database yang lama diberi akhiran versi seperti `namadbv2`, dst.
- **Tabel (Poin 5.2):** Wajib menggunakan awalan `t_` diikuti nama tabel (contoh: `t_transaksi`, `t_pemakaian`, `t_invoice_online`).
- **View (Poin 5.3):** Wajib menggunakan awalan `v_` diikuti nama view (contoh: `v_rekap_harian`).
- **Foreign Key (Poin 5.4):** Wajib menggunakan awalan `fk_` diikuti singkatan nama tabel dan nama field: `fk_<singkatan_tabel>_<nama_kolom>` (contoh: tabel `t_invoice_online` disingkat `tio`, field `id_invoice_online` -> `fk_tio_id_invoice_online`).
- **Function (Poin 5.5):** Wajib menggunakan awalan `f_` diikuti nama function (contoh: `f_hitung_total`).
- **Stored Procedure (Poin 5.6):** Wajib menggunakan awalan `sp_` diikuti nama stored procedure (contoh: `sp_proses_approval`).
- **Trigger (Poin 5.7):** Wajib menggunakan awalan `tr_` diikuti nama trigger (contoh: `tr_after_insert_pemakaian`).
- **Branch Git & Alur Kerja Git (Poin 5.8):**
  * **Kategori Branch (5.8.1):**
    1. `feature`: Branch di local device untuk mengerjakan modul terkait.
    2. `develop`: Branch alias di server tempat branch `feature` digabungkan sebelum diuji.
    3. `qa` (atau `qa/test`): Branch khusus QA testing, di mana branch ini dilakukan `reset --hard` ke `origin/master` terlebih dahulu sebelum melakukan pull request / merge ke branch `develop` yang akan ditest.
    4. `release`: Branch untuk modul yang telah lulus QA testing dan siap di-deploy.
    5. `master`: Branch utama tempat seluruh source code berjalan secara real-time di server produksi.
    6. `hotfix`: Branch perbaikan bug kecil pada program yang sudah di-deploy, kemudian langsung di-pull request ke `master`.
  * **Format Nama Branch (5.8.2):** Gunakan `/` sebagai pemisah antara kategori, nama modul, dan deskripsi modul (`<kategori>/<nama-modul>/<deskripsi-fitur>`), serta gunakan `-` untuk nama modul atau deskripsi yang terdiri dari lebih dari satu suku kata (contoh: `feature/absen/kehadiran`, `develop/absen/report-atasan`, `develop/absen-alker/harian`).
  * **3 Tahap Alur Kerja Git (Git Workflow):**
    1. *Development Local:* Clone repo -> buat branch personal (`feature/...`) dari `master` -> buat branch `develop` dari `master` (saat pertama kali clone) -> kerjakan kode di branch personal.
    2. *Development QA Environment:* Push branch personal ke server -> checkout ke `develop` di lokal -> pull `develop` dari repo -> merge branch personal ke `develop` lokal -> push `develop` ke server untuk diuji QA.
    3. *Deploy to Production:* Setelah lolos QA, checkout kembali ke branch personal -> push ke repo -> buat Pull Request (PR) dari branch personal ke `master` -> merge ke `master`.

## 6. Standar Komentar (Standard Commenting)
Setiap fungsi atau prosedur kode wajib memiliki blok komentar tepat di atas deklarasinya yang menjelaskan 3 aspek wajib (Poin 6.1 & 6.2):
1. **Fungsi:** Kode ini berfungsi untuk apa?
2. **Cara Kerja:** Bagaimana kode ini secara singkat melakukan fungsinya?
3. **Cara Penggunaan:** Bagaimana cara menggunakan/memanggil kode tersebut beserta parameternya?

*Format komentar menyesuaikan standar bahasa target (DocBlock `/** ... */` untuk PHP/JS/TS/Java, Docstrings `""" ... """` untuk Python, komentar baris `//` untuk Go, XML Doc `///` untuk C#).*

## 7. Antarmuka Pengguna (UX Friendly / UI Guidelines)
- **Multiplatform & Mobile Friendly (Poin 4.5.1 & 4.5.2):** Template wajib kompatibel lintas browser (Chrome, Mozilla Firefox, Safari, Opera, Edge/IE) serta responsif (*mobile friendly*) di tablet dan smartphone.
- **Posisi Menu & Logo (Poin 4.5.3 & 4.5.4):**
  * **Web Desktop:** Sidebar sebelah kiri.
  * **Mobile Web:** Pojok kanan atas.
  * **Mobile Apps:** Pojok kiri atas.
  * **Logo:** Wajib berada di posisi kiri atas.
- **Bahasa & Tipografi (Poin 4.5.5):** Penggunaan bahasa wajib seragam 100% (Bahasa Indonesia semua atau Bahasa Inggris semua). Wajib menjaga konsistensi penamaan **Label (Form, Button, Menu)**, **Placeholder**, serta **kalimat notifikasi dan error message** (gunakan indikator *inline error* yang rapi pada field terkait).
- **Hierarki Elemen, Tombol, & Tata Letak Form (Poin 4.5.6.1 - 4.5.6.4):**
  * **Warna Button (4.5.6.1):** Tombol **Submit** wajib berwarna **Biru**, tombol **Cancel** menggunakan warna **lebih pudar** dari tombol lain (putih/abu-abu), dan tombol **Delete** wajib berwarna **Merah**.
  * **Icon Button (4.5.6.2):** Penyeragaman penggunaan ikon yang familiar dan mudah dipahami pada label form atau tombol aksi (misal: tombol Edit dengan ikon pena, tombol Delete dengan ikon tempat sampah).
  * **Posisi Elemen & Form Vertikal (4.5.6.3):** Tombol *primary* (Submit) diletakkan lebih menonjol dan mudah ditemukan dibanding tombol *secondary* (Cancel). **Form dengan banyak field wajib disusun secara vertikal (satu kolom ke bawah)**, dilarang menyusun menyamping multi-kolom horizontal.
  * **Pengelompokan Informasi (4.5.6.4):** Informasi yang ditampilkan (input field, table field, dll.) wajib dikelompokkan sesuai dengan kategorinya (misal: kelompok *Personal*, *Account*, *Contact*).
- **Matriks Standar Kombinasi Warna Foreground vs Background (Poin 4.5.6.5):**
  Kombinasi warna antara teks (*Foreground*) dan latar belakang (*Background*) wajib menggunakan pasangan yang berstatus **Good** (kontras & mudah dilihat) dan menghindari pasangan **Poor**:
  * **Foreground Red:** *Good* pada background Yellow, Black, White (*Poor* pada Orange, Green, Blue, Violet, Gray).
  * **Foreground Orange:** *Good* pada background Black (*Poor* pada Red, Yellow, Green, Blue, Violet, White, Gray).
  * **Foreground Yellow:** *Good* pada background Red, Orange, Blue, Black, Gray (*Poor* pada Green, Violet, White).
  * **Foreground Green:** *Good* pada background Blue, Black, Gray (*Poor* pada Red, Orange, Yellow, Violet, White).
  * **Foreground Blue:** *Good* pada background Yellow, Green, White (*Poor* pada Red, Orange, Violet, Black, Gray).
  * **Foreground Violet:** *Good* pada background Yellow, Black, White (*Poor* pada Red, Orange, Green, Blue, Gray).
  * **Foreground Black:** *Good* pada background Orange, Yellow, Green, Violet, White (*Poor* pada Red, Blue, Gray).
  * **Foreground White:** *Good* pada background Red, Orange, Yellow, Blue, Violet, Black, Gray (*Poor* pada Green).
  * **Foreground Gray:** *Good* pada background Yellow, Green, White (*Poor* pada Red, Orange, Blue, Violet, Black).
