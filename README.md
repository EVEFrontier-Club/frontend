# EVE Frontier Club — Frontend

This is the frontend for **EVE Frontier Club**, a modular platform built around analytics, reputation systems, and community tools for the EVE Frontier universe.  
The frontend is implemented using **Jaspr**, a Dart-based reactive UI framework with SSR support, and styled using **Tailwind CSS v4** via `jaspr_tailwind`.

It serves as the user-facing interface for projects such as **EVE Frontier Index**, including dashboards, player profiles, leaderboards, and interactive visualizations.

---

## ✨ Features

- **Jaspr SSR + Client Hydration**  
  Fast, reactive UI with seamless server–client rendering.

- **Tailwind v4 Theme**  
  Custom cosmic sci‑fi theme inspired by evefrontier.com and the EVE Frontier Club visual identity.

- **Modular Page Structure**  
  Each feature (Index, Trust Score, Leaderboards, etc.) is implemented as an independent module.

- **Reusable UI Components**  
  Cards, charts, tables, glow effects, and layout primitives.

- **API Integration**  
  Connects to the Serverpod backend for metrics, scores, and player data.

---

## 🎨 Styling

The project uses:

- **Tailwind CSS v4 (CSS‑first mode)**
- **Custom theme** with:
  - deep‑space backgrounds  
  - neon blue accents  
  - glow utilities  
  - gradient buttons  
  - card components  
  - typography and spacing tokens  

Theme file: `web/styles/tailwind.css`

---

## 🚀 Getting Started

### Install dependencies

```bash
dart pub get