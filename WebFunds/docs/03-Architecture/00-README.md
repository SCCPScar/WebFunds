---
title: Architecture
version: 1.0.0
status: Approved
owner: Architecture
last_updated: 2026-07-19
---

# Architecture

> A good architecture allows the product to evolve without losing consistency.

---

# Purpose

This folder defines how WebFunds is built.

Unlike Domain documents, which define business behavior, Architecture documents describe technical implementation.

Architecture exists to make future changes easier, safer and more predictable.

---

# Objectives

Maintainability

Scalability

Security

Performance

Offline-first

AI Integration

Cross-platform support

---

# Architectural Principles

Business rules are independent from UI.

Infrastructure never defines business rules.

Every dependency points inward.

Modules communicate through clear contracts.

Every component has a single responsibility.

---

# Main Layers

Presentation

Application

Domain

Infrastructure

External Services

---

# Technical Topics

System Architecture

Database

Offline Synchronization

API

Storage

Authentication

Performance

Caching

Observability

---

# Technology Stack

Flutter

Riverpod

Supabase

PostgreSQL

Drift

Anthropic Claude

OpenAI

Google ML Kit

GitHub Actions

---

# Documentation Order

01 System Architecture

02 Tech Stack

03 Database

04 Folder Structure

05 API

06 Synchronization

07 State Management

08 Offline

09 Performance

10 ADR

---

# Final Principle

Architecture should make the correct solution easier than the incorrect one.