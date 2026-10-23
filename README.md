# Cross Promo

Cross-promote your Flutter apps to each other's users. Theme-adaptive widgets that integrate naturally into any app.

## Features

- 🎨 Theme-adaptive cards that match your app's look & feel
- 🌍 Multi-language support (EN, FR, ES, DE, IT, PT, NL)
- 🔄 Remote catalog: update app list & descriptions without releasing a new version
- 📴 Offline fallback: works without network using embedded data
- 🌐 Web support: no `dart:io`; in a browser, the store link follows the visitor's OS (App Store on iOS and macOS, Play Store on Android)

## Getting started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  cross_promo:
    git:
      url: https://github.com/Sachha/flutter_cross_promo.git
```

## Usage

### 1. Create a CatalogService

> ⚠️ **Important**: The `repoRawBaseUrl` must point to the `main` branch. This is the URL used to fetch the remote catalog at runtime.

```dart
final catalogService = CatalogService(
  repoRawBaseUrl: 'https://raw.githubusercontent.com/Sachha/flutter_cross_promo/main',
);
```

### 2. Add the CrossPromoSection widget

```dart
CrossPromoSection(
  excludeAppId: 'your_app_id', // exclude the current app from the list
  catalogService: catalogService,
)
```

Available app IDs: `doku`, `rise`, `aouh`, `tic_tac_go`, `happy_hour` (the app now named Pypo: the id did not change)

### 3. Customization

You can customize the appearance with `CrossPromoStyle` and choose between vertical/horizontal layouts:

```dart
CrossPromoSection(
  excludeAppId: 'aouh',
  catalogService: catalogService,
  direction: Axis.horizontal,
  style: CrossPromoStyle(
    cardSpacing: 16,
  ),
)
```

## Updating the catalog

To update app descriptions, icons, or add new apps **without releasing a new version** of your apps:

1. Edit `catalog.json` in this repo
2. Add/update assets in the `assets/` folder (use `.webp` format)
3. Push to the `main` branch
4. Changes will be reflected in all apps on next launch

> 💡 Don't forget to also update `lib/src/data/app_catalog.dart` to keep the offline fallback in sync: `test/catalog_files_test.dart` fails when the two differ, or when an icon is missing from `assets/`.

## Development

`tool/verify.sh` runs everything: analysis, tests on the VM and in Chrome (`SKIP_CHROME=1` to skip them), and the web builds (dart2js and dart2wasm) of the app in `example/`.
