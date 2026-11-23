---
name: check-db-naming
description: Use when checking database object naming (/check-db-naming) for t_, v_, fk_, f_, sp_, tr_. Do NOT use for SQL security.
metadata:
  author: okta4294
  tags:
    - database
    - naming-convention
    - sql
    - code-convention
---

# Command: /check-db-naming

## Purpose
Memeriksa kepatuhan penamaan objek basis data (tabel, view, foreign key, function, procedure, trigger, dan nama database) terhadap standar konvensi enterprise.

## Prerequisites
- Pengguna menyediakan skrip DDL, file migrasi, ERD, atau daftar nama objek basis data yang akan diperiksa.
- Tidak memerlukan koneksi database aktif, API key, atau kredensial.

## Instructions

### Mode Operasional
- ADVISORY ONLY (Read-Only).
- Validasi skema DDL atau query pembuatan objek database tanpa mengeksekusi perubahan ke database secara langsung.

### Aturan Standar Penamaan Objek Basis Data
- Database: Sesuai nama fungsi atau representasi data (contoh: `naker`). Jika ada migrasi struktur lama ke baru tanpa ubah nama tabel, database lama diberi akhiran `v2`, `v3`, dst. (contoh: `namadbv2`).
- Tabel: Wajib menggunakan awalan `t_` (contoh: `t_transaksi`, `t_pemakaian`).
- View: Wajib menggunakan awalan `v_` (contoh: `v_rekap_harian`).
- Foreign Key: Wajib menggunakan awalan `fk_` diikuti singkatan tabel asal dan nama kolom (format: `fk_<singkatan_tabel>_<nama_kolom>`).
  * Contoh: Tabel `t_invoice_online` (singkatan `tio`), kolom `id_invoice_online` -> `fk_tio_id_invoice_online`.
- Function: Wajib menggunakan awalan `f_` (contoh: `f_hitung_total`).
- Stored Procedure: Wajib menggunakan awalan `sp_` (contoh: `sp_proses_approval`).
- Trigger: Wajib menggunakan awalan `tr_` (contoh: `tr_after_insert_pemakaian`).

### Format Output Wajib
#### Ringkasan Validasi Penamaan Basis Data
- Status: [Valid / Penamaan Tidak Sesuai]
- Objek yang Diperiksa: [Tabel / View / FK / Routine]

---

#### Rincian Pelanggaran Konvensi
| Nama Objek Saat Ini | Tipe Objek | Seharusnya (Standar) | Keterangan |
| :--- | :--- | :--- | :--- |
| ... | ... | ... | ... |

---

#### Implementation Plan
1. Langkah 1: Siapkan skrip alter / rename objek.
2. Langkah 2: Sesuaikan pemanggilan nama objek pada kode aplikasi atau ORM model.

---

#### Usulan Perubahan Skrip DDL / Migration (Proposed Code)
```sql
-- Rekomendasi DDL / Query Penyesuaian
```

---

#### Catatan Review untuk Developer
[Dampak perubahan nama tabel/kolom/constraint terhadap query aplikasi, model ORM, serta pencadangan database sebelum migrasi]

## Examples

### Pemeriksaan Skrip DDL Tabel dan Foreign Key
Input pengguna:
```sql
CREATE TABLE invoice_detail (
  id INT PRIMARY KEY,
  id_invoice_online INT,
  CONSTRAINT invoice_fk FOREIGN KEY (id_invoice_online) REFERENCES t_invoice_online(id_invoice_online)
);
```

Usulan perbaikan sesuai konvensi:
```sql
CREATE TABLE t_invoice_detail (
  id INT PRIMARY KEY,
  id_invoice_online INT,
  CONSTRAINT fk_tid_id_invoice_online FOREIGN KEY (id_invoice_online) REFERENCES t_invoice_online(id_invoice_online)
);
```

## Limitations
- Bersifat Read-Only (Advisory Only) dan tidak menjalankan skrip DDL/migrasi ke server database.
- Tidak memvalidasi performa indeks, keamanan query SQL Injection, atau transaksi commit/rollback (gunakan `/review-security` atau `/review-integrity`).

## Troubleshooting
- **Error:** Singkatan nama tabel untuk Foreign Key ambigu atau bentrok.
  - **Cause:** Dua tabel berbeda memiliki inisial kata yang sama.
  - **Solution:** Gunakan singkatan tabel yang unik dan konsisten dengan konvensi ERD proyek, lalu catat pada bagian Catatan Review untuk Developer.
- **Error:** Input pengguna tidak menyertakan tipe objek (misal hanya nama `rekap_harian`).
  - **Cause:** Tidak jelas apakah objek tersebut tabel (`t_`) atau view (`v_`).
  - **Solution:** Konfirmasi tipe objek ke pengguna sebelum menyusun skrip rename akhir.
