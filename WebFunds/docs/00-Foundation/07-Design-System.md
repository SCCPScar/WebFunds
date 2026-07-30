---
title: Design System
version: 1.0.0
status: Approved
owner: Design
last_updated: 2026-07-19
related_documents:
  - Design Manifesto
  - Brand Identity
  - UX Principles
---

# Design System

> Consistency is invisible quality.

---

# Purpose

This document defines the complete visual language of WebFunds.

Every screen, component and interaction must follow these standards.

Developers and AI assistants should never invent styles outside this document.

---

# Design Philosophy

WebFunds combines:

- Apple's Human Interface Guidelines
- Linear
- Arc Browser
- Modern Glass UI
- iOS Native Design
- Scientific elegance inspired by The Amazing Spider-Man technology

The experience should feel premium, clean and modern.

---

# Color Philosophy

Color exists to communicate meaning.

Never decoration.

The interface should rely primarily on spacing, typography and hierarchy.

Accent colors should be used sparingly.

---

# Theme

The application supports:

- Light Mode
- Dark Mode

Dark Mode is considered the primary experience.

---

# Primary Accent

Electric Blue

Used for:

- Primary buttons
- Active navigation
- Links
- Focus states
- Interactive charts

---

# Secondary Accent

Soft Cyan

Used for:

- Hover effects
- AI elements
- Highlights

---

# Success

Green

Reserved for:

- Successful actions
- Completed goals
- Connected services

---

# Warning

Amber

Reserved for:

- Items requiring attention
- Possible subscriptions
- Transactions awaiting review

---

# Danger

Red

Reserved only for:

- Delete actions
- Security issues
- Critical failures

Never use red for ordinary spending.

---

# Border Radius

Cards

16px

Buttons

14px

Inputs

14px

Dialogs

20px

Charts

16px

---

# Shadows

Use soft shadows.

Avoid heavy elevation.

The interface should feel light.

---

# Glass Effects

Allowed.

Only for:

- Navigation bars
- Floating panels
- Dialog backgrounds

Never reduce readability.

---

# Spacing Scale

4

8

12

16

24

32

48

64

Always use these spacing values.

Never invent arbitrary spacing.

---

# Typography

Primary Font

Inter

Fallback

System UI

Font weights

400

500

600

700

Avoid extremely thin fonts.

---

# Heading Hierarchy

H1

Page title

H2

Section title

H3

Card title

Body

Default text

Caption

Supporting information

---

# Icons

Primary Library

Lucide

Secondary Library

Bootstrap Icons

Never mix icon styles inside the same screen.

---

# Buttons

Primary

Filled

Accent color

Secondary

Outline

Ghost

Transparent

Danger

Red

Only for destructive actions.

---

# Cards

Cards are the primary layout component.

Every card should contain one subject only.

Never overload cards.

---

# Forms

Always:

Large touch targets

Clear labels

Visible validation

Helpful placeholders

---

# Inputs

Minimum height

48px

Support icons when useful.

Never rely only on placeholders.

---

# Charts

Use:

Line charts

Bar charts

Area charts

Donut charts

Avoid:

3D charts

Pie charts with many segments

Decorative graphics

---

# Tables

Avoid whenever possible.

Prefer responsive cards.

Tables are desktop-only.

---

# Navigation

Mobile

Bottom Navigation Bar

Desktop

Sidebar

Navigation should remain identical in structure.

---

# Animations

Use Framer Motion.

Animations should be:

Fast

Natural

Purposeful

Avoid excessive motion.

---

# Motion Duration

Fast

150ms

Normal

250ms

Complex

350ms

Never exceed 500ms.

---

# Loading States

Always use Skeleton components.

Avoid spinning loaders unless absolutely necessary.

---

# Empty States

Illustration

Title

Description

Primary Action

Optional Secondary Action

---

# Modals

Maximum width

640px

Rounded corners

Background blur

ESC closes on desktop.

Swipe down closes on mobile where appropriate.

---

# Responsive Breakpoints

Mobile

Primary platform

Tablet

Optimized

Desktop

Expanded layout

Large Desktop

Maximum content width

Never stretch content excessively.

---

# Accessibility

Minimum contrast

WCAG AA

Minimum touch target

44x44px

Keyboard navigation

Required

Screen reader labels

Required

Reduced motion

Supported

---

# Visual Density

Comfortable.

Never compact.

Whitespace improves understanding.

---

# Design Tokens

All colors, spacing, typography, radii and shadows must be exposed as design tokens.

Never hardcode values inside components.

---

# Component Library

Every reusable component belongs in:

src/components/ui/

Feature-specific components belong inside:

src/features/

---

# Final Principle

Every new component should feel like it has always been part of WebFunds.