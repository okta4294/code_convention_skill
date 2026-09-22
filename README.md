# Corporate Code Quality & Compliance Advisor

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

## Panduan Instalasi Cepat

### Opsi 1: Pasang Secara Global (Otomatis Aktif di Semua Proyek)
Konfigurasi akan disalin ke direktori pengguna:
- **Antigravity:** `~/.gemini/config/skills/` & `~/.gemini/config/rules/`
- **Claude Code:** `~/.claude/CLAUDE.md`
- **OpenCode:** `~/.config/opencode/AGENTS.md` & `~/.config/opencode/commands/`

**Linux / macOS / Git Bash:**
```bash
./install.sh --global
```

**Windows PowerShell:**
```powershell
.\install.ps1 -Global
```

---

### Opsi 2: Pasang ke Proyek Tertentu (Lokal)
Menyalin seluruh berkas adapter dan perintah ke direktori proyek target (`.cursorrules`, `.windsurfrules`, `CLAUDE.md`, `AGENTS.md`, `.opencode/commands/`, dan `.agents/skills/`).

**Linux / macOS / Git Bash:**
```bash
# Untuk proyek saat ini
./install.sh

# Atau arahkan ke direktori proyek target
./install.sh /path/ke/proyek-anda
```

**Windows PowerShell:**
```powershell
# Untuk proyek saat ini
.\install.ps1

# Atau arahkan ke direktori proyek target
.\install.ps1 -TargetDir "D:\proyek\aplikasi-saya"
```

---

### Opsi 3: Web Chat / Custom GPT (OpenAI & Antigravity)
Salin seluruh teks yang ada di dalam berkas [adapters/custom-gpt-instructions.txt](file:///adapters/custom-gpt-instructions.txt) lalu tempel ke menu **Custom Instructions** atau **System Prompt**.

---

## Daftar Pintasan Perintah & Skills

| Perintah (Slash Command) | Fungsi & Aspek yang Diaudit |
| :--- | :--- |
| **`/review-all`** | Audit kepatuhan menyeluruh (Keamanan, Integritas, Skalabilitas, Penamaan, dan Dokumentasi). |
| **`/review-security`** | Audit celah SQL Injection, sanitasi `$_GET` (`htmlentities`), ID download terproteksi, dan ekstensi file upload. |
| **`/review-integrity`** | Audit transaksi database (*commit/rollback*), relasi *Foreign Key*, dan validasi berlapis *Back-End*. |
| **`/check-db-naming`** | Memvalidasi awalan nama objek basis data (`t_`, `v_`, `fk_`, `f_`, `sp_`, `tr_`). |
| **`/check-branch`** | Memvalidasi format nama Git branch (`<kategori>/<modul>/<deskripsi>`). |
| **`/comment`** | Menghasilkan template blok komentar 3 poin wajib (Fungsi, Cara Kerja, Cara Pakai). |
| **`/check-ui`** | Memeriksa form vertikal, letak navigasi & logo, serta hierarki warna tombol (Submit = Biru, Delete = Merah, Cancel = Netral). |

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
