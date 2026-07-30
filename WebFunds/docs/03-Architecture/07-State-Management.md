---
title: State Management
version: 1.0.0
status: Approved
owner: Architecture
last_updated: 2026-07-19
---

# State Management

> Predictable state creates predictable software.

---

# Philosophy

Application state should always have a single source of truth.

Business state must never live inside Widgets.

UI reacts to state.

State never reacts to UI.

---

# Official Library

Riverpod

---

# State Categories

Application State

↓

Feature State

↓

Widget State

---

# Application State

Authentication

Theme

Language

Navigation

Connectivity

Synchronization

Notifications

Settings

---

# Feature State

Transactions

Financial Cycles

Dreams

Mysteries

Receipts

Reports

Weaver

Subscriptions

Profile

---

# Widget State

Scroll Position

Animations

Selected Tab

Text Editing

Focus

Temporary Filters

---

# Rules

Never expose database models directly.

Always expose Domain Models.

State must be immutable.

Updates create new instances.

---

# Async States

Loading

Success

Error

Empty

Offline

Every screen supports all five states.

---

# Provider Naming

transactionProvider

dreamProvider

cycleProvider

weaverProvider

Never abbreviate.

---

# Caching

Repositories cache locally.

Providers cache UI state.

Synchronization refreshes data.

---

# Error Handling

Errors remain local.

Unexpected errors are logged.

Recoverable errors provide retry.

---

# Final Principle

State should be easy to understand by simply reading its provider.