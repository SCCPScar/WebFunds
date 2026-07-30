# Data Dictionary

> Every field has meaning.

---

# users

| Field | Type | Description | Example |
|--------|------|-------------|---------|
| id | UUID | Unique user identifier | UUID |
| email | TEXT | Login email | maria@email.com |
| created_at | TIMESTAMP | Account creation | 2026-01-14 |

---

# financial_cycles

| Field | Type | Description | Example |
|--------|------|-------------|---------|
| id | UUID | Cycle identifier | UUID |
| start_date | DATE | Beginning of cycle | 2026-04-12 |
| end_date | DATE | End of cycle | 2026-05-08 |
| status | TEXT | Active / Closed | Active |

---

# transactions

| Field | Type | Description | Example |
|--------|------|-------------|---------|
| id | UUID | Transaction identifier | UUID |
| account_id | UUID | Bank account | UUID |
| financial_cycle_id | UUID | Related cycle | UUID |
| amount | DECIMAL | Transaction value | 58.90 |
| currency_code | TEXT | ISO Currency | EUR |
| merchant_name | TEXT | Normalized merchant | Continente |
| bank_description | TEXT | Original bank text | PAGAMENTO TP 12345 |
| display_name | TEXT | Name shown in UI | Continente Colombo |
| category_id | UUID | Expense category | UUID |
| type | TEXT | Income / Expense / Transfer | Expense |
| status | TEXT | Posted / Pending | Posted |
| created_at | TIMESTAMP | Creation | Timestamp |

---

# dreams

| Field | Type | Description | Example |
|--------|------|-------------|---------|
| id | UUID | Dream identifier | UUID |
| target_amount | DECIMAL | Goal amount | 2500 |
| reserved_amount | DECIMAL | Reserved value | 1100 |
| target_date | DATE | Optional target | 2027-12-31 |

---

# mysteries

| Field | Type | Description | Example |
|--------|------|-------------|---------|
| id | UUID | Mystery identifier | UUID |
| transaction_id | UUID | Related transaction | UUID |
| confidence | DECIMAL | AI confidence | 0.91 |
| reason | TEXT | Why it exists | Unknown Merchant |
| status | TEXT | Open / Resolved | Open |

---

# subscriptions

| Field | Type | Description | Example |
|--------|------|-------------|---------|
| id | UUID | Subscription identifier | UUID |
| merchant_name | TEXT | Merchant | Spotify |
| expected_amount | DECIMAL | Expected payment | 10.99 |
| frequency | TEXT | Monthly | Monthly |

---

# receipts

| Field | Type | Description | Example |
|--------|------|-------------|---------|
| id | UUID | Receipt identifier | UUID |
| transaction_id | UUID | Related transaction | UUID |
| image_url | TEXT | Storage path | receipts/uuid.jpg |
| ocr_status | TEXT | OCR progress | Completed |

---

# weaver_insights

| Field | Type | Description | Example |
|--------|------|-------------|---------|
| id | UUID | Insight identifier | UUID |
| confidence | DECIMAL | Confidence score | 0.97 |
| explanation | TEXT | AI reasoning | Similar purchase pattern |
| created_at | TIMESTAMP | Generated | Timestamp |

---

# Final Principle

No field exists without a documented purpose.