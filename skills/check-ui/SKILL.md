---
name: check-ui
description: Use when auditing UI/UX compliance (/check-ui) for form layout, buttons, colors, and paging. Do NOT use for backend code.
metadata:
  author: okta4294
  tags:
    - ui-ux
    - frontend
    - accessibility
    - code-convention
---

# Command: /check-ui

## Purpose
Memeriksa kode antarmuka (HTML, Blade, CSS, atau komponen view) terhadap standar UX Friendly (Poin 4.5) dan Skalabilitas Tabel (Poin 4.4.1): hierarki elemen, responsivitas multiplatform, tata letak form vertikal, pengelompokan informasi, konsistensi navigasi/logo, warna & ikon tombol, serta matriks kombinasi pewarnaan teks terhadap latar belakang.

## Prerequisites
- Pengguna menyediakan kode antarmuka (HTML, CSS, Blade, JSX/Vue, atau deskripsi komponen UI) yang akan diaudit.
- Tidak memerlukan browser headless, API key, atau dependensi eksternal.

## Instructions

### Mode Operasional
- ADVISORY ONLY (Read-Only).
- Memberikan saran perbaikan CSS/HTML dalam format Implementation Plan tanpa menimpa file proyek secara langsung.

### Aturan Kepatuhan Desain UI/UX (Poin 4.4.1 & 4.5)
1. Multiplatform & Mobile Friendly (Poin 4.5.1 & 4.5.2):
   - Template yang digunakan harus *multiplatform* (dapat berjalan dengan baik di Chrome, Mozilla Firefox, Safari, Opera, dan IE/Edge).
   - Template harus *mobile friendly* (responsif saat dijalankan di tablet, smartphone, maupun perangkat mobile lainnya).
2. Posisi Menu & Logo (Poin 4.5.3 & 4.5.4):
   - **Web Desktop:** Sidebar menu berada di sebelah **kiri**.
   - **Mobile Web:** Menu berada di sebelah **kanan atas**.
   - **Mobile Apps:** Menu berada di sebelah **kiri atas**.
   - **Logo:** Letak logo pada web wajib berada di posisi **kiri atas**.
3. Bahasa & Tipografi (Poin 4.5.5):
   - Penggunaan bahasa wajib diseragamkan 100% dalam satu antarmuka (**Bahasa Indonesia semua** atau **Bahasa Inggris semua**).
   - Konsistensi penamaan **Label (Form, Button, Menu)**.
   - Konsistensi penamaan **Placeholder**.
   - Konsistensi dan kesesuaian kalimat **notifikasi dan error message** (gunakan indikator *inline error* yang rapi pada masing-masing field, hindari kotak pesan merah raksasa yang tidak proporsional).
4. Hierarki Elemen, Tombol, & Form (Poin 4.5.6-1 sampai 4.5.6-4):
   - **Warna Button (4.5.6-1):**
     * Button **Submit**: Menggunakan warna **Biru** dengan tulisan sesuai keseragaman bahasa.
     * Button **Cancel**: Menggunakan warna **lebih pudar** dari tombol lain (misal: **putih** atau **abu-abu**).
     * Button **Delete**: Menggunakan warna **Merah**.
   - **Icon Button (4.5.6-2):** Penyeragaman penggunaan ikon yang familiar dan mudah dipahami pada label form atau button action (misal: button Edit menggunakan ikon pena, button Delete menggunakan ikon tempat sampah).
   - **Position & Tata Letak Form Vertikal (4.5.6-3):**
     * Memposisikan button, menu, dan elemen secara seragam dan konsisten; **button primary (Submit) diletakkan lebih menonjol dan mudah ditemukan** dibandingkan tombol secondary (Cancel).
     * **Form dengan banyak field wajib diposisikan secara vertikal** (satu kolom berurutan ke bawah — *Do*, dilarang menyusun menyamping multi-kolom horizontal — *Don't*).
   - **Pengelompokan Informasi (4.5.6-4):** Informasi yang ditampilkan (input field, table field, dll.) wajib dikelompokkan sesuai dengan kategorinya (misal: grup *Personal*, *Account*, *Contact*).
5. Matriks Standar Pewarnaan Teks / Foreground vs Background (Poin 4.5.6-5):
   Kombinasi warna antara kata (*Foreground*) dan *Background* wajib sesuai dan mudah dilihat (**Good**) serta dilarang memakai kombinasi **Poor**:

   | Foreground \ Background | Red | Orange | Yellow | Green | Blue | Violet | Black | White | Gray |
   | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
   | **Red** | — | Poor | **Good** | Poor | Poor | Poor | **Good** | **Good** | Poor |
   | **Orange** | Poor | — | Poor | Poor | Poor | Poor | **Good** | Poor | Poor |
   | **Yellow** | **Good** | **Good** | — | Poor | **Good** | Poor | **Good** | Poor | **Good** |
   | **Green** | Poor | Poor | Poor | — | **Good** | Poor | **Good** | Poor | **Good** |
   | **Blue** | Poor | Poor | **Good** | **Good** | — | Poor | Poor | **Good** | Poor |
   | **Violet** | Poor | Poor | **Good** | Poor | Poor | — | **Good** | **Good** | Poor |
   | **Black** | Poor | **Good** | **Good** | **Good** | Poor | **Good** | — | **Good** | Poor |
   | **White** | **Good** | **Good** | **Good** | Poor | **Good** | **Good** | **Good** | — | **Good** |
   | **Gray** | Poor | Poor | **Good** | **Good** | Poor | Poor | Poor | **Good** | — |

6. Skalabilitas Paging Tampilan Tabel (Poin 4.4.1):
   - Apabila data yang ditampilkan di dalam tabel akan terus bertambah, wajib menggunakan **server-side paging** dan **dilarang menggunakan plugin jQuery DataTables secara client-side**.

### Format Output Wajib
#### Ringkasan Audit Kepatuhan UI/UX
- Status: [Sesuai Panduan / Ditemukan Ketidaksesuaian]
- Komponen Terdampak: [Nama Form / View / Tabel]

---

#### Temuan Ketidaksesuaian UI/UX
[Jelaskan elemen yang melanggar: form multi-kolom horizontal, tombol submit non-biru, kombinasi warna Foreground/Background berstatus Poor, bahasa bercampur, ketiadaan pengelompokan field, atau datatable client-side]

---

#### Implementation Plan
1. Langkah 1: Restrukturisasi tata letak grid/form menjadi vertikal (1 kolom) dan kelompokkan informasi per kategori.
2. Langkah 2: Sesuaikan warna & ikon tombol (Submit = Biru, Delete = Merah + ikon tempat sampah, Cancel = Pudar/Putih/Abu-abu) serta kontras warna sesuai matriks.
3. Langkah 3: Seragamkan 100% bahasa label/placeholder/notifikasi dan terapkan server-side paging pada tabel.

---

#### Usulan Perubahan Antarmuka (Proposed HTML/CSS)
```html
<!-- Sebelum -->
<!-- Sesudah (Rekomendasi Sesuai Panduan) -->
```

---

#### Catatan Review untuk Front-End Developer
[Pengecekan kontras warna berdasarkan matriks Poin 4.5.6-5, uji multiplatform browser, dan responsivitas pada layar mobile]

## Examples

### Audit Tombol Aksi dan Tata Letak Form
Input pengguna:
```html
<div class="row">
  <div class="col-6"><label>Nama</label><input type="text" placeholder="Enter name"></div>
  <div class="col-6"><label>Email</label><input type="email" placeholder="Masukkan email"></div>
</div>
<button class="btn-success">Simpan</button>
<button class="btn-danger">Cancel</button>
```

Usulan perbaikan sesuai konvensi:
```html
<fieldset>
  <legend>Informasi Pribadi</legend>
  <div class="mb-3"><label>Nama</label><input type="text" placeholder="Masukkan nama"></div>
  <div class="mb-3"><label>Email</label><input type="email" placeholder="Masukkan email"></div>
</fieldset>
<button type="submit" class="btn-primary">Simpan</button>
<button type="button" class="btn-secondary">Batal</button>
```

## Limitations
- Bersifat statis (analisis kode HTML/CSS) dan tidak merender tampilan visual langsung di browser.
- Tidak memeriksa celah keamanan backend atau query database (gunakan `/review-security` untuk audit XSS dan keamanan).

## Troubleshooting
- **Error:** Warna didefinisikan lewat class CSS eksternal yang tidak disertakan dalam input.
  - **Cause:** Definisi warna foreground dan background tidak terlihat pada potongan HTML saja.
  - **Solution:** Minta file CSS/stylesheet terkait atau laporkan keterbatasan pengecekan kontras pada bagian Catatan Review.
- **Error:** Bahasa antarmuka bercampur antara Indonesia dan Inggris.
  - **Cause:** Sebagian label atau placeholder memakai istilah Inggris sementara tombol memakai Bahasa Indonesia.
  - **Solution:** Tentukan satu bahasa target yang konsisten (100% Indonesia atau 100% Inggris) dan daftar seluruh teks yang harus diseragamkan.
