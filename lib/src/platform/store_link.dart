import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_info.dart';

/// Store link of [app] for [platform] (defaults to [defaultTargetPlatform]).
///
/// No `dart:io`: this file compiles for the web. In a browser,
/// [defaultTargetPlatform] follows the visitor's OS (Safari on iOS gives
/// [TargetPlatform.iOS], Chrome on Android gives [TargetPlatform.android]),
/// so a web visitor gets the store of their phone.
///
/// - iOS and macOS: App Store only (null if the app has none).
/// - Android: Play Store only (null if the app has none).
/// - Anything else (desktop browser on Windows or Linux, …): App Store,
///   then Play Store.
String? storeUrlFor(AppInfo app, {TargetPlatform? platform}) {
  switch (platform ?? defaultTargetPlatform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return app.appStoreUrl;
    case TargetPlatform.android:
      return app.playStoreUrl;
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return app.appStoreUrl ?? app.playStoreUrl;
  }
}

/// Launch mode for store links: the browser only supports the default mode
/// (`url_launcher_web` opens a new tab), native platforms open the store app.
LaunchMode get storeLaunchMode =>
    kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication;

/// Opens the store page of [app]. Returns false when there is no link for
/// this platform or when the launch fails.
Future<bool> openStore(AppInfo app, {TargetPlatform? platform}) async {
  final url = storeUrlFor(app, platform: platform);
  if (url == null) return false;
  try {
    return await launchUrl(Uri.parse(url), mode: storeLaunchMode);
  } catch (_) {
    // No browser or store app able to open the link: nothing to show.
    return false;
  }
}
