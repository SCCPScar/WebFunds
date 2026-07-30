---
title: Central
version: 1.0.0
status: Approved
owner: Product & Design
last_updated: 2026-07-19
related_documents:
  - Navigation
  - Financial Cycles
  - UX Principles
---

# Central

> The Central screen is the financial home of WebFunds.

---

# Purpose

Central provides an immediate overview of the owner's financial situation.

It should answer the following questions in less than five seconds:

- How much money do I currently have?
- How much can I safely spend?
- What changed recently?
- Does anything require my attention?
- What is my current Financial Cycle?

This screen should never overwhelm the owner with information.

---

# Screen Philosophy

Central is not a dashboard.

It is a decision-making screen.

Every element should help the owner understand their financial position before making their next financial decision.

---

# Layout Structure

The screen is composed of vertically stacked sections.

1. Header

↓

2. Financial Summary

↓

3. Available to Spend

↓

4. Current Financial Cycle

↓

5. Recent Activity

↓

6. Attention Required

↓

7. Quick Actions

↓

8. Weaver Insight

---

# Header

Contains:

- Greeting
- Current date
- Profile avatar
- Notifications button

Greeting examples:

Good morning.

Good afternoon.

Good evening.

Avoid displaying the owner's name repeatedly.

The greeting should feel natural.

---

# Financial Summary Card

This is the most important component on the screen.

Displays:

Current Balance

Available to Spend

Reserved Money

Upcoming Commitments

Only these four values.

Avoid adding additional statistics.

---

# Available to Spend

This value receives visual emphasis.

Definition:

Money that may be spent without affecting reserved money or planned commitments.

This amount updates immediately after:

- new transaction
- income
- transfer
- manual adjustments

---

# Current Financial Cycle

Displays:

Cycle name

Start date

Current progress

Days since start

Income received

Expenses

Remaining balance

A "View Details" button opens the complete Financial Cycle.

---

# Recent Activity

Shows the five most recent financial events.

Each item displays:

Merchant

Amount

Category

Date

Optional Memory indicator

Tap opens transaction details.

---

# Attention Required

Only appears when necessary.

Possible items:

Unknown transaction

Subscription detected

Receipt missing

Large expense

Bank synchronization failed

Never display more than three items.

Prioritize by importance.

---

# Quick Actions

Displayed as rounded action buttons.

Actions:

Add Transaction

Scan Receipt

Search

Ask Weaver

Start Financial Cycle

The order should remain fixed.

---

# Weaver Insight

Displays one proactive suggestion.

Examples:

"You spent less on restaurants this week."

"I found two recurring subscriptions."

"This purchase looks similar to one from last month."

Only one insight at a time.

The owner may dismiss it.

---

# Pull to Refresh

Refreshing should:

Synchronize the connected bank.

Refresh balances.

Refresh AI suggestions.

Refresh notifications.

Display subtle haptic feedback.

---

# Empty State

If no data exists:

Display a welcome illustration.

Explain the first steps.

Primary action:

Connect your bank.

Secondary action:

Add a transaction manually.

---

# Loading State

Use Skeleton components.

Never show blank areas.

Loading should feel immediate.

---

# Offline State

Display the latest synchronized information.

Inform the owner that live data is unavailable.

Allow browsing historical information.

---

# Error State

Errors should never replace the entire screen.

Show partial information whenever possible.

Unavailable cards should explain the problem.

---

# Gestures

Pull to refresh.

Swipe down to dismiss modals.

Long press on Recent Activity items opens quick actions.

---

# Animations

Cards fade in.

Numbers animate smoothly.

Progress indicators update gradually.

Avoid dramatic movement.

---

# Accessibility

Support Dynamic Type.

VoiceOver.

High contrast.

Reduced motion.

Touch targets at least 44x44 points.

---

# Performance

The Central screen should become interactive in under one second after launch.

Financial summary should appear before secondary content.

---

# Future Expansion

Possible future cards:

Investment Overview

Savings Goals

Credit Score

Upcoming Bills

Monthly Comparison

These should remain optional.

---

# Success Criteria

The owner should understand their financial situation within five seconds of opening WebFunds.

If the owner needs to search for information on this screen, the design should be reconsidered.

---

# Final Principle

Central should answer the owner's most important financial question:

"Can I spend money today with confidence?"