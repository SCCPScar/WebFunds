# Bank Connections

> Represents authorization to access banking information.

---

# Purpose

Stores the connection between WebFunds and financial institutions.

No credentials are stored.

Only authorization metadata.

---

# Table

bank_connections

---

# Relationships

User

↓

Many Bank Connections

↓

Many Bank Accounts

---

# Columns

id

UUID

Primary Key

---

user_id

UUID

Foreign Key

---

provider

TEXT

Example

Millennium

---

provider_account_id

TEXT

---

status

TEXT

Connecting

Healthy

Expired

Revoked

Failed

---

authorization_date

TIMESTAMP

---

expires_at

TIMESTAMP

---

last_sync_at

TIMESTAMP

---

sync_status

TEXT

Idle

Running

Failed

---

created_at

TIMESTAMP

---

updated_at

TIMESTAMP

---

deleted_at

TIMESTAMP

Nullable

---

# Constraints

One active authorization per provider.

---

# Indexes

user_id

provider

status

---

# RLS

Owner only.

---

# Future Providers

CGD

ActivoBank

Moey

Revolut

N26

Wise

---

# Final Principle

Connections authorize reading.

Never spending.