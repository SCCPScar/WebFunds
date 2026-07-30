---
title: Transactions
version: 1.0.0
status: Approved
owner: Product & Architecture
last_updated: 2026-07-19
related_documents:
  - Financial Cycles
  - Memories
  - Mysteries
  - Banking
  - Weaver
---

# Transactions

> Every Euro Has a Story.

---

# Purpose

A Transaction represents any financial movement recorded inside WebFunds.

Transactions are the primary source of truth for the application.

Every report, analysis, Dream, Mystery and AI insight ultimately originates from one or more Transactions.

A Transaction is much more than an amount of money.

It represents an event in the owner's financial life.

---

# Philosophy

Traditional banking applications record movements.

WebFunds preserves stories.

Every Transaction should eventually answer:

What happened?

Where?

Why?

How was it paid?

Was it expected?

How did it affect the owner's financial life?

---

# Core Principles

Transactions are immutable historical events.

Corrections generate audit history.

Nothing important is silently overwritten.

Every modification is traceable.

---

# Entity Definition

A Transaction represents one movement of money.

It may represent:

Income

Expense

Transfer

Refund

Adjustment

Fee

Interest

Investment (future)

Loan (future)

---

# Transaction Lifecycle

Imported

↓

Analyzed

↓

Reviewed

↓

Completed

↓

Archived

---

# Imported

Created by:

Bank synchronization

CSV import

Manual creation

API

OCR

---

# Analyzed

Weaver analyzes:

Merchant

Category

Possible Subscription

Possible Dream

Possible Mystery

Possible Duplicate

Confidence Score

---

# Reviewed

Owner confirms:

Merchant

Category

Amount

Date

Story

Optional Memory

---

# Completed

The Transaction becomes part of permanent financial history.

Statistics update.

Reports update.

Dreams update.

---

# Archived

Historical.

Read-only.

Never deleted automatically.

---

# Required Fields

Transaction ID

Financial Cycle ID

Account ID

Type

Amount

Currency

Transaction Date

Import Date

Status

Created At

Updated At

---

# Optional Fields

Merchant

Category

Subcategory

Description

Story

Memory

Receipt

Location

Latitude

Longitude

Tags

Reference Number

External Identifier

Notes

Attachments

---

# Transaction Types

Income

Expense

Transfer

Internal Transfer

Refund

Correction

Manual Adjustment

Fee

Interest

Cash Withdrawal

Deposit

Future types should remain compatible.

---

# Status

Pending

Imported

Needs Review

Reviewed

Completed

Archived

Mystery

Hidden

Deleted (logical only)

---

# Ownership

Every Transaction belongs to:

One Financial Cycle

One Primary Account

One Currency

Zero or more Memories

Zero or one Receipt

Zero or more Attachments

Zero or more AI Insights

---

# Relationships

Transaction

↓

Receipt

↓

Memory

↓

Story

↓

Mystery

↓

Dream Contribution

↓

Reports

---

# Identity

Every Transaction receives a permanent UUID.

This identifier never changes.

Bank identifiers are stored separately.

---

# Currency

Every Transaction stores:

Original Currency

Converted Currency (future)

Exchange Rate (future)

Display Currency

---

# Amount Rules

Amounts are always stored as positive values.

Direction is determined by Transaction Type.

Expense

↓

Negative effect

Income

↓

Positive effect

Transfers

↓

Neutral overall

---

# Date Rules

Each Transaction stores:

Transaction Date

Booking Date

Import Date

Creation Date

Last Modification

All timestamps use UTC internally.

---

# Merchant

Merchant is independent from the raw bank description.

Example

Raw:

PGT*CNTNT03452

Merchant:

Continente Braga

The owner always has the final word.

---

# Categories

Categories are independent from Merchants.

Example

Merchant:

Amazon

Possible Categories

Electronics

Books

Office

Home

Software

The owner confirms.

---

# Tags

Transactions may contain unlimited tags.

Examples

Vacation

Family

Health

Work

Taxes

Gift

Christmas

Tags never replace Categories.

---

# Transaction Story

## Purpose

The Transaction Story transforms a financial movement into a meaningful event.

Unlike traditional banking applications, WebFunds treats every transaction as a small chapter of the owner's financial history.

A Story is optional but strongly encouraged.

---

# Philosophy

Amounts fade from memory.

Stories remain.

Months or years later, the owner should immediately understand why the money was spent.

---

# Story Components

A Story may contain:

Title

Narrative

Photos

Receipt

Merchant

Location

People (future)

Tags

Related Dream

Related Financial Cycle

AI Summary

Attachments

Timeline

---

# Story Title

Optional.

Examples:

Weekly Groceries

Birthday Dinner

Gaming Upgrade

Portugal Trip

Office Setup

---

# Narrative

Markdown supported.

Maximum:

10,000 characters.

The owner writes naturally.

Example:

Today I bought groceries after work.

I also purchased cleaning products and ingredients for dinner.

---

# AI Summary

Weaver automatically generates a concise summary.

Example:

Weekly grocery shopping.

Estimated household purchase.

Confidence:

97%

The owner may edit or disable the summary.

---

# Photos

Supported formats:

JPEG

PNG

HEIC

WEBP

Future:

Live Photos

Each Story supports multiple images.

---

# Attachments

Supported:

PDF

Invoice

Warranty

Screenshot

Manual

Future formats should remain compatible.

---

# Timeline

Every Story records:

Transaction Imported

Receipt Attached

Memory Added

Story Edited

Merchant Confirmed

Category Changed

Mystery Resolved

Timeline entries cannot be modified.

---

# Story Visibility

Private

Default.

Future:

Shared

Family

Read-only

---

# Related Stories

Stories may reference other Stories.

Example:

Office Setup

↓

Monitor Purchase

↓

Desk Purchase

↓

Chair Purchase

↓

Keyboard Purchase

The owner sees the entire project.

---

# Search

Story text is indexed.

Photos may become searchable in the future.

Receipt OCR participates in Story Search.

---

# Story Completion

A Story is considered Complete when:

Merchant confirmed

Category confirmed

Optional narrative added

Optional receipt attached

Mystery resolved (if applicable)

Completion is informational only.

---

# Receipts

## Purpose

Receipts preserve purchase details that banks do not provide.

They increase accuracy.

They improve Memories.

They help resolve Mysteries.

---

# Receipt Sources

Camera

Photo Library

PDF

Email Import (future)

OCR Import

Manual Upload

---

# Receipt Metadata

Receipt ID

Transaction ID

Capture Date

OCR Status

File Size

Checksum

Original Filename

Import Source

---

# OCR

The OCR engine attempts to extract:

Merchant

Date

Items

Taxes

VAT

Currency

Total

Payment Method

Invoice Number

---

# Confidence

OCR returns:

High

Medium

Low

Low confidence requires review.

---

# Receipt Matching

Receipts may be matched automatically using:

Merchant

Amount

Date

Time

Confidence

The owner confirms every match.

---

# Receipt Storage

Original file is never modified.

OCR data is stored separately.

Deleting OCR never deletes the original receipt.

---

# Duplicate Detection

Receipts are hashed.

Duplicate uploads are detected.

The owner chooses whether to keep both.

---

# Warranty Support (Future)

Receipts may contain:

Warranty Expiration

Return Deadline

Support Information

Store Contacts

---

# Privacy

Receipts are encrypted.

Receipt images remain local unless backup is enabled.

---

# Audit History

Every Transaction maintains a permanent audit trail.

Nothing important disappears.

---

# Recorded Events

Imported

Viewed

Edited

Merchant Changed

Category Changed

Story Updated

Receipt Attached

Memory Added

Mystery Created

Mystery Resolved

Archived

Restored

---

# Audit Entry

Timestamp

Action

Old Value

New Value

Source

User

AI

System

---

# Versioning

Each modification increases the Version Number.

Example:

Version 1

Imported

↓

Version 2

Merchant corrected

↓

Version 3

Receipt attached

↓

Version 4

Story added

---

# Undo

Recent edits may be undone.

Undo never removes audit history.

---

# Conflict Resolution

If synchronization detects conflicting edits:

Owner changes always win.

Original values remain in audit history.

---

# AI Responsibilities

Weaver analyzes every Transaction.

Possible outputs:

Merchant Suggestion

Category Suggestion

Subscription Detection

Duplicate Detection

Mystery Detection

Story Summary

Dream Recommendation

Expense Pattern

Confidence Score

---

# AI Rules

Weaver never:

Deletes Transactions

Changes Amounts

Changes Dates

Moves Transactions

Starts Financial Cycles

Creates Dreams

All suggestions require confirmation.

---

# Confidence Levels

95–100%

Very High

80–94%

High

60–79%

Medium

Below 60%

Low

Low confidence automatically creates a review recommendation.

---

# Learning

Every confirmation improves future suggestions.

Every correction is stored as training context.

Learning remains local whenever possible.

---

# Explainability

Every AI suggestion must explain:

Why it was suggested.

Confidence.

Supporting evidence.

Example:

Merchant matched because:

Amount similarity

Previous purchases

Merchant history

Receipt OCR

Location (future)

---

# Success Criteria

A Transaction should never become meaningless over time.

The owner should always understand:

What happened.

Where.

Why.

How much.

When.

How it relates to the rest of their financial life.

---

# Final Principle

A Transaction is not a number.

It is a memory connected to a Financial Cycle.

Every Euro Has a Story.