# Agentic AI Workflow

**Patterns and practices for AI-assisted software development.**

This document captures lessons learned from building the PPDS ecosystem with agentic AI. It's a living document that evolves with practice.

---

## Philosophy

### Why This Exists

A single architect can now design and implement substantial systems by leveraging AI agents. This changes the economics of software development - but only if you work *with* the AI effectively.

This isn't about replacing human judgment. It's about:
- Offloading mechanical work to AI
- Maintaining architectural control
- Building systems that are maintainable long-term
- Creating foundations that support iteration

### Core Principles

1. **AI executes, you architect** - You make design decisions. AI implements them.
2. **Context is king** - AI without context produces generic solutions. Invest in CLAUDE.md.
3. **Iterate from use** - Don't over-design upfront. Build, use, refine.
4. **Document decisions, not just code** - Future you (and future AI) need to know *why*.

---

## CLAUDE.md Patterns

CLAUDE.md is not documentation - it's **instructions**. It tells the AI how to work in your codebase.

### What Makes a Good CLAUDE.md

| Section | Purpose | Example |
|---------|---------|---------|
| **Project Overview** | 1-2 sentences on what this is | "NuGet package for plugin registration" |
| **Tech Stack** | Technologies and versions | .NET 4.6.2/6.0/8.0, C# |
| **Project Structure** | Directory tree | Where things live |
| **Commands** | Copy-paste ready | `dotnet build`, `npm test` |
| **Conventions** | Naming, patterns | `Verb-Dataverse<Noun>` |
| **NEVER** | Anti-patterns | Things the AI should never do |
| **ALWAYS** | Required patterns | Things the AI must do |
| **Testing Requirements** | What's required before PR | Coverage targets, test commands |
| **Decision Presentation** | How to present choices | Lead with recommendation |

### NEVER/ALWAYS Structure

The most valuable sections. These prevent mistakes.

```markdown
## NEVER (Non-Negotiable)

| Rule | Why |
|------|-----|
| `Console.WriteLine` in plugins | Sandbox blocks it; use `ITracingService` |
| Hardcoded GUIDs | Breaks across environments |

## ALWAYS (Required Patterns)

| Rule | Why |
|------|-----|
| `ITracingService` for debugging | Only way to get runtime output |
| Early-bound entities | Compile-time type checking |
```

### Evolution Pattern

CLAUDE.md grows from corrections, not upfront design:

1. AI makes a mistake
2. You correct it
3. You add a rule to prevent recurrence
4. Repeat

Don't try to anticipate everything. Add rules when you see patterns of mistakes.

### Multi-Repo Pattern

For ecosystems with multiple repositories:

- **Parent CLAUDE.md**: Cross-cutting concerns, navigation, release coordination
- **Child CLAUDE.md**: Project-specific commands, conventions, patterns
- **Don't repeat**: Reference parent for shared patterns

```markdown
**Part of the PPDS Ecosystem** - See `C:\VS\ppds\CLAUDE.md` for cross-project context.
```

---

## Project Setup Checklist

When starting a new project, create these:

### Minimum Viable Setup

- [ ] `CLAUDE.md` with project overview, tech stack, structure, commands
- [ ] `.gitignore` appropriate for tech stack
- [ ] `README.md` for humans (what is this, how to install/use)
- [ ] Basic directory structure

### Add When Needed

- [ ] NEVER/ALWAYS sections (after first AI mistakes)
- [ ] Testing requirements (when tests exist)
- [ ] Architecture docs (when patterns emerge)
- [ ] Troubleshooting guide (when issues recur)

### Don't Create Upfront

- Elaborate templates
- Comprehensive documentation
- Complex tooling

Build the minimum, iterate from use.

---

## Multi-Repo Coordination

### Workspace Setup

For multi-repo ecosystems, use a parent workspace folder:

```
ppds/                          # Parent workspace (not a git repo)
├── CLAUDE.md                  # Cross-project context
├── ppds.code-workspace        # VS Code workspace file
├── extension/                 # Git repo
├── sdk/                       # Git repo
├── tools/                     # Git repo
└── alm/                       # Git repo
```

### Git Worktrees

For long-running feature branches, use worktrees instead of switching branches:

```powershell
# Create worktree for feature branch
git worktree add ../extension-plugin-registration feature/plugin-registration

# List worktrees
git worktree list

# Remove when done
git worktree remove ../extension-plugin-registration
```

Benefits:
- Keep multiple branches checked out simultaneously
- No stashing/switching overhead
- Each worktree can have its own VS Code window

---

## Session Location

Where you start your Claude Code session determines your context.

### When to Start in Parent Workspace

Start in `ppds/` when:
- Work spans multiple repositories
- You need cross-project context
- Exploring how components integrate
- Updating ecosystem documentation

### When to Start in Child Repo

Start in the specific repo (e.g., `sdk/`) when:
- All work is scoped to that project
- You need project-specific CLAUDE.md context
- Git operations are for that repo

### The Rule

**Start where your primary context needs to be.**

| Task Type | Session Location | Why |
|-----------|------------------|-----|
| SDK feature | `sdk/` | SDK-specific patterns and commands |
| Cross-repo feature | `ppds/` | Need visibility into multiple repos |
| Extension panel | `extension/` | Extension-specific architecture |
| Coordinated release | `ppds/` | Cross-project orchestration |

---

## Testing Philosophy

Different project types need different testing approaches.

### Libraries (SDK)

- **Target 80% coverage** (guideline, not gate)
- Unit tests for public API
- Tests must pass before PR
- `dotnet test`

### Tools (PowerShell Modules)

- **Target 80% coverage** (guideline, not gate)
- Pester tests for public cmdlets
- Mock external dependencies
- `Invoke-Pester ./tests`

### CI/CD Templates (ALM)

- **Cannot be unit tested** - they must run in real CI/CD
- YAML linting (`actionlint`)
- Manual verification against test repo
- Document the verification process

### Applications (Extension)

- Domain: 80%+ coverage
- Complex orchestration: 70%+ coverage
- Integration tests for panels
- E2E tests for critical flows

### When to Skip Tests

- Prototypes and experiments
- One-off scripts
- Documentation-only changes

But: If it's going to production, it needs tests.

---

## Context Preservation

The biggest challenge with AI-assisted development: alignment conversations eat context, leaving nothing for execution.

### The Pattern That Solves This

**Write decisions to a file before executing.**

```
1. Alignment conversation → decisions made
2. Write EXECUTION_SPEC.md capturing decisions
3. Execute against the spec
4. Agents can READ the spec for context
5. Delete spec when done (git history preserves it)
```

### Execution Spec Template

Keep it minimal. This is NOT a design document - it's a context checkpoint.

```markdown
# [Feature Name]

## Context
[1-2 sentences: Why are we doing this?]

## Decisions
| Decision | Choice | Why |
|----------|--------|-----|
| ... | ... | ... |

## Scope
- **In**: [What we're building]
- **Out**: [Explicitly NOT building]

## Acceptance Criteria
- [ ] ...
- [ ] ...

## Open Questions
[Resolve before implementing - or delete section if none]
```

### Spec Location

| Work Type | Spec Lives In |
|-----------|---------------|
| Single-repo feature | That repo's root (e.g., `sdk/EXECUTION_SPEC.md`) |
| Cross-repo feature | Parent workspace (`ppds/docs/EXECUTION_SPEC.md`) |

### Spec Lifecycle

1. **Create**: After alignment, before implementation
2. **Use**: Reference during implementation; agents read it for context
3. **Delete**: After PR merged (git history preserves it)

**Why delete?** Stale specs mislead. The implementation is the real documentation now.

### When to Write a Spec

| Scenario | Write Spec? |
|----------|-------------|
| Trivial task (< 30 min) | No |
| Non-trivial, single session, won't forget | Optional |
| Non-trivial, might span sessions | Yes |
| Delegating to agents | Yes |
| Cross-repo coordination | Yes |

### When to Skip

- Small, single-session tasks
- Work you'll complete immediately
- Simple changes with clear scope

---

## Working With Agents

### Agent Usage by Phase

| Phase | Use Agents? | Why |
|-------|-------------|-----|
| **Exploration** | ✅ Yes | Gather context efficiently before or during design |
| **Design/Alignment** | ❌ No | Design is conversation - requires iteration and judgment |
| **Writing Spec** | ❌ No | You're capturing the conversation you just had |
| **Implementation** | ✅ Sometimes | Parallel independent work benefits from agents |
| **Review** | ✅ Yes | Code review agents can help |

### Why Not Agents for Design?

Design is fundamentally a **conversation**. It requires:
- Back-and-forth iteration
- Clarifying questions you need to answer
- Human judgment on trade-offs
- Building on previous context

Agents can't do this. They execute a task and return - no iteration, no follow-up questions.

### When Agents Excel

- **Exploration**: "Find all authentication handlers across repos"
- **Parallel implementation**: Independent tasks that don't depend on each other
- **Cross-repo work**: Multiple agents working in different repos simultaneously
- **Mechanical tasks**: Renaming, reformatting, applying patterns

### When to Do It Yourself

- Small sequential edits
- Work requiring full conversation context
- Tasks where agent overhead exceeds time saved
- Design decisions

### Agent Context Problem

Agents don't have your conversation context. Solve this by:

1. Writing spec files that agents can read
2. Including necessary context in the agent prompt
3. Doing context-heavy work yourself

### Decision Presentation

Configure AI to present choices effectively:

```markdown
## Decision Presentation

When presenting choices or asking questions:
1. **Lead with your recommendation** and rationale
2. **List alternatives considered** and why they're not preferred
3. **Ask for confirmation**, not open-ended input

❌ "What testing approach should we use?"
✅ "I recommend X because Y. Alternatives considered: A (rejected because B), C (rejected because D). Do you agree?"
```

This saves time and produces better decisions.

---

## Complete Design-to-Implementation Workflow

Putting it all together:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. START SESSION                                            │
│    • Single-repo work → Start in child repo                 │
│    • Cross-repo work → Start in parent workspace            │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. EXPLORATION (Agents OK)                                  │
│    • "Find all places we handle X"                          │
│    • "What patterns does Y use?"                            │
│    • Gather context before design decisions                 │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. DESIGN CONVERSATION (No Agents)                          │
│    • Discuss approach with Claude directly                  │
│    • Iterate on trade-offs                                  │
│    • Make decisions together                                │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. WRITE SPEC (if non-trivial)                              │
│    • Minimal EXECUTION_SPEC.md                              │
│    • Single-repo → child repo                               │
│    • Cross-repo → ppds/docs/                                │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. IMPLEMENT (Agents for parallel work)                     │
│    • Sequential work → Do directly                          │
│    • Parallel independent tasks → Use agents                │
│    • Agents read spec for context                           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. CLEANUP                                                  │
│    • Delete EXECUTION_SPEC.md after PR merged               │
│    • Git history preserves it                               │
│    • Add CLAUDE.md rules if AI made repeated mistakes       │
└─────────────────────────────────────────────────────────────┘
```

### Same Session or New Session?

| Scenario | Recommendation |
|----------|----------------|
| Design + implement in one sitting | Same session (context preserved) |
| Long design, need break | Write spec, can resume or start fresh |
| Delegating implementation to agents | Agents read spec |
| Context feels exhausted | Write spec, start fresh session |

The spec file is your checkpoint. With a spec, you can always resume.

---

## Anti-Patterns

### What Doesn't Work

| Anti-Pattern | Why It Fails | Instead |
|--------------|--------------|---------|
| **Elaborate upfront templates** | Projects differ too much | Minimal start, iterate |
| **Generic documentation** | AI needs specific instructions | CLAUDE.md with concrete rules |
| **Hoping AI knows your patterns** | It doesn't | Document in NEVER/ALWAYS |
| **Long alignment, no execution** | Context exhausted | Write spec file, then execute |
| **Treating AI as autonomous** | You're the architect | Clear direction, review output |
| **Using agents for design** | Design needs conversation | Do design directly with Claude |
| **Detailed design docs** | Become stale, waste effort | Minimal spec, delete after merge |
| **Specs that live forever** | Mislead when outdated | Delete after PR merged |

### Signs You're Off Track

- AI keeps making the same mistakes → Missing CLAUDE.md rules
- Spending more time correcting than building → Step back, document patterns
- Losing context mid-task → Write spec files
- AI solutions don't fit your architecture → Need clearer constraints

---

## Evolution

This document will evolve. Update it when:

- You discover a pattern that works
- You find an anti-pattern to avoid
- Your workflow changes
- You learn something from a mistake

The best practices are the ones you actually use.
