---
title: Folder Structure
version: 1.0.0
status: Approved
owner: Architecture
last_updated: 2026-07-19
---

# Folder Structure

> Organization reduces complexity.

---

# Philosophy

Every file should have an obvious place.

Folders represent responsibilities.

Features remain isolated whenever possible.

---

# Root

lib/

assets/

docs/

database/

scripts/

test/

integration_test/

---

# Flutter

lib/

core/

features/

shared/

router/

theme/

services/

main.dart

---

# Core

core/

constants/

errors/

extensions/

localization/

utils/

widgets/

---

# Features

Each feature owns:

Application

Domain

Infrastructure

Presentation

Example:

features/

transactions/

dreams/

mysteries/

reports/

weaver/

banking/

profile/

settings/

---

# Feature Layout

transactions/

application/

domain/

infrastructure/

presentation/

---

# Presentation

pages/

widgets/

controllers/

providers/

dialogs/

bottom_sheets/

animations/

---

# Domain

entities/

repositories/

services/

value_objects/

rules/

---

# Application

use_cases/

commands/

queries/

dto/

validators/

---

# Infrastructure

datasources/

repositories/

models/

mappers/

api/

storage/

---

# Shared

Reusable UI

Reusable Models

Components

Themes

Icons

Animations

---

# Assets

assets/

images/

icons/

animations/

fonts/

lottie/

illustrations/

---

# Tests

test/

unit/

widget/

golden/

helpers/

fixtures/

---

# Documentation

docs/

Foundation

Experience

Domain

Architecture

Engineering

Security

AI

---

# Final Principle

Finding a file should never require guessing.