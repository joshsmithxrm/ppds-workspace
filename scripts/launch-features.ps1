# launch-features.ps1
# PPDS Feature Development Workspace - Windows Terminal 5-Pane Layout
#
# Layout:
# ┌─────────────┬─────────────┬─────────────┬─────────┐
# │             │             │             │  Demo   │
# │  Feature 1  │  Feature 2  │  Feature 3  ├─────────┤
# │             │             │             │  Root   │
# └─────────────┴─────────────┴─────────────┴─────────┘

$root = "C:\VS\ppds"

# ============================================================
# CONFIGURE FEATURES HERE - swap these as needed
# ============================================================
$feature1 = @{ Path = "$root\extension-plugin-registration"; Title = "Plugin Reg" }
$feature2 = @{ Path = "$root\extension-solution-diff";       Title = "Sol Diff" }
$feature3 = @{ Path = "$root\extension-deployment-settings"; Title = "Deploy Set" }
# ============================================================

# Delay: wait 1 second before launching claude to fix rendering bug
$delay = "cmd /k `"timeout /t 1 /nobreak >nul && claude`""

$wtArgs = @(
    # 1. Start with Feature 1 (will be leftmost)
    "-w 0 nt --title `"$($feature1.Title)`" -d `"$($feature1.Path)`" $delay",
    # 2. Create Demo/Root column on far right (25% width)
    "split-pane -V -s 0.25 --title `"Demo`" -d `"$root\demo`" $delay",
    # 3. Split Demo for Root below
    "split-pane -H --title `"Root`" -d `"$root`" $delay",
    # 4. Go back to Feature 1
    "move-focus left",
    # 5. Split Feature 1 to create Feature 2 + Feature 3 area (67% of left side)
    "split-pane -V -s 0.67 --title `"$($feature2.Title)`" -d `"$($feature2.Path)`" $delay",
    # 6. Split to create Feature 3 (50% of remaining)
    "split-pane -V -s 0.5 --title `"$($feature3.Title)`" -d `"$($feature3.Path)`" $delay",
    # 7. Move focus back to Feature 1
    "move-focus left",
    "move-focus left"
) -join " ; "

Write-Host "Launching PPDS feature workspace..." -ForegroundColor Cyan
Write-Host "wt $wtArgs" -ForegroundColor DarkGray

# Use cmd /c to avoid PowerShell alias conflicts
cmd /c "wt $wtArgs"
