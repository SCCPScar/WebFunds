---
title: Synchronization
version: 1.0.0
status: Approved
owner: Architecture
last_updated: 2026-07-19
---

# Synchronization

> Offline first. Online whenever possible.

---

# Philosophy

Synchronization must never surprise the owner.

Every imported change is auditable.

---

# Sources

Millennium

Manual Entries

Receipts

OCR

Settings

Dreams

Weaver Learning

---

# Direction

Bank

↓

Server

↓

Local Database

↓

UI

Owner Changes

↓

Queue

↓

Server

---

# Queue

Every pending operation is stored.

Operations execute sequentially.

Retry automatically.

---

# Conflict Resolution

Owner changes win.

Server history preserved.

Audit updated.

---

# Duplicate Detection

Transaction ID

Bank Reference

Amount

Date

Merchant

Confidence

---

# Sync States

Idle

Syncing

Completed

Failed

Paused

Offline

---

# Retry Strategy

1 minute

5 minutes

15 minutes

1 hour

Manual Retry

---

# Offline

All local operations remain available.

Synchronization resumes automatically.

---

# Security

Encrypted queue.

Authenticated requests.

Request signatures.

---

# Logging

Every synchronization stores:

Start

End

Duration

Items

Errors

Retries

---

# Success Criteria

Synchronization should be invisible when successful.

Transparent when it fails.

---

# Final Principle

The owner should never fear synchronization.