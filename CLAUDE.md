# PPDS Ecosystem - Claude Code Context

**Power Platform Developer Suite** - A multi-repository ecosystem for Power Platform development tooling.

---

## What This Is

Parent workspace for the PPDS ecosystem. Each subfolder is an independent git repository. This folder itself is NOT a git repo - it's a local workspace for coordinating cross-project work.

---

## Repositories

| Folder | Repository | Purpose |
|--------|------------|---------|
| `extension/` | [power-platform-developer-suite](https://github.com/joshsmithxrm/power-platform-developer-suite) | VS Code extension |
| `sdk/` | [ppds-sdk](https://github.com/joshsmithxrm/ppds-sdk) | NuGet packages (`PPDS.Plugins`) |
| `tools/` | [ppds-tools](https://github.com/joshsmithxrm/ppds-tools) | PowerShell module (`PPDS.Tools`) |
| `alm/` | [ppds-alm](https://github.com/joshsmithxrm/ppds-alm) | CI/CD templates for GitHub Actions & Azure DevOps |
| `demo/` | [ppds-demo](https://github.com/joshsmithxrm/ppds-demo) | Reference implementation |

### Extension Worktrees

| Folder | Branch | Feature |
|--------|--------|---------|
| `extension-plugin-registration/` | `feature/plugin-registration` | Plugin registration panel |
| `extension-solution-diff/` | `feature/solution-diff` | Solution diff viewer |
| `extension-deployment-settings/` | `feature/deployment-settings-promotion` | Deployment settings |

---

## When to Work From This Folder

Use the parent workspace (`C:\VS\ppds\`) for:
- Cross-project migrations or refactors
- Coordinated releases across multiple repos
- Debugging integration issues between projects
- Ecosystem-wide documentation updates
- Tasks that span multiple repositories

## When to Work From Child Folders

Use individual project folders for:
- Any work scoped to a single project
- Feature development, bug fixes, tests
- Project-specific documentation
- Normal development workflow

**Each child project has its own detailed CLAUDE.md** with project-specific rules, commands, and patterns.

---

## Cross-Project Conventions

### Naming
- **NuGet packages:** `PPDS.*` (e.g., `PPDS.Plugins`, `PPDS.Plugins.Abstractions`)
- **PowerShell module:** `PPDS.Tools`
- **PowerShell cmdlets:** `Verb-Dataverse<Noun>` (e.g., `Deploy-DataversePlugin`, `Get-DataverseAssembly`)
- **GitHub repos:** lowercase with hyphens (`ppds-sdk`, `ppds-tools`)

### Versioning
- All repos use SemVer
- Major versions stay in sync across ecosystem for compatibility
- Each repo has independent minor/patch versions

### Dependencies
```
ppds-demo
├── references → ppds-sdk (NuGet)
├── uses → ppds-tools (PowerShell module)
└── uses → ppds-alm (CI/CD templates)

extension
└── independent (TypeScript/VS Code)
```

---

## Common Cross-Project Tasks

### Coordinated Release
When releasing a new major version across the ecosystem:
1. Update and tag `ppds-sdk` first (NuGet must publish)
2. Update and tag `ppds-tools` (PowerShell Gallery must publish)
3. Tag `ppds-alm` (templates reference specific versions)
4. Update `ppds-demo` to use new versions
5. Update `extension` if needed

### Version Compatibility Check
```powershell
# Check all repos are on compatible versions
cd C:\VS\ppds
Get-ChildItem -Directory | ForEach-Object {
    if (Test-Path "$($_.FullName)\.git") {
        Write-Host "$($_.Name):" -ForegroundColor Cyan
        git -C $_.FullName describe --tags --always 2>$null
    }
}
```

---

## Folder Structure

```
ppds/
├── CLAUDE.md                    # Cross-project AI instructions
├── README.md                    # Human-readable overview
├── ppds.code-workspace          # VS Code multi-root workspace
├── docs/
│   └── AGENTIC-WORKFLOW.md      # Patterns for AI-assisted development
├── scripts/                     # Utility scripts
│   ├── launch-workspace.ps1
│   └── launch-features.ps1
├── extension/                   # VS Code extension repo
├── sdk/                         # NuGet packages repo
├── tools/                       # PowerShell module repo
├── alm/                         # CI/CD templates repo
└── demo/                        # Reference implementation repo
```

**Note:** Extension worktrees (`extension-plugin-registration/`, etc.) are hidden from VS Code workspace but accessible in file system.

---

## Quick Commands

### Open Full Workspace in VS Code
```powershell
code C:\VS\ppds\ppds.code-workspace
```

### Check Status of All Repos
```powershell
Get-ChildItem C:\VS\ppds -Directory | Where-Object { Test-Path "$($_.FullName)\.git" } | ForEach-Object {
    Write-Host "`n$($_.Name):" -ForegroundColor Cyan
    git -C $_.FullName status -sb
}
```

### Pull All Repos
```powershell
Get-ChildItem C:\VS\ppds -Directory | Where-Object { Test-Path "$($_.FullName)\.git" } | ForEach-Object {
    Write-Host "`n$($_.Name):" -ForegroundColor Cyan
    git -C $_.FullName pull
}
```

---

## Decision Presentation

When presenting choices or asking questions:
1. **Lead with your recommendation** and rationale
2. **List alternatives considered** and why they're not preferred
3. **Ask for confirmation**, not open-ended input

❌ "What testing approach should we use?"
✅ "I recommend X because Y. Alternatives considered: A (rejected because B), C (rejected because D). Do you agree?"

