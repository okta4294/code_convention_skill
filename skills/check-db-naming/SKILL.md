---
name: check-db-naming
description: Memeriksa kepatuhan penamaan objek basis data (awalan t_, v_, fk_, f_, sp_, tr_, dan nama database) terhadap standar konvensi enterprise. Trigger dengan /check-db-naming.
---

# Command: /check-db-naming

## Deskripsi
Memeriksa kepatuhan penamaan objek basis data (tabel, view, foreign key, function, procedure, trigger, dan nama database) terhadap standar konvensi.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Validasi skema DDL atau query pembuatan objek database.

## Aturan Standar Penamaan Objek Basis Data
- Database: Sesuai nama fungsi atau representasi data (contoh: `naker`). Jika ada migrasi struktur lama ke baru tanpa ubah nama tabel, database lama diberi akhiran `v2`, `v3`, dst. (contoh: `namadbv2`).
- Tabel: Wajib menggunakan awalan `t_` (contoh: `t_transaksi`, `t_pemakaian`).
- View: Wajib menggunakan awalan `v_` (contoh: `v_rekap_harian`).
- Foreign Key: Wajib menggunakan awalan `fk_` diikuti singkatan tabel asal dan nama kolom (format: `fk_<singkatan_tabel>_<nama_kolom>`).
  * Contoh: Tabel `t_invoice_online` (singkatan `tio`), kolom `id_invoice_online` -> `fk_tio_id_invoice_online`.
- Function: Wajib menggunakan awalan `f_` (contoh: `f_hitung_total`).
- Stored Procedure: Wajib menggunakan awalan `sp_` (contoh: `sp_proses_approval`).
- Trigger: Wajib menggunakan awalan `tr_` (contoh: `tr_after_insert_pemakaian`).

## Format Output Wajib
### 📋 Ringkasan Validasi Penamaan Basis Data
- Status: [Valid / Penamaan Tidak Sesuai]
- Objek yang Diperiksa: [Tabel / View / FK / Routine]

---

### 🔍 Rincian Pelanggaran Konvensi
| Nama Objek Saat Ini | Tipe Objek | Seharusnya (Standar) | Keterangan |
| :--- | :--- | :--- | :--- |
| ... | ... | ... | ... |

---

### 🛠️ Implementation Plan
1. Langkah 1: Siapkan skrip alter / rename objek.
2. Langkah 2: Sesuaikan pemanggilan nama objek pada kode aplikasi atau ORM model.

---

### 💻 Usulan Perubahan Skrip DDL / Migration (Proposed Code)
-- Rekomendasi DDL / Query Penyesuaian
...
