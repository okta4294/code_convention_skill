# Command: /review-security

## Deskripsi
Melakukan audit khusus keamanan aplikasi (Secured Programming - Poin 4.6) untuk mendeteksi kerentanan SQL Injection dan karakter unik parsing data, XSS pada parsing parameter GET, eksposur path pada download berkas, celah upload berkas, serta otorisasi akses konten berbasis role.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Berikan saran perbaikan kode yang mengutamakan keamanan dan sanitasi input/output dalam format Implementation Plan.

## Aturan Kepatuhan Khusus
1. Antisipasi Karakter Unik Parsing Data & Pencegahan SQL Injection (Poin 4.6.3):
   - Dilarang merangkai variabel mentah langsung ke dalam string query SQL (terutama pada pemanggilan API atau input yang mengandung karakter unik seperti tanda petik `'` yang merusak sintaks query dan membuka celah SQL Injection).
   - Wajib mengutamakan **Parameterized Query / Prepared Statements**:
     * **Native PHP (MySQLi Object-Oriented):** `$stmt = $mysqli->prepare("SELECT ... WHERE Name=?"); $stmt->bind_param("s", $val); $stmt->execute();`
     * **Native PHP (MySQLi Procedural):** `$stmt = mysqli_prepare($link, "SELECT ... WHERE Name=?"); mysqli_stmt_bind_param($stmt, "s", $val); mysqli_stmt_execute($stmt);`
     * **Native PHP (PDO):** Gunakan named parameter (`WHERE col = :col` dengan `$sth->execute([':col' => $val])`) atau question mark (`WHERE col = ?` dengan `$sth->execute([$val])`).
     * **Framework (YII, CodeIgniter, Laravel, Golang GORM, dll.):** Ikuti *best practice* Query Builder / ORM bawaan framework (atau parameter binding jika terpaksa memakai raw query).
   - **Mitigasi Alternatif untuk Kode Legasi:**
     Apabila aplikasi legasi belum memungkinkan prepared statements, AI wajib menyarankan strategi pengamanan alternatif:
     * **Fungsi Pelolosan Karakter (Escaping):** Berikan fungsi `mysqli_real_escape_string()` / `mysql_real_escape_string()` (untuk driver MySQL) atau `addslashes()` pada setiap parsing data.
     * **Strict Type Casting:** Paksa parameter numerik menjadi bilangan bulat/desimal secara eksplisit (misal `(int)$id` di PHP).
     * **Whitelist Validation & Regex Filter:** Validasi ketat dengan daftar nilai putih (*whitelist*) untuk klausa dinamis (seperti `ORDER BY`) dan filter format input.
     * **Protokol Konfirmasi:** AI wajib menanyakan apakah developer ingin menerapkan sanitasi alternatif tersebut atau melakukan migrasi bertahap ke prepared statements.
2. Filtering Parsing Data ke Tampilan / XSS Prevention (Poin 4.6.2):
   - Setiap variabel dari parsing data GET yang ditampilkan menjadi label/HTML wajib difilter menggunakan fungsi `htmlentities()` (contoh benar: `<h1><?php echo htmlentities($_GET['title']); ?></h1>`, atau auto-escaping template engine).
   - Dilarang langsung melakukan print variabel GET (`<?php echo $_GET['title']; ?>`) karena peretas dapat menyisipkan skrip JavaScript (`<script>...</script>`) yang berjalan bersamaan dengan program.
3. Metode Download Berkas Terproteksi (Poin 4.6.1):
   - **Yang Harus Dilakukan:** Berikan link download menggunakan **ID dari dokumen** yang disimpan (contoh: `http://www.site.com/report/download.php?id=1` atau `http://www.site.com/report/download/1`) serta wajib melakukan pengecekan **autentikasi dan otorisasi akses** terhadap user yang melakukan download file.
   - **Yang Dilarang Dilakukan:** Dilarang menggunakan parameter GET yang menunjuk nama atau path file secara langsung (contoh salah: `http://www.site.com/product.php?file=sales_report.pdf` atau `http://www.site.com/product/file/download/sales_report.pdf`) karena berpotensi membuka celah akses ke index file hingga koneksi database.
   - **Pola Implementasi ID Download:**
     * *Berbasis Tabel Database:* Gunakan *Primary Key* dari tabel terkait (misal `id` pada tabel transaksi/dokumen) sebagai parameter `?id=123`, cek hak akses user, ambil nama file hash dari kolom tabel di database, lalu baca dan alirkan (*force download*) file fisik dari folder storage tertutup.
     * *Alternatif Tanpa Tabel Baru (File Statis):* Dapat menggunakan mapping array di kode (`[1 => 'file.pdf']`), menggunakan nama hash unik langsung sebagai parameter ID, atau token terenkripsi (seperti JWT), dengan syarat **tetap wajib menjalankan pengecekan autentikasi dan otorisasi hak akses pengguna** sebelum file dikirimkan.
4. Penamaan dan Ekstensi Upload Berkas (Poin 4.6.5):
   - Saat proses upload, penamaan file wajib melalui proses **rename menggunakan hashing** sehingga menghasilkan nama file yang unik (*unique name*).
   - Nama file yang disimpan di dalam kolom database **wajib menggunakan nama hasil hash tersebut** agar aplikasi dapat menemukan file fisik saat proses download (jika perlu menampilkan nama asli file di layar kepada pengguna, sediakan dua kolom berbeda: satu kolom untuk nama hash sistem dan satu kolom untuk teks nama asli file).
   - Wajib terdapat validasi ekstensi file upload (dan MIME type) sesuai daftar ekstensi yang telah disepakati di QMS.
5. Otorisasi Akses Konten Data (Poin 4.6.4):
   - Otorisasi akses konten data wajib divalidasi untuk memastikan apakah sebuah konten berhak diakses oleh pengguna atau tidak, dengan aturan otorisasi hak akses disimpan di dalam database dalam bentuk **role**.

## Format Output Wajib
### 📋 Ringkasan Audit Kepatuhan: Keamanan
- Status: [Aman / Celah Keamanan Terdeteksi]
- Tingkat Risiko: [Kritis / Sedang / Rendah]
- Titik Kerentanan: [Nama File, Baris Kode, atau Parameter]

---

### 🔍 Analisis Kerentanan
[Jelaskan potensi eksploitasi peretas, seperti SQL Injection akibat karakter petik, eksekusi skrip XSS, atau eksposur direktori file]

---

### 🛠️ Implementation Plan
1. Langkah 1: [Sanitasi input / perbaikan prepared statement / penyesuaian route download berbasis ID]
2. Langkah 2: [Penerapan hashing nama file upload di server & DB, validasi ekstensi, dan cek otorisasi role]

---

### 💻 Usulan Perubahan Kode (Proposed Code)
// Sebelum (Rentan):
...

// Sesudah (Aman Sesuai Standar):
...

---

### ⚠️ Catatan Review untuk Developer
[Pengujian payload karakter unik ('), sinkronisasi kolom nama file hash di database, dan pengecekan session/role otorisasi]