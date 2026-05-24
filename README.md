# Cross Promo

Cross-promote your Flutter apps to each other's users. Theme-adaptive widgets that integrate naturally into any app.

## Features

- 🎨 Theme-adaptive cards that match your app's look & feel
- 🌍 Multi-language support (EN, FR, ES, DE, IT, PT, NL)
- 🔄 Remote catalog: update app list & descriptions without releasing a new version
- 📴 Offline fallback: works without network using embedded data

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

Available app IDs: `tic_tac_go`, `aouh`, `happy_hour`

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

> 💡 Don't forget to also update `lib/src/data/app_catalog.dart` to keep the offline fallback in sync.
