# 💍 Digital Wedding Invitation — Medhat & Nesma

A premium, minimalist, luxury-styled single-page wedding invitation built
with Flutter Web, `flutter_bloc`, and Firebase Firestore — fully bilingual
(Arabic default / English) with a splash intro and scroll-triggered
animations.

## ✨ Palette & Type

- **Colors:** Deep Navy (`#0B2A25`), Emerald (`#16433B`), Gold (`#C9A66B`) —
  defined once in `lib/core/theme/app_theme.dart` (`AppColors`).
- **Type:** `Great Vibes` (script, names/hero) + `Playfair Display`
  (headings) + `Lato` (body/UI), all loaded via `google_fonts`.

## 📁 Project Structure (Feature-First / Clean Architecture)

```
lib/
├── main.dart                              # Firebase + locale + splash wiring
├── core/
│   ├── constants/app_constants.dart       # Names, date, venue, links
│   ├── localization/
│   │   ├── app_language.dart              # AppLanguage enum (ar/en)
│   │   ├── locale_cubit.dart              # Cubit<AppLanguage>, ar by default
│   │   └── app_strings.dart               # All bilingual UI copy
│   ├── theme/app_theme.dart               # Colors, text styles, ThemeData
│   └── utils/
│       ├── responsive.dart                # Breakpoint helpers
│       └── date_formatter.dart            # Bilingual date/time formatting
├── features/
│   └── blessings/                         # Guestbook feature
│       ├── data/
│       │   ├── models/blessing_model.dart
│       │   └── services/firebase_service.dart
│       ├── cubit/
│       │   ├── blessings_cubit.dart
│       │   └── blessings_state.dart
│       └── presentation/widgets/blessings_section.dart
└── presentation/
    ├── pages/
    │   ├── splash_screen.dart             # Welcome screen w/ Skip button
    │   └── wedding_home_page.dart         # Assembles all sections
    └── widgets/
        ├── hero_section.dart
        ├── countdown_section.dart
        ├── venue_section.dart
        └── common/
            ├── section_wrapper.dart
            ├── scroll_fade_in.dart        # Scroll-triggered reveal wrapper
            └── language_toggle_button.dart
```

## 🚀 Getting Started

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Connect Firebase**
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   Generates `lib/firebase_options.dart`. Then in `main.dart`: uncomment
   `import 'firebase_options.dart';` and replace the manual
   `FirebaseOptions(...)` block with `options: DefaultFirebaseOptions.currentPlatform`.

3. **Firestore collection & rules**
   The app reads/writes `blessings` (`AppConstants.blessingsCollection`) —
   created automatically on first submission. Deploy the included rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

4. **Personalize content**
   - Names, wedding date/time, venue, Google Maps link →
     `lib/core/constants/app_constants.dart`
   - All bilingual copy (labels, hints, toast message, etc.) →
     `lib/core/localization/app_strings.dart`

5. **Run**
   ```bash
   flutter run -d chrome
   ```

## 🌍 Localization (Arabic default / English)

- `AppLanguage` (`core/localization/app_language.dart`) is the two-value
  enum; `LocaleCubit` holds the current selection and **starts on
  `AppLanguage.ar`**, satisfying "Arabic as default on load."
- `AppLocalizations` (`core/localization/app_strings.dart`) is a plain
  Dart class (no code-gen / `.arb` files) exposing `context.tr('key')` /
  `AppLocalizations.of(context).t('key')`. Every static string, form hint,
  validator message, button label, and the guestbook toast is looked up
  through it — nothing is hardcoded per-language in the widgets.
- `MaterialApp` in `main.dart` wires up `flutter_localizations`
  (`GlobalMaterialLocalizations`, `GlobalWidgetsLocalizations`,
  `GlobalCupertinoLocalizations`) and passes `locale: language.locale`.
  Flutter automatically derives the app-wide `Directionality` from that
  locale, so **Arabic renders fully right-to-left** with zero manual RTL
  widgets required elsewhere.
- Dates/times are formatted per-language by `core/utils/date_formatter.dart`
  without needing `intl`'s async locale-data initialization (which is easy
  to forget on Flutter Web) — it derives weekday/month names from the
  `DateTime` directly, so changing the wedding date automatically updates
  both languages correctly.
- Tap the gold pill button (top-right of the hero) to toggle languages at
  any time — see `LanguageToggleButton`.

## 📅 Wedding Details (edit in `app_constants.dart`)

| Field | Value |
|---|---|
| Date & time | September 5, 2026, 6:00 PM |
| Venue (EN) | Evangelical Church in Abu Qurqas al-Balad |
| Venue (AR) | الكنيسة الإنجيلية بأبو قرقاص البلد |
| Maps link | https://maps.app.goo.gl/PApVrYTyzeSyR5un9 |

## 🧩 Key Design Decisions & Fixes

- **Cubit over full Bloc** for both the guestbook and locale state — the
  interactions are simple enough that `Cubit` keeps the code lean while
  `BlocBuilder`/`BlocConsumer` still give clean state/UI separation.
- **Two independent status enums** (`BlessingsStatus` for the live list,
  `SubmissionStatus` for the form) so submitting a new blessing never
  interrupts or reloads the existing list.
- **Circular photo fix:** the hero photo previously could turn oval when
  its flexible parent (`Expanded`) got narrower than the intended size on
  window resize. It's now wrapped in `AspectRatio(aspectRatio: 1)` inside a
  `ConstrainedBox`, guaranteeing a true 1:1 square *before* `ClipOval`
  clips it — so it stays a perfect circle at every viewport width. See
  `_CouplePhoto` in `hero_section.dart`.
- **Custom "thank you" toast:** submitting a blessing shows a bespoke
  floating card (`_ThankYouToast` in `blessings_section.dart`) — the
  couple's circular photo next to the localized message — instead of a
  default `SnackBar` look, by rendering the card as the SnackBar's
  `content` with a transparent background/no elevation.
- **Splash / welcome screen:** `splash_screen.dart` plays an intro (drop
  your own `assets/images/splash.gif` to use a real animated intro — it's
  picked up automatically) with a minimal "Skip" button in the
  language-aware corner. `RootScreen` in `main.dart` cross-fades into the
  main page via `AnimatedSwitcher` once the timer elapses or the person
  taps Skip. Tune the auto-advance duration via
  `AppConstants.splashAutoAdvance` to match your GIF's real length.
- **Scroll reveal animations:** `ScrollFadeIn` (using the
  `visibility_detector` package) fades + slides each section up the first
  time it scrolls into view, replacing the previously static scroll feel.
  Wrapped around Countdown, Venue, and Blessings in `wedding_home_page.dart`.
- **RTL correctness:** hardcoded `TextAlign.left` was replaced with
  `TextAlign.start` throughout so text alignment mirrors correctly in
  Arabic; `Row`s (e.g. the thank-you toast) rely on Flutter's automatic
  RTL mirroring rather than manual child reordering.

## 🎵 Background Music

- The track is bundled at `assets/audio/wedding-music.mp3` and played via
  the `audioplayers` package (`lib/features/music/cubit/music_cubit.dart`),
  looping at a comfortable volume (`AppConstants.backgroundMusicVolume`).
- **Why it might not start instantly on web:** browsers block audio-with-
  sound until the page receives a real user gesture (a security policy,
  not a bug — Flutter can't override it). The app tries to autoplay on
  load; if the browser blocks it, playback starts automatically on the
  guest's very first tap/click anywhere on the page (wired in `RootScreen`
  in `main.dart`), so in practice music starts the moment someone
  interacts with the invitation.
- A small floating gold button (bottom-right, always visible via
  `MusicToggleButton`) lets guests mute/unmute manually at any time.
- To swap the track: replace `assets/audio/wedding-music.mp3` (same
  filename) or update `AppConstants.backgroundMusicAssetPath`.

## 📦 Notes

- **Splash GIF:** no animated GIF asset is bundled by default (none was
  provided). Add yours at `assets/images/splash.gif` — it's already
  registered under `assets:` in `pubspec.yaml` via the `assets/images/`
  folder glob, so no further pubspec changes are needed. Until you add
  one, a tasteful animated gold-ring-and-heart monogram is shown instead.
- The couple's photo (`assets/images/couple.png`) is used both in the hero
  circle and the thank-you toast.
