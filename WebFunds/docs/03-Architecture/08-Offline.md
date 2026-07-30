---
title: Offline Strategy
version: 1.0.0
status: Approved
owner: Architecture
last_updated: 2026-07-19
---

# Offline

> The application should remain useful without internet.

---

# Philosophy

Offline is a feature.

Not an error.

---

# Available Offline

Transactions

Dreams

Memories

Mysteries

Reports

Receipts

Search

Settings

Weaver History

---

# Limited Offline

Bank Synchronization

Push Notifications

Cloud Backup

AI Cloud Models

---

# Local Storage

SQLite (Drift)

Encrypted Storage

Image Cache

Receipt Cache

Search Index

---

# Queue

Every write operation is queued.

Examples

Create Memory

Update Category

Resolve Mystery

Create Dream

Add Receipt

The queue synchronizes later.

---

# Conflict Resolution

Owner changes have priority.

Conflicts require audit history.

No silent overwrites.

---

# Connectivity States

Online

↓

Limited

↓

Offline

↓

Synchronizing

---

# UI Indicators

Offline Banner

Sync Indicator

Pending Changes Badge

Retry Button

---

# Synchronization Recovery

Automatic

Manual Retry

Partial Recovery

Conflict Detection

---

# Final Principle

Loss of internet must never mean loss of productivity.