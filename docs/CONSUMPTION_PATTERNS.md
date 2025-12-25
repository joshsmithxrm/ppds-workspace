# PPDS Consumption Patterns

When to use library, CLI, or PowerShell cmdlets for PPDS functionality.

---

## Architecture Layers

The PPDS ecosystem provides functionality at three layers:

```
┌─────────────────────────────────────────────────────────────┐
│  ppds-alm (CI/CD templates)                                 │
│  └── uses PPDS.Tools cmdlets                                │
├─────────────────────────────────────────────────────────────┤
│  PPDS.Tools (PowerShell module)                             │
│  └── wraps CLI tools via process invocation                 │
├─────────────────────────────────────────────────────────────┤
│  CLI Tools (dotnet tools)                                   │
│  ├── ppds-migrate (PPDS.Migration.Cli)                      │
│  └── invokes library APIs                                   │
├─────────────────────────────────────────────────────────────┤
│  Libraries (NuGet packages)                                 │
│  ├── PPDS.Migration                                         │
│  ├── PPDS.Dataverse                                         │
│  └── PPDS.Plugins                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## When to Use Each Layer

### Library (NuGet Package Reference)

**Use when:**
- Building a custom C# application
- Need programmatic control over operations
- Want to extend or customize behavior
- Composing with other .NET code
- Writing a reference implementation

**Examples:**
```csharp
// Custom migration app with business logic
var migrator = new DataverseMigrator(connection);
var result = await migrator.ExportAsync(options);
// Custom post-processing, integration with other systems
```

**Lifecycle:** Direct PackageReference. You're coupled to library API. Update code when API changes.

---

### CLI Tool (dotnet tool install)

**Use when:**
- Running operations without writing code
- Need a stable, versioned interface
- Working in a shell (bash, cmd, pwsh)
- Want self-documenting commands (`--help`)
- Learning how to use the library (CLI as reference implementation)

**Examples:**
```bash
dotnet tool install -g PPDS.Migration.Cli
ppds-migrate export --connection "$CONN" --entities account,contact --output ./data
ppds-migrate import --connection "$CONN" --input ./data --dry-run
```

**Lifecycle:** Install a tool version. CLI maintains backwards-compatible flags. Library can change internally.

---

### PowerShell Cmdlets (PPDS.Tools)

**Use when:**
- Scripting in PowerShell
- Want PowerShell-native features (pipeline, `-WhatIf`, parameter sets)
- Want consistency with other PPDS cmdlets
- Running in ALM workflows

**Examples:**
```powershell
Import-Module PPDS.Tools
Invoke-DataverseMigration -Export -Entities account,contact -Output ./data
Invoke-DataverseMigration -Import -Input ./data -WhatIf
```

**Lifecycle:** Tools declares minimum CLI version. Tools handles CLI installation and invocation details.

---

### ALM Workflows (ppds-alm)

**Use when:**
- Automating in CI/CD (GitHub Actions, Azure DevOps)
- Want declarative, reusable pipelines
- Don't want to write PowerShell/bash scripts

**Examples:**
```yaml
jobs:
  migrate:
    uses: joshsmithxrm/ppds-alm/.github/workflows/data-migrate.yml@v1
    with:
      environment-url: 'https://myorg.crm.dynamics.com'
    secrets:
      client-id: ${{ secrets.CLIENT_ID }}
```

**Lifecycle:** Pin to version tags. Update refs when upgrading.

---

## Decision Matrix

| Scenario | Consume | Why |
|----------|---------|-----|
| Build custom C# migration app | Library | Full control, in-process, can extend |
| Learn how to use the library | Read CLI source | CLI is the reference implementation |
| Run migrations from terminal | CLI | Simple, self-documenting |
| Script migrations in PowerShell | Tools cmdlets | PowerShell-native UX |
| Automate in CI/CD | ALM workflows (via Tools) | Declarative, reusable |
| Quick one-off migration | CLI | No code needed |
| Embed migrations in larger C# system | Library | Compose with other logic |

---

## Why Tools Wraps CLI (Not Library)

See [ADR-0001 in ppds-tools](https://github.com/joshsmithxrm/ppds-tools/blob/main/docs/adr/0001_CLI_WRAPPER_PATTERN.md) for full rationale.

**Summary:**
- **Process isolation** - No .NET assembly loading conflicts in PowerShell
- **Stable interface** - CLI flags are a stable contract; library APIs may evolve faster
- **Simpler dependencies** - CLI is a single tool install, not NuGet package chain
- **Consistent behavior** - Same code path whether user runs CLI directly or via PowerShell

---

## Why ALM Uses Tools (Not CLI Directly)

- **Consistency** - ALM uses Tools for plugin operations; migrations should follow same pattern
- **Orchestration** - Tools can combine operations, add logging, handle errors consistently
- **Single abstraction** - One set of docs, one interface for all PPDS operations
- **PAC CLI is the exception** - External Microsoft tool with its own lifecycle; we don't control it

---

## Version Coordination

Each layer declares minimum versions of its dependencies:

| Layer | Depends On | Declared Where |
|-------|------------|----------------|
| ALM workflows | PPDS.Tools | Workflow `Install-Module` command |
| PPDS.Tools | PPDS.Migration.Cli | `Get-PpdsMigrateCli` helper |
| CLI | PPDS.Migration library | PackageReference in csproj |

Breaking changes flow upward:
1. Library breaks → CLI updates → Tools updates → ALM updates
2. CLI flags break → Tools updates → ALM updates
3. Tools cmdlets break → ALM updates

See [VERSIONING_POLICY.md](./VERSIONING_POLICY.md) for version sync rules.
