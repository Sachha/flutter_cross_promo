// Runs on the VM (`flutter test`) and in a browser
// (`flutter test --platform chrome`): the widgets must not need `dart:io`.
import 'package:cross_promo/cross_promo.dart';
import 'package:cross_promo/src/platform/store_link.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart' show LaunchMode;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'support/fake_url_launcher.dart';

const _appStore = 'https://apps.apple.com/app/test/id1';
const _playStore = 'https://play.google.com/store/apps/details?id=test.app';

const _both = AppInfo(
  id: 'both',
  name: 'Both',
  descriptions: {'en': 'Both stores'},
  icon: 'aouh.webp',
  appStoreUrl: _appStore,
  playStoreUrl: _playStore,
);

const _playOnly = AppInfo(
  id: 'play_only',
  name: 'Play only',
  descriptions: {'en': 'Play Store only'},
  icon: 'aouh.webp',
  playStoreUrl: _playStore,
);

/// Expected link on [platform] for [_both].
String _expectedFor(TargetPlatform platform) => switch (platform) {
  TargetPlatform.android => _playStore,
  _ => _appStore,
};

PreferredLaunchMode get _expectedMode => kIsWeb
    ? PreferredLaunchMode.platformDefault
    : PreferredLaunchMode.externalApplication;

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('storeUrlFor', () {
    test('iOS and macOS: App Store', () {
      expect(storeUrlFor(_both, platform: TargetPlatform.iOS), _appStore);
      expect(storeUrlFor(_both, platform: TargetPlatform.macOS), _appStore);
    });

    test('Android: Play Store', () {
      expect(storeUrlFor(_both, platform: TargetPlatform.android), _playStore);
    });

    test('other platforms: App Store, then Play Store', () {
      for (final p in [
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.fuchsia,
      ]) {
        expect(storeUrlFor(_both, platform: p), _appStore, reason: '$p');
        expect(storeUrlFor(_playOnly, platform: p), _playStore, reason: '$p');
      }
    });

    test('no link for the store of the platform: null', () {
      expect(storeUrlFor(_playOnly, platform: TargetPlatform.iOS), isNull);
      expect(storeUrlFor(_playOnly, platform: TargetPlatform.macOS), isNull);
      const appStoreOnly = AppInfo(
        id: 'ios_only',
        name: 'iOS only',
        descriptions: {},
        icon: 'aouh.webp',
        appStoreUrl: _appStore,
      );
      expect(
        storeUrlFor(appStoreOnly, platform: TargetPlatform.android),
        isNull,
      );
    });

    test('defaults to defaultTargetPlatform', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      expect(storeUrlFor(_both), _playStore);
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(storeUrlFor(_both), _appStore);
    });
  });

  test('launch mode: default in a browser, store app on native platforms', () {
    expect(
      storeLaunchMode,
      kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
    );
  });

  group('openStore', () {
    test('opens the link of the platform', () async {
      final fake = FakeUrlLauncher.install();
      expect(await openStore(_both, platform: TargetPlatform.android), isTrue);
      expect(fake.urls, [_playStore]);
      expect(fake.modes, [_expectedMode]);
    });

    test('no link: nothing opened, false', () async {
      final fake = FakeUrlLauncher.install();
      expect(await openStore(_playOnly, platform: TargetPlatform.iOS), isFalse);
      expect(fake.urls, isEmpty);
    });

    test('launch failure: false, no exception', () async {
      final fake = FakeUrlLauncher.install()..fail = true;
      expect(await openStore(_both, platform: TargetPlatform.iOS), isFalse);
      expect(fake.urls, isEmpty);
    });
  });

  final platforms = TargetPlatformVariant(TargetPlatform.values.toSet());

  testWidgets('CrossPromoCard: the button opens the store of the platform', (
    tester,
  ) async {
    final fake = FakeUrlLauncher.install();
    await tester.pumpWidget(_host(const CrossPromoCard(app: _both)));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(fake.urls, [_expectedFor(defaultTargetPlatform)]);
    expect(fake.modes, [_expectedMode]);
  }, variant: platforms);

  testWidgets('CrossPromoBanner: a tap opens the store of the platform', (
    tester,
  ) async {
    final fake = FakeUrlLauncher.install();
    await tester.pumpWidget(_host(const CrossPromoBanner(app: _both)));

    await tester.tap(find.byType(CrossPromoBanner));
    await tester.pump();

    expect(fake.urls, [_expectedFor(defaultTargetPlatform)]);
    expect(fake.modes, [_expectedMode]);
  }, variant: platforms);

  testWidgets('no link for the platform: a tap does nothing', (tester) async {
    final fake = FakeUrlLauncher.install();
    await tester.pumpWidget(
      _host(
        const Column(
          children: [
            CrossPromoCard(app: _playOnly),
            CrossPromoBanner(app: _playOnly),
          ],
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.tap(find.byType(CrossPromoBanner));
    await tester.pump();

    expect(fake.urls, isEmpty);
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('launch failure: no exception in the tap handler', (
    tester,
  ) async {
    final fake = FakeUrlLauncher.install()..fail = true;
    await tester.pumpWidget(_host(const CrossPromoCard(app: _both)));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(fake.urls, isEmpty);
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));
}
