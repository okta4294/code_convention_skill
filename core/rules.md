# Aturan Konvensi Rekayasa Perangkat Lunak (Corporate Engineering Rules)

## 1. Pemrograman Aman (Security)
- **SQL Injection Prevention:** Dilarang merangkai variabel mentah ke dalam string query SQL. Wajib mengutamakan Parameterized Query / Prepared Statements (contoh: PDO/MySQLi pada PHP, query berparameter pada Node.js/pg/Prisma, SQLAlchemy/Django ORM pada Python, PreparedStatement pada Java, atau Query Builder resmi framework).
  * **Mitigasi Alternatif (Jika Arsitektur Belum Memungkinkan Prepared Statements):** Jika aplikasi legasi belum memungkinkan penggunaan prepared statements, AI wajib menyarankan mitigasi alternatif:
    1. **Fungsi Pelolosan Karakter (Escaping):** Gunakan fungsi escaping bawaan driver basis data aktif (misal `mysqli_real_escape_string`, driver-specific escaping) atau utilitas sanitasi karakter bahasa terkait.
    2. **Strict Type Casting:** Paksa parameter numerik menjadi bilangan bulat/desimal secara eksplisit (misal `(int)$id` di PHP, `Number.parseInt()` di JS/TS, `int()` di Python) agar payload injeksi karakter kutip tereliminasi.
    3. **Whitelist Validation:** Untuk input dinamis yang tidak dapat di-parameterize (seperti nama kolom sorting, klausa `ORDER BY`, arah `ASC`/`DESC`), validasi ketat menggunakan daftar nilai putih (*whitelist*) sebelum query dieksekusi.
    4. **Validasi Format (Filter / Regex):** Validasi format data menggunakan fungsi validator atau regular expression ketat sebelum disisipkan ke dalam query.
    5. **Protokol Konfirmasi:** AI wajib menanyakan konfirmasi kepada developer apakah ingin menerapkan mitigasi sanitasi alternatif tersebut atau melakukan migrasi bertahap ke prepared statements.
- **Sanitasi Parameter Input ke Tampilan (XSS Prevention):** Setiap parameter input pengguna (misal parameter query URL seperti `$_GET` pada PHP, `req.query` pada Express/Node.js, `request.GET` pada Django, query params pada Spring/ASP.NET) yang dicetak langsung ke antarmuka/HTML wajib disanitasi menggunakan fungsi encoding/escaping HTML kontekstual (misal `htmlentities()` / `htmlspecialchars()` pada PHP, atau mekanisme sanitasi/auto-escaping bawaan template engine).
- **Download Berkas Terproteksi:** Dilarang memberikan path berkas langsung atau parameter nama file di URL (misal: `?file=laporan.pdf`). Wajib menggunakan verifikasi ID dokumen (misal: `?id=1` atau `/download/1`) disertai pengecekan otentikasi dan otorisasi akses pengguna sebelum berkas dialirkan (*stream*).
- **Upload Berkas:** Nama berkas wajib diubah (*rename*) menggunakan mekanisme hashing unik (misal UUID atau hash acak) dan wajib melakukan validasi whitelist ekstensi serta MIME type berkas yang diizinkan.
- **Otorisasi Berbasis Peran:** Hak akses modul dan manipulasi data wajib divalidasi terhadap peran (*role*) pengguna yang terdaftar di basis data.

## 2. Integritas Data & Validasi (Integrity)
- **Database Transactions (Commit & Rollback):** Setiap operasi penulisan basis data di back end (insert, update, delete) yang melibatkan multi-tabel atau keutuhan data wajib dibungkus blok transaksi database dengan mekanisme rollback saat error. Contoh penerapan:
  * PHP: PDO `beginTransaction()` / `commit()` / `rollBack()`, CodeIgniter `trans_start()` / `trans_complete()`, Laravel `DB::transaction()`.
  * Node.js / TypeScript: Prisma `$transaction()`, Knex `transaction()`, TypeORM `QueryRunner`, transaksi driver `pg` / `mysql2`.
  * Python: Django `transaction.atomic()`, SQLAlchemy session transactions.
  * Java: Spring `@Transactional`, JDBC `setAutoCommit(false)` / `commit()` / `rollback()`.
  * Go / C# .NET: Blok `db.Begin()` / `tx.Commit()` / `tx.Rollback()`, Entity Framework `Database.BeginTransaction()`.
- **Relasi Tabel & Foreign Key:** Relasi antar tabel yang berhubungan wajib menggunakan Foreign Key sejak pembuatan skema/ERD. Penamaan constraint: `fk_<singkatan_tabel>_<nama_kolom>`.
- **Dual-Layer Validation:** Validasi data WAJIB diterapkan pada Back End terlebih dahulu sebagai pertahanan utama. Validasi Front End hanya bertindak sebagai pelengkap kenyamanan pengguna (UX).

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

*Format komentar menyesuaikan standar bahasa target (DocBlock `/** ... */` untuk PHP/JS/TS/Java, Docstrings `""" ... """` untuk Python, komentar baris `//` untuk Go, XML Doc `///` untuk C#).*

## 6. Antarmuka Pengguna (UI/UX)
- **Tata Letak Form:** Form dengan banyak field wajib disusun secara vertikal (satu kolom ke bawah).
- **Hierarki & Pewarnaan Tombol:** Submit = Biru (Primary), Delete = Merah (Danger), Cancel = Netral/Pudar/Abu-abu (Secondary).
- **Navigasi & Logo:** Desktop di sidebar kiri, mobile web di kanan atas, mobile app di kiri atas. Logo di pojok kiri atas.
- **Konsistensi Bahasa:** 100% seragam satu bahasa (Bahasa Indonesia seluruhnya atau Bahasa Inggris seluruhnya).
