import 'package:flutter_test/flutter_test.dart';
import 'package:cross_promo/cross_promo.dart';

void main() {
  test('AppInfo.descriptionFor returns correct locale', () {
    const app = AppInfo(
      id: 'test',
      name: 'Test',
      descriptions: {'en': 'English', 'fr': 'Français'},
      icon: 'test.png',
    );

    expect(app.descriptionFor('fr'), 'Français');
    expect(app.descriptionFor('en'), 'English');
    expect(app.descriptionFor('de'), 'English'); // fallback to en
  });

  test('Catalog localized getters work', () {
    expect(fallbackCatalog.sectionTitleFor('fr'), 'Découvre nos apps');
    expect(fallbackCatalog.buttonLabelFor('fr'), 'Obtenir');
    expect(fallbackCatalog.sectionTitleFor('zh'), 'Discover our apps');
    expect(fallbackCatalog.buttonLabelFor('zh'), 'Get');
  });

  test('fallbackCatalog contains apps', () {
    expect(fallbackCatalog.apps.length, greaterThanOrEqualTo(2));
    expect(fallbackCatalog.apps.any((a) => a.id == 'tic_tac_go'), true);
    expect(fallbackCatalog.apps.any((a) => a.id == 'aouh'), true);
  });

  test('CatalogService builds correct icon URL', () {
    final service = CatalogService(
      repoRawBaseUrl: 'https://raw.githubusercontent.com/user/repo/main',
    );
    expect(
      service.iconUrl('aouh.webp'),
      'https://raw.githubusercontent.com/user/repo/main/assets/aouh.webp',
    );
  });
}
