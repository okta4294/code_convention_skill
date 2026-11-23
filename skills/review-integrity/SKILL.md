---
name: review-integrity
description: Use when auditing data integrity, OOP/DRY, transactions, and Foreign Keys (/review-integrity). Do NOT use for UI or XSS.
metadata:
  author: okta4294
  tags:
    - data-integrity
    - database-transactions
    - oop-dry
    - code-convention
---

# Command: /review-integrity

## Purpose
Melakukan audit terhadap integritas data (Poin 4.2), konsep pemrograman OOP & DRY (Poin 2.1 & 2.2), serta fleksibilitas konfigurasi database (Poin 4.3).

## Prerequisites
- Pengguna menyediakan kode controller, model, service, atau skema migrasi database yang akan diperiksa.
- Tidak memerlukan koneksi database aktif atau API key.

## Instructions

### Mode Operasional
- ADVISORY ONLY (Read-Only).
- Fokus pada pencegahan data korup (inconsistent data), duplikasi logika kode, dan bypass validasi front-end tanpa mengubah file secara langsung.

### Aturan Kepatuhan Khusus
1. Database Foreign Key (Poin 4.2.1):
   - Aplikasi wajib menggunakan Foreign Key apabila melibatkan relasi antara dua tabel yang saling berhubungan.
   - Pembuatan Foreign Key wajib dilakukan sejak desain ERD dengan standar penamaan `fk_<singkatan_tabel>_<nama_kolom>` (contoh: `fk_tio_id_invoice_online`).
2. Database Transactions - Commit & Rollback (Poin 4.2.2):
   - Setiap proses penyimpanan database di back end (insert, update, delete) wajib menggunakan sistem **commit dan rollback**.
   - Contoh standar implementasi:
     * **CodeIgniter:**
       ```php
       $this->db->trans_start();
       $this->db->trans_strict(FALSE);
       // ... operasi insert / update / delete ...
       if ($this->db->trans_status() === TRUE) {
           $this->db->trans_commit();
       } else {
           $this->db->trans_rollback();
       }
       ```
     * **PHP (PDO / Laravel / YII):** PDO `beginTransaction()` / `commit()` / `rollBack()`, Laravel `DB::transaction()`, YII `beginTransaction()`.
     * **Golang (GORM) & Stack Lain:** GORM `db.Transaction()`, `db.Begin()` / `tx.Commit()` / `tx.Rollback()`, Prisma `$transaction()`, Django `transaction.atomic()`, Spring `@Transactional`.
3. Validasi Front End dan Back End (Poin 4.2.3):
   - Proses validasi jenis data dan kualitas data wajib dilakukan pada dua sisi (Front End dan Back End).
   - **Utamakan validasi dilakukan di Back End terlebih dahulu**, baru kemudian fokus pada validasi Front End.
   - Hal ini wajib diterapkan karena pengguna sering mematikan JavaScript di browser sehingga validasi Front End saja dapat ditembus. **Proses pengujian QA wajib diskenariokan dengan mematikan JavaScript.**
4. Konsep OOP & DRY - Don't Repeat Yourself (Poin 2.1 & 2.2):
   - Gunakan Object Oriented Programming (OOP) untuk kejelasan struktur objek sistem.
   - Proses yang digunakan lebih dari satu kali wajib dibuatkan fungsi dan prosedur yang dideklarasikan secara `public`, kemudian class pemanggil dinyatakan sebagai perpanjangan (`extends`) dari class yang menjalankan proses tersebut.
5. Fleksibilitas Konfigurasi Database (Poin 4.3.1 - 4.3.3):
   - **Pemanggilan API (4.3.1):** Link URL API wajib disimpan di dalam tabel database (misal kolom `no`, `url`, `aplikasi`, `nama_modul`) dan diambil terlebih dahulu dari database (misal via fungsi `getApi($nama_modul)`) agar perubahan URL tidak memerlukan perubahan kode aplikasi.
   - **Standard Approval (4.3.2):** Tahapan dan pelaku approval wajib disimpan di dalam tabel database (`approval_action`, `approval_step`, `approval_group`, `transaksional_log`, `transaksional_approval`).
   - **Setting Konfigurasi Aplikasi (4.3.3):** Sediakan modul konfigurasi aplikasi agar perubahan variabel operasional dapat langsung dikerjakan oleh PIC user tanpa perlu intervensi kode oleh tim IT.

### Format Output Wajib
#### Ringkasan Audit Kepatuhan: Integritas & Arsitektur
- Status: [Integritas Terjaga / Celah Transaksi & Validasi Ditemukan]
- Komponen: [Fungsi Controller / Model / Skema Migration]

---

#### Temuan Masalah Integritas
[Identifikasi ketiadaan commit/rollback, ketiadaan foreign key, validasi yang hanya di front-end, duplikasi kode (pelanggaran DRY), atau URL API/approval yang di-hardcode]

---

#### Implementation Plan
1. Langkah 1: [Bungkus logika penyimpanan dalam database transaction commit & rollback]
2. Langkah 2: [Tambahkan validasi Back End menyeluruh (tahan uji saat JavaScript dimatikan)]
3. Langkah 3: [Definisikan Foreign Key / ekstrak fungsi public OOP (DRY) / pindahkan URL API & approval ke tabel]

---

#### Usulan Perubahan Kode (Proposed Code)
```php
// Sebelum:
// Sesudah (Dengan Transaksi, Validasi Back End, & Standar Konvensi):
```

---

#### Catatan Review untuk Developer
[Skenario pengujian QA dengan mematikan JavaScript di browser, pengecekan isolasi transaksi, dan relasi Foreign Key]

## Examples

### Membungkus Proses Simpan dengan Transaksi & Validasi Back End
Input pengguna:
```php
public function updateStok($id, $qty) {
    $this->db->update('t_stok', ['qty' => $qty], ['id' => $id]);
    $this->db->insert('t_log_stok', ['stok_id' => $id, 'qty' => $qty]);
}
```

Usulan perbaikan sesuai konvensi:
```php
public function updateStok($id, $qty) {
    if (!is_numeric($id) || !is_numeric($qty) || $qty < 0) {
        return false;
    }
    $this->db->trans_start();
    $this->db->trans_strict(FALSE);
    $this->db->update('t_stok', ['qty' => (int)$qty], ['id' => (int)$id]);
    $this->db->insert('t_log_stok', ['stok_id' => (int)$id, 'qty' => (int)$qty]);
    if ($this->db->trans_status() === TRUE) {
        $this->db->trans_commit();
        return true;
    }
    $this->db->trans_rollback();
    return false;
}
```

## Limitations
- Bersifat Read-Only (Advisory Only) dan tidak mengeksekusi perubahan kode maupun migrasi database.
- Tidak mencakup audit keamanan SQL Injection/XSS secara mendalam (gunakan `/review-security`) atau audit tampilan UI (gunakan `/check-ui`).

## Troubleshooting
- **Error:** Engine tabel database tidak mendukung transaksi atau Foreign Key (misal MyISAM).
  - **Cause:** Tabel lama belum menggunakan storage engine transaksional seperti InnoDB.
  - **Solution:** Catat prasyarat migrasi engine ke InnoDB pada bagian Catatan Review sebelum menerapkan transaksi dan Foreign Key.
- **Error:** Validasi Front End tidak terlihat di file backend yang dikirim.
  - **Cause:** Pengguna hanya melampirkan kode controller/model tanpa file view.
  - **Solution:** Audit validasi Back End terlebih dahulu sebagai prioritas utama, lalu ingatkan developer untuk menyinkronkan validasi Front End dan menguji skenario QA non-JS.
