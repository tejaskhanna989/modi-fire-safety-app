# Modi Fire Safety — Design System

All visual decisions live in `lib/core/theme/` and `lib/core/widgets/`.
Feature screens must not use raw hex values, `Colors.*` for brand or text
colours, or create their own `ThemeData`.

## Colour (`app_colors.dart`)

| Role | Token | Hex |
| --- | --- | --- |
| Primary (buttons, active navigation) | `AppColors.navy` | `#14263D` |
| Secondary / accent (sparingly) | `AppColors.safetyRed` | `#D9272E` |
| Background | `AppColors.softGrey` | `#F4F6F8` |
| Surface (cards, inputs, nav bar) | `AppColors.white` | `#FFFFFF` |
| Primary text | `AppColors.ink` | `#1C2127` (dark charcoal) |
| Secondary text | `AppColors.slate` | `#5E6772` (neutral grey) |
| Hairlines and borders | `AppColors.line` | `#DDE2E8` |
| Fire accent (logo flame) | `AppColors.fire` | `#F94C06` |
| Fire accent text on white | `AppColors.fireDeep` | `#C53A03` |
| Fire tint (selected and highlighted fills) | `AppColors.fireTint` | `#FFEEE6` |

Fire accents are used for: the active tab icon and indicator, focus outlines,
selected chips, switches, the cart badge, progress indicators, section header
bars and the home hero accent line. Navy stays on primary buttons and headings.
Do not use fire orange for body text; use `fireDeep` when a fire-coloured
label is needed on white.

Semantic colours (`amber`, `success`, `info`, `danger`, each with a `*Tint`)
are for status only and must always be paired with a text label.

## Theme

Light is the default. Users can switch to the dark design from
Profile > Appearance. `ThemeState` (`lib/core/state/theme_state.dart`) holds
the choice in memory only, and `app.dart` passes it to `MaterialApp`. Dark
colours come from `AppTheme.dark()`; they follow the same token names.

## Typography (`app_typography.dart`)

Platform UI font. Use the existing scale (`displayMedium`, `headlineMedium`,
`titleMedium`, `bodyMedium`, `labelSmall` …). Do not set ad-hoc font sizes.

## Spacing and shape

- `AppSpacing`: 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 56.
- `AppRadius`: 6 (sm) · 8 (md, buttons and inputs) · 12 (lg, cards) · 16 (xl,
  sheets) · pill (chips and badges).

## Components

| Component | File | Notes |
| --- | --- | --- |
| Button | `widgets/app_button.dart` | Primary = navy fill; secondary = outline; quiet = text |
| Card | `widgets/app_card.dart` | White, hairline border, no shadow; `onTap` optional |
| Text field | `widgets/app_text_field.dart` | Styled by `InputDecorationTheme` |
| Badge / status | `widgets/app_badge.dart`, `status_badge.dart` | Label always carries meaning |
| Section header | `widgets/app_section_header.dart` | Title plus optional action |
| App bar | `widgets/app_app_bar.dart` | Shared top bar |
| Brand | `widgets/brand_wordmark.dart` | Supplied flame logo (`assets/brand/flame_logo.png`) with the wordmark text |
| Bottom navigation | `app/shell/app_shell.dart` | Themed via `NavigationBarThemeData` |

## Motion

Use `AppMotion` durations only (`fast` 140 ms, `medium` 260 ms, `slow` 420 ms).
Motion is limited to state changes (press, selection, page change).

## Not yet included

- Product photography. Cards currently show category icons. Add supplied,
  licensed product photos through a single product-image widget when available.
- Launcher icon: still the default Android icon. The supplied logo is 111×156 px, so a 512 px PNG or SVG is needed for a sharp app icon.
