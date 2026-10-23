import 'package:flutter/foundation.dart';

/// Texts of the house ad. Built in for English, French, Spanish, German and
/// Italian ([HouseAdStrings.of]); a host app can inject its own (for
/// instance from its ARB files) with the constructor or [copyWith].
@immutable
class HouseAdStrings {
  const HouseAdStrings({
    required this.label,
    required this.skip,
    required this.skipIn,
    required this.studio,
    required this.install,
    required this.selfTitle,
    required this.selfBody,
    required this.scan,
    required this.appStore,
    required this.play,
  });

  /// Languages with built-in texts.
  static const List<String> languages = ['en', 'fr', 'es', 'de', 'it'];

  /// Built-in texts for [languageCode]; English for any other language.
  factory HouseAdStrings.of(String languageCode) => switch (languageCode) {
    'fr' => fr,
    'es' => es,
    'de' => de,
    'it' => it,
    _ => en,
  };

  /// Ad label in the corner ("Ad").
  final String label;

  /// Skip button, once active ("Skip").
  final String skip;

  /// Skip button while counting down ("Skip in 5s").
  final String Function(int seconds) skipIn;

  /// Overline above another app of the studio ("From the same studio").
  final String studio;

  /// Store button on a phone ("Install Doku").
  final String Function(String app) install;

  /// Title of the host app's own ad ("Install Pypo").
  final String Function(String app) selfTitle;

  /// Body of the host app's own ad (usually injected by the app).
  final String selfBody;

  /// Hint under the QR codes on a computer ("Scan with your phone").
  final String scan;

  /// Store names under the QR codes.
  final String appStore;
  final String play;

  HouseAdStrings copyWith({
    String? label,
    String? skip,
    String Function(int seconds)? skipIn,
    String? studio,
    String Function(String app)? install,
    String Function(String app)? selfTitle,
    String? selfBody,
    String? scan,
    String? appStore,
    String? play,
  }) => HouseAdStrings(
    label: label ?? this.label,
    skip: skip ?? this.skip,
    skipIn: skipIn ?? this.skipIn,
    studio: studio ?? this.studio,
    install: install ?? this.install,
    selfTitle: selfTitle ?? this.selfTitle,
    selfBody: selfBody ?? this.selfBody,
    scan: scan ?? this.scan,
    appStore: appStore ?? this.appStore,
    play: play ?? this.play,
  );

  static String _enSkipIn(int s) => 'Skip in ${s}s';
  static String _enInstall(String app) => 'Install $app';
  static String _frSkipIn(int s) => 'Passer dans $s s';
  static String _frInstall(String app) => 'Installer $app';
  static String _frSelfTitle(String app) => 'Installe $app';
  static String _esSkipIn(int s) => 'Saltar en $s s';
  static String _esInstall(String app) => 'Instalar $app';
  static String _esSelfTitle(String app) => 'Instala $app';
  static String _deSkipIn(int s) => 'Noch $s s';
  static String _deInstall(String app) => '$app installieren';
  static String _deSelfTitle(String app) => 'Installiere $app';
  static String _itSkipIn(int s) => 'Salta tra $s s';
  static String _itInstall(String app) => 'Installa $app';

  static const HouseAdStrings en = HouseAdStrings(
    label: 'Ad',
    skip: 'Skip',
    skipIn: _enSkipIn,
    studio: 'From the same studio',
    install: _enInstall,
    selfTitle: _enInstall,
    selfBody: "It's free.",
    scan: 'Scan with your phone',
    appStore: 'App Store',
    play: 'Google Play',
  );

  static const HouseAdStrings fr = HouseAdStrings(
    label: 'Pub',
    skip: 'Passer',
    skipIn: _frSkipIn,
    studio: 'Du même studio',
    install: _frInstall,
    selfTitle: _frSelfTitle,
    selfBody: "C'est gratuit.",
    scan: 'Scanne avec ton téléphone',
    appStore: 'App Store',
    play: 'Google Play',
  );

  static const HouseAdStrings es = HouseAdStrings(
    label: 'Anuncio',
    skip: 'Saltar',
    skipIn: _esSkipIn,
    studio: 'Del mismo estudio',
    install: _esInstall,
    selfTitle: _esSelfTitle,
    selfBody: 'Es gratis.',
    scan: 'Escanea con tu móvil',
    appStore: 'App Store',
    play: 'Google Play',
  );

  static const HouseAdStrings de = HouseAdStrings(
    label: 'Werbung',
    skip: 'Überspringen',
    skipIn: _deSkipIn,
    studio: 'Vom selben Studio',
    install: _deInstall,
    selfTitle: _deSelfTitle,
    selfBody: 'Kostenlos.',
    scan: 'Scanne mit deinem Handy',
    appStore: 'App Store',
    play: 'Google Play',
  );

  static const HouseAdStrings it = HouseAdStrings(
    label: 'Pubblicità',
    skip: 'Salta',
    skipIn: _itSkipIn,
    studio: 'Dallo stesso studio',
    install: _itInstall,
    selfTitle: _itInstall,
    selfBody: 'È gratis.',
    scan: 'Inquadra con il telefono',
    appStore: 'App Store',
    play: 'Google Play',
  );
}
