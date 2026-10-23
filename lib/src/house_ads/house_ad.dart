import 'package:flutter/foundation.dart';

import '../data/app_catalog.dart';
import '../models/app_info.dart';

/// A house ad: a full-screen ad for an app of the studio, shown by the host
/// app instead of an ad network ad (web build, ad network unavailable…).
///
/// Pure data: when to show one (pacing, forbidden moments, consent) is up to
/// the host app; this package only picks which ad and renders it.
@immutable
sealed class HouseAd {
  const HouseAd();
}

/// "Install this app": the host app promotes itself (for instance on its web
/// build, to bring visitors to the store).
final class SelfAppAd extends HouseAd {
  const SelfAppAd();

  @override
  bool operator ==(Object other) => other is SelfAppAd;

  @override
  int get hashCode => 0;
}

/// Another app of the studio, from the catalog.
final class StudioAppAd extends HouseAd {
  const StudioAppAd(this.app);

  final AppInfo app;

  @override
  bool operator ==(Object other) =>
      other is StudioAppAd && other.app.id == app.id;

  @override
  int get hashCode => app.id.hashCode;
}

/// The other apps of the studio, in the order of [order]: unknown ids are
/// ignored, catalog apps missing from [order] come last, and the host app
/// ([selfId]) is never included. [catalog] defaults to the embedded
/// [fallbackCatalog] (no network call).
List<AppInfo> studioAppsInOrder(
  List<String> order, {
  required String selfId,
  List<AppInfo>? catalog,
}) {
  final apps = [
    for (final a in catalog ?? fallbackCatalog.apps)
      if (a.id != selfId) a,
  ];
  final byId = {for (final a in apps) a.id: a};
  final seen = <String>{};
  return [
    for (final id in order)
      if (byId[id] != null && seen.add(id)) byId[id]!,
    for (final a in apps)
      if (seen.add(a.id)) a,
  ];
}

/// House ad number [index] of a rotation (0 = the first one).
///
/// - [selfEvery] ≥ 1: the host app ([SelfAppAd]) once every [selfEvery] ads
///   (when `index % selfEvery == 0`), the apps of [others] in between, in a
///   loop. Without other apps: always the host app.
/// - [selfEvery] ≤ 0: never the host app, only [others] in a loop; null when
///   [others] is empty (nothing to show).
HouseAd? houseAdAt(
  int index, {
  required int selfEvery,
  required List<AppInfo> others,
}) {
  if (selfEvery <= 0) {
    if (others.isEmpty) return null;
    return StudioAppAd(others[index % others.length]);
  }
  if (others.isEmpty || index % selfEvery == 0) return const SelfAppAd();
  // "Other app" ads already shown before [index].
  final before = index - index ~/ selfEvery - 1;
  return StudioAppAd(others[before % others.length]);
}

/// A store where an app can be installed.
enum HouseAdStore { appStore, play }

/// Stores to offer on [platform]: iPhone and iPad only have the App Store,
/// Android only Play; a computer (or an unknown device) gets both, for QR
/// codes to scan with a phone.
List<HouseAdStore> houseAdStoresFor(TargetPlatform platform) =>
    switch (platform) {
      TargetPlatform.iOS => const [HouseAdStore.appStore],
      TargetPlatform.android => const [HouseAdStore.play],
      _ => const [HouseAdStore.appStore, HouseAdStore.play],
    };

/// Store page of [app] on [store] with the install campaign of the house
/// ad: `ct` set to [campaign] on the App Store; on Play, `referrer` set to
/// `utm_source` = [campaign] and `utm_medium` = [medium]. Null when the app
/// is not on that store.
Uri? studioStoreUri(
  AppInfo app,
  HouseAdStore store, {
  required String campaign,
  String medium = 'house_ad',
}) {
  final raw = switch (store) {
    HouseAdStore.appStore => app.appStoreUrl,
    HouseAdStore.play => app.playStoreUrl,
  };
  final base = raw == null ? null : Uri.tryParse(raw);
  if (base == null) return null;
  return base.replace(
    queryParameters: {
      ...base.queryParameters,
      ...switch (store) {
        HouseAdStore.appStore => {'ct': campaign},
        HouseAdStore.play => {
          'referrer': 'utm_source=$campaign&utm_medium=$medium',
        },
      },
    },
  );
}

/// Links of [ad] for [stores], in that order. Another app: [studioStoreUri]
/// with [campaign] and [medium]; the host app: [selfLink] (its own links and
/// campaign). Stores without a link are left out.
Map<HouseAdStore, Uri> houseAdLinks(
  HouseAd ad,
  List<HouseAdStore> stores, {
  required String campaign,
  String medium = 'house_ad',
  Uri? Function(HouseAdStore store)? selfLink,
}) => {
  for (final s in stores)
    s: ?switch (ad) {
      SelfAppAd() => selfLink?.call(s),
      StudioAppAd(:final app) => studioStoreUri(
        app,
        s,
        campaign: campaign,
        medium: medium,
      ),
    },
};
