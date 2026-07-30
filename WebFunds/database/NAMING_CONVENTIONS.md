# Naming Conventions

> Consistency is more important than preference.

---

# Tables

Plural

snake_case

Examples

users

transactions

financial_cycles

dreams

mysteries

---

# Columns

snake_case

Examples

created_at

updated_at

deleted_at

merchant_name

bank_description

financial_cycle_id

---

# Primary Keys

Always

id UUID

Example

transaction.id

dream.id

---

# Foreign Keys

Always

*_id

Examples

user_id

transaction_id

merchant_id

---

# Boolean Fields

Prefix

is_

has_

can_

should_

Examples

is_active

is_deleted

has_receipt

can_sync

---

# Dates

*_at

Examples

created_at

updated_at

completed_at

received_at

---

# Amounts

Always DECIMAL

Examples

amount

reserved_amount

available_amount

salary_amount

---

# Currency

currency_code

ISO-4217

EUR

USD

GBP

---

# Status

Always TEXT

Backed by ENUM in the application.

Examples

status

sync_status

connection_status

---

# Index Names

idx_table_column

Examples

idx_transactions_date

idx_transactions_merchant

---

# Foreign Keys

fk_table_reference

Example

fk_transactions_cycles

---

# Triggers

trg_table_action

Example

trg_transactions_updated

---

# Functions

verb_noun()

Examples

calculate_balance()

resolve_mystery()

create_cycle()

---

# Policies

table_action

Example

transactions_select

transactions_update

---

# Views

vw_

Example

vw_monthly_summary

vw_active_subscriptions

---

# Files

snake_case

Never spaces.

---

# Dart Classes

PascalCase

Transaction

Dream

Mystery

---

# Variables

camelCase

transactionAmount

merchantName

availableBalance

---

# Constants

lowerCamelCase

Only compile-time constants may use lower_snake in SQL.

---

# Final Principle

One concept.

One name.

Everywhere.