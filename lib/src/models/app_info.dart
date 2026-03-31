import 'package:flutter/widgets.dart';

/// Represents an app to promote.
class AppInfo {
  /// Unique identifier for this app (e.g. 'tic_tac_go', 'aouh').
  final String id;

  /// Display name shown to users.
  final String name;

  /// Short description (1 line).
  final String description;

  /// Icon widget — can be an Image.asset, Image.network, Icon, or any widget.
  final Widget icon;

  /// App Store URL (iOS). Null if not on iOS.
  final String? appStoreUrl;

  /// Play Store URL (Android). Null if not on Android.
  final String? playStoreUrl;

  const AppInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.appStoreUrl,
    this.playStoreUrl,
  });
}
