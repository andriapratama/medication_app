# Medication App

A small Flutter app for looking up drug labels from the openFDA API. You can scroll through medications, search by name or ingredient, open the full label, and keep a list of favorites on your phone.

I built this for the ITSD Flutter Mobile Developer take-home test.

## What it does

- Shows a list of medications, 20 at a time. More load as you scroll, and you can pull down to refresh.
- Search looks at the brand name, generic name, and active ingredient. It waits until you stop typing for 400 ms before sending a request, so it doesn't hit the API on every key press.
- The detail page shows the names, manufacturer, an OTC or Rx badge, and sections for purpose, dosage, warnings, and ingredients. Sections can be opened and closed.
- Tap the star on a detail page to save it. Favorites live in their own tab, you can swipe one away to remove it, and they're still there after you close the app.
- The app follows the phone's language. English and Indonesian are supported.
- Every screen has a loading, empty, and error state, and errors come with a Retry button.

## Before you start

You'll need Flutter 3.38.7 (stable channel, Dart 3.10) and either an Android emulator, an iOS simulator, or a real device.

There's no API key or secret to set up. openFDA works without a key, with a limit of 40 requests a minute.

## Running the app

```bash
flutter pub get
flutter run
```

The Hive adapter file (`medication_model.g.dart`) is already committed. If you ever change `MedicationModel`, regenerate it with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Running the tests

```bash
flutter test
```

There are 43 tests. They cover the repository (success, every kind of error including a 429 rate limit, and the favorites stream), the three cubits (list, detail, favorites), and two screens (detail and favorites). Everything is mocked, so the tests never call the real API.

## How the code is organized

```
lib/
  core/          constants, DI setup, error types, Dio client, small helpers
  domain/        entities, the repository contract, use cases (plain Dart only)
  data/          the JSON/Hive model, API and Hive data sources, repository
  presentation/  one folder per feature with its cubit and screens, plus shared widgets
  router/        go_router setup and the bottom navigation shell
  l10n/          translation files and the generated classes
```

A request always goes the same way: screen, cubit, use case, repository, data source. The repository catches every exception and hands back either `Ok(data)` or `Err(failure)`, so the screens never see a raw Dio or Hive error.

The reasoning behind these choices is in [docs/ADR.md](docs/ADR.md).

## Translations

All UI text is in `lib/l10n/app_en.arb` and `lib/l10n/app_id.arb`. The Dart classes are generated on `flutter pub get` or `flutter run` because `generate: true` is set in `pubspec.yaml`. Running `flutter gen-l10n` does the same thing by hand.

The drug information itself comes straight from openFDA and stays in English.

## Building for release

```bash
flutter build apk --release --split-per-abi
```

This gives one APK per CPU type, around 8 MB each. For now the release build is signed with the debug key.

## Known limitations

A few things I'm aware of but didn't get to:

- Without an API key, openFDA allows 40 requests a minute and 1,000 a day per IP. The app retries a 429 with backoff, but a long session can still run into the daily limit.
- Search only shows the first 20 matches. Unlike the main list, search results don't load more pages.
- openFDA doesn't accept a `skip` above 25,000, so the main list stops after roughly 1,250 pages.
- About half of the labels have no `openfda.brand_name`. For those, the app takes the name from the start of `spl_product_data_elements`, which is free text, so some names come out cut short or with an extra word.
- openFDA returns most text fields as arrays and the app only shows the first entry, so part of a long warning can be missing.
- Label text is shown exactly as the FDA wrote it. Sections often repeat their own heading (for example "Warnings Liver warning...") and are only in English.
- A favorite is a snapshot of the label at the moment you saved it. It isn't refreshed from the API later.
- The list and detail pages need internet. Only favorites work offline.
- If saving a favorite fails, the star quietly goes back to how it was. There's no message telling the user why.
- There's no language switch inside the app (it follows the phone setting) and no dark mode.
- Widget tests only cover the detail and favorites screens. The list screen is covered through its cubit tests only.
- The wait-and-retry timing in `RetryInterceptor` isn't unit tested. The mapping from 429 to a rate limit error is.
- I couldn't use the new Dart 3.10 shorthand like `.center`. `hive_generator` depends on an old analyzer that fails to parse it, so the code writes out full names everywhere. Switching to `hive_ce` would fix this.
- The release build uses the debug signing key and the `com.example` package name, so it isn't ready for the Play Store yet.

## What I'd do next

- Cache the last few pages so the list still opens without internet
- Load more search results as you scroll, the same way the main list does
- Show a short message when saving or removing a favorite fails
- Cancel old search requests with a Dio `CancelToken` rather than just ignoring their results
- Respect the `Retry-After` header when openFDA says we're sending too many requests
- Add filters for OTC and prescription drugs, and some sorting options
- A widget test for the list screen, and golden tests for the list item and detail page
- Dark mode and an in-app language switch

## Time spent

Estimated from my commit history, spread over five full working days. A fair share of it went into learning as I went, since Bloc, Hive, and go_router were new to me, and into reading the openFDA docs to understand how the data is shaped.

| Work | Time |
|---|---|
| Reading the brief, exploring the openFDA API, planning the structure | ~3 h |
| Project setup, dependencies, localization config | ~1.5 h |
| Core layer: error types, `Result`, debouncer, Dio client with retry on 429 | ~4 h |
| Domain layer: entities, repository contract, use cases | ~2.5 h |
| Data layer: model and JSON parsing for the openFDA quirks (empty `openfda`, array fields, OTC vs prescription fields, name fallback) | ~6 h |
| Hive setup and fixing the `hive_generator` build error | ~2 h |
| Remote and local data sources, repository implementation | ~3.5 h |
| Repository tests with mocks, including the 429 case | ~3 h |
| Dependency injection, translations, shared widgets, routing | ~4 h |
| Medication list with pagination, pull-to-refresh, and load-more errors | ~4.5 h |
| Search with debounce and query cleanup | ~2.5 h |
| Detail screen, sections, and favorite toggle, with tests | ~4 h |
| Favorites tab (Hive stream, swipe to remove), with tests | ~3 h |
| Testing on Android, release build, internet permission fix | ~2.5 h |
| Cleanup, formatting, final pass over the code | ~1.5 h |
| README and ADR | ~2.5 h |
| Total | ~50 h |
