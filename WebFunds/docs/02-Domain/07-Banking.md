---
title: Banking
version: 1.0.0
status: Approved
owner: Product & Architecture
last_updated: 2026-07-19
related_documents:
  - Transactions
  - Financial Cycles
  - Weaver
---

# Banking

> Banking data is imported. Never controlled.

---

# Purpose

The Banking domain defines how WebFunds connects to financial institutions.

WebFunds never initiates payments.

WebFunds only imports financial information.

---

# Core Principles

Connections are read-only.

Every imported transaction remains traceable.

Synchronization never modifies bank data.

Bank access can be revoked at any moment.

---

# Supported Data

Accounts

Balances

Transactions

Transaction Descriptions

Merchant Codes

Currencies

IBAN

Account Type

Pending Transactions

---

# Unsupported Operations

Transfers

Payments

PIX

MB WAY Payments

Card Blocking

Loan Requests

Investments

Any operation that moves money.

---

# Bank Connection

Each connection stores:

Connection ID

Institution

Country

Authorization Date

Expiration Date

Connection Status

Synchronization Status

Owner Identifier

---

# Connection Lifecycle

Disconnected

↓

Connecting

↓

Authorized

↓

Synchronizing

↓

Healthy

↓

Expired

↓

Revoked

---

# Account Types

Checking

Savings

Credit Card

Joint Account

Business Account

Cash (manual)

Investment (future)

---

# Synchronization

Synchronization imports only new or updated transactions.

Existing data is never overwritten without audit history.

Duplicate detection runs before persistence.

---

# Pending Transactions

Pending transactions remain marked until confirmed by the bank.

Weaver may ignore them for reports until they are posted.

---

# Connection Health

Healthy

Delayed

Expired

Failed

Revoked

Each state includes a user-friendly explanation.

---

# Manual Accounts

The owner may create manual accounts.

Examples:

Cash Wallet

Emergency Cash

Gift Card

Family Loan

Manual accounts behave like bank accounts, except they are not synchronized.

---

# Error Handling

Possible errors:

Authentication Failure

Connection Timeout

Bank Unavailable

Permission Revoked

Expired Consent

Duplicate Import

Each error includes recovery instructions.

---

# Security

Bank credentials are never stored by WebFunds.

Authentication uses the provider's authorization flow.

Sensitive tokens remain encrypted.

---

# Privacy

Only the minimum data required for financial analysis is imported.

No banking credentials are visible to the owner or to Weaver.

---

# Future Features

Multiple Banks

Open Banking Aggregation

Automatic Reconnection

Investment Accounts

Loan Accounts

Currency Conversion

---

# Success Criteria

Bank synchronization should be reliable, transparent and fully auditable.

---

# Final Principle

WebFunds observes money.

It never moves it.