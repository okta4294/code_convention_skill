---
name: check-branch
description: Use when validating Git branch names or Git workflow (/check-branch). Do NOT use for code review or database naming.
metadata:
  author: okta4294
  tags:
    - git
    - branch-naming
    - workflow
    - code-convention
---

# Command: /check-branch

## Purpose
Memvalidasi atau menghasilkan nama Git branch agar sesuai dengan kategori alur kerja repositori, hierarki modul, format pemisah kata (Poin 5.8), serta memberikan panduan alur kerja Git 3 tahap (Local, QA, Production).

## Prerequisites
- Pengguna menyediakan nama branch yang ingin diperiksa atau deskripsi fitur/modul untuk membuat nama branch baru.
- Tidak memerlukan API key, kredensial, atau akses eksekusi perintah Git langsung.

## Instructions

### Mode Operasional
- ADVISORY ONLY (Read-Only).
- Mengecek kesesuaian nama branch yang diberikan, menyusun nama branch baru yang valid, dan menjelaskan urutan alur perintah Git sesuai tahapannya.

### Aturan Penamaan & Kategori Git Branch (Poin 5.8.1 & 5.8.2)
1. Kategori Branch yang Diizinkan (5.8.1):
   - `feature`: Branch yang hanya terdapat di local device untuk mengerjakan modul tersebut.
   - `develop`: Ketika branch `feature` di-push ke server, dibuatkan branch alias/perantaranya terlebih dahulu, yaitu `develop`.
   - `qa` (atau `qa/test`): Branch khusus untuk QA testing, di mana branch ini dilakukan `reset --hard` ke `origin/master` terlebih dahulu sebelum melakukan pull request / merge ke branch `develop` yang akan ditest.
   - `release`: Modul yang telah lulus QA testing dibuatkan branch baru atau di-merge ke satu branch `release` yang nantinya akan di-deploy.
   - `master`: Branch utama tempat seluruh source code sedang berjalan secara real-time di server produksi.
   - `hotfix`: Ketika terdapat bug kecil pada program yang sudah di-deploy, perbaikannya dilakukan di branch `hotfix` yang kemudian langsung di-pull request ke `master`.
2. Aturan Format Penamaan (5.8.2):
   - Gunakan tanda garis miring (`/`) sebagai pemisah antara: **Kategori**, **Nama Modul**, dan **Deskripsi Modul**.
   - Gunakan tanda hubung (`-`) untuk penamaan modul atau deskripsi yang terdiri dari lebih dari satu suku kata.
   - Format: `<kategori>/<nama-modul>/<deskripsi-fitur>`
   - Contoh Benar:
     * `feature/absen/kehadiran`
     * `feature/absen/report`
     * `develop/absen/report-atasan`
     * `develop/absen-alker/harian`

### Standar Alur Kerja Git / Git Workflow (3 Tahap)
1. **Proses Development Local:**
   - Clone aplikasi dari repository yang telah disediakan.
   - Buat branch personal dari `master` (contoh: `feature/<nama-modul>/<deskripsi-fitur>`).
   - Buat branch `develop` dari `master` (dilakukan pertama kali setelah clone).
   - Lakukan pengerjaan kode di branch personal lokal.
2. **Proses Development QA Environment:**
   - Push branch personal ke repository server (`git push origin feature/<nama-modul>/<deskripsi-fitur>`).
   - Di lokal, checkout ke branch `develop` (`git checkout develop`).
   - Pull branch `develop` dari repo (`git pull origin develop`).
   - Merge branch personal ke branch `develop` di lokal (`git merge feature/<nama-modul>/<deskripsi-fitur>`).
   - Push branch `develop` ke server untuk diuji di environment QA (`git push origin develop`).
3. **Proses Deploy to Production:**
   - Apabila perubahan telah lolos pengujian QA, kembali aktif di branch personal (`git checkout feature/<nama-modul>/<deskripsi-fitur>`).
   - Push perubahan ke repository (`git push origin feature/<nama-modul>/<deskripsi-fitur>`).
   - Buat *Pull Request* (PR) dari branch personal ke branch `master`.
   - Lakukan *Merge* ke `master`.

### Format Output Wajib
#### Validasi Branch & Alur Kerja Git
- Input Branch: `...`
- Status: [Valid / Tidak Standar]

---

#### Catatan Evaluasi
[Jelaskan letak kesalahan seperti ketiadaan kategori, pemisah kata yang salah (misal underscore alih-alih tanda hubung `-`), atau kurangnya segmen pemisah `/`]

---

#### Rekomendasi Nama Branch & Perintah Alur Git (Proposed Plan)
- Nama Sesuai Standar: `<kategori>/<nama-modul>/<deskripsi-fitur>`
- Contoh Perintah Git Sesuai Tahapan:
```bash
git checkout -b <kategori>/<nama-modul>/<deskripsi-fitur>
```

## Examples

### Validasi Branch Tidak Standar
Input pengguna:
```text
/check-branch feat_absen_report_atasan
```

Output yang diharapkan:
```bash
# Status: Tidak Standar (kategori bukan feature/develop/qa/release/master/hotfix dan memakai underscore)
# Nama Sesuai Standar: feature/absen/report-atasan
git checkout -b feature/absen/report-atasan
```

## Limitations
- Bersifat Read-Only (Advisory Only) dan tidak mengeksekusi perintah `git checkout`, `git merge`, atau `git push` secara otomatis.
- Hanya memvalidasi konvensi penamaan branch dan alur kerja Git 3 tahap, tidak memeriksa kualitas isi kode di dalam commit.

## Troubleshooting
- **Error:** Input nama branch kosong atau hanya berisi satu kata tanpa pemisah `/`.
  - **Cause:** Pengguna belum menyertakan kategori, nama modul, dan deskripsi fitur.
  - **Solution:** Minta pengguna menyebutkan tujuan perubahan (fitur baru atau hotfix) dan nama modul agar sistem dapat menyusun format `<kategori>/<nama-modul>/<deskripsi-fitur>`.
- **Error:** Kategori branch tidak dikenal (misal `feat/` atau `fix/`).
  - **Cause:** Kategori di luar daftar standar (`feature`, `develop`, `qa`, `release`, `master`, `hotfix`).
  - **Solution:** Petakan ke kategori standar terdekat (`feat` ke `feature`, `fix` ke `hotfix`) dan tampilkan perintah `git branch -m` sebagai saran perbaikan.
