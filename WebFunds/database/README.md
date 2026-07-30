# Database

> The database is the single source of truth for WebFunds.

---

## Purpose

This folder contains the complete database architecture for WebFunds.

Unlike the application source code, every database object is defined here before implementation.

Nothing is created directly in Supabase without first being documented.

---

## Goals

- Predictability
- Scalability
- Auditability
- Security
- Performance
- Offline-first synchronization
- AI-ready structure

---

## Structure

database/

README.md

SCHEMA.md

DATA_DICTIONARY.md

NAMING_CONVENTIONS.md

ERD.md

migrations/

functions/

triggers/

policies/

views/

seed/

---

## Principles

The database stores facts.

Business rules belong to the Domain.

AI never owns data.

Every important change is audited.

Every table has a clear responsibility.

---

## Database Engine

PostgreSQL

Hosted on Supabase.

---

## Local Database

SQLite (Drift)

Encrypted.

Offline-first.

---

## Migration Strategy

Every schema change requires:

- Migration
- Rollback
- Documentation
- Version Number

---

## Security

- Row Level Security
- Storage Policies
- JWT Authentication
- Encrypted Storage
- Audit Logs

---

## Final Principle

If the application disappears, the database should still tell the complete financial story.