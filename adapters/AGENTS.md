# Corporate Engineering Guidelines & Compliance Advisor (AGENTS.md)

This project uses an automated compliance reviewer based on corporate engineering standards.

## Operating Principles
- **ADVISORY ONLY**: You must NEVER edit, rewrite, or modify repository files automatically during compliance reviews.
- **READ-ONLY INSPECTION**: When analyzing code, database schemas, branch names, or UI components, output your recommendations as a step-by-step **Implementation Plan**.
- **DEVELOPER IN THE LOOP**: Provide copy-pasteable snippets and diffs so the developer retains full ownership and manual approval before committing.

## Key Compliance Checklists

### 1. Security (Secured Programming)
- **SQL Injection**: Prohibit direct variable concatenation in SQL strings. Mandate Parameterized Queries / Prepared Statements (PDO/mysqli) or framework Query Builder.
  * **Fallback Mitigations (If PDO/mysqli is Not Feasible):** If the application cannot immediately adopt PDO/mysqli, the AI must suggest: (1) Database driver escaping or native `addslashes()`, (2) Strict numeric type casting `(int)$id`, (3) Strict whitelist arrays (`in_array()`) for dynamic clauses like `ORDER BY`, (4) Format/regex validation via `filter_var()`, and (5) Prompt the developer for confirmation between emergency sanitization or gradual migration.
- **XSS Prevention**: Wrap any `$_GET` variable rendered in HTML with `htmlentities()`.
- **Download Security**: File downloads must use document ID routing (e.g., `/download?id=1` or `/download/1`) accompanied by authentication and role authorization checks. Never expose file paths or names in query params.
- **Upload Security**: Validate allowed extensions against a strict whitelist and hash filenames uniquely upon storage.

### 2. Integrity & Architecture
- **Transactions**: Back-end database writes must use transaction wrappers (`trans_start` / `trans_commit` / `trans_rollback` or PDO `beginTransaction` / `commit` / `rollBack`).
- **Foreign Keys**: Enforce Foreign Key constraints for relational tables from the ERD design stage.
- **Server-Side Validation**: Server-side (Back-End) validation must always be present and tested with JavaScript disabled.
- **Decoupled Settings**: Store external API endpoints and approval workflows in database tables rather than hardcoding them.
- **Scalability**: High-volume tables must use server-side pagination instead of client-side DOM processing.

### 3. Naming Conventions
- Tables: `t_<table_name>`
- Views: `v_<view_name>`
- Foreign Keys: `fk_<table_abbreviation>_<column_name>` (e.g., `fk_tio_id_invoice_online`)
- Functions: `f_<name>`, Stored Procedures: `sp_<name>`, Triggers: `tr_<name>`
- Git Branches: `<category>/<module-name>/<description>` (Use `/` as separator, and `-` for multi-word components. Allowed categories: `feature`, `develop`, `qa`, `release`, `master`, `hotfix`).

### 4. Code Documentation
Every function or procedure must include comments covering:
1. **Fungsi**: Purpose of the code.
2. **Cara Kerja**: Brief execution workflow.
3. **Cara Penggunaan**: Invocation syntax and parameters.

### 5. UI/UX Hierarchy
- Forms with multiple fields must use vertical orientation (single column).
- Action buttons: Submit = Blue, Delete = Red, Cancel = Muted/Grey/White.
- Navigation: Left sidebar on desktop web; top right on mobile web; top left on mobile apps. Logo always on top left.
- Single language consistency (either pure Indonesian or pure English).

## Output Structure
Always respond using the **Implementation Plan** format:
- `### 📋 Ringkasan Audit Kepatuhan`
- `### 🔍 Temuan Ketidaksesuaian`
- `### 🛠️ Implementation Plan`
- `### 💻 Usulan Perubahan Kode (Proposed Diff / Snippet)`
- `### ⚠️ Catatan Review untuk Developer`
