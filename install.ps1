<#
.SYNOPSIS
  Corporate Code Quality & Compliance Advisor Installer for Windows PowerShell
.DESCRIPTION
  Memasang file konfigurasi aturan untuk Cursor, Windsurf, Claude Code, Antigravity, dan OpenCode.
.PARAMETER TargetDir
  Direktori tujuan proyek lokal (default: direktori saat ini).
.PARAMETER Global
  Pasang aturan secara global ke home directory pengguna (~/.gemini/config, ~/.claude, dan ~/.config/opencode).
.EXAMPLE
  .\install.ps1
  .\install.ps1 -TargetDir "D:\proyek\aplikasi-saya"
  .\install.ps1 -Global
#>

param(
    [string]$TargetDir = ".",
    [switch]$Global
)

$ErrorActionPreference = "Stop"

# Tentukan direktori sumber (lokal atau unduh sementara jika dijalankan via piping ire/iex)
$ScriptDir = ""
if ($PSScriptRoot) {
    $ScriptDir = $PSScriptRoot
} elseif ($MyInvocation.MyCommand.Definition) {
    try {
        $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    } catch {
        $ScriptDir = ""
    }
}

$TempDir = ""
$CleanupNeeded = $false

try {
    if (-not $ScriptDir -or -not (Test-Path (Join-Path $ScriptDir "adapters"))) {
        $RepoUrl = if ($env:CODE_CONVENTION_REPO) { $env:CODE_CONVENTION_REPO } else { "https://github.com/YOUR_ORGANIZATION_OR_USERNAME/code_convention.git" }
        Write-Host "Mengunduh konfigurasi dari repositori..."
        $TempDir = Join-Path $env:TEMP ("code_conv_" + [System.Guid]::NewGuid().ToString("N"))
        New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
        $CleanupNeeded = $true

        if (Get-Command git -ErrorAction SilentlyContinue) {
            git clone --depth 1 $RepoUrl $TempDir 2>$null
            $SourceDir = $TempDir
        } else {
            $ZipUrl = $RepoUrl -replace "\.git$", "/archive/refs/heads/main.zip"
            $ZipPath = Join-Path $env:TEMP "code_convention.zip"
            Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath
            Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
            Remove-Item -Path $ZipPath -Force -ErrorAction SilentlyContinue
            $Extracted = Get-ChildItem -Path $TempDir -Directory | Select-Object -First 1
            if ($Extracted) { $SourceDir = $Extracted.FullName } else { $SourceDir = $TempDir }
        }
    } else {
        $SourceDir = $ScriptDir
    }

    $UserHome = [Environment]::GetFolderPath("UserProfile")

    if ($Global) {
        Write-Host "Memasang aturan secara global..."

        # 1. Antigravity / Gemini CLI Global Skills & Rules
        $GeminiSkills = Join-Path $UserHome ".gemini\config\skills"
        $GeminiRules = Join-Path $UserHome ".gemini\config\rules"

        if (-not (Test-Path $GeminiSkills)) { New-Item -ItemType Directory -Path $GeminiSkills -Force | Out-Null }
        if (-not (Test-Path $GeminiRules)) { New-Item -ItemType Directory -Path $GeminiRules -Force | Out-Null }

        $SourceSkills = Join-Path $SourceDir "skills"
        if (Test-Path $SourceSkills) {
            Copy-Item -Path "$SourceSkills\*" -Destination $GeminiSkills -Recurse -Force
            Write-Host "  -> Antigravity skills: $GeminiSkills"
        }

        $SourceRules = Join-Path $SourceDir "core\rules.md"
        if (Test-Path $SourceRules) {
            Copy-Item -Path $SourceRules -Destination (Join-Path $GeminiRules "corporate-rules.md") -Force
            Write-Host "  -> Antigravity rules: $GeminiRules\corporate-rules.md"
        }

        # 2. Claude Code Global Guide
        $ClaudeDir = Join-Path $UserHome ".claude"
        if (-not (Test-Path $ClaudeDir)) { New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null }

        $SourceClaude = Join-Path $SourceDir "adapters\CLAUDE.md"
        if (Test-Path $SourceClaude) {
            Copy-Item -Path $SourceClaude -Destination (Join-Path $ClaudeDir "CLAUDE.md") -Force
            Write-Host "  -> Claude Code: $ClaudeDir\CLAUDE.md"
        }

        # 3. OpenCode Global Configuration & Commands
        $OpenCodeDir = Join-Path $UserHome ".config\opencode"
        $OpenCodeCommands = Join-Path $OpenCodeDir "commands"
        if (-not (Test-Path $OpenCodeCommands)) { New-Item -ItemType Directory -Path $OpenCodeCommands -Force | Out-Null }

        $SourceAgents = Join-Path $SourceDir "adapters\AGENTS.md"
        if (Test-Path $SourceAgents) {
            Copy-Item -Path $SourceAgents -Destination (Join-Path $OpenCodeDir "AGENTS.md") -Force
            Write-Host "  -> OpenCode instructions: $OpenCodeDir\AGENTS.md"
        }

        $SourceCommands = Join-Path $SourceDir "commands"
        if (Test-Path $SourceCommands) {
            Copy-Item -Path "$SourceCommands\*" -Destination $OpenCodeCommands -Force
            Write-Host "  -> OpenCode commands: $OpenCodeCommands"
        }

        Write-Host "Selesai. Aturan global berhasil dipasang."
    }
    else {
        $ResolvedTarget = Resolve-Path $TargetDir -ErrorAction SilentlyContinue
        if (-not $ResolvedTarget) {
            New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
            $ResolvedTarget = Resolve-Path $TargetDir
        }

        Write-Host "Memasang aturan ke: $ResolvedTarget"

        # Salin adapter IDE (Cursor, Windsurf, Claude Code, OpenCode)
        $CursorSource = Join-Path $SourceDir "adapters\.cursorrules"
        $WindsurfSource = Join-Path $SourceDir "adapters\.windsurfrules"
        $ClaudeSource = Join-Path $SourceDir "adapters\CLAUDE.md"
        $AgentsSource = Join-Path $SourceDir "adapters\AGENTS.md"

        if (Test-Path $CursorSource) { Copy-Item -Path $CursorSource -Destination $ResolvedTarget -Force }
        if (Test-Path $WindsurfSource) { Copy-Item -Path $WindsurfSource -Destination $ResolvedTarget -Force }
        if (Test-Path $ClaudeSource) { Copy-Item -Path $ClaudeSource -Destination $ResolvedTarget -Force }
        if (Test-Path $AgentsSource) { Copy-Item -Path $AgentsSource -Destination $ResolvedTarget -Force }

        # Salin skills untuk Antigravity Workspace
        $AgentSkills = Join-Path $ResolvedTarget ".agents\skills"
        $AgentRules = Join-Path $ResolvedTarget ".agents\rules"

        if (-not (Test-Path $AgentSkills)) { New-Item -ItemType Directory -Path $AgentSkills -Force | Out-Null }
        if (-not (Test-Path $AgentRules)) { New-Item -ItemType Directory -Path $AgentRules -Force | Out-Null }

        $SourceSkills = Join-Path $SourceDir "skills"
        if (Test-Path $SourceSkills) {
            Copy-Item -Path "$SourceSkills\*" -Destination $AgentSkills -Recurse -Force
        }

        $SourceRules = Join-Path $SourceDir "core\rules.md"
        if (Test-Path $SourceRules) {
            Copy-Item -Path $SourceRules -Destination (Join-Path $AgentRules "corporate-rules.md") -Force
        }

        # Salin commands untuk OpenCode Workspace
        $OpenCodeLocalCommands = Join-Path $ResolvedTarget ".opencode\commands"
        if (-not (Test-Path $OpenCodeLocalCommands)) { New-Item -ItemType Directory -Path $OpenCodeLocalCommands -Force | Out-Null }

        $SourceCommands = Join-Path $SourceDir "commands"
        if (Test-Path $SourceCommands) {
            Copy-Item -Path "$SourceCommands\*" -Destination $OpenCodeLocalCommands -Force
        }

        Write-Host "  -> .cursorrules (Cursor)"
        Write-Host "  -> .windsurfrules (Windsurf)"
        Write-Host "  -> CLAUDE.md (Claude Code)"
        Write-Host "  -> AGENTS.md (OpenCode)"
        Write-Host "  -> .opencode/commands/ (OpenCode)"
        Write-Host "  -> .agents/skills/ (Antigravity)"

        Write-Host "Selesai. Aturan lokal berhasil dipasang."
    }
}
finally {
    if ($CleanupNeeded -and (Test-Path $TempDir)) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
