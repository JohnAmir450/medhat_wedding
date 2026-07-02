# 💍 Digital Wedding Invitation — Flutter Web

A premium, minimalist, luxury-styled single-page wedding invitation built with
Flutter Web, `flutter_bloc`, and Firebase Firestore.

## ✨ Palette & Type

- **Colors:** Deep Navy (`#0B2A25`), Emerald (`#16433B`), Gold (`#C9A66B`) —
  defined once in `lib/core/theme/app_theme.dart` (`AppColors`). Swap these
  four hex values to switch to a Champagne & Rose Gold theme; nothing else
  needs to change.
- **Type:** `Great Vibes` (script, names/hero) + `Playfair Display`
  (headings) + `Lato` (body/UI), all loaded via `google_fonts` — no manual
  font bundling required.

## 📁 Project Structure (Feature-First / Clean Architecture)

```
lib/
├── main.dart                          # Firebase init + MaterialApp
├── core/
│   ├── constants/app_constants.dart   # Couple names, date, venue, hashtag
│   ├── theme/app_theme.dart           # Colors, text styles, ThemeData
│   └── utils/responsive.dart          # Breakpoint helpers
├── features/
│   └── blessings/                     # Guestbook feature
│       ├── data/
│       │   ├── models/blessing_model.dart
│       │   └── services/firebase_service.dart
│       ├── cubit/
│       │   ├── blessings_cubit.dart
│       │   └── blessings_state.dart
│       └── presentation/widgets/blessings_section.dart
└── presentation/
    ├── pages/wedding_home_page.dart   # Assembles all sections
    └── widgets/
        ├── hero_section.dart
        ├── countdown_section.dart
        ├── venue_section.dart
        └── common/section_wrapper.dart
```

Each layer only depends on the one below it (presentation → cubit → data),
so the guestbook's Firestore logic can be swapped for another backend by
rewriting only `firebase_service.dart`.

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
   This generates `lib/firebase_options.dart`. Then in `main.dart`:
   - uncomment `import 'firebase_options.dart';`
   - replace the manual `FirebaseOptions(...)` block with
     `options: DefaultFirebaseOptions.currentPlatform`.

3. **Create the Firestore collection**
   The app reads/writes `blessings` (see `AppConstants.blessingsCollection`).
   No manual setup needed — the first submission creates it automatically.
   Deploy the included rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

4. **Personalize content**
   Edit `lib/core/constants/app_constants.dart`: names, date/time, venue,
   address, coordinates, and photo URLs.

5. **Run**
   ```bash
   flutter run -d chrome
   ```

## 🧩 Key Design Decisions

- **Cubit over full Bloc** for the guestbook: the interactions are simple
  (subscribe to a stream, submit a form) so `Cubit` keeps the code lean
  while `flutter_bloc`'s `BlocBuilder` / `BlocConsumer` still give clean
  separation between state and UI.
- **Two independent status enums** (`BlessingsStatus` for the live list,
  `SubmissionStatus` for the form) so submitting a new blessing never
  interrupts or reloads the existing list.
- **`SectionWrapper` + `SectionTitle`** centralize spacing/typography rules
  so every section (`Hero`, `Countdown`, `Venue`, `Blessings`) stays visually
  consistent without repeating layout code.
- **Responsive layout** via `Responsive` helpers — hero switches from a
  side-by-side desktop layout to a stacked mobile layout, and the blessings
  grid adapts from 3 columns → 2 → 1.
- **`flutter_animate`** powers the subtle fade/slide entry animations
  throughout (hero text, countdown digits, blessing cards).

## 📦 Notes

- Replace `AppConstants.heroImageUrl` / `coupleImageUrl` with your own
  hosted photos (or bundle them as assets and update `pubspec.yaml`).
- `google_maps_flutter` is included in `pubspec.yaml` for an optional
  embedded map upgrade to the Venue section; the current implementation
  keeps it simple with a "View on Google Maps" deep link via `url_launcher`.
