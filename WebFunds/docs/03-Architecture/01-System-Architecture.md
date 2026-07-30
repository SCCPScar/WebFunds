---
title: System Architecture
version: 1.0.0
status: Approved
owner: Architecture
last_updated: 2026-07-19
---

# System Architecture

> Simplicity at the edges. Intelligence at the center.

---

# Overview

WebFunds follows Clean Architecture principles.

Presentation Layer

↓

Application Layer

↓

Domain Layer

↓

Infrastructure Layer

↓

External Services

Each layer has a single responsibility.

Dependencies always point inward.

---

# Presentation Layer

Responsible for:

Pages

Widgets

Navigation

Animations

Accessibility

Localization

Theme

No business rules are allowed.

---

# Application Layer

Responsible for:

Use Cases

Commands

Queries

Validation

Orchestration

Permissions

Synchronization Flow

Communication between UI and Domain

---

# Domain Layer

Contains:

Entities

Value Objects

Repositories (Interfaces)

Business Rules

Financial Logic

Weaver Rules

Dream Rules

Mystery Rules

No Flutter code.

No Supabase code.

No HTTP code.

---

# Infrastructure Layer

Responsible for:

Supabase

Database

Storage

OCR

Authentication

Networking

Push Notifications

Logging

Caching

Repositories Implementation

---

# External Services

Millennium PSD2

Supabase

Anthropic Claude

OpenAI

Google ML Kit OCR

Apple Face ID

Apple Push Notifications

Future Integrations

---

# Main Modules

Authentication

Banking

Transactions

Dreams

Mysteries

Reports

Weaver

Notifications

Profile

Settings

Each module remains independent.

---

# Dependency Rules

UI depends on Application.

Application depends on Domain.

Infrastructure implements Domain interfaces.

Domain depends on nothing.

---

# Event Flow

Bank Synchronization

↓

Application

↓

Validation

↓

Domain

↓

Database

↓

Weaver Analysis

↓

UI Refresh

---

# Error Flow

Infrastructure Error

↓

Application

↓

User-friendly Error

↓

Optional Retry

↓

Logging

---

# Final Principle

The Domain is the heart.

Everything else exists to serve it.