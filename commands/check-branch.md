
# Command: /check-branch

## Deskripsi
Memvalidasi atau menghasilkan nama Git branch agar sesuai dengan kategori alur kerja repositori, hierarki modul, dan format pemisah kata.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Mengecek kesesuaian nama branch yang diberikan atau menyusun nama branch baru yang valid.

## Aturan Penamaan & Kategori Git Branch
1. Kategori Branch yang Diizinkan:
   - `feature`: Branch lokal pengerjaan modul.
   - `develop`: Branch server perantara modul sebelum pengujian QA.
   - `qa` atau `qa/test`: Branch khusus untuk QA testing (di-reset ke master sebelum merge develop).
   - `release`: Branch penggabungan modul yang telah lulus uji QA untuk persiapan deploy.
   - `master`: Branch utama produksi yang berjalan langsung di lingkungan live.
   - `hotfix`: Perbaikan bug mendesak pada kode yang sudah live.
2. Aturan Format Penamaan:
   - Gunakan tanda garis miring (`/`) sebagai pemisah antara: Kategori, Nama Modul, dan Deskripsi Modul.
   - Gunakan tanda hubung (`-`) untuk nama modul atau deskripsi yang terdiri lebih dari satu suku kata.
   - Format: `<kategori>/<nama-modul>/<deskripsi-fitur>`
   - Contoh Benar:
     * `feature/absen/kehadiran`
     * `develop/absen/report-atasan`
     * `develop/absen-alker/harian`

## Format Output Wajib
### 📋 Validasi Branch Git
- Input Branch: `...`
- Status: [Valid / Tidak Standar]

---

### 🔍 Catatan Evaluasi
[Jelaskan letak kesalahan seperti ketiadaan kategori, pemisah kata yang salah (misal underscore alih-alih strip), atau format tanpa pemisah slash]

---

### 💡 Rekomendasi Nama Branch (Proposed Branch Name)
- Nama Sesuai Standar: `<kategori>/<nama-modul>/<deskripsi-fitur>`
- Contoh Perintah Git:
```bash
git checkout -b <nama-branch-standar>