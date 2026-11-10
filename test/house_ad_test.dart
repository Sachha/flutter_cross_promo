import 'package:cross_promo/cross_promo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _selfId = 'happy_hour';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('en'),
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  // Only the description and the built-in texts follow the locale: no
  // Material localizations needed.
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Localizations.override(
          context: context,
          locale: locale,
          child: child,
        ),
      ),
    ),
  );
}

bool _canPop(WidgetTester tester) => tester
    .widgetList<Widget>(find.byWidgetPredicate((w) => w is PopScope))
    .cast<PopScope<Object?>>()
    .first
    .canPop;

void main() {
  final others = studioAppsInOrder(const ['doku', 'aouh'], selfId: _selfId);

  group('rotation', () {
    test('other apps of the catalog, never the host app', () {
      expect(others.map((a) => a.id), isNot(contains(_selfId)));
      expect(others.length, fallbackCatalog.apps.length - 1);
    });

    test('order: unknown ids ignored, missing apps last, no duplicates', () {
      final apps = studioAppsInOrder(const [
        'aouh',
        'nope',
        'aouh',
        'doku',
      ], selfId: _selfId);
      expect(apps.take(2).map((a) => a.id), ['aouh', 'doku']);
      expect(apps.map((a) => a.id).toSet().length, apps.length);
      expect(apps.length, others.length);
    });

    test('selfEvery 2: host app, then the others in a loop', () {
      final ads = [
        for (var i = 0; i < 6; i++)
          houseAdAt(i, selfEvery: 2, others: others.take(2).toList()),
      ];
      expect(ads, [
        const SelfAppAd(),
        StudioAppAd(others[0]),
        const SelfAppAd(),
        StudioAppAd(others[1]),
        const SelfAppAd(),
        StudioAppAd(others[0]),
      ]);
    });

    test('selfEvery 0: never the host app; nothing without other apps', () {
      final ads = [
        for (var i = 0; i < others.length + 1; i++)
          houseAdAt(i, selfEvery: 0, others: others),
      ];
      expect(ads.whereType<SelfAppAd>(), isEmpty);
      expect(ads.first, StudioAppAd(others.first));
      expect(ads.last, StudioAppAd(others.first));
      expect(houseAdAt(3, selfEvery: 0, others: const []), isNull);
      expect(houseAdAt(3, selfEvery: 2, others: const []), const SelfAppAd());
    });
  });

  group('links', () {
    final doku = others.firstWhere((a) => a.id == 'doku');

    test('campaign on both stores, existing query kept', () {
      final ios = studioStoreUri(
        doku,
        HouseAdStore.appStore,
        campaign: 'pypo_app',
      )!;
      expect(ios.queryParameters['ct'], 'pypo_app');
      final play = studioStoreUri(
        doku,
        HouseAdStore.play,
        campaign: 'pypo_app',
        medium: 'fallback',
      )!;
      expect(play.queryParameters['id'], isNotEmpty);
      expect(
        play.queryParameters['referrer'],
        'utm_source=pypo_app&utm_medium=fallback',
      );
    });

    test('stores of the device; self links from the app', () {
      expect(houseAdStoresFor(TargetPlatform.iOS), [HouseAdStore.appStore]);
      expect(houseAdStoresFor(TargetPlatform.android), [HouseAdStore.play]);
      expect(houseAdStoresFor(TargetPlatform.macOS).length, 2);
      final self = houseAdLinks(
        const SelfAppAd(),
        HouseAdStore.values,
        campaign: 'x',
        selfLink: (s) =>
            s == HouseAdStore.play ? Uri.parse('https://play/x') : null,
      );
      expect(self, {HouseAdStore.play: Uri.parse('https://play/x')});
      expect(
        houseAdLinks(StudioAppAd(doku), const [
          HouseAdStore.play,
        ], campaign: 'x').keys,
        [HouseAdStore.play],
      );
    });
  });

  group('strings', () {
    test('5 built-in languages, English otherwise', () {
      expect(HouseAdStrings.languages, ['en', 'fr', 'es', 'de', 'it']);
      final labels = {
        for (final l in HouseAdStrings.languages) HouseAdStrings.of(l).label,
      };
      expect(labels.length, 5);
      expect(HouseAdStrings.of('zh').label, 'Ad');
      expect(HouseAdStrings.of('fr').install('Doku'), 'Installer Doku');
      expect(HouseAdStrings.of('de').install('Doku'), 'Doku installieren');
      expect(HouseAdStrings.fr.copyWith(label: 'Publicité').label, 'Publicité');
    });
  });

  group('view', () {
    final aouh = others.firstWhere((a) => a.id == 'aouh');

    testWidgets('skip only after the delay; back blocked until then', (
      tester,
    ) async {
      var closed = 0;
      await _pump(
        tester,
        HouseAdView(
          ad: StudioAppAd(aouh),
          links: const {},
          onClose: () => closed++,
          skipAfter: const Duration(seconds: 3),
        ),
      );
      expect(find.text('Skip in 3s'), findsOneWidget);
      expect(_canPop(tester), isFalse);
      await tester.tap(find.byKey(HouseAdKeys.skip));
      expect(closed, 0);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Skip'), findsOneWidget);
      expect(_canPop(tester), isTrue);
      await tester.tap(find.byKey(HouseAdKeys.skip));
      expect(closed, 1);
    });

    testWidgets('phone: one store button; texts of the locale', (tester) async {
      final opened = <Uri>[];
      final links = houseAdLinks(StudioAppAd(aouh), const [
        HouseAdStore.play,
      ], campaign: 'test');
      await _pump(
        tester,
        HouseAdView(
          ad: StudioAppAd(aouh),
          links: links,
          onClose: () {},
          onOpen: (u) async => opened.add(u),
        ),
        locale: const Locale('fr'),
      );
      expect(find.byKey(HouseAdKeys.studio('aouh')), findsOneWidget);
      expect(find.text('Du même studio'), findsOneWidget);
      expect(find.text(aouh.descriptionFor('fr')), findsOneWidget);
      await tester.tap(find.byKey(HouseAdKeys.store(HouseAdStore.play)));
      expect(opened, [links[HouseAdStore.play]]);
    });

    testWidgets('computer: QR codes and links; self ad with injected texts', (
      tester,
    ) async {
      final qrs = <String>[];
      await _pump(
        tester,
        HouseAdView(
          ad: const SelfAppAd(),
          links: {
            HouseAdStore.appStore: Uri.parse('https://apps/x'),
            HouseAdStore.play: Uri.parse('https://play/x'),
          },
          onClose: () {},
          selfName: 'Pypo',
          selfHero: const SizedBox(key: ValueKey('hero')),
          strings: HouseAdStrings.en.copyWith(selfBody: 'Party games.'),
          style: HouseAdStyle(
            qr: (_, data, size) {
              qrs.add(data);
              return SizedBox(width: size, height: size);
            },
          ),
        ),
      );
      expect(find.byKey(HouseAdKeys.self), findsOneWidget);
      expect(find.text('Install Pypo'), findsOneWidget);
      expect(find.text('Party games.'), findsOneWidget);
      expect(find.byKey(const ValueKey('hero')), findsOneWidget);
      expect(find.byKey(HouseAdKeys.qr), findsOneWidget);
      expect(qrs, ['https://apps/x', 'https://play/x']);
      expect(find.text('Scan with your phone'), findsOneWidget);
    });

    testWidgets('studio app: studioVisual instead of the icon, icon if null', (
      tester,
    ) async {
      final app = studioAppsInOrder(const [], selfId: _selfId).first;
      Widget view(Widget? visual) => HouseAdView(
        ad: StudioAppAd(app),
        links: {HouseAdStore.play: Uri.parse('https://play/x')},
        onClose: () {},
        studioVisual: (_, a) {
          expect(a.id, app.id);
          return visual;
        },
      );
      await _pump(tester, view(const SizedBox(key: ValueKey('video'))));
      expect(find.byKey(const ValueKey('video')), findsOneWidget);
      expect(find.byType(Image), findsNothing);
      await _pump(tester, view(null));
      expect(find.byKey(const ValueKey('video')), findsNothing);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('computer with qrLink: one QR above both store links', (
      tester,
    ) async {
      final qrs = <String>[];
      final opened = <Uri>[];
      final links = {
        HouseAdStore.appStore: Uri.parse('https://apps/x'),
        HouseAdStore.play: Uri.parse('https://play/x'),
      };
      await _pump(
        tester,
        HouseAdView(
          ad: const SelfAppAd(),
          links: links,
          qrLink: Uri.parse('https://example.app/get'),
          onClose: () {},
          onOpen: (uri) async => opened.add(uri),
          selfName: 'Pypo',
          style: HouseAdStyle(
            qr: (_, data, size) {
              qrs.add(data);
              return SizedBox(width: size, height: size);
            },
          ),
        ),
      );
      expect(find.byKey(HouseAdKeys.qr), findsOneWidget);
      expect(qrs, ['https://example.app/get']);
      final apple = find.byKey(HouseAdKeys.store(HouseAdStore.appStore));
      final play = find.byKey(HouseAdKeys.store(HouseAdStore.play));
      expect(tester.getTopLeft(apple).dy, tester.getTopLeft(play).dy);
      expect(tester.getTopLeft(apple).dx, lessThan(tester.getTopLeft(play).dx));
      expect(find.text('Scan with your phone'), findsOneWidget);
      await tester.tap(apple);
      await tester.tap(play);
      expect(opened, [links[HouseAdStore.appStore], links[HouseAdStore.play]]);
    });

    testWidgets('phone with qrLink: still the store button', (tester) async {
      final qrs = <String>[];
      await _pump(
        tester,
        HouseAdView(
          ad: const SelfAppAd(),
          links: {HouseAdStore.play: Uri.parse('https://play/x')},
          qrLink: Uri.parse('https://example.app/get'),
          onClose: () {},
          selfName: 'Pypo',
          style: HouseAdStyle(
            qr: (_, data, size) {
              qrs.add(data);
              return SizedBox(width: size, height: size);
            },
          ),
        ),
      );
      expect(find.byKey(HouseAdKeys.qr), findsNothing);
      expect(qrs, isEmpty);
      expect(find.byKey(HouseAdKeys.store(HouseAdStore.play)), findsOneWidget);
    });

    testWidgets('no link: no install panel', (tester) async {
      await _pump(
        tester,
        HouseAdView(ad: StudioAppAd(aouh), links: const {}, onClose: () {}),
      );
      expect(find.byKey(HouseAdKeys.store(HouseAdStore.play)), findsNothing);
      expect(find.byKey(HouseAdKeys.qr), findsNothing);
    });
  });
}
