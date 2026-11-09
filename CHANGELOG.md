## 1.5.0

* `AppInfo.videos` (`videos` in `catalog.json`, optional): a short promo
  video per locale for house ads, and `videoFor(locale)` (English
  fallback). Light, silent, vertical MP4 hosted on the studio site
  (`happyapp.studio/apps/<app>/promo/`), so it can change without a
  release. Older versions of the package ignore the field.
* `tool/promo_video.sh`: turns a reel into that light video.

## 1.4.0

* House ads: `qrLink` on `HouseAdView` and `HouseInstallPanel`. On a
  computer, a single QR of that link (an address of the host app's site
  that sends each phone to its own store) above both store links, instead
  of one QR per store. Without it, nothing changes.

## 1.3.0

* House ads: a full-screen ad for an app of the studio, to show instead of
  an ad network ad (web build, or when AdMob cannot show anything). No
  dependency on any ad SDK: pacing and forbidden moments stay in the host
  app.
  * `HouseAd` (`SelfAppAd`, `StudioAppAd`), `studioAppsInOrder` (host app
    excluded by `selfId`), `houseAdAt` (host app once every N ads, or never
    with `selfEvery: 0`).
  * Store links with a campaign (`ct` on the App Store, `utm_source` and
    `utm_medium` in the Play referrer): `studioStoreUri`, `houseAdLinks`,
    `houseAdStoresFor`.
  * `HouseAdView` (skip button after N seconds, back blocked until then; a
    store button on a phone, QR codes and links on a computer) and
    `HouseInstallPanel`; look injected with `HouseAdStyle` (background,
    buttons, QR builder, text styles, spacing), Material by default.
  * `HouseAdStrings`: built-in texts in English, French, Spanish, German and
    Italian, or injected by the app.

## 1.2.0

* The `happy_hour` entry is renamed Pypo, with a new icon and a description
  without any "hot" angle or alcohol. Same id, same store links.

## 1.1.0

* Web: no more `dart:io` in `CrossPromoCard` and `CrossPromoBanner`. The store
  link comes from `defaultTargetPlatform`, which follows the visitor's OS in a
  browser (Play Store on Android, instead of the App Store for every visitor).
* A failed store launch no longer throws from the tap handler.
* French section title: "Découvre nos autres apps" (typo).
* Tests: store links on every platform (VM and Chrome), `catalog.json` and the
  embedded catalog kept in sync, icons present in `assets/`.
* `example/`: minimal app, built for the web by `tool/verify.sh`.

## 1.0.0

* Initial release.
