---
title: Mysteries
version: 1.0.0
status: Approved
owner: Product & Architecture
last_updated: 2026-07-19
related_documents:
  - Transactions
  - Memories
  - Weaver
  - Banking
---

# Mysteries

> Unknown today. Understood tomorrow.

---

# Purpose

A Mystery represents a Transaction that requires additional context before it becomes part of the owner's permanent financial history.

Mysteries exist because bank information is often incomplete.

WebFunds treats uncertainty as something to resolve, not ignore.

---

# Philosophy

A financial history should be understandable.

If the owner cannot recognize a transaction, WebFunds should help recover its meaning.

Mysteries are temporary.

Understanding is permanent.

---

# Definition

A Mystery is a domain entity linked to exactly one Transaction.

It stores uncertainty.

Not incorrect information.

Once resolved, the Mystery becomes historical evidence of the review process.

---

# Core Principles

Every Mystery belongs to one Transaction.

A Transaction may have zero or one active Mystery.

Resolved Mysteries are never deleted.

Every action is audited.

---

# Mystery Lifecycle

Detected

↓

Analyzed

↓

Reviewed

↓

Resolved

↓

Archived

---

# Detected

The system identifies missing or uncertain information.

---

# Analyzed

Weaver evaluates the available evidence.

Confidence scores are calculated.

Possible explanations are generated.

---

# Reviewed

The owner reviews the available suggestions.

Changes are optional.

---

# Resolved

The owner confirms the information.

The Mystery becomes historical.

---

# Archived

Read-only.

Searchable.

Included in reports.

---

# Creation Rules

A Mystery may be created when:

Unknown Merchant

Unknown Category

Low AI Confidence

Missing Description

Manual Flag

Conflicting Import

Possible Duplicate

Incomplete OCR

Bank Synchronization Error

Future rules may extend this list.

---

# Required Fields

Mystery ID

Transaction ID

Status

Created At

Updated At

Reason

Confidence

---

# Optional Fields

Suggested Merchant

Suggested Category

Suggested Story

Suggested Tags

Notes

Attachments

Related Transactions

---

# Confidence

Confidence ranges:

95–100%

Very High

80–94%

High

60–79%

Medium

Below 60%

Low

Confidence is recalculated whenever new evidence appears.

---

# Confidence Sources

Merchant History

Owner Corrections

Receipt OCR

Bank Description

Transaction Amount

Transaction Date

Recurring Pattern

Financial Cycle Context

Future Location Matching

---

# Weaver Responsibilities

Weaver may suggest:

Merchant

Category

Subscription

Related Memory

Story Summary

Duplicate Detection

Confidence Explanation

Potential Receipt Match

Suggestions never modify data automatically.

---

# Manual Mysteries

The owner may manually create a Mystery.

Example:

"I remember this purchase, but I don't remember exactly what I bought."

Manual Mysteries behave exactly like automatic Mysteries.

---

# Resolution Rules

A Mystery may be resolved by:

Confirming Merchant

Selecting Category

Adding Story

Attaching Receipt

Confirming AI Suggestion

Manual Confirmation

Multiple actions may be required.

---

# Reopening

A resolved Mystery may be reopened.

Example:

The owner later discovers incorrect information.

The previous audit history remains intact.

---

# Duplicate Detection

If Weaver believes two transactions represent the same purchase:

A Duplicate Mystery may be created.

The owner confirms whether they are duplicates.

No automatic merging occurs.

---

# Related Transactions

Mysteries may reference similar transactions.

Examples:

Previous purchase at the same merchant

Same amount

Same day

Same Financial Cycle

Recurring expense

---

# Search

Mysteries are searchable by:

Merchant

Amount

Confidence

Reason

Date

Category

Story

Receipt

Status

---

# Notifications

Optional notifications include:

New Mystery detected

Mystery unresolved for 7 days

High-value Mystery

Confidence improved

Mystery resolved

---

# Reports

Reports include:

Mysteries Created

Resolved Mysteries

Average Resolution Time

Resolution Rate

Confidence Distribution

Recurring Mystery Sources

---

# AI Learning

Every confirmation improves future suggestions.

Every correction strengthens merchant recognition.

Rejected suggestions are also valuable learning signals.

Learning is based on explicit confirmation only.

---

# Audit History

Every Mystery records:

Created

Analyzed

Suggestion Generated

Suggestion Accepted

Suggestion Rejected

Story Added

Receipt Attached

Resolved

Reopened

Archived

Audit entries are immutable.

---

# Privacy

Mysteries inherit the privacy level of their Transaction.

Attachments remain encrypted.

No Mystery information is shared externally.

---

# Accessibility

VoiceOver

Dynamic Type

Reduced Motion

Keyboard Navigation

High Contrast

---

# Future Features

Merchant Community Database

Location Matching

Calendar Correlation

Photo Recognition

Email Receipt Matching

Warranty Detection

Family Purchase Recognition

Travel Mode

---

# Success Criteria

Every Mystery should eventually become understandable.

The owner should never permanently lose the meaning behind a financial transaction.

---

# Final Principle

Mysteries exist to eliminate forgotten spending.

Not to create uncertainty.