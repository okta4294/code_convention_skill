<#
.SYNOPSIS
  Corporate Code Quality & Compliance Advisor Installer for Windows PowerShell
.DESCRIPTION
  Memasang file konfigurasi aturan untuk Cursor, Windsurf, Claude Code, Antigravity, dan OpenCode.
.PARAMETER TargetDir
  Direktori tujuan proyek lokal (default: direktori saat ini).
.PARAMETER Global
  Pasang aturan secara global ke home directory pengguna.
.PARAMETER Cursor
  Hanya pasang konfigurasi Cursor IDE (.cursorrules).
.PARAMETER Windsurf
  Hanya pasang konfigurasi Windsurf IDE (.windsurfrules).
.PARAMETER Claude
  Hanya pasang konfigurasi Claude Code (CLAUDE.md).
.PARAMETER Antigravity
  Hanya pasang konfigurasi Google Antigravity (Skills & Rules).
.PARAMETER OpenCode
  Hanya pasang konfigurasi OpenCode (AGENTS.md & Commands).
.PARAMETER All
  Pasang seluruh konfigurasi AI.
.PARAMETER Uninstall
  Hapus/uninstall konfigurasi aturan yang telah dipasang.
.EXAMPLE
  .\install.ps1
  .\install.ps1 -Global
  .\install.ps1 -Cursor
  .\install.ps1 -Global -Claude
  .\install.ps1 -Uninstall
  .\install.ps1 -Global -Uninstall
#>

param(
    [string]$TargetDir = ".",
    [switch]$Global,
    [switch]$All,
    [switch]$Cursor,
    [switch]$Windsurf,
    [switch]$Claude,
    [switch]$Antigravity,
    [switch]$OpenCode,
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"

# Tentukan direktori sumber (hanya jika berkas dijalankan secara lokal dari disk)
$ScriptDir = ""
if ($PSScriptRoot) {
    $ScriptDir = $PSScriptRoot
} elseif ($MyInvocation.MyCommand.Path) {
    try {
        $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    } catch {
        $ScriptDir = ""
    }
}

$IsLocalRepo = (-not [string]::IsNullOrWhiteSpace($ScriptDir)) -and (Test-Path -LiteralPath $ScriptDir -PathType Container) -and (Test-Path -LiteralPath (Join-Path $ScriptDir "adapters"))

$TempDir = ""
$CleanupNeeded = $false

try {
    if (-not $IsLocalRepo) {
        $RepoUrl = if ($env:CODE_CONVENTION_REPO) { $env:CODE_CONVENTION_REPO } else { "https://github.com/okta4294/code_convention_skill.git" }
        Write-Host "Mengunduh konfigurasi dari repositori..."
        $TempDir = Join-Path $env:TEMP ("code_conv_" + [System.Guid]::NewGuid().ToString("N"))
        New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
        $CleanupNeeded = $true

        $Cloned = $false
        if (Get-Command git -ErrorAction SilentlyContinue) {
            try {
                $prevEAP = $ErrorActionPreference
                $ErrorActionPreference = "Continue"
                git clone --quiet --depth 1 $RepoUrl $TempDir 2>&1 | Out-Null
                $ErrorActionPreference = $prevEAP
                if (Test-Path -LiteralPath (Join-Path $TempDir "adapters")) {
                    $SourceDir = $TempDir
                    $Cloned = $true
                }
            } catch {
                $Cloned = $false
            }
        }
        
        if (-not $Cloned) {
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
    $IsGlobal = ($PSBoundParameters.ContainsKey('Global') -and $Global) -or $Global.IsPresent -or ($args -contains "-Global") -or ($args -contains "--global") -or ($args -contains "-g") -or ($env:GLOBAL -eq "1") -or ($env:GLOBAL -eq "true")
    $IsUninstall = ($PSBoundParameters.ContainsKey('Uninstall') -and $Uninstall) -or $Uninstall.IsPresent -or ($args -contains "-Uninstall") -or ($args -contains "--uninstall") -or ($args -contains "-u")

    # Deteksi pilihan alat
    $DoCursor = $Cursor.IsPresent -or ($args -contains "-Cursor") -or ($args -contains "--cursor")
    $DoWindsurf = $Windsurf.IsPresent -or ($args -contains "-Windsurf") -or ($args -contains "--windsurf")
    $DoClaude = $Claude.IsPresent -or ($args -contains "-Claude") -or ($args -contains "--claude")
    $DoAntigravity = $Antigravity.IsPresent -or ($args -contains "-Antigravity") -or ($args -contains "--antigravity")
    $DoOpenCode = $OpenCode.IsPresent -or ($args -contains "-OpenCode") -or ($args -contains "--opencode")
    $DoAll = $All.IsPresent -or ($args -contains "-All") -or ($args -contains "--all")

    $AnyToolSelected = $DoCursor -or $DoWindsurf -or $DoClaude -or $DoAntigravity -or $DoOpenCode -or $DoAll

    if (-not $AnyToolSelected) {
        if ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
            $actionLabel = if ($IsUninstall) { "dihapus / diuninstall" } else { "dipasang" }
            Write-Host "Pilih AI assistant yang ingin $actionLabel`:"
            Write-Host "  [1] Semua AI (Default)"
            Write-Host "  [2] Cursor IDE (.cursorrules)"
            Write-Host "  [3] Windsurf IDE (.windsurfrules)"
            Write-Host "  [4] Claude Code (CLAUDE.md)"
            Write-Host "  [5] Google Antigravity (Skills & Rules)"
            Write-Host "  [6] OpenCode (AGENTS.md & Commands)"
            $choice = Read-Host "Masukkan pilihan [1-6 atau pisahkan koma misal: 2,5] (Default: 1)"

            if (-not $choice -or $choice -match "1") {
                $DoCursor = $DoWindsurf = $DoClaude = $DoAntigravity = $DoOpenCode = $true
            } else {
                if ($choice -match "2") { $DoCursor = $true }
                if ($choice -match "3") { $DoWindsurf = $true }
                if ($choice -match "4") { $DoClaude = $true }
                if ($choice -match "5") { $DoAntigravity = $true }
                if ($choice -match "6") { $DoOpenCode = $true }
            }
        } else {
            # Default non-interaktif
            $DoCursor = $DoWindsurf = $DoClaude = $DoAntigravity = $DoOpenCode = $true
        }
    } elseif ($DoAll) {
        $DoCursor = $DoWindsurf = $DoClaude = $DoAntigravity = $DoOpenCode = $true
    }

    if ($IsUninstall) {
        if ($IsGlobal) {
            Write-Host "Menghapus konfigurasi secara global..."
            if ($DoCursor) {
                $p = Join-Path $UserHome ".cursorrules"
                if (Test-Path $p) { Remove-Item -Path $p -Force; Write-Host "  -> Dihapus: $p" }
            }
            if ($DoWindsurf) {
                $p = Join-Path $UserHome ".windsurfrules"
                if (Test-Path $p) { Remove-Item -Path $p -Force; Write-Host "  -> Dihapus: $p" }
            }
            if ($DoClaude) {
                $p = Join-Path $UserHome ".claude\CLAUDE.md"
                if (Test-Path $p) { Remove-Item -Path $p -Force; Write-Host "  -> Dihapus: $p" }
            }
            if ($DoOpenCode) {
                $p = Join-Path $UserHome ".config\opencode\AGENTS.md"
                if (Test-Path $p) { Remove-Item -Path $p -Force; Write-Host "  -> Dihapus: $p" }
                $cmdDir = Join-Path $UserHome ".config\opencode\commands"
                $SourceCommands = Join-Path $SourceDir "commands"
                if ((Test-Path $cmdDir) -and (Test-Path $SourceCommands)) {
                    Get-ChildItem -Path $SourceCommands | ForEach-Object {
                        $targetCmd = Join-Path $cmdDir $_.Name
                        if (Test-Path $targetCmd) { Remove-Item -Path $targetCmd -Force }
                    }
                    Write-Host "  -> Perintah OpenCode dibersihkan dari: $cmdDir"
                }
            }
            if ($DoAntigravity) {
                $GeminiRules = Join-Path $UserHome ".gemini\config\rules\corporate-rules.md"
                if (Test-Path $GeminiRules) { Remove-Item -Path $GeminiRules -Force; Write-Host "  -> Dihapus: $GeminiRules" }
                $GeminiSkills = Join-Path $UserHome ".gemini\config\skills"
                $SourceSkills = Join-Path $SourceDir "skills"
                if ((Test-Path $GeminiSkills) -and (Test-Path $SourceSkills)) {
                    Get-ChildItem -Path $SourceSkills -Directory | ForEach-Object {
                        $targetSkill = Join-Path $GeminiSkills $_.Name
                        if (Test-Path $targetSkill) { Remove-Item -Path $targetSkill -Recurse -Force }
                    }
                    Write-Host "  -> Skill Antigravity dibersihkan dari: $GeminiSkills"
                }
            }
            Write-Host "Selesai. Aturan global berhasil dihapus."
        } else {
            $ResolvedTarget = Resolve-Path $TargetDir -ErrorAction SilentlyContinue
            if (-not $ResolvedTarget) { $ResolvedTarget = $TargetDir }
            Write-Host "Menghapus konfigurasi dari: $ResolvedTarget"
            if ($DoCursor) {
                $p = Join-Path $ResolvedTarget ".cursorrules"
                if (Test-Path $p) { Remove-Item -Path $p -Force; Write-Host "  -> Dihapus: $p" }
            }
            if ($DoWindsurf) {
                $p = Join-Path $ResolvedTarget ".windsurfrules"
                if (Test-Path $p) { Remove-Item -Path $p -Force; Write-Host "  -> Dihapus: $p" }
            }
            if ($DoClaude) {
                $p = Join-Path $ResolvedTarget "CLAUDE.md"
                if (Test-Path $p) { Remove-Item -Path $p -Force; Write-Host "  -> Dihapus: $p" }
            }
            if ($DoOpenCode) {
                $p = Join-Path $ResolvedTarget "AGENTS.md"
                if (Test-Path $p) { Remove-Item -Path $p -Force; Write-Host "  -> Dihapus: $p" }
                $pCmd = Join-Path $ResolvedTarget ".opencode\commands"
                if (Test-Path $pCmd) { Remove-Item -Path $pCmd -Recurse -Force; Write-Host "  -> Dihapus: $pCmd" }
            }
            if ($DoAntigravity) {
                $pRules = Join-Path $ResolvedTarget ".agents\rules\corporate-rules.md"
                if (Test-Path $pRules) { Remove-Item -Path $pRules -Force; Write-Host "  -> Dihapus: $pRules" }
                $targetSkillsDir = Join-Path $ResolvedTarget ".agents\skills"
                $SourceSkills = Join-Path $SourceDir "skills"
                if ((Test-Path $targetSkillsDir) -and (Test-Path $SourceSkills)) {
                    Get-ChildItem -Path $SourceSkills -Directory | ForEach-Object {
                        $targetSkill = Join-Path $targetSkillsDir $_.Name
                        if (Test-Path $targetSkill) { Remove-Item -Path $targetSkill -Recurse -Force }
                    }
                    Write-Host "  -> Skill Antigravity dibersihkan dari: $targetSkillsDir"
                }
            }
            Write-Host "Selesai. Aturan lokal berhasil dihapus."
        }
        return
    }

    if ($IsGlobal) {
        Write-Host "Memasang aturan secara global..."

        if ($DoAntigravity) {
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
        }

        if ($DoClaude) {
            $ClaudeDir = Join-Path $UserHome ".claude"
            if (-not (Test-Path $ClaudeDir)) { New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null }
            $SourceClaude = Join-Path $SourceDir "adapters\CLAUDE.md"
            if (Test-Path $SourceClaude) {
                Copy-Item -Path $SourceClaude -Destination (Join-Path $ClaudeDir "CLAUDE.md") -Force
                Write-Host "  -> Claude Code: $ClaudeDir\CLAUDE.md"
            }
        }

        if ($DoOpenCode) {
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
        }

        if ($DoCursor) {
            $SourceCursor = Join-Path $SourceDir "adapters\.cursorrules"
            if (Test-Path $SourceCursor) {
                Copy-Item -Path $SourceCursor -Destination (Join-Path $UserHome ".cursorrules") -Force
                Write-Host "  -> Cursor global template: $UserHome\.cursorrules"
            }
        }

        if ($DoWindsurf) {
            $SourceWindsurf = Join-Path $SourceDir "adapters\.windsurfrules"
            if (Test-Path $SourceWindsurf) {
                Copy-Item -Path $SourceWindsurf -Destination (Join-Path $UserHome ".windsurfrules") -Force
                Write-Host "  -> Windsurf global template: $UserHome\.windsurfrules"
            }
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

        if ($DoCursor) {
            $CursorSource = Join-Path $SourceDir "adapters\.cursorrules"
            if (Test-Path $CursorSource) {
                Copy-Item -Path $CursorSource -Destination $ResolvedTarget -Force
                Write-Host "  -> .cursorrules (Cursor)"
            }
        }

        if ($DoWindsurf) {
            $WindsurfSource = Join-Path $SourceDir "adapters\.windsurfrules"
            if (Test-Path $WindsurfSource) {
                Copy-Item -Path $WindsurfSource -Destination $ResolvedTarget -Force
                Write-Host "  -> .windsurfrules (Windsurf)"
            }
        }

        if ($DoClaude) {
            $ClaudeSource = Join-Path $SourceDir "adapters\CLAUDE.md"
            if (Test-Path $ClaudeSource) {
                Copy-Item -Path $ClaudeSource -Destination $ResolvedTarget -Force
                Write-Host "  -> CLAUDE.md (Claude Code)"
            }
        }

        if ($DoOpenCode) {
            $AgentsSource = Join-Path $SourceDir "adapters\AGENTS.md"
            if (Test-Path $AgentsSource) { Copy-Item -Path $AgentsSource -Destination $ResolvedTarget -Force }
            $OpenCodeLocalCommands = Join-Path $ResolvedTarget ".opencode\commands"
            if (-not (Test-Path $OpenCodeLocalCommands)) { New-Item -ItemType Directory -Path $OpenCodeLocalCommands -Force | Out-Null }
            $SourceCommands = Join-Path $SourceDir "commands"
            if (Test-Path $SourceCommands) { Copy-Item -Path "$SourceCommands\*" -Destination $OpenCodeLocalCommands -Force }
            Write-Host "  -> AGENTS.md & .opencode/commands/ (OpenCode)"
        }

        if ($DoAntigravity) {
            $AgentSkills = Join-Path $ResolvedTarget ".agents\skills"
            $AgentRules = Join-Path $ResolvedTarget ".agents\rules"
            if (-not (Test-Path $AgentSkills)) { New-Item -ItemType Directory -Path $AgentSkills -Force | Out-Null }
            if (-not (Test-Path $AgentRules)) { New-Item -ItemType Directory -Path $AgentRules -Force | Out-Null }

            $SourceSkills = Join-Path $SourceDir "skills"
            if (Test-Path $SourceSkills) { Copy-Item -Path "$SourceSkills\*" -Destination $AgentSkills -Recurse -Force }
            $SourceRules = Join-Path $SourceDir "core\rules.md"
            if (Test-Path $SourceRules) { Copy-Item -Path $SourceRules -Destination (Join-Path $AgentRules "corporate-rules.md") -Force }
            Write-Host "  -> .agents/skills/ (Antigravity)"
        }

        Write-Host "Selesai. Aturan lokal berhasil dipasang."
    }
}
finally {
    if ($CleanupNeeded -and (Test-Path $TempDir)) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
