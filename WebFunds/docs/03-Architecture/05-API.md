---
title: API
version: 1.0.0
status: Approved
owner: Backend
last_updated: 2026-07-19
---

# API

> APIs expose capabilities, not databases.

---

# Philosophy

The application communicates through services.

The UI never performs raw database operations.

---

# API Style

REST

JSON

HTTPS

JWT Authentication

Versioned

---

# Base Path

/api/v1/

---

# Main Modules

Authentication

Users

Banking

Transactions

Dreams

Mysteries

Receipts

Notifications

Reports

Weaver

Settings

---

# Request Rules

Validate input.

Authenticate owner.

Authorize action.

Execute use case.

Return standardized response.

---

# Response Format

Success

Data

Metadata

Errors

Request ID

Timestamp

---

# Error Format

Code

Message

Details

Documentation Link

---

# Status Codes

200 OK

201 Created

204 No Content

400 Bad Request

401 Unauthorized

403 Forbidden

404 Not Found

409 Conflict

422 Validation

500 Internal Error

---

# Pagination

Cursor Based

Future Offset Support

---

# Authentication

Bearer Token

Refresh Token

Biometric Session

---

# Security

HTTPS only.

Rate limiting.

Audit logging.

Request validation.

---

# Future

GraphQL

WebSockets

Streaming

Public API

---

# Final Principle

APIs expose business actions.

Never database tables.