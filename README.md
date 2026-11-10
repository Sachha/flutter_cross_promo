# Cross Promo

Cross-promote your Flutter apps to each other's users. Theme-adaptive widgets that integrate naturally into any app.

## Features

- 🎨 Theme-adaptive cards that match your app's look & feel
- 🌍 Multi-language support (EN, FR, ES, DE, IT, PT, NL)
- 🔄 Remote catalog: update app list & descriptions without releasing a new version
- 📴 Offline fallback: works without network using embedded data
- 📺 House ads: a full-screen ad for another app of the studio, when the ad network has nothing to show
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

### 4. House ads

A full-screen ad for an app of the studio, to show at the moments where the
host app would show an interstitial (the host app keeps the pacing, the
forbidden moments and the consent rules; this package only picks the ad and
renders it):

```dart
final others = studioAppsInOrder(['doku', 'aouh'], selfId: 'happy_hour');
final ad = houseAdAt(rotationIndex, selfEvery: 0, others: others); // never self
if (ad != null) {
  await Navigator.of(context).push(MaterialPageRoute(
    fullscreenDialog: true,
    builder: (context) => HouseAdView(
      ad: ad,
      links: houseAdLinks(ad, houseAdStoresFor(defaultTargetPlatform),
          campaign: 'myapp_house'),
      onClose: () => Navigator.of(context).pop(),
      // Optional: strings: HouseAdStrings.of('fr').copyWith(...),
      // style: HouseAdStyle(button: ..., qr: ..., background: ...),
    ),
  ));
}
```

`selfEvery: 2` alternates the host app's own ad (`SelfAppAd`, with
`selfName`, `selfHero` and links from `selfLink`) with the other apps.
Texts are built in for EN, FR, ES, DE and IT.
On a computer, both stores get a QR code; pass `qrLink` (an address of your
site that redirects each phone to its own store, by user agent) to show a
single QR above the two store links instead.

### 5. Promo videos (house ads)

An app of the catalog can have a short promo video per locale (`videos`,
English fallback with `videoFor(locale)`): a light, silent, vertical MP4
hosted on the studio site, so it can change without a release.

```json
"videos": {
  "fr": "https://happyapp.studio/apps/doku/promo/doku-pays-fr-v1.mp4",
  "en": "https://happyapp.studio/apps/doku/promo/doku-pays-en-v1.mp4"
}
```

1. `tool/promo_video.sh <reel.mp4> <out.mp4>` (540 px wide, no sound,
   15 s at most, ~0.5 MB), into `happyapp-studio/apps/<app>/promo/`.
2. Push the site (its CI deploys `happyapp.studio/apps/<app>/promo/…`).
3. Then the URL in `catalog.json` and `lib/src/data/app_catalog.dart`.

A new video always gets a new file name (`-v2`): host apps cache videos by
URL. The package only carries the URLs; downloading and playing them is up
to the host app (Tic Tac Go downloads them during the game and falls back
to the icon). With the shared `HouseAdView`, the host app passes its
player as `studioVisual` (Pypo).

## Updating the catalog

To update app descriptions, icons, or add new apps **without releasing a new version** of your apps:

1. Edit `catalog.json` in this repo
2. Add/update assets in the `assets/` folder (use `.webp` format)
3. Push to the `main` branch
4. Changes will be reflected in all apps on next launch

> 💡 Don't forget to also update `lib/src/data/app_catalog.dart` to keep the offline fallback in sync: `test/catalog_files_test.dart` fails when the two differ, or when an icon is missing from `assets/`.

## Development

`tool/verify.sh` runs everything: analysis, tests on the VM and in Chrome (`SKIP_CHROME=1` to skip them), and the web builds (dart2js and dart2wasm) of the app in `example/`.
