import 'package:cross_promo/cross_promo.dart';
import 'package:cross_promo_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the example shows the banner and the section', (tester) async {
    await tester.pumpWidget(const CrossPromoExampleApp());
    await tester.pump();

    expect(find.byType(CrossPromoBanner), findsOneWidget);
    expect(find.byType(CrossPromoSection), findsOneWidget);
    // The section excludes tic_tac_go: one card per other app of the catalog.
    expect(
      find.byType(CrossPromoCard),
      findsNWidgets(fallbackCatalog.apps.length - 1),
    );
  });
}
