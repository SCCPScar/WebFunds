---
title: Finances
version: 1.0.0
status: Approved
owner: Product & Design
last_updated: 2026-07-19
related_documents:
  - Financial Cycles
  - Transactions
  - Categories
  - Mysteries
---

# Finances

> Every transaction tells part of your financial story.

---

# Purpose

The Finances screen is the complete history of the owner's financial activity.

Its purpose is to make every transaction easy to understand, categorize and remember.

Unlike a traditional bank statement, this screen provides context.

The owner should never ask:

"Where did this money go?"

---

# Screen Philosophy

The screen is organized around Financial Cycles.

Transactions are grouped by the active Financial Cycle by default.

Older cycles remain accessible.

The experience should encourage understanding instead of scrolling.

---

# Primary Goals

The owner should be able to:

• Review every transaction

• Understand spending

• Add Memories

• Attach receipts

• Correct categories

• Search instantly

• Filter information

• Detect unusual expenses

---

# Screen Layout

Header

↓

Financial Cycle Selector

↓

Quick Summary

↓

Filters

↓

Transaction List

↓

Floating Action Button

---

# Header

Displays:

Screen title

Current Financial Cycle

Search button

Filter button

---

# Financial Cycle Selector

Horizontal selector.

Displays:

Current Cycle

Previous Cycles

Archived Cycles

Changing cycles reloads only transaction data.

Navigation remains instant.

---

# Quick Summary

Displays four values.

Income

Expenses

Reserved

Available to Spend

These values always refer to the selected Financial Cycle.

---

# Filters

Available filters:

Income

Expense

Category

Merchant

Date

Amount

Reviewed

Needs Review

Mysteries

Receipt Attached

Memory Added

Subscriptions

Transfers

Multiple filters may be combined.

---

# Transaction List

Transactions are displayed chronologically.

Newest first.

Each card contains:

Merchant

Amount

Category

Date

Optional icon

Optional Memory indicator

Receipt indicator

AI confidence indicator

Review status

---

# Transaction Card

Touching the card opens Transaction Details.

Long press opens Quick Actions.

Swipe right:

Mark as reviewed.

Swipe left:

More actions.

---

# Transaction Details

Contains:

Merchant

Amount

Date

Time

Category

Payment Method

Bank Account

Location (future)

Receipt

Memory

AI Suggestions

History

Related Transactions

---

# Memories

The owner may attach:

Notes

Photos

Receipts

Voice notes (future)

Links (future)

Memories are permanent unless deleted.

---

# AI Suggestions

Weaver may suggest:

Category

Merchant

Subscription detection

Duplicate detection

Possible recurring payment

Estimated purchase type

Every suggestion requires owner confirmation.

---

# Receipt Support

Receipts may be:

Captured

Imported

Scanned

OCR analyzed

The original image is always preserved.

---

# Transaction Status

Possible states:

New

Reviewed

Needs Review

Mystery

Archived

---

# Floating Action Button

Default action:

Add Transaction

Long press:

Scan Receipt

Import Statement

Create Manual Income

Create Manual Expense

---

# Search

Search supports:

Merchant

Category

Amount

Memory

Notes

Receipt text (OCR)

Financial Cycle

---

# Empty State

Illustration

Title

Description

Primary Action

Connect Bank

Secondary Action

Create Manual Transaction

---

# Loading State

Skeleton cards.

Never show empty lists.

---

# Offline

Historical transactions remain accessible.

Editing is disabled until synchronization resumes.

---

# Error State

Individual cards may fail to load.

The rest of the screen remains available.

---

# Performance

Infinite scrolling.

Progressive loading.

Instant search.

Optimistic updates.

---

# Accessibility

VoiceOver

Dynamic Type

Large touch targets

Keyboard navigation on desktop

Reduced motion

---

# Future Features

Split transactions

Transaction tags

Shared expenses

Travel mode

Investments

Custom fields

Attachments

Maps

Merchant logos

---

# Success Criteria

The owner should identify any transaction within five seconds.

Adding a Memory should require no more than two taps.

Searching should feel instantaneous.

---

# Final Principle

The Finances screen should answer one simple question:

"Where did every Euro go?"