#!/bin/bash
set -e

# Installer for Corporate Code Quality & Compliance Advisor

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
TEMP_DIR=""

cleanup() {
  if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi
}
trap cleanup EXIT

# Unduh repositori sementara jika dijalankan via pipe/curl
if [ -z "$SCRIPT_DIR" ] || [ ! -d "$SCRIPT_DIR/adapters" ]; then
  REPO_URL="${CODE_CONVENTION_REPO:-https://github.com/okta4294/code_convention_skill.git}"
  TEMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t 'code_conv')"
  git clone --depth 1 "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
    echo "Error: Gagal mengunduh repositori. Pastikan git terpasang atau tentukan CODE_CONVENTION_REPO."
    exit 1
  }
  SOURCE_DIR="$TEMP_DIR"
else
  SOURCE_DIR="$SCRIPT_DIR"
fi

USER_HOME="${HOME:-$USERPROFILE}"

if [ "$1" == "--global" ] || [ "$1" == "-g" ]; then
  echo "Memasang aturan secara global..."

  # 1. Antigravity / Gemini CLI
  GEMINI_CONFIG="${USER_HOME}/.gemini/config"
  mkdir -p "${GEMINI_CONFIG}/skills" "${GEMINI_CONFIG}/rules"
  if [ -d "$SOURCE_DIR/skills" ]; then
    cp -r "$SOURCE_DIR"/skills/* "${GEMINI_CONFIG}/skills/" 2>/dev/null || true
    echo "  -> Antigravity skills: ${GEMINI_CONFIG}/skills/"
  fi
  if [ -f "$SOURCE_DIR/core/rules.md" ]; then
    cp "$SOURCE_DIR/core/rules.md" "${GEMINI_CONFIG}/rules/corporate-rules.md" 2>/dev/null || true
    echo "  -> Antigravity rules: ${GEMINI_CONFIG}/rules/corporate-rules.md"
  fi

  # 2. Claude Code
  CLAUDE_DIR="${USER_HOME}/.claude"
  mkdir -p "${CLAUDE_DIR}"
  if [ -f "$SOURCE_DIR/adapters/CLAUDE.md" ]; then
    cp "$SOURCE_DIR/adapters/CLAUDE.md" "${CLAUDE_DIR}/CLAUDE.md" 2>/dev/null || true
    echo "  -> Claude Code: ${CLAUDE_DIR}/CLAUDE.md"
  fi

  # 3. OpenCode
  OPENCODE_CONFIG="${USER_HOME}/.config/opencode"
  mkdir -p "${OPENCODE_CONFIG}/commands"
  if [ -f "$SOURCE_DIR/adapters/AGENTS.md" ]; then
    cp "$SOURCE_DIR/adapters/AGENTS.md" "${OPENCODE_CONFIG}/AGENTS.md" 2>/dev/null || true
    echo "  -> OpenCode instructions: ${OPENCODE_CONFIG}/AGENTS.md"
  fi
  if [ -d "$SOURCE_DIR/commands" ]; then
    cp "$SOURCE_DIR"/commands/* "${OPENCODE_CONFIG}/commands/" 2>/dev/null || true
    echo "  -> OpenCode commands: ${OPENCODE_CONFIG}/commands/"
  fi

  echo "Selesai. Aturan global berhasil dipasang."
else
  TARGET_DIR="${1:-.}"
  mkdir -p "$TARGET_DIR"

  echo "Memasang aturan ke: $TARGET_DIR"

  # Salin adapter IDE
  cp "$SOURCE_DIR/adapters/.cursorrules" "$TARGET_DIR/" 2>/dev/null || true
  cp "$SOURCE_DIR/adapters/.windsurfrules" "$TARGET_DIR/" 2>/dev/null || true
  cp "$SOURCE_DIR/adapters/CLAUDE.md" "$TARGET_DIR/" 2>/dev/null || true
  cp "$SOURCE_DIR/adapters/AGENTS.md" "$TARGET_DIR/" 2>/dev/null || true

  # Salin skills untuk Antigravity workspace
  mkdir -p "$TARGET_DIR/.agents/skills" "$TARGET_DIR/.agents/rules"
  if [ -d "$SOURCE_DIR/skills" ]; then
    cp -r "$SOURCE_DIR"/skills/* "$TARGET_DIR/.agents/skills/" 2>/dev/null || true
  fi
  if [ -f "$SOURCE_DIR/core/rules.md" ]; then
    cp "$SOURCE_DIR/core/rules.md" "$TARGET_DIR/.agents/rules/corporate-rules.md" 2>/dev/null || true
  fi

  # Salin commands untuk OpenCode workspace
  mkdir -p "$TARGET_DIR/.opencode/commands"
  if [ -d "$SOURCE_DIR/commands" ]; then
    cp "$SOURCE_DIR"/commands/* "$TARGET_DIR/.opencode/commands/" 2>/dev/null || true
  fi

  echo "  -> .cursorrules (Cursor)"
  echo "  -> .windsurfrules (Windsurf)"
  echo "  -> CLAUDE.md (Claude Code)"
  echo "  -> AGENTS.md (OpenCode)"
  echo "  -> .opencode/commands/ (OpenCode)"
  echo "  -> .agents/skills/ (Antigravity)"

  echo "Selesai. Aturan lokal berhasil dipasang."
fi
