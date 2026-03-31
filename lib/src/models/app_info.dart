/// Represents an app to promote.
class AppInfo {
  /// Unique identifier for this app (e.g. 'tic_tac_go', 'aouh').
  final String id;

  /// Display name shown to users.
  final String name;

  /// Short description per locale. Key = locale code, value = description.
  final Map<String, String> descriptions;

  /// Icon filename (e.g. 'aouh.webp'). Resolved to a full URL by the catalog service.
  final String icon;

  /// App Store URL (iOS).
  final String? appStoreUrl;

  /// Play Store URL (Android).
  final String? playStoreUrl;

  const AppInfo({
    required this.id,
    required this.name,
    required this.descriptions,
    required this.icon,
    this.appStoreUrl,
    this.playStoreUrl,
  });

  /// Returns the localized description, falling back to English.
  String descriptionFor(String locale) =>
      descriptions[locale] ?? descriptions['en'] ?? '';

  factory AppInfo.fromJson(Map<String, dynamic> json) => AppInfo(
        id: json['id'] as String,
        name: json['name'] as String,
        descriptions: Map<String, String>.from(json['descriptions'] as Map),
        icon: json['icon'] as String,
        appStoreUrl: json['appStoreUrl'] as String?,
        playStoreUrl: json['playStoreUrl'] as String?,
      );
}
