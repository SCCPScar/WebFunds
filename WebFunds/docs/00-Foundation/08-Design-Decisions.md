---
title: Design Decisions
version: 1.0.0
status: Approved
owner: Product & Design
last_updated: 2026-07-19
related_documents:
  - Constitution
  - Product Vision
  - Design Manifesto
  - Brand Identity
  - Product Language
  - UX Principles
  - Design System
---

# Design Decisions

> Every important decision should have a documented reason.

---

# Purpose

This document records the reasoning behind major product and design decisions.

Its purpose is to prevent future changes that unintentionally reduce the quality, consistency or usability of WebFunds.

Future contributors should understand not only *what* was decided, but *why*.

---

# Decision 001 — Mobile First

## Decision

WebFunds is designed for iPhone before any other platform.

## Reason

The owner primarily uses an iPhone.

A focused mobile experience leads to better usability than designing for desktop first.

Desktop exists to extend the experience, not define it.

---

# Decision 002 — Financial Cycles Instead of Calendar Months

## Decision

Financial organization is based on Financial Cycles.

## Reason

Income does not always arrive on fixed dates.

Calendar months do not accurately represent the owner's financial reality.

The owner decides when a cycle begins.

---

# Decision 003 — AI Never Makes Financial Decisions

## Decision

Weaver only recommends.

The owner always confirms.

## Reason

Financial decisions require trust.

Automation should reduce work without reducing control.

---

# Decision 004 — Dark Mode Is the Primary Experience

## Decision

Dark Mode is considered the reference design.

## Reason

The owner uses Dark Mode exclusively.

The visual identity was designed around dark surfaces with subtle lighting.

Light Mode remains fully supported.

---

# Decision 005 — Spider-Man Inspiration Without Copyrighted Assets

## Decision

The Amazing Spider-Man serves only as an emotional and aesthetic inspiration.

## Reason

The owner enjoys its futuristic technological style.

The product must remain legally independent.

No copyrighted graphics, logos or characters may be reproduced.

---

# Decision 006 — Bootstrap Icons and Lucide Icons

## Decision

Lucide is the primary icon library.

Bootstrap Icons may be used when appropriate.

## Reason

Both libraries are lightweight, modern and visually consistent.

They cover nearly every interface need.

---

# Decision 007 — Bottom Navigation on Mobile

## Decision

The main navigation uses a bottom navigation bar on iPhone.

## Reason

It follows Apple's Human Interface Guidelines.

It improves one-handed usability.

---

# Decision 008 — Cards as the Primary Layout

## Decision

Most content is presented inside cards.

## Reason

Cards naturally separate financial information into understandable sections.

They also adapt well to responsive layouts.

---

# Decision 009 — Glass Effects Used Sparingly

## Decision

Glassmorphism is used only where it improves hierarchy.

## Reason

Excessive transparency reduces readability.

Subtle effects create a premium appearance without sacrificing clarity.

---

# Decision 010 — Calm Before Control

## Decision

The interface always prioritizes emotional calm.

## Reason

Many financial applications create anxiety.

WebFunds should have the opposite effect.

---

# Decision 011 — Memories Are First-Class Citizens

## Decision

Transactions may contain notes, receipts and personal memories.

## Reason

Numbers alone rarely explain spending.

Context helps the owner remember why money was spent.

---

# Decision 012 — Search Is Global

## Decision

Search can access every important piece of information.

## Reason

Owners should never wonder where information is stored.

Searching should feel universal.

---

# Decision 013 — Vendor Independence

## Decision

External providers must always be replaceable.

## Reason

Changing AI providers, banking providers or OCR services should not require rewriting the application.

---

# Decision 014 — Native Feeling Over Custom Complexity

## Decision

Whenever possible, interactions should feel native to iOS.

## Reason

Familiar interactions reduce learning time and increase trust.

---

# Decision 015 — Premium Minimalism

## Decision

The interface avoids unnecessary decoration.

## Reason

Financial information should remain the focus.

Visual effects support understanding rather than compete for attention.

---

# Decision 016 — Every Screen Has a Primary Purpose

## Decision

Each screen exists to answer one main question.

## Reason

Focused screens reduce cognitive load and improve navigation.

---

# Decision 017 — Manual Confirmation of Income Types

## Decision

Incoming transactions are never automatically classified as salary.

## Reason

The owner may receive money from different sources, including family transfers, reimbursements and other payments.

Automatic assumptions could create incorrect Financial Cycles or inaccurate reports.

---

# Decision 018 — Weaver Learns Through Confirmation

## Decision

Weaver improves its suggestions based on confirmed user actions.

## Reason

Learning from explicit confirmation increases accuracy while keeping the owner in control.

---

# Decision 019 — Accessibility Is a Product Requirement

## Decision

Accessibility is considered part of product quality.

## Reason

Readable typography, sufficient contrast and proper touch targets improve usability for everyone.

---

# Decision 020 — Documentation Before Development

## Decision

The product is fully specified before implementation.

## Reason

Clear documentation reduces ambiguity, improves AI-generated code and keeps the project consistent over time.

---

# Future Decisions

Every major architectural, design or product decision should be recorded here.

Each new decision must include:

- Decision
- Reason
- Alternatives considered (optional)
- Expected impact

---

# Final Principle

When a future proposal conflicts with a documented decision, the reasoning should be reviewed before the implementation changes.

Understanding the reason behind a decision is more valuable than preserving the decision itself.