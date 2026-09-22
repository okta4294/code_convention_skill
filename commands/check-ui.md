# Command: /check-ui

## Deskripsi
Memeriksa kode antarmuka (HTML, Blade, CSS, atau komponen view) terhadap standar hierarki elemen, responsivitas multiplatform, penataan form, serta konsistensi navigasi dan pewarnaan.

## Mode Operasional
- ADVISORY ONLY (Read-Only).
- Memberikan saran perbaikan CSS/HTML dalam format Implementation Plan.

## Aturan Kepatuhan Desain UI/UX
1. Posisi Navigasi & Logo:
   - Web Desktop: Sidebar menu berada di sebelah kiri.
   - Mobile Web: Menu di sebelah kanan atas.
   - Mobile Apps: Menu di sebelah kiri atas.
   - Logo: Wajib berada di pojok kiri atas.
2. Tata Letak Form (Form Hierarchy):
   - Form dengan banyak field wajib disusun secara vertikal (satu kolom berurutan ke bawah, bukan menyebar horizontal multi-kolom).
   - Label diletakkan di atas input field secara konsisten.
   - Pengelompokan informasi: Field form atau tabel wajib dikelompokkan sesuai kategorinya.
3. Hierarki & Warna Tombol (Button Styling):
   - Tombol Submit (Primary): Warna Biru, posisi dibuat lebih menonjol dan mudah ditemukan.
   - Tombol Delete (Danger): Warna Merah.
   - Tombol Cancel / Secondary: Warna lebih pudar / netral (abu-abu atau putih).
   - Ikon Tombol: Gunakan ikon yang familiar dan konsisten (misal: ikon pena untuk edit, ikon tempat sampah untuk delete).
4. Bahasa & Tipografi:
   - Wajib seragam satu bahasa dalam satu antarmuka (Bahasa Indonesia seluruhnya atau Bahasa Inggris seluruhnya).
   - Konsistensi kalimat label, placeholder, notifikasi, dan pesan kesalahan.
5. Multiplatform & Skalabilitas Tampilan:
   - Kompatibel lintas browser (Chrome, Mozilla, Safari, Edge, Opera) dan ramah perangkat seluler (mobile friendly).
   - Tampilan tabel dengan potensi data bertambah wajib menggunakan server-side paging (hindari datatable client-side murni).

## Format Output Wajib
### 📋 Ringkasan Audit Kepatuhan UI/UX
- Status: [Sesuai Panduan / Ditemukan Ketidaksesuaian]
- Komponen Terdampak: [Nama Form / View / Tabel]

---

### 🔍 Temuan Ketidaksesuaian UI/UX
[Jelaskan elemen yang melanggar: form multi-kolom horizontal, tombol submit non-biru, bahasa bercampur, atau navigasi tidak standar]

---

### 🛠️ Implementation Plan
1. Langkah 1: Restrukturisasi tata letak grid/form menjadi vertikal.
2. Langkah 2: Sesuaikan kelas warna tombol (biru untuk submit, merah untuk delete, pudar untuk cancel).
3. Langkah 3: Seragamkan bahasa label dan pesan notifikasi.

---

### 💻 Usulan Perubahan Antarmuka (Proposed HTML/CSS)
// Sebelum:
...

// Sesudah (Rekomendasi Sesuai Panduan):
...

---

### ⚠️ Catatan Review untuk Front-End Developer
[Pengecekan kontras warna teks terhadap latar belakang dan responsivitas pada viewport layar mobile]