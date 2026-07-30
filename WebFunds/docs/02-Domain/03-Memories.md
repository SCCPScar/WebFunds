---
title: Memories
version: 1.0.0
status: Approved
owner: Product & Architecture
last_updated: 2026-07-19
related_documents:
  - Transactions
  - Mysteries
  - Weaver
---

# Memories

> A transaction is remembered because of its story.

---

# Purpose

A Memory enriches a Transaction with human context.

Bank statements preserve numbers.

WebFunds preserves meaning.

A Memory explains why a transaction happened and why it mattered.

---

# Philosophy

People rarely remember amounts.

They remember moments.

Memories transform financial history into personal history.

---

# Definition

A Memory is an optional entity linked to exactly one Transaction.

It never exists independently.

Deleting a Transaction never permanently deletes its Memory.

Instead, the Memory becomes orphaned until restored or reassigned.

---

# Core Principles

A Memory never changes financial values.

A Memory only adds context.

Memories are always editable.

Every edit is recorded in audit history.

---

# Memory Structure

Required fields:

Memory ID

Transaction ID

Created At

Updated At

Author

Version

---

# Optional Fields

Title

Narrative

Mood

Photos

Receipt

Location

Tags

Weather (future)

Companions (future)

Voice Note (future)

---

# Title

Short description.

Examples:

First Day at New Job

Birthday Dinner

Weekend Trip

Christmas Shopping

New Laptop

---

# Narrative

Markdown supported.

Maximum length:

10,000 characters.

The owner writes naturally.

Examples:

"Today I finally bought the monitor I had been saving for."

"I had dinner with my parents after work."

---

# Photos

Supported formats:

JPEG

PNG

HEIC

WEBP

Multiple photos allowed.

Original files remain unchanged.

---

# Location

Optional.

Contains:

Latitude

Longitude

City

Country

Place Name

Location is never mandatory.

---

# Tags

Unlimited.

Examples:

Family

Travel

Work

Health

Gift

Holiday

---

# Mood

Optional emotional context.

Examples:

Happy

Excited

Proud

Relaxed

Neutral

Unexpected

Stressful

Mood is descriptive.

Never used for financial analysis.

---

# AI Assistance

Weaver may suggest:

Memory title

Summary

Related Memories

Similar purchases

Potential tags

Suggestions always require confirmation.

---

# Timeline

Every Memory records:

Created

Edited

Photo Added

Photo Removed

Narrative Updated

Tag Added

Tag Removed

Location Updated

---

# Search

Search indexes:

Title

Narrative

Tags

OCR

Merchant

Transaction

Location

AI Summary

---

# Privacy

Memories are encrypted.

Photos remain private.

No Memory data is shared externally without explicit owner action.

---

# Accessibility

VoiceOver

Dynamic Type

Reduced Motion

Keyboard Navigation

High Contrast

---

# Future Features

Voice Memories

Memory Timeline

Memory Collections

Photo Recognition

Travel Journals

Shared Memories

AI-generated Monthly Stories

---

# Success Criteria

A Memory should allow the owner to immediately remember the event behind a transaction.

Years later, a transaction should still make sense because its Memory preserves the context.

---

# Final Principle

Money is temporary.

Memories are lasting.