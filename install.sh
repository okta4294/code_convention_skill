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

# Opsi dan Flag
IS_GLOBAL=false
TARGET_DIR="."
INSTALL_CURSOR=false
INSTALL_WINDSURF=false
INSTALL_CLAUDE=false
INSTALL_ANTIGRAVITY=false
INSTALL_OPENCODE=false
TOOL_SPECIFIED=false

for arg in "$@"; do
  case "$arg" in
    --global|-g)
      IS_GLOBAL=true
      ;;
    --cursor)
      INSTALL_CURSOR=true
      TOOL_SPECIFIED=true
      ;;
    --windsurf)
      INSTALL_WINDSURF=true
      TOOL_SPECIFIED=true
      ;;
    --claude)
      INSTALL_CLAUDE=true
      TOOL_SPECIFIED=true
      ;;
    --antigravity)
      INSTALL_ANTIGRAVITY=true
      TOOL_SPECIFIED=true
      ;;
    --opencode)
      INSTALL_OPENCODE=true
      TOOL_SPECIFIED=true
      ;;
    --all)
      INSTALL_CURSOR=true
      INSTALL_WINDSURF=true
      INSTALL_CLAUDE=true
      INSTALL_ANTIGRAVITY=true
      INSTALL_OPENCODE=true
      TOOL_SPECIFIED=true
      ;;
    -*)
      echo "Opsi diabaikan: $arg"
      ;;
    *)
      TARGET_DIR="$arg"
      ;;
  esac
done

# Jika belum ada tool spesifik yang dipilih via flag:
if [ "$TOOL_SPECIFIED" = false ]; then
  # Periksa apakah terminal interaktif
  if [ -t 0 ] || [ -c /dev/tty ]; then
    echo "Pilih AI assistant yang ingin dipasang:"
    echo "  [1] Semua AI (Default)"
    echo "  [2] Cursor IDE (.cursorrules)"
    echo "  [3] Windsurf IDE (.windsurfrules)"
    echo "  [4] Claude Code (CLAUDE.md)"
    echo "  [5] Google Antigravity (Skills & Rules)"
    echo "  [6] OpenCode (AGENTS.md & Commands)"
    
    if [ -t 0 ]; then
      read -p "Masukkan pilihan [1-6 atau dipisah koma, contoh: 2,5] (Default: 1): " user_choice
    else
      read -p "Masukkan pilihan [1-6 atau dipisah koma, contoh: 2,5] (Default: 1): " user_choice < /dev/tty
    fi

    if [ -z "$user_choice" ] || [[ "$user_choice" =~ 1 ]]; then
      INSTALL_CURSOR=true
      INSTALL_WINDSURF=true
      INSTALL_CLAUDE=true
      INSTALL_ANTIGRAVITY=true
      INSTALL_OPENCODE=true
    else
      [[ "$user_choice" =~ 2 ]] && INSTALL_CURSOR=true
      [[ "$user_choice" =~ 3 ]] && INSTALL_WINDSURF=true
      [[ "$user_choice" =~ 4 ]] && INSTALL_CLAUDE=true
      [[ "$user_choice" =~ 5 ]] && INSTALL_ANTIGRAVITY=true
      [[ "$user_choice" =~ 6 ]] && INSTALL_OPENCODE=true
    fi
  else
    # Default non-interaktif
    INSTALL_CURSOR=true
    INSTALL_WINDSURF=true
    INSTALL_CLAUDE=true
    INSTALL_ANTIGRAVITY=true
    INSTALL_OPENCODE=true
  fi
fi

if [ "$IS_GLOBAL" = true ]; then
  echo "Memasang aturan secara global..."

  if [ "$INSTALL_ANTIGRAVITY" = true ]; then
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
  fi

  if [ "$INSTALL_CLAUDE" = true ]; then
    CLAUDE_DIR="${USER_HOME}/.claude"
    mkdir -p "${CLAUDE_DIR}"
    if [ -f "$SOURCE_DIR/adapters/CLAUDE.md" ]; then
      cp "$SOURCE_DIR/adapters/CLAUDE.md" "${CLAUDE_DIR}/CLAUDE.md" 2>/dev/null || true
      echo "  -> Claude Code: ${CLAUDE_DIR}/CLAUDE.md"
    fi
  fi

  if [ "$INSTALL_OPENCODE" = true ]; then
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
  fi

  if [ "$INSTALL_CURSOR" = true ]; then
    cp "$SOURCE_DIR/adapters/.cursorrules" "${USER_HOME}/.cursorrules" 2>/dev/null || true
    echo "  -> Cursor global template: ${USER_HOME}/.cursorrules"
  fi

  if [ "$INSTALL_WINDSURF" = true ]; then
    cp "$SOURCE_DIR/adapters/.windsurfrules" "${USER_HOME}/.windsurfrules" 2>/dev/null || true
    echo "  -> Windsurf global template: ${USER_HOME}/.windsurfrules"
  fi

  echo "Selesai. Aturan global berhasil dipasang."
else
  mkdir -p "$TARGET_DIR"
  echo "Memasang aturan ke: $TARGET_DIR"

  if [ "$INSTALL_CURSOR" = true ]; then
    cp "$SOURCE_DIR/adapters/.cursorrules" "$TARGET_DIR/" 2>/dev/null || true
    echo "  -> .cursorrules (Cursor)"
  fi

  if [ "$INSTALL_WINDSURF" = true ]; then
    cp "$SOURCE_DIR/adapters/.windsurfrules" "$TARGET_DIR/" 2>/dev/null || true
    echo "  -> .windsurfrules (Windsurf)"
  fi

  if [ "$INSTALL_CLAUDE" = true ]; then
    cp "$SOURCE_DIR/adapters/CLAUDE.md" "$TARGET_DIR/" 2>/dev/null || true
    echo "  -> CLAUDE.md (Claude Code)"
  fi

  if [ "$INSTALL_OPENCODE" = true ]; then
    cp "$SOURCE_DIR/adapters/AGENTS.md" "$TARGET_DIR/" 2>/dev/null || true
    mkdir -p "$TARGET_DIR/.opencode/commands"
    if [ -d "$SOURCE_DIR/commands" ]; then
      cp "$SOURCE_DIR"/commands/* "$TARGET_DIR/.opencode/commands/" 2>/dev/null || true
    fi
    echo "  -> AGENTS.md & .opencode/commands/ (OpenCode)"
  fi

  if [ "$INSTALL_ANTIGRAVITY" = true ]; then
    mkdir -p "$TARGET_DIR/.agents/skills" "$TARGET_DIR/.agents/rules"
    if [ -d "$SOURCE_DIR/skills" ]; then
      cp -r "$SOURCE_DIR"/skills/* "$TARGET_DIR/.agents/skills/" 2>/dev/null || true
    fi
    if [ -f "$SOURCE_DIR/core/rules.md" ]; then
      cp "$SOURCE_DIR/core/rules.md" "$TARGET_DIR/.agents/rules/corporate-rules.md" 2>/dev/null || true
    fi
    echo "  -> .agents/skills/ (Antigravity)"
  fi

  echo "Selesai. Aturan lokal berhasil dipasang."
fi
