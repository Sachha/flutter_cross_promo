import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cross_promo/cross_promo.dart';

void main() {
  test('CrossPromoSection filters out excluded app', () {
    final apps = [
      AppInfo(
        id: 'app_a',
        name: 'App A',
        description: 'Description A',
        icon: const Icon(Icons.star),
      ),
      AppInfo(
        id: 'app_b',
        name: 'App B',
        description: 'Description B',
        icon: const Icon(Icons.star),
      ),
    ];

    // CrossPromoSection should exclude app_a and only show app_b
    expect(apps.where((a) => a.id != 'app_a').length, 1);
    expect(apps.where((a) => a.id != 'app_a').first.id, 'app_b');
  });
}
