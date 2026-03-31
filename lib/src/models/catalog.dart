import 'app_info.dart';

/// Full catalog with localized UI strings and app list.
class Catalog {
  final Map<String, String> sectionTitles;
  final Map<String, String> buttonLabels;
  final List<AppInfo> apps;

  const Catalog({
    required this.sectionTitles,
    required this.buttonLabels,
    required this.apps,
  });

  String sectionTitleFor(String locale) =>
      sectionTitles[locale] ?? sectionTitles['en'] ?? 'Discover our apps';

  String buttonLabelFor(String locale) =>
      buttonLabels[locale] ?? buttonLabels['en'] ?? 'Download';

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
        sectionTitles: Map<String, String>.from(json['sectionTitles'] as Map),
        buttonLabels: Map<String, String>.from(json['buttonLabels'] as Map),
        apps: (json['apps'] as List)
            .map((e) => AppInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
