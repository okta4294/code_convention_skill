# Command: /check-branch

## Deskripsi
Memvalidasi atau menghasilkan nama Git branch agar sesuai dengan kategori alur kerja repositori, hierarki modul, format pemisah kata (Poin 5.8), serta memberikan panduan alur kerja Git 3 tahap (Local, QA, Production).

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Mengecek kesesuaian nama branch yang diberikan, menyusun nama branch baru yang valid, dan menjelaskan urutan alur perintah Git sesuai tahapannya.

## Aturan Penamaan & Kategori Git Branch (Poin 5.8.1 & 5.8.2)
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

## Standar Alur Kerja Git / Git Workflow (3 Tahap)
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

## Format Output Wajib
### 📋 Validasi Branch & Alur Kerja Git
- Input Branch: `...`
- Status: [Valid / Tidak Standar]

---

### 🔍 Catatan Evaluasi
[Jelaskan letak kesalahan seperti ketiadaan kategori, pemisah kata yang salah (misal underscore alih-alih tanda hubung `-`), atau kurangnya segmen pemisah `/`]

---

### 💡 Rekomendasi Nama Branch & Perintah Alur Git (Proposed Plan)
- Nama Sesuai Standar: `<kategori>/<nama-modul>/<deskripsi-fitur>`
- Contoh Perintah Git Sesuai Tahapan:
```bash
git checkout -b <kategori>/<nama-modul>/<deskripsi-fitur>
```