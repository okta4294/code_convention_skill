# Code Quality & Compliance Advisor

Standar konvensi pengembangan perangkat lunak, pemrograman aman (*secured programming*), integritas basis data, dan aturan arsitektur untuk asisten AI (*AI Coding Agents*).

Berkas konfigurasi siap pakai untuk berbagai asisten AI:
- **Cursor IDE** (`.cursorrules`)
- **Windsurf IDE** (`.windsurfrules`)
- **Claude Code / Claude Desktop** (`CLAUDE.md`)
- **Google Antigravity / Gemini CLI** (`skills/` & `.agents/`)
- **OpenCode** (`AGENTS.md` & `.opencode/commands/`)
- **OpenAI ChatGPT / Antigravity Web Chat** (`adapters/custom-gpt-instructions.txt`)

---

## Mode Operasional: ADVISORY ONLY (Read-Only)

Untuk menjaga stabilitas repositori dan kepemilikan kode oleh developer (*Developer-in-the-Loop*):
1. **Dilarang Menimpa File Langsung:** Asisten AI dilarang keras mengubah atau menimpa berkas proyek secara otomatis.
2. **Format Implementation Plan:** Seluruh temuan audit disajikan dalam bentuk analisis terstruktur, langkah perbaikan bertahap, dan draf kode usulan (*proposed diff*) agar dapat ditinjau sebelum di-*commit*.

---

## Panduan Instalasi & Uninstall Lengkap

Aturan ini dapat dipasang dan dicopot (*uninstall*) dengan sangat mudah, baik menggunakan skrip otomatis maupun langkah manual per AI Agent.

---

### 1. Google Antigravity & Gemini CLI

#### A. Menggunakan Plugin Manager Resmi (Direkomendasikan)
- **Instalasi:**
  * **Google Antigravity CLI (`agy`):**
    ```bash
    agy plugin install https://github.com/okta4294/code_convention_skill
    ```
  * **Gemini CLI:**
    ```bash
    gemini extension install https://github.com/okta4294/code_convention_skill
    ```
- **Uninstall:**
  * **Google Antigravity CLI (`agy`):**
    ```bash
    agy plugin uninstall code_convention_skill
    ```
  * **Gemini CLI:**
    ```bash
    gemini extension uninstall code_convention_skill
    ```

#### B. Menggunakan Skrip Otomatis
- **Instalasi Global (Semua Proyek):**
  * PowerShell: `.\install.ps1 -Global -Antigravity`
  * Bash: `./install.sh --global --antigravity`
- **Instalasi Lokal (Proyek Saat Ini):**
  * PowerShell: `.\install.ps1 -Antigravity`
  * Bash: `./install.sh --antigravity`
- **Uninstall Otomatis:**
  * Global (PowerShell): `.\install.ps1 -Global -Antigravity -Uninstall`
  * Global (Bash): `./install.sh --global --antigravity --uninstall`
  * Lokal (PowerShell): `.\install.ps1 -Antigravity -Uninstall`
  * Lokal (Bash): `./install.sh --antigravity --uninstall`

#### C. Uninstall Manual
- **Global:** Hapus folder `review-all`, `review-security`, `review-integrity`, `check-db-naming`, `check-branch`, `comment`, dan `check-ui` dari `~/.gemini/config/skills/`, serta hapus file `~/.gemini/config/rules/corporate-rules.md`.
- **Lokal Proyek:** Hapus folder `.agents/skills/` dan file `.agents/rules/corporate-rules.md`.

---

### 2. Cursor IDE

#### A. Menggunakan Skrip Otomatis
- **Instalasi Lokal:**
  * PowerShell: `.\install.ps1 -Cursor`
  * Bash: `./install.sh --cursor`
- **Instalasi Global:**
  * PowerShell: `.\install.ps1 -Global -Cursor`
  * Bash: `./install.sh --global --cursor`
- **Uninstall Otomatis:**
  * Lokal: `.\install.ps1 -Cursor -Uninstall` (PowerShell) / `./install.sh --cursor --uninstall` (Bash)
  * Global: `.\install.ps1 -Global -Cursor -Uninstall` (PowerShell) / `./install.sh --global --cursor --uninstall` (Bash)

#### B. Manual
- **Instalasi:** Salin file `adapters/.cursorrules` ke *root directory* proyek Anda (atau ke direktori pengguna `~/.cursorrules`).
- **Uninstall:** Hapus file `.cursorrules` dari *root directory* proyek Anda (atau dari `%USERPROFILE%\.cursorrules` / `~/.cursorrules`).

---

### 3. Windsurf IDE (Cascade)

#### A. Menggunakan Skrip Otomatis
- **Instalasi Lokal:**
  * PowerShell: `.\install.ps1 -Windsurf`
  * Bash: `./install.sh --windsurf`
- **Instalasi Global:**
  * PowerShell: `.\install.ps1 -Global -Windsurf`
  * Bash: `./install.sh --global --windsurf`
- **Uninstall Otomatis:**
  * Lokal: `.\install.ps1 -Windsurf -Uninstall` (PowerShell) / `./install.sh --windsurf --uninstall` (Bash)
  * Global: `.\install.ps1 -Global -Windsurf -Uninstall` (PowerShell) / `./install.sh --global --windsurf --uninstall` (Bash)

#### B. Manual
- **Instalasi:** Salin file `adapters/.windsurfrules` ke *root directory* proyek Anda (atau ke direktori pengguna `~/.windsurfrules`).
- **Uninstall:** Hapus file `.windsurfrules` dari *root directory* proyek Anda (atau dari `%USERPROFILE%\.windsurfrules` / `~/.windsurfrules`).

---

### 4. Claude Code / Claude Desktop

#### A. Menggunakan Skrip Otomatis
- **Instalasi Lokal:**
  * PowerShell: `.\install.ps1 -Claude`
  * Bash: `./install.sh --claude`
- **Instalasi Global:**
  * PowerShell: `.\install.ps1 -Global -Claude`
  * Bash: `./install.sh --global --claude`
- **Uninstall Otomatis:**
  * Lokal: `.\install.ps1 -Claude -Uninstall` (PowerShell) / `./install.sh --claude --uninstall` (Bash)
  * Global: `.\install.ps1 -Global -Claude -Uninstall` (PowerShell) / `./install.sh --global --claude --uninstall` (Bash)

#### B. Manual
- **Instalasi:** Salin file `adapters/CLAUDE.md` ke *root directory* proyek Anda (atau ke folder global `~/.claude/CLAUDE.md`).
- **Uninstall:** Hapus file `CLAUDE.md` dari *root directory* proyek Anda (atau hapus file `~/.claude/CLAUDE.md`).

---

### 5. OpenCode

#### A. Menggunakan Skrip Otomatis
- **Instalasi Lokal:**
  * PowerShell: `.\install.ps1 -OpenCode`
  * Bash: `./install.sh --opencode`
- **Instalasi Global:**
  * PowerShell: `.\install.ps1 -Global -OpenCode`
  * Bash: `./install.sh --global --opencode`
- **Uninstall Otomatis:**
  * Lokal: `.\install.ps1 -OpenCode -Uninstall` (PowerShell) / `./install.sh --opencode --uninstall` (Bash)
  * Global: `.\install.ps1 -Global -OpenCode -Uninstall` (PowerShell) / `./install.sh --global --opencode --uninstall` (Bash)

#### B. Manual
- **Instalasi:**
  * Salin file `adapters/AGENTS.md` ke *root directory* proyek (atau ke `~/.config/opencode/AGENTS.md`).
  * Salin isi folder `commands/` ke `.opencode/commands/` di root proyek (atau ke `~/.config/opencode/commands/`).
- **Uninstall:**
  * Hapus `AGENTS.md` dan folder `.opencode/commands/` dari proyek Anda (atau dari folder `~/.config/opencode/`).

---

### 6. Web Chat / Custom GPTs (ChatGPT, Claude Web, Gemini Web)
- **Instalasi:** Salin seluruh teks yang ada di dalam berkas [adapters/custom-gpt-instructions.txt](file:///adapters/custom-gpt-instructions.txt) lalu tempel ke menu **Custom Instructions**, **System Prompt**, atau konfigurasi Custom GPT.
- **Uninstall:** Buka menu pengaturan **Custom Instructions** / **System Prompt** pada peramban Anda, hapus seluruh teks instruksi tersebut, lalu simpan (*Save*).

---

### 7. Instalasi & Uninstall Instan 1-Baris (Tanpa Clone Repositori)

#### Instalasi Instan (Semua AI Sekaligus)
- **Global (Windows PowerShell):**
  ```powershell
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/okta4294/code_convention_skill/main/install.ps1))) -Global
  ```
- **Global (Linux / macOS / Git Bash):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/okta4294/code_convention_skill/main/install.sh | bash -s -- --global
  ```
- **Lokal Proyek (Windows PowerShell):**
  ```powershell
  irm https://raw.githubusercontent.com/okta4294/code_convention_skill/main/install.ps1 | iex
  ```
- **Lokal Proyek (Linux / macOS / Git Bash):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/okta4294/code_convention_skill/main/install.sh | bash
  ```

#### Uninstall Instan 1-Baris
- **Hapus Global (Windows PowerShell):**
  ```powershell
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/okta4294/code_convention_skill/main/install.ps1))) -Global -Uninstall
  ```
- **Hapus Global (Linux / macOS / Git Bash):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/okta4294/code_convention_skill/main/install.sh | bash -s -- --global --uninstall
  ```
- **Hapus Lokal (Windows PowerShell):**
  ```powershell
  & ([scriptblock]::Create((irm https://raw.githubusercontent.com/okta4294/code_convention_skill/main/install.ps1))) -Uninstall
  ```
- **Hapus Lokal (Linux / macOS / Git Bash):**
  ```bash
  curl -fsSL https://raw.githubusercontent.com/okta4294/code_convention_skill/main/install.sh | bash -s -- --uninstall
  ```

---

## Daftar Pintasan Perintah & Skills

| Perintah (Slash Command) | Fungsi & Aspek yang Diaudit |
| :--- | :--- |
| **`/review-all`** | Audit kepatuhan menyeluruh (Konsep OOP & DRY, Keamanan, Integritas, Fleksibilitas & Skalabilitas, Penamaan & Alur Git, Dokumentasi 3 Poin, dan UI/UX). |
| **`/review-security`** | Audit celah SQL Injection & karakter unik parsing data (`'`), sanitasi `htmlentities` pada parameter GET (XSS), metode download berbasis ID dokumen, hashing & validasi ekstensi upload file, serta otorisasi berbasis `role`. |
| **`/review-integrity`** | Audit transaksi database (*commit & rollback*), relasi *Foreign Key*, validasi *Back-End* (skenario QA non-JavaScript), konsep OOP & DRY, serta fleksibilitas tabel API, approval, dan konfigurasi aplikasi. |
| **`/check-db-naming`** | Memvalidasi penamaan database (`namadb` / `namadbv2`) serta awalan objek basis data (`t_`, `v_`, `fk_`, `f_`, `sp_`, `tr_`). |
| **`/check-branch`** | Memvalidasi format nama Git branch (`<kategori>/<nama-modul>/<deskripsi-fitur>`) serta memandu 3 tahap alur kerja Git (Local, QA, Production). |
| **`/comment`** | Menghasilkan atau memeriksa template blok komentar 3 poin wajib (Fungsi kode untuk apa, Cara Kerja singkat, Cara Penggunaan). |
| **`/check-ui`** | Memeriksa form vertikal (1 kolom), pengelompokan informasi, letak navigasi & logo, hierarki warna & ikon tombol (Submit = Biru, Delete = Merah, Cancel = Pudar), matriks kontras warna teks vs background, server-side paging tabel, dan konsistensi 1 bahasa. |

---

## Struktur Repositori

```text
code_convention/
├── adapters/                          # Konfigurasi spesifik tiap AI IDE
│   ├── .cursorrules                   # Cursor IDE rules
│   ├── .windsurfrules                 # Windsurf Cascade rules
│   ├── CLAUDE.md                      # Claude Code project guide
│   ├── AGENTS.md                      # OpenCode & Agentic project instructions
│   └── custom-gpt-instructions.txt    # Teks System Prompt untuk Web Chat
├── commands/                          # Dokumentasi prompt perintah pintasan (OpenCode / Manual)
│   ├── review-all.md
│   ├── review-security.md
│   ├── review-integrity.md
│   ├── check-db-naming.md
│   ├── check-branch.md
│   ├── comment.md
│   └── check-ui.md
├── skills/                            # Format Skill resmi (Antigravity / Agentic IDE)
│   ├── review-all/SKILL.md
│   ├── review-security/SKILL.md
│   ├── review-integrity/SKILL.md
│   ├── check-db-naming/SKILL.md
│   ├── check-branch/SKILL.md
│   ├── comment/SKILL.md
│   └── check-ui/SKILL.md
├── core/                              # Standar inti pedoman
│   ├── rules.md                       # Daftar aturan teknis lengkap
│   └── system-prompt.md               # Definisi persona & batasan agen AI
├── install.sh                         # Skrip otomatisasi Bash / macOS / Linux
├── install.ps1                        # Skrip otomatisasi Windows PowerShell
├── .gitignore                         # File filter Git
└── README.md                          # Panduan penggunaan
```

---

## Format Output Wajib (Implementation Plan)

Setiap temuan audit akan menghasilkan respons dengan format baku:

```markdown
### 📋 Ringkasan Audit Kepatuhan
- Status: [Perlu Perbaikan / Lolos Standar]
- Bagian Terdampak: [Nama File / Fungsi / Skema]
- Poin Standar: [Aturan Terkait]

### 🔍 Temuan Ketidaksesuaian
[Uraikan detail temuan baris kode per kategori pelanggaran beserta risikonya]

### 🛠️ Implementation Plan
1. Langkah 1: ...
2. Langkah 2: ...

### 💻 Usulan Perubahan Kode (Proposed Diff / Snippet)
// Sebelum (Existing):
...
// Sesudah (Rekomendasi Sesuai Standar):
...

### ⚠️ Catatan Review untuk Developer
[Dampak perubahan arsitektur, dependensi variabel, atau hal yang wajib diverifikasi manual]
```
