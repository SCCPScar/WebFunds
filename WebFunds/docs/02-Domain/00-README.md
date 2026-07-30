---
title: Domain
version: 1.0.0
status: Approved
owner: Product & Architecture
last_updated: 2026-07-19
---

# Domain

> The business rules behind WebFunds.

---

# Purpose

This folder defines the business domain of WebFunds.

Unlike Experience documents, which describe how the application behaves from the owner's perspective, Domain documents define the underlying concepts, rules and relationships.

Everything inside this folder should remain independent from the user interface.

The same rules should apply whether the application runs on iPhone, iPad, Desktop or future platforms.

---

# Principles

The domain is the single source of truth.

Business rules must never depend on UI components.

Every entity has a clearly defined lifecycle.

AI suggestions never modify domain data automatically.

Every important financial event is traceable.

---

# Main Entities

Financial Cycle

Transaction

Memory

Dream

Mystery

Bank Account

Income

Expense

Merchant

Category

Receipt

Subscription

Notification

Weaver Insight

---

# Relationships

Financial Cycles contain Transactions.

Transactions may contain Memories.

Transactions may generate Mysteries.

Dreams reserve available money.

Receipts belong to Transactions.

Subscriptions are inferred from Transactions.

Weaver analyzes all domain entities but never owns them.

---

# Design Goals

Predictable behavior.

Extensible architecture.

Auditability.

Offline-first compatibility.

Clear separation of responsibilities.

---

# Future Documents

01 Financial Cycles

02 Transactions

03 Memories

04 Dreams

05 Mysteries

06 Weaver

07 Banking

08 Subscriptions

09 Notifications

10 Reports

11 Rules

---

# Final Principle

The domain should remain stable even if the interface changes completely.