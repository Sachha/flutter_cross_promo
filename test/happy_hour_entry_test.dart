import 'package:cross_promo/cross_promo.dart';
import 'package:flutter_test/flutter_test.dart';

/// Words that must never describe the app in a catalog shown by all-ages
/// apps: no "hot" angle, no alcohol (5 languages of the app, plus PT and NL).
final _forbidden = RegExp(
  r'\bhot\b|picant|hei(ß|ss)|piccant|pikant|sexy|alcoo?l|alkohol|álcool|'
  r'bi(è|e)re?\b|\bbeer|birra|cerveja|cerveza|\bvin\b|\bwine|\bwein\b|\bvino|'
  r'\bshots?\b|\bdrinks?\b|\bboire\b|trinken|beber|\bbere\b|cocktail|ap(é|e)ro|'
  r'happy ?hour|\bivre|drunk|betrunken|borracho|ubriac|bêbad|dronken',
  caseSensitive: false,
);

void main() {
  final entry = fallbackCatalog.apps.singleWhere((a) => a.id == 'happy_hour');

  test('the happy_hour id is kept and the entry is named Pypo', () {
    expect(entry.name, 'Pypo');
    expect(entry.icon, 'happy_hour.webp');
    expect(
      fallbackCatalog.apps.where((a) => a.name.contains('Happy')),
      isEmpty,
    );
  });

  test('same app in the stores (store ids unchanged)', () {
    expect(entry.appStoreUrl, contains('id1536798029'));
    expect(entry.playStoreUrl, endsWith('?id=happyapp.happyhour'));
  });

  test('descriptions in 7 languages, without "hot" or alcohol', () {
    expect(entry.descriptions.keys.toSet(), {
      'en',
      'fr',
      'es',
      'de',
      'it',
      'pt',
      'nl',
    });
    entry.descriptions.forEach((locale, text) {
      expect(text, isNotEmpty, reason: locale);
      expect(_forbidden.hasMatch(text), isFalse, reason: '$locale: $text');
    });
  });

  test('the forbidden-word check catches the former descriptions', () {
    const former = [
      'Hot party games all in one app!',
      'Des jeux de soirée hot réunis en une seule app !',
      '¡Juegos de fiesta picantes en una sola app!',
      'Heiße Partyspiele in einer App!',
      "Giochi di società piccanti in un'unica app!",
      'Jogos de festa picantes numa só app!',
      'Pikante partyspellen in één app!',
    ];
    for (final text in former) {
      expect(_forbidden.hasMatch(text), isTrue, reason: text);
    }
  });
}
