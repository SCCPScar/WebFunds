# WebFunds - Sprint 01 Kickoff

> This document starts Sprint 01.
>
> Read it completely before writing any code.

---

# Mission

You are joining an existing software project.

This is NOT a prototype.

This is NOT a coding challenge.

This is NOT an experiment.

You are becoming part of the engineering team responsible for building WebFunds.

Your responsibility is to deliver production-quality software.

---

# Before Anything Else

Read the project documentation in the following order:

1. .claude/MASTER_PROMPT.md
2. .claude/CURRENT_SPRINT.md
3. PROJECT_BIBLE.md
4. README.md
5. ROADMAP.md
6. docs/
7. database/
8. design/
9. blueprints/
10. ai/

Do not skip any step.

If documentation conflicts exist, stop and report them.

Never silently choose one version.

---

# First Task

Before writing code:

Perform a complete architectural review.

Create a report containing:

- Folder structure validation
- Missing documentation
- Duplicate documentation
- Architecture inconsistencies
- Security concerns
- Performance concerns
- Flutter best-practice suggestions
- Supabase best-practice suggestions

Only after presenting this report may implementation begin.

---

# Development Strategy

Work in small iterations.

Never generate the entire application at once.

Always finish one milestone before starting another.

At the end of every milestone:

- summarize what was completed;
- explain architectural decisions;
- list any trade-offs;
- identify risks;
- suggest the next milestone.

---

# Scope of Sprint 01

Sprint 01 is strictly limited to the technical foundation.

Allowed work:

- Flutter project creation
- Feature-first folder structure
- Clean Architecture setup
- Riverpod
- GoRouter
- Flutter Hooks (if justified)
- Theme configuration
- Light theme
- Dark theme
- Spider-Man inspired theme tokens
- Bootstrap Icons
- Google Fonts
- Splash Screen
- Login Screen
- Face ID / Local Authentication
- Supabase initialization
- Drift initialization
- Environment configuration
- Dependency Injection
- Logging
- Error handling foundation
- Basic testing infrastructure
- Lint configuration

---

# Forbidden During Sprint 01

Do NOT implement:

- Dashboard
- Transactions
- Financial Cycles
- Millennium integration
- Reports
- Dreams
- Mysteries
- Notifications
- OCR
- AI features
- Weaver
- Budgets
- Categories
- Charts

If implementation requires any of those, create extension points only.

---

# Coding Standards

Follow existing documentation.

Prefer composition over inheritance.

Prefer immutable models.

Avoid global mutable state.

Avoid unnecessary packages.

Keep files small.

Prefer readable code.

Avoid clever abstractions.

Document public APIs.

Follow SOLID.

Follow Clean Architecture.

Use Feature First organization.

---

# UI Principles

The application targets iPhone first.

Dark Mode is the primary experience.

The visual identity is inspired by Spider-Man.

The style should be:

- premium
- elegant
- youthful
- modern
- clean
- trustworthy

Never create a childish interface.

Never use emoji as UI elements.

Use Bootstrap Icons.

Animations must be subtle.

Accessibility is mandatory.

---

# Security

Never store banking credentials.

Never log sensitive data.

Never expose API keys.

Prepare secure storage.

Prepare biometric authentication.

Prepare encrypted local storage.

---

# Database

Do not modify the documented schema.

If changes are required:

Stop.

Explain why.

Propose an ADR.

Wait for approval.

---

# AI

AI must not be implemented during Sprint 01.

Only prepare extension points.

---

# Git Workflow

Work incrementally.

Each logical step should be treated as an independent commit.

Example:

- chore: initialize flutter project
- feat: configure riverpod
- feat: configure routing
- feat: implement login screen

---

# Communication Style

When responding:

1. Explain your reasoning.
2. Present the implementation plan.
3. Wait if architectural clarification is required.
4. Implement.
5. Summarize.
6. Suggest next steps.

Never jump directly into code.

---

# Definition of Done

Sprint 01 is complete only when:

- Flutter project builds successfully.
- Android runs successfully.
- iOS project is configured.
- Theme works.
- Navigation works.
- Login screen opens.
- Face ID integration is prepared.
- Supabase initializes successfully.
- Drift initializes successfully.
- No analyzer warnings remain.
- No TODOs remain.
- Folder structure matches documentation.
- Documentation is updated if necessary.

---

# Quality Over Speed

Never optimize for speed.

Optimize for maintainability.

Every decision should improve the project.

Imagine this application will be maintained for the next ten years.

---

# Final Instruction

You are expected to behave like a senior engineer working on a long-term product.

If something is unclear:

Do not guess.

Ask.

If you believe documentation can be improved:

Propose improvements before implementing them.

The quality of the architecture is more important than the quantity of code.

Begin by auditing the repository and presenting your implementation plan.

Do not write any code until the audit is complete.