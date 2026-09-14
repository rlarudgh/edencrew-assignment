# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Starter template for the Edencrew Flutter hiring assignment: a Korean domestic-stock
watchlist app. Requirements live in `docs/ASSIGNMENT.md` (screens, must-have vs.
optional, grading criteria, submission) and `docs/NAVER_API.md` (data integration).
Figma designs are delivered by email and are not in the repo.

Only `lib/theme/` (design tokens) and `assets/fonts/` are pre-built. `lib/main.dart`
is a placeholder (`StartHereScreen`) meant to be deleted. **Folder structure, state
management, and architecture are deliberately undefined — they are the candidate's
call and are graded on the stated rationale, so do not assume a pattern exists;
follow whatever is already in the tree, and when introducing one, say why in
`README.md`.**

Scope: three screens (`관심` watchlist / `검색` search / `종목상세` detail) plus their
empty, sort-sheet, and toast states, all dark-theme only, designed at 393×852.

## Commands

```bash
flutter pub get
flutter run -d macos          # or an iOS/Android device
flutter analyze               # required to be clean before submitting
flutter test
flutter test test/widget_test.dart --plain-name '시작 화면'   # single test
```

Toolchain: Flutter 3.47.4 / Dart 3.13.3 (stable); `pubspec.yaml` requires SDK `^3.11.5`.

- **Never run on Chrome/web.** The Naver endpoints send no CORS headers, so every
  request fails in a browser. Many IDEs default to Chrome — pass `-d` explicitly.
- Verify at phone size (emulator, device, or a ~393×852 window). Comparing against
  Figma in a large desktop window is meaningless.
- `analysis_options.yaml` excludes the platform folders, so `flutter analyze` covers
  `lib/` and `test/` only.

## Design tokens (`lib/theme/`)

Three layers; screens only ever touch the top one:

1. `app_palette.dart` — raw hex (`AppPalette`, Figma `Primitives`).
2. `app_colors.dart` / `app_dimens.dart` — semantic `ThemeExtension`s
   (`AppColors.dark()`, `AppDimens.standard()`), assembled into `AppTheme.dark`.
3. `app_theme.dart` — `AppThemeContext` extension giving `context.colors` /
   `context.dimens`. `app_typography.dart` exposes `AppTypography.fontFamily`
   (`'NotoSansKR'`, already the theme default) and `regular`/`medium`/`bold`.
   `theme.dart` is the barrel — import that.

Rules (graded):

- **Never write a color hex in screen code and never reference `AppPalette`
  directly** — always `context.colors.*`.
- Do not change existing token values. Adding a token is allowed, but record the
  reason in `README.md`.
- **Font sizes and line heights are intentionally not tokenized** (Figma only
  variabilizes family and weight). Read each value off the Figma text layer and
  write it inline, as `StartHereScreen` does.
- Price direction follows Korean market convention: **up = red (`priceUpText`),
  down = blue (`priceDownText`)**, flat = `priceFlatText` / `priceFlatBg`. Getting
  this backwards is called out explicitly in the assignment.
- `lib/theme/README.md` is the Figma-variable ↔ Dart-field ↔ hex lookup table.

## Naver data integration

Four endpoints, detailed in `docs/NAVER_API.md`. Requests, parsing, DTOs, and model
mapping are all required work. Constraints that carry grading weight:

- **Realtime quotes are batched**: one `polling.finance.naver.com/api/realtime`
  call with a comma-joined `query` covers the whole watchlist — never one call per
  symbol. Change = `nv - pcv`, rate = `(nv - pcv) / pcv`, market cap =
  `nv × countOfListedStock`.
- **`finance.naver.com/item/sise_day.naver` returns HTML, not JSON, and it is not
  UTF-8** — decoding the bytes as UTF-8 mangles Hangul. Column order is
  `종가, 전일비, 시가, 고가, 저가, 거래량`; normalize dates to `yyyyMMdd`.
- **Fetch daily-price pages incrementally and cache them.** 10 trading days per
  page (1M≈2, 3M≈6, 6M≈12, 1Y≈25 pages); period-tab switches must reuse pages
  already fetched, and must never request beyond `lastPage`.
- Search autocomplete: keep domestic stocks only, 6-digit codes only, canonical id
  `domestic:{symbol}`.
- Save sample responses under `assets/mock/` (already registered in `pubspec.yaml`
  assets) and commit them — the endpoints throttle under repeated calls.

## Working conventions

- Root `README.md` is currently the starter's instructions and is meant to be
  **replaced** by the project write-up; `docs/` stays as-is. The required README
  sections are checklisted in `docs/ASSIGNMENT.md` § 제출 방법 — run commands,
  implemented scope, technology rationale, and every judgement call made where
  Figma was silent (toast duration/dismissal, loading and network-error handling,
  long-name overflow, sort position of rows without a quote yet).
- Commit in **work-sized increments, not one squashed commit** — the reviewer reads
  the commit history.
- Korean is the language of the docs, UI strings, and code comments; match it.
