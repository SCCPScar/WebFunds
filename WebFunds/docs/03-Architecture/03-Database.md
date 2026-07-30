---
title: Database
version: 1.0.0
status: Approved
owner: Architecture
last_updated: 2026-07-19
---

# Database

> Every piece of information has one source of truth.

---

# Philosophy

The database stores facts.

Business rules belong to the Domain.

The database should remain predictable.

---

# Database Engine

PostgreSQL

Hosted on Supabase.

---

# Local Database

SQLite

Managed by Drift.

Works offline.

Synchronizes later.

---

# Main Tables

users

profiles

bank_connections

bank_accounts

financial_cycles

transactions

transaction_memories

dreams

dream_contributions

mysteries

subscriptions

receipts

receipt_items

notifications

merchant_aliases

categories

tags

transaction_tags

attachments

audit_logs

settings

weaver_insights

sync_queue

---

# Naming Convention

snake_case

Plural table names

UUID primary keys

created_at

updated_at

deleted_at

---

# IDs

Every entity uses UUID v4.

IDs never change.

---

# Soft Delete

Supported.

Records are marked.

Never immediately removed.

---

# Relationships

One User

↓

Many Bank Accounts

↓

Many Financial Cycles

↓

Many Transactions

↓

Many Memories

↓

Many Receipts

↓

Many Mysteries

---

# Audit

Important tables generate audit entries.

Audit records are immutable.

---

# Indexes

Transaction Date

Merchant

Category

Financial Cycle

Dream

Mystery

Status

Search

---

# Search

Uses PostgreSQL Full Text Search.

Future semantic search supported.

---

# Backup

Daily

Encrypted

Versioned

Restorable

---

# Migration Strategy

Every schema change requires:

Migration Script

Rollback Strategy

Version Number

Documentation

---

# Final Principle

The database stores reality.

Interpretation belongs to the Domain.