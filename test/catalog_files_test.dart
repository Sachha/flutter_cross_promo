// Reads files of the repository: VM only.
@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:cross_promo/cross_promo.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _appJson(AppInfo app) => {
  'id': app.id,
  'name': app.name,
  'descriptions': app.descriptions,
  'icon': app.icon,
  'appStoreUrl': app.appStoreUrl,
  'playStoreUrl': app.playStoreUrl,
};

void main() {
  final remote = Catalog.fromJson(
    jsonDecode(File('catalog.json').readAsStringSync()) as Map<String, dynamic>,
  );

  test('catalog.json (remote) and fallbackCatalog (embedded) are in sync', () {
    expect(remote.sectionTitles, fallbackCatalog.sectionTitles);
    expect(remote.buttonLabels, fallbackCatalog.buttonLabels);
    expect(
      remote.apps.map(_appJson).toList(),
      fallbackCatalog.apps.map(_appJson).toList(),
    );
  });

  test('every icon of the catalog is an asset of the package', () {
    for (final app in fallbackCatalog.apps) {
      expect(File('assets/${app.icon}').existsSync(), isTrue, reason: app.id);
    }
  });

  test('ids are unique and every app has an English description', () {
    final ids = fallbackCatalog.apps.map((a) => a.id).toList();
    expect(ids.toSet().length, ids.length);
    for (final app in fallbackCatalog.apps) {
      expect(app.descriptions['en'], isNotEmpty, reason: app.id);
    }
  });

  test('no dart:io in lib/ (the package must compile and run on the web)', () {
    final offenders = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where(
          (f) => RegExp(
            r'''import\s+['"]dart:io['"]''',
          ).hasMatch(f.readAsStringSync()),
        )
        .map((f) => f.path)
        .toList();
    expect(offenders, isEmpty);
  });
}
