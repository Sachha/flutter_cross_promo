import 'package:cross_promo/cross_promo.dart';
import 'package:flutter/material.dart';

/// Remote catalog of the package (`main` branch), as in the README.
const String catalogBaseUrl =
    'https://raw.githubusercontent.com/Sachha/flutter_cross_promo/main';

void main() {
  runApp(
    CrossPromoExampleApp(
      catalogService: CatalogService(repoRawBaseUrl: catalogBaseUrl),
    ),
  );
}

/// Example app: a [CrossPromoSection] and a [CrossPromoBanner].
///
/// Without [catalogService], everything comes from the embedded catalog
/// (used by the tests).
class CrossPromoExampleApp extends StatelessWidget {
  const CrossPromoExampleApp({super.key, this.catalogService});

  final CatalogService? catalogService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cross_promo',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('cross_promo')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CrossPromoBanner(
              app: fallbackCatalog.apps.first,
              catalogService: catalogService,
            ),
            const SizedBox(height: 24),
            CrossPromoSection(
              excludeAppId: 'tic_tac_go',
              catalogService: catalogService,
            ),
          ],
        ),
      ),
    );
  }
}
