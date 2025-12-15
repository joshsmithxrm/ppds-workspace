# ppds-workspace

**Parent workspace for the PPDS (Power Platform Developer Suite) ecosystem.**

This repository contains cross-project coordination files and documentation for working with agentic AI across multiple repositories.

## What's Here

```
ppds/
├── CLAUDE.md                    # AI assistant instructions
├── README.md                    # This file
├── ppds.code-workspace          # VS Code multi-root workspace
├── docs/
│   └── AGENTIC-WORKFLOW.md      # Patterns for AI-assisted development
└── scripts/
    └── *.ps1                    # Utility scripts
```

## The PPDS Ecosystem

| Repository | Purpose |
|------------|---------|
| [power-platform-developer-suite](https://github.com/joshsmithxrm/power-platform-developer-suite) | VS Code extension |
| [ppds-sdk](https://github.com/joshsmithxrm/ppds-sdk) | NuGet packages (`PPDS.Plugins`) |
| [ppds-tools](https://github.com/joshsmithxrm/ppds-tools) | PowerShell module (`PPDS.Tools`) |
| [ppds-alm](https://github.com/joshsmithxrm/ppds-alm) | CI/CD templates |
| [ppds-demo](https://github.com/joshsmithxrm/ppds-demo) | Reference implementation |

## Usage

Clone this repo alongside the other PPDS repositories:

```
ppds/                          # This repo
├── extension/                 # power-platform-developer-suite
├── sdk/                       # ppds-sdk
├── tools/                     # ppds-tools
├── alm/                       # ppds-alm
└── demo/                      # ppds-demo
```

Then open `ppds.code-workspace` in VS Code for the full multi-root workspace.

## Why This Exists

When working with agentic AI across multiple repositories, you need:
- A place for cross-project AI instructions
- Documentation of patterns that work
- Coordination for ecosystem-wide changes

This repo provides that foundation.

## License

MIT
