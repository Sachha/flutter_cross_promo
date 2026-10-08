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
