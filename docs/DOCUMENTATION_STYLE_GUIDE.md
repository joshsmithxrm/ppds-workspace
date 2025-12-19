# Documentation Style Guide

**Ecosystem-wide documentation conventions for the PPDS project suite.**

---

## 🎯 Purpose

Ensures consistency, maintainability, and AI-readability across all documentation in the Power Platform Developer Suite ecosystem.

---

## 📛 File Naming

### SCREAMING_SNAKE_CASE Required

All documentation files use SCREAMING_SNAKE_CASE:

```
✅ GETTING_STARTED.md
✅ API_REFERENCE.md
✅ CLEAN_ARCHITECTURE_GUIDE.md
✅ VALUE_OBJECT_PATTERNS.md

❌ getting-started.md
❌ api-reference.md
❌ cleanArchitectureGuide.md
```

### File Name Suffixes

| Suffix | Purpose | Example |
|--------|---------|---------|
| `_GUIDE.md` | How-to, workflows, step-by-step | `GETTING_STARTED_GUIDE.md` |
| `_PATTERNS.md` | Reusable design patterns | `VALUE_OBJECT_PATTERNS.md` |
| `_REFERENCE.md` | Quick lookup, API docs | `PAC_CLI_REFERENCE.md` |
| `_STRATEGY.md` | High-level approach | `BRANCHING_STRATEGY.md` |

### Exceptions

| File | Reason |
|------|--------|
| `README.md` | Industry standard |
| `CHANGELOG.md` | Industry standard |
| `CLAUDE.md` | AI context file |
| `.github/pull_request_template.md` | GitHub convention (lowercase required) |

---

## 📝 Section Headers

### Emoji Prefixes

Use emoji prefixes for major sections in CLAUDE.md files:

| Emoji | Section Type |
|-------|-------------|
| 🚫 | NEVER rules |
| ✅ | ALWAYS rules |
| 💻 | Tech Stack |
| 📁 | Project/Folder Structure |
| 🛠️ | Commands |
| 🔄 | Workflows |
| 📦 | Version/Package Management |
| 🔀 | Git/Branch Strategy |
| 🚀 | Release Process |
| 🧪 | Testing |
| 🔗 | Ecosystem/Integration |
| 📋 | Key Files/Summary |
| 📚 | Documentation/References |
| ⚖️ | Decision Presentation |
| 🎯 | Purpose/Goals |
| 📛 | Naming Conventions |

### Header Levels

```markdown
# Document Title           (only one per doc)
## 🚫 Major Section        (emoji prefix)
### Subsection             (if needed)
#### Detail                (avoid if possible)
```

---

## ✅ Good/Bad Example Pattern

Use ✅/❌ prefixes for code examples:

```csharp
// ✅ Correct - Descriptive reason
public string? OptionalProperty { get; set; }

// ❌ Wrong - What's wrong with it
public string OptionalProperty { get; set; }
```

---

## 📊 Tables for Rules

Structure NEVER/ALWAYS rules as tables:

```markdown
## 🚫 NEVER

| Rule | Why |
|------|-----|
| Use `powershell.exe` | Requires PowerShell 7+ |
| Hardcode GUIDs | Breaks across environments |

## ✅ ALWAYS

| Rule | Why |
|------|-----|
| Use `pwsh` | Cross-platform PowerShell 7+ |
| Use config/queries | Environment-portable |
```

---

## 🔗 Cross-References

### Internal Links

```markdown
See [GETTING_STARTED_GUIDE.md](docs/GETTING_STARTED_GUIDE.md)
```

### Code References

Include file paths for code examples:

```markdown
See `src/domain/Environment.ts:45-67` for the implementation.
```

---

## 📏 Document Length

| Length | Recommendation |
|--------|---------------|
| < 400 lines | Single document, no Quick Reference needed |
| 400-800 lines | Add Quick Reference section at top |
| > 800 lines | Consider splitting into multiple documents |

---

## 🗂️ Folder Organization

```
docs/
├── README.md                    # Index/navigation
├── DOCUMENTATION_STYLE_GUIDE.md # This file
├── architecture/                # Design patterns (permanent)
│   ├── CLEAN_ARCHITECTURE_GUIDE.md
│   └── VALUE_OBJECT_PATTERNS.md
├── guides/                      # How-to docs (permanent)
│   └── GETTING_STARTED_GUIDE.md
├── reference/                   # API/CLI reference (permanent)
│   └── PAC_CLI_REFERENCE.md
├── strategy/                    # High-level approaches (permanent)
│   └── BRANCHING_STRATEGY.md
└── design/                      # Temporary design docs (DELETE after implementation)
```

---

## 🗑️ Documentation Lifecycle

### Permanent Documentation
- Architecture patterns
- Workflow guides
- Code quality standards
- Reference documentation

### Temporary Documentation (DELETE after use)
- Design documents → Delete after implementation complete
- Investigation reports → Delete after issue resolved
- Migration guides → Delete after migration complete

**Rationale:** Outdated documentation wastes AI context tokens and creates confusion.

---

## ✅ Review Checklist

Before committing documentation:

- [ ] File uses SCREAMING_SNAKE_CASE
- [ ] CLAUDE.md has emoji section headers
- [ ] Examples use ✅/❌ pattern
- [ ] Rules use table format
- [ ] No dates in content (except CHANGELOG.md)
- [ ] Links use relative paths
- [ ] Code examples include file paths
