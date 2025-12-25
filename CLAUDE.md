# PPDS Ecosystem - Claude Code Context

**Power Platform Developer Suite** - A multi-repository ecosystem for Power Platform development tooling.

---

## 📋 What This Is

Parent workspace git repository for the PPDS ecosystem. This repo tracks workspace-level files (documentation, scripts, workspace config). Each subfolder is an independent nested git repository with its own history.

---

## 📦 Repositories

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

## 🎯 When to Work From This Folder

Start your Claude Code session in `C:\VS\ppds\` when:
- **Cross-repo features** - Work spans multiple repositories
- **Ecosystem coordination** - Releases, migrations, refactors
- **Cross-project exploration** - Understanding how pieces fit together
- **Workspace documentation** - Updating docs/ in this repo

**Design specs for cross-repo work live here** in `docs/` (version controlled).

## 📁 When to Work From Child Folders

Start your Claude Code session in the child folder (e.g., `sdk/`) when:
- **Single-repo work** - Feature, bug fix, refactor in one project
- **You need project-specific context** - Child CLAUDE.md has detailed patterns
- **Git operations are for that repo** - Commits, branches, PRs

**Design specs for single-repo work live in that repo.**

**Each child project has its own detailed CLAUDE.md** with project-specific rules, commands, and patterns.

### Quick Reference

| Task | Start Session In | Spec Location |
|------|------------------|---------------|
| SDK feature | `sdk/` | `sdk/EXECUTION_SPEC.md` |
| Extension bug fix | `extension/` | `extension/EXECUTION_SPEC.md` |
| Cross-repo feature | `ppds/` | `ppds/docs/EXECUTION_SPEC.md` |
| Ecosystem release | `ppds/` | `ppds/docs/EXECUTION_SPEC.md` |

---

## 🚫 NEVER (Cross-Project)

| Rule | Why |
|------|-----|
| Mix changes across repos in one commit | Each repo has independent history |
| Push to main without PR | All repos use branch protection |
| Skip CHANGELOG.md updates | Release notes are required |
| Use inconsistent naming conventions | Ecosystem cohesion requires consistency |

---

## ✅ ALWAYS (Cross-Project)

| Rule | Why |
|------|-----|
| Use SCREAMING_SNAKE_CASE for doc files | Ecosystem-wide documentation standard |
| Use emoji section headers in CLAUDE.md | Consistent AI-first formatting |
| Use ✅/❌ patterns in examples | Clear good/bad distinction |
| Update all affected repos together | Cross-cutting changes need coordination |

---

## 📛 Cross-Project Naming Conventions

| Component | Convention | Example |
|-----------|------------|---------|
| NuGet packages | `PPDS.*` | `PPDS.Plugins`, `PPDS.Plugins.Abstractions` |
| PowerShell module | `PPDS.Tools` | - |
| PowerShell cmdlets | `Verb-Dataverse<Noun>` | `Deploy-DataversePlugin`, `Get-DataverseAssembly` |
| GitHub repos | lowercase with hyphens | `ppds-sdk`, `ppds-tools` |
| Documentation files | SCREAMING_SNAKE_CASE | `GETTING_STARTED.md`, `API_REFERENCE.md` |

---

## 📦 Versioning

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

## 🔌 Consumption Patterns (SDK/Tools/ALM)

**When to use each layer:**

| Layer | Use When | Example |
|-------|----------|---------|
| **Library** (NuGet) | Building C# apps, need programmatic control | `var migrator = new DataverseMigrator(conn);` |
| **CLI** (dotnet tool) | Running from terminal, learning the API | `ppds-migrate export --connection $CONN` |
| **Cmdlets** (PPDS.Tools) | PowerShell scripting, ALM workflows | `Invoke-DataverseMigration -Export` |
| **Workflows** (ppds-alm) | CI/CD automation | `uses: .../data-migrate.yml@v1` |

**Key architectural rules:**
- Tools wraps CLI (process invocation) - not library directly - for isolation
- ALM uses Tools (not CLI directly) - for consistency with plugin pattern
- CLI serves as reference implementation for library usage

See [CONSUMPTION_PATTERNS.md](docs/CONSUMPTION_PATTERNS.md) for full guidance.

---

## 🚀 Coordinated Release Process

When releasing a new major version across the ecosystem:

1. Update and tag `ppds-sdk` first (NuGet must publish)
2. Update and tag `ppds-tools` (PowerShell Gallery must publish)
3. Tag `ppds-alm` (templates reference specific versions)
4. Update `ppds-demo` to use new versions
5. Update `extension` if needed

---

## 🛠️ Quick Commands

### Check Version Compatibility

```powershell
# Check all repos are on compatible versions
Get-ChildItem C:\VS\ppds -Directory | ForEach-Object {
    if (Test-Path "$($_.FullName)\.git") {
        Write-Host "$($_.Name):" -ForegroundColor Cyan
        git -C $_.FullName describe --tags --always 2>$null
    }
}
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

### Open Full Workspace in VS Code

```powershell
code C:\VS\ppds\ppds.code-workspace
```

---

## 📁 Folder Structure

```
ppds/
├── CLAUDE.md                    # Cross-project AI instructions
├── README.md                    # Human-readable overview
├── ppds.code-workspace          # VS Code multi-root workspace
├── docs/
│   ├── CONSUMPTION_PATTERNS.md  # When to use library vs CLI vs PowerShell vs ALM
│   ├── VERSIONING_POLICY.md     # Cross-repo versioning rules
│   ├── RELEASE_COORDINATION.md  # Coordinated release playbooks
│   ├── AGENTIC_WORKFLOW.md      # Patterns for AI-assisted development
│   └── DOCUMENTATION_STYLE_GUIDE.md  # Documentation conventions
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

## 📚 Documentation References

- [CONSUMPTION_PATTERNS.md](docs/CONSUMPTION_PATTERNS.md) - When to use library vs CLI vs PowerShell vs ALM
- [VERSIONING_POLICY.md](docs/VERSIONING_POLICY.md) - Cross-repo versioning rules and compatibility
- [RELEASE_COORDINATION.md](docs/RELEASE_COORDINATION.md) - Coordinated release playbooks
- [AGENTIC_WORKFLOW.md](docs/AGENTIC_WORKFLOW.md) - Patterns for AI-assisted development
- [DOCUMENTATION_STYLE_GUIDE.md](docs/DOCUMENTATION_STYLE_GUIDE.md) - Documentation conventions for all repos

---

## ⚖️ Decision Presentation

When presenting choices or asking questions:
1. **Lead with your recommendation** and rationale
2. **List alternatives considered** and why they're not preferred
3. **Ask for confirmation**, not open-ended input

❌ "What testing approach should we use?"
✅ "I recommend X because Y. Alternatives considered: A (rejected because B), C (rejected because D). Do you agree?"
