import 'package:flutter/material.dart';

import '../data/app_catalog.dart';
import '../data/catalog_service.dart';
import '../models/app_info.dart';
import '../models/catalog.dart';
import '../models/cross_promo_style.dart';
import 'cross_promo_card.dart';

/// A complete section displaying all apps to promote.
///
/// Fetches the catalog from the remote repo on first build.
/// Falls back to the embedded catalog if offline.
/// All text (title, button label, descriptions) comes from the catalog.
class CrossPromoSection extends StatefulWidget {
  /// The ID of the current app to exclude from the list.
  final String excludeAppId;

  /// The catalog service instance. If null, uses fallback catalog only.
  final CatalogService? catalogService;

  /// Override the section title (bypasses catalog translation).
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

  @override
  State<CrossPromoSection> createState() => _CrossPromoSectionState();
}

class _CrossPromoSectionState extends State<CrossPromoSection> {
  Catalog _catalog = fallbackCatalog;

  @override
  void initState() {
    super.initState();
    _fetchCatalog();
  }

  Future<void> _fetchCatalog() async {
    final service = widget.catalogService;
    if (service == null) return;
    final catalog = await service.getCatalog();
    if (mounted) {
      setState(() => _catalog = catalog);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps =
        _catalog.apps.where((app) => app.id != widget.excludeAppId).toList();

    if (filteredApps.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final sectionTitle = widget.title ?? _catalog.sectionTitleFor(locale);
    final buttonLabel = _catalog.buttonLabelFor(locale);
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
          ..._buildVerticalList(filteredApps, spacing, locale, buttonLabel)
        else
          _buildHorizontalList(filteredApps, spacing, locale, buttonLabel),
      ],
    );
  }

  List<Widget> _buildVerticalList(
      List<AppInfo> apps, double spacing, String locale, String buttonLabel) {
    final widgets = <Widget>[];
    for (var i = 0; i < apps.length; i++) {
      widgets.add(CrossPromoCard(
        app: apps[i],
        style: widget.style,
        locale: locale,
        buttonLabel: buttonLabel,
        catalogService: widget.catalogService,
      ));
      if (i < apps.length - 1) {
        widgets.add(SizedBox(height: spacing));
      }
    }
    return widgets;
  }

  Widget _buildHorizontalList(
      List<AppInfo> apps, double spacing, String locale, String buttonLabel) {
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
            buttonLabel: buttonLabel,
            catalogService: widget.catalogService,
          ),
        ),
      ),
    );
  }
}
