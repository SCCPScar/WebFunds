# Profiles

> Stores personal preferences.

---

# Purpose

Contains information used by the application.

Not authentication.

---

# Table

profiles

---

# Relationship

One User

↓

One Profile

---

# Columns

id

UUID

Primary Key

---

user_id

UUID

Foreign Key

Required

---

display_name

TEXT

---

avatar_url

TEXT

Nullable

---

preferred_currency

TEXT

ISO-4217

Default EUR

---

country_code

TEXT

ISO-3166

PT

---

theme

TEXT

System

Light

Dark

Spider

Future Custom

---

language

TEXT

pt-PT

---

financial_cycle_mode

TEXT

Income Based

Calendar

Manual

---

first_day_of_week

INTEGER

---

timezone

TEXT

Europe/Lisbon

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

# Indexes

user_id

country_code

---

# RLS

Owner only.

---

# Future Fields

AI Preferences

Accessibility

Notification Preferences

Experimental Features

---

# Final Principle

Everything configurable belongs here.