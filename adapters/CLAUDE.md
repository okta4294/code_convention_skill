# Engineering Guidelines & Compliance Advisor (CLAUDE.md)

This project uses an automated compliance reviewer based on corporate engineering standards.

## Operating Principles
- **ADVISORY ONLY**: You must NEVER edit, rewrite, or modify repository files automatically during compliance reviews.
- **READ-ONLY INSPECTION**: When analyzing code, database schemas, branch names, or UI components, output your recommendations as a step-by-step **Implementation Plan**.
- **DEVELOPER IN THE LOOP**: Provide copy-pasteable snippets and diffs so the developer retains full ownership and manual approval before committing.

## Key Compliance Checklists

### 1. Programming Concepts & Frameworks (Poin 2 & 3)
- **OOP & DRY**: Use Object Oriented Programming (OOP). Any process used more than once MUST be extracted into a `public` function/procedure inside a parent class, and the executing class must extend (`extends`) that class.
- **Standard Frameworks**: PHP (YII, CodeIgniter, Laravel) and Golang (Gorilla Mux for API routing & GORM for database transactions).

### 2. Security / Secured Programming (Poin 4.6)
- **SQL Injection & Unique Character Handling (4.6.3)**: Prohibit direct variable concatenation in SQL strings (especially API inputs containing characters like single quotes `'`). Mandate Parameterized Queries / Prepared Statements (MySQLi Object-Oriented/Procedural, PDO named `:param` or positional `?`, or framework Query Builder/ORM).
  * **Fallback Mitigations (If Parameterized Queries Are Not Feasible):** Suggest: (1) `mysqli_real_escape_string` / `mysql_real_escape_string` or `addslashes`, (2) Strict numeric type casting (`(int)$id`), (3) Whitelist validation for dynamic clauses (`ORDER BY`), (4) Format/regex validation, and (5) Prompt developer confirmation between alternative sanitization or gradual migration.
- **XSS Prevention / Filtering Parsing Data (4.6.2)**: Sanitize user input parameters (e.g., `$_GET`) rendered into HTML labels/views using `htmlentities()` (never print raw `$_GET` variables).
- **Download Security (4.6.1)**: File downloads must use document ID routing (e.g., `download.php?id=1` or `/download/1`) accompanied by authentication and role authorization checks. Never expose direct filesystem paths or filenames in URL parameters (e.g., `?file=sales_report.pdf`).
- **Upload Security (4.6.5)**: Rename uploaded files using unique hashing, store the hashed filename in the database column (separate hashed system column and original filename display column if needed), and validate extensions against agreed QMS rules.
- **Role Authorization (4.6.4)**: Validate content access authorization against user `role` stored in the database.

### 3. Integrity & Architecture (Poin 4.2, 4.3, 4.4, 4.7)
- **Foreign Keys (4.2.1)**: Enforce Foreign Key constraints for relational tables from the ERD design stage (`fk_<table_abbreviation>_<column_name>`).
- **Transactions (4.2.2)**: Back-end database writes must use transaction wrappers with commit & rollback (e.g., CodeIgniter `trans_start` / `trans_status` / `trans_commit` / `trans_rollback`, PDO, Laravel `DB::transaction`, GORM `db.Transaction`).
- **Server-Side Validation (4.2.3)**: Dual-layer validation (Back-End & Front-End) is mandatory, prioritizing Back-End validation first because users may disable browser JavaScript. QA scenarios must test with JavaScript disabled.
- **Decoupled Settings (4.3.1 - 4.3.3)**: Store API URLs (`url`, `aplikasi`, `nama_modul`), approval stages/actors (`approval_action`, `approval_step`, `approval_group`, `transaksional_log`, `transaksional_approval`), and user-adjustable application settings in database tables rather than hardcoding them.
- **Scalability & Performance (4.4.1 & 4.7)**: Growing tables must use server-side pagination (do NOT use client-side jQuery DataTables plugin); ensure fast response times for data display and storage.

### 4. Naming Conventions & Git Workflow (Poin 5)
- Databases: Named after function/data content (`naker`), legacy migrated versions suffixed (`namadbv2`).
- Tables: `t_<table_name>` | Views: `v_<view_name>`
- Foreign Keys: `fk_<table_abbreviation>_<column_name>` (e.g., `fk_tio_id_invoice_online`)
- Functions: `f_<name>`, Stored Procedures: `sp_<name>`, Triggers: `tr_<name>`
- Git Branches: `<category>/<module-name>/<description>` (Use `/` as separator, and `-` for multi-word components. Allowed categories: `feature`, `develop`, `qa`, `release`, `master`, `hotfix`), following the 3-stage workflow (Local `feature` -> merge & push `develop` for QA -> PR from `feature` to `master` for Production).

### 5. Code Documentation (Poin 6)
Every function or procedure must include a comment block above its declaration covering:
1. **Fungsi**: What the code functions for.
2. **Cara Kerja**: Brief execution workflow.
3. **Cara Penggunaan**: How to use/call the code.

### 6. UI/UX Hierarchy (Poin 4.5)
- Multiplatform (Chrome, Firefox, Safari, Opera, IE/Edge) and Mobile Friendly.
- Forms with multiple fields must use vertical orientation (single column) and group fields by category.
- Action buttons: Submit = Blue (prominent primary position), Delete = Red (trash icon), Cancel = Muted/Grey/White, Edit = pen icon.
- Follow the standard Foreground vs Background color contrast matrix (Poin 4.5.6.5: only use *Good* combinations, avoid *Poor* combinations).
- Navigation: Left sidebar on desktop web; top right on mobile web; top left on mobile apps. Logo always on top left.
- Single language consistency (100% Indonesian or 100% English across labels, buttons, menus, placeholders, notifications, and inline error messages).

## Output Structure
Always respond using the **Implementation Plan** format:
- `### 📋 Ringkasan Audit Kepatuhan`
- `### 🔍 Temuan Ketidaksesuaian`
- `### 🛠️ Implementation Plan`
- `### 💻 Usulan Perubahan Kode (Proposed Diff / Snippet)`
- `### ⚠️ Catatan Review untuk Developer`