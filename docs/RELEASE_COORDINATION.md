# Release Coordination

Playbooks for coordinated releases across PPDS repos.

---

## Single-Repo Release (non-breaking)

1. Update version in manifest/csproj
2. Update CHANGELOG.md
3. Verify CI passes
4. Create PR, merge to main
5. Create GitHub Release with tag
6. Verify package published

---

## Cross-Repo Breaking Release

### Checklist

- [ ] Identify all affected repos
- [ ] Plan release order (SDK → Tools → ALM)
- [ ] Update compatibility matrix in this doc
- [ ] For each repo:
  - [ ] Update minimum version requirements
  - [ ] Update CHANGELOG with breaking change notes
  - [ ] Coordinate release timing
- [ ] Update ppds-demo to use new versions

---

## Scenario: SDK Breaking Change

Example: `PluginStepAttribute` adds required property

1. **SDK**
   - Bump to 2.0.0
   - Update CHANGELOG with migration guide
   - Release to NuGet

2. **Tools**
   - Update reflection code for new attribute
   - Bump to 2.0.0
   - Document: "Requires assemblies built with PPDS.Plugins 2.0+"
   - Release to PSGallery

3. **ALM**
   - Update `Install-Module` to `-MinimumVersion '2.0.0'`
   - Bump to 2.0.0
   - Tag and update `v2` alias

4. **Demo**
   - Update NuGet reference to SDK 2.0.0
   - Update workflow refs to ALM `@v2`

---

## Scenario: Tools New Feature (non-breaking)

Example: `Deploy-DataversePlugins` adds optional `-Parallel` switch

1. **Tools**
   - Bump to 1.3.0
   - Release to PSGallery

2. **ALM** (if using the feature)
   - Add workflow input for parallel option
   - Bump to 1.2.0
   - Update minimum Tools version to 1.3.0

3. **SDK/Demo**
   - No changes needed

---

## Scenario: ALM-Only Change

Example: New workflow for solution validation

1. **ALM**
   - Add new workflow
   - Bump minor version
   - Release

2. **Other repos**
   - No changes needed

---

## Pre-Release Coordination

### Testing a Tools pre-release in ALM

```yaml
# On ALM feature branch, temporarily:
- name: Install PPDS.Tools (prerelease)
  run: |
    Install-Module PPDS.Tools -AllowPrerelease -Force
```

### Testing an SDK pre-release in Tools

```powershell
# In Tools test environment:
dotnet tool install --global PPDS.Migration.Cli --prerelease
```

---

## Version Status Check

```powershell
# Check all repo versions from C:\VS\ppds
Get-ChildItem -Directory | Where-Object { Test-Path "$($_.FullName)\.git" } | ForEach-Object {
    $name = $_.Name
    $tag = git -C $_.FullName describe --tags --abbrev=0 2>$null
    [PSCustomObject]@{
        Repo = $name
        LatestTag = if ($tag) { $tag } else { "(none)" }
    }
} | Format-Table -AutoSize
```
