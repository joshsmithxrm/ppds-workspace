# launch-workspace.ps1
# PPDS Development Workspace - Windows Terminal 5-Pane Layout
#
# Layout:
# ┌─────────────┬─────────────┬─────────────┐
# │             │    Demo     │    Tools    │
# │  Extension  ├─────────────┼─────────────┤
# │   (Main)    │    Root     │     SDK     │
# └─────────────┴─────────────┴─────────────┘

$root = "C:\VS\ppds"

# Build the wt command as a single string for cmd.exe
# This avoids PowerShell interpreting 'sp' as Set-ItemProperty
# Delay: wait 1 second before launching claude to fix rendering bug
$delay = "cmd /k `"timeout /t 1 /nobreak >nul && claude`""

$wtArgs = @(
    # 1. Start with Extension (main pane, left side)
    "-w 0 nt --title `"Extension`" -d `"$root\extension`" $delay",
    # 2. Split right 67% for Demo (top-middle placeholder)
    "split-pane -V -s 0.67 --title `"Demo`" -d `"$root\demo`" $delay",
    # 3. Split Demo horizontally - Root goes below Demo
    "split-pane -H --title `"Root`" -d `"$root`" $delay",
    # 4. Move focus up to Demo
    "move-focus up",
    # 5. Split Demo vertically - Tools goes right of Demo
    "split-pane -V -s 0.5 --title `"Tools`" -d `"$root\tools`" $delay",
    # 6. Move focus down to Root
    "move-focus down",
    # 7. Split Root vertically - SDK goes right of Root
    "split-pane -V -s 0.5 --title `"SDK`" -d `"$root\sdk`" $delay",
    # 8. Move focus back to Extension
    "move-focus left",
    "move-focus left"
) -join " ; "

Write-Host "Launching PPDS workspace..." -ForegroundColor Cyan
Write-Host "wt $wtArgs" -ForegroundColor DarkGray

# Use cmd /c to avoid PowerShell alias conflicts
cmd /c "wt $wtArgs"
