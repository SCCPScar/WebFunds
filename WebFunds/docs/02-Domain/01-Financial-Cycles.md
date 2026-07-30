---
title: Financial Cycles
version: 1.0.0
status: Approved
owner: Product & Architecture
last_updated: 2026-07-19
---

# Financial Cycles

> Time organized around income, not calendar months.

---

# Purpose

A Financial Cycle is the primary organizational unit of WebFunds.

Unlike traditional budgeting systems that rely on calendar months, a Financial Cycle begins whenever the owner decides that a new financial period has started.

In most cases this will happen after receiving salary, but the application must never assume that every incoming payment is salary.

---

# Why Financial Cycles?

Many people:

Receive salaries on different dates.

Receive bonuses.

Receive family transfers.

Receive reimbursements.

Receive multiple incomes.

Calendar months do not accurately represent these realities.

Financial Cycles solve this problem.

---

# Definition

A Financial Cycle is a time period manually started by the owner.

Every transaction belongs to exactly one Financial Cycle.

---

# Core Principles

The owner always decides when a cycle starts.

Cycles never overlap.

A transaction belongs to one and only one cycle.

Historical cycles are immutable except for corrections.

---

# Lifecycle

Draft

↓

Active

↓

Closed

↓

Archived

---

# Draft

Created but not yet confirmed.

Transactions are not assigned automatically.

---

# Active

Current working cycle.

New transactions are assigned here by default.

---

# Closed

The cycle has ended.

Reports become available.

Statistics become final.

Minor corrections remain possible.

---

# Archived

Read-only.

Historical reference.

Cannot receive new transactions.

---

# Required Properties

Unique Identifier

Name

Start Date

End Date (optional)

Status

Opening Balance

Closing Balance

Income Total

Expense Total

Reserved Total

Available Total

Created At

Updated At

---

# Derived Values

Net Balance

Savings Rate

Largest Expense

Largest Income

Category Totals

Merchant Totals

Average Daily Spending

Number of Mysteries

Dream Contributions

Subscription Cost

---

# Manual Creation

The owner chooses:

Start date

Optional name

Optional notes

Opening balance (optional)

---

# Automatic Suggestion

Weaver may recommend starting a new cycle when:

A significant income is detected.

A long period has elapsed.

The owner usually starts a cycle around this time.

The owner always confirms.

---

# Closing a Cycle

Closing a cycle:

Calculates final statistics.

Locks historical reports.

Preserves audit history.

Does not delete data.

---

# Transaction Assignment

Every transaction references exactly one Financial Cycle.

If imported before a cycle exists:

Transactions remain "Unassigned" until reviewed.

---

# Corrections

Transactions may be moved between cycles.

Every change is recorded.

Audit history is preserved.

---

# Reports

Each cycle generates:

Income Summary

Expense Summary

Category Breakdown

Merchant Breakdown

Dream Contributions

Mystery Statistics

Subscription Summary

Weaver Narrative

---

# AI Responsibilities

Weaver may:

Suggest cycle boundaries.

Explain differences between cycles.

Compare previous cycles.

Forecast future cycles.

Weaver never starts or closes a cycle automatically.

---

# Edge Cases

Income received twice in one week.

Family transfer mistaken for salary.

Refund received after cycle closure.

Late bank synchronization.

Imported historical transactions.

Manual adjustments.

All must be supported without breaking cycle integrity.

---

# Success Criteria

Every transaction can be traced to one Financial Cycle.

The owner always understands which cycle is active.

Cycles reflect the owner's real financial life rather than arbitrary calendar dates.

---

# Final Principle

Financial Cycles exist to match reality, not the calendar.