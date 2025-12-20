# PPDS Ecosystem Versioning Policy

Cross-repo versioning rules for the PPDS ecosystem.

---

## Version Sync Rules

| Rule | Description |
|------|-------------|
| Major versions sync | Breaking changes trigger coordinated major bump across affected repos |
| Minor/patch independent | Each repo releases independently for non-breaking changes |
| Document compatibility | Each repo documents minimum versions of dependencies |

---

## Dependency Flow

```
ppds-alm (CI/CD templates)
    │
    └── calls ──► ppds-tools (PowerShell module)
                      │
                      ├── reflects on ──► ppds-sdk (PPDS.Plugins)
                      │
                      └── shells to ──► ppds-sdk (PPDS.Migration.Cli)

ppds-demo (reference implementation)
    │
    ├── uses ──► ppds-alm workflows
    ├── uses ──► ppds-tools cmdlets
    └── references ──► ppds-sdk packages
```

---

## When to Sync Major Versions

| Scenario | Action |
|----------|--------|
| SDK changes `PluginStepAttribute` properties | SDK 2.0 → Tools 2.0 |
| Tools changes cmdlet signatures | Tools 2.0 → ALM 2.0 |
| Tools changes auth flow | Tools 2.0 → ALM 2.0 |
| ALM changes workflow inputs | ALM 2.0 only |

---

## Pre-release Conventions

| Repo | Mechanism | Example |
|------|-----------|---------|
| sdk | Git tag suffix | `v1.2.0-alpha1` |
| tools | Manifest field | `Prerelease = 'alpha1'` |
| alm | Git tag suffix (optional) | `v1.1.0-beta1` |

### Stages

| Stage | Format | Purpose |
|-------|--------|---------|
| Alpha | `-alphaN` | Early testing |
| Beta | `-betaN` | Feature complete |
| RC | `-rcN` | Release candidate |
| Stable | (no suffix) | Production |

---

## Compatibility Matrix

**Last updated:** 2024-12-19

| ALM | Tools (min) | SDK (min) |
|-----|-------------|-----------|
| 1.0.x | 1.1.0 | N/A |
| 1.1.x | 1.2.0 | N/A |

| Tools | PPDS.Plugins (min) | PPDS.Migration.Cli (min) |
|-------|-------------------|-------------------------|
| 1.1.x | 1.0.0 | N/A |
| 1.2.x | 1.0.0 | 1.0.0 |

---

## Release Order

For breaking changes, release in this order:

1. **ppds-sdk** - NuGet packages must publish first
2. **ppds-tools** - PowerShell module (may depend on SDK)
3. **ppds-alm** - Templates (depend on Tools)
4. **ppds-demo** - Update to use new versions
