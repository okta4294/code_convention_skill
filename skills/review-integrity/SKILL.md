---
name: review-integrity
description: Melakukan audit terhadap integritas data, ketahanan proses transaksi basis data (commit/rollback), relasi Foreign Key, serta keandalan validasi di sisi server. Trigger dengan /review-integrity.
---

# Command: /review-integrity

## Deskripsi
Melakukan audit terhadap integritas data, ketahanan proses transaksi basis data, serta keandalan validasi data di sisi server.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Fokus pada pencegahan data korup (inconsistent data) dan bypass validasi front-end.

## Aturan Kepatuhan Khusus
1. Database Transactions (Commit & Rollback):
   - Setiap operasi penulisan basis data di back end (insert, update, delete) wajib dibungkus blok transaksi.
   - Menggunakan mekanisme `trans_start()`, `trans_commit()`, dan `trans_rollback()` (atau blok `beginTransaction`, `commit`, `rollBack` pada PDO).
2. Relasi Tabel & Foreign Key:
   - Relasi antar tabel yang berhubungan wajib menggunakan Foreign Key sejak pembuatan skema/ERD.
   - Penamaan constraint Foreign Key harus mematuhi konvensi (`fk_<singkatan_tabel>_<nama_kolom>`).
3. Dual-Layer Validation:
   - Validasi data WAJIB diterapkan pada Back End terlebih dahulu.
   - Validasi Front End hanya bertindak sebagai pelengkap.
   - Logika aplikasi tidak boleh bergantung pada JavaScript client karena dapat dimatikan oleh pengguna pada browser.

## Format Output Wajib
### 📋 Ringkasan Audit Kepatuhan: Integritas & Transaksi
- Status: [Integritas Terjaga / Celah Transaksi Ditemukan]
- Komponen: [Fungsi Controller / Model / Skema Migration]

---

### 🔍 Temuan Masalah Integritas
[Identifikasi ketiadaan rollback saat error, ketiadaan foreign key, atau validasi yang hanya ada di script front-end]

---

### 🛠️ Implementation Plan
1. Langkah 1: [Bungkus logika penyimpanan dalam database transaction]
2. Langkah 2: [Tambahkan validasi server-side menyeluruh]
3. Langkah 3: [Definisikan relasi Foreign Key pada skema tabel terkait]

---

### 💻 Usulan Perubahan Kode (Proposed Code)
// Sebelum:
...

// Sesudah (Dengan Transaksi & Validasi Back End):
...

---

### ⚠️ Catatan Review untuk Developer
[Dampak pada foreign key check, isolasi transaksi, dan penanganan exception/error log]
