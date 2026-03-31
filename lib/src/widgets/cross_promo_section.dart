import 'package:flutter/material.dart';

import '../data/app_catalog.dart';
import '../data/catalog_service.dart';
import '../models/app_info.dart';
import '../models/cross_promo_style.dart';
import 'cross_promo_card.dart';

/// A complete section displaying all apps to promote.
///
/// Fetches the catalog from the remote repo on first build.
/// Falls back to the embedded catalog if offline.
/// Filters out the current app via [excludeAppId].
class CrossPromoSection extends StatefulWidget {
  /// The ID of the current app to exclude from the list.
  final String excludeAppId;

  /// The catalog service instance. If null, uses fallback catalog only.
  final CatalogService? catalogService;

  /// Section title. Defaults to localized "Discover our apps".
  final String? title;

  /// Optional style overrides.
  final CrossPromoStyle? style;

  /// Layout direction for the cards.
  final Axis direction;

  /// Whether to show the section title.
  final bool showTitle;

  const CrossPromoSection({
    super.key,
    required this.excludeAppId,
    this.catalogService,
    this.title,
    this.style,
    this.direction = Axis.vertical,
    this.showTitle = true,
  });

  static const _defaultTitles = {
    'en': 'Discover our apps',
    'fr': 'Découvre nos apps',
    'es': 'Descubre nuestras apps',
    'de': 'Entdecke unsere Apps',
    'it': 'Scopri le nostre app',
    'pt': 'Descobre as nossas apps',
    'nl': 'Ontdek onze apps',
  };

  @override
  State<CrossPromoSection> createState() => _CrossPromoSectionState();
}

class _CrossPromoSectionState extends State<CrossPromoSection> {
  late List<AppInfo> _apps;

  @override
  void initState() {
    super.initState();
    // Start with fallback immediately so there's no blank flash
    _apps = fallbackCatalog;
    _fetchCatalog();
  }

  Future<void> _fetchCatalog() async {
    final service = widget.catalogService;
    if (service == null) return;
    final catalog = await service.getCatalog();
    if (mounted) {
      setState(() => _apps = catalog);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps =
        _apps.where((app) => app.id != widget.excludeAppId).toList();

    if (filteredApps.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final sectionTitle = widget.title ??
        CrossPromoSection._defaultTitles[locale] ??
        CrossPromoSection._defaultTitles['en']!;
    final spacing = widget.style?.cardSpacing ?? 12.0;

    final sectionTitleStyle = widget.style?.sectionTitleStyle ??
        theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showTitle) ...[
          Text(sectionTitle, style: sectionTitleStyle),
          SizedBox(height: spacing),
        ],
        if (widget.direction == Axis.vertical)
          ..._buildVerticalList(filteredApps, spacing, locale)
        else
          _buildHorizontalList(filteredApps, spacing, locale),
      ],
    );
  }

  List<Widget> _buildVerticalList(
      List<AppInfo> apps, double spacing, String locale) {
    final widgets = <Widget>[];
    for (var i = 0; i < apps.length; i++) {
      widgets.add(CrossPromoCard(
        app: apps[i],
        style: widget.style,
        locale: locale,
        catalogService: widget.catalogService,
      ));
      if (i < apps.length - 1) {
        widgets.add(SizedBox(height: spacing));
      }
    }
    return widgets;
  }

  Widget _buildHorizontalList(
      List<AppInfo> apps, double spacing, String locale) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: apps.length,
        separatorBuilder: (_, _) => SizedBox(width: spacing),
        itemBuilder: (context, index) => SizedBox(
          width: 300,
          child: CrossPromoCard(
            app: apps[index],
            style: widget.style,
            locale: locale,
            catalogService: widget.catalogService,
          ),
        ),
      ),
    );
  }
}
