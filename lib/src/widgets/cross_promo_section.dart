import 'package:flutter/material.dart';

import '../models/app_info.dart';
import '../models/cross_promo_style.dart';
import 'cross_promo_card.dart';

/// A complete section displaying all apps to promote.
///
/// Filters out the current app via [excludeAppId].
/// Adapts to the host app's theme by default.
class CrossPromoSection extends StatelessWidget {
  /// List of all apps in your portfolio.
  final List<AppInfo> apps;

  /// The ID of the current app to exclude from the list.
  final String excludeAppId;

  /// Section title displayed above the cards.
  /// Defaults to "Discover our apps".
  final String? title;

  /// Optional style overrides.
  final CrossPromoStyle? style;

  /// Layout direction for the cards.
  final Axis direction;

  /// Whether to show the section title.
  final bool showTitle;

  const CrossPromoSection({
    super.key,
    required this.apps,
    required this.excludeAppId,
    this.title,
    this.style,
    this.direction = Axis.vertical,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final filteredApps =
        apps.where((app) => app.id != excludeAppId).toList();

    if (filteredApps.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final sectionTitle = title ?? 'Discover our apps';
    final spacing = style?.cardSpacing ?? 12.0;

    final sectionTitleStyle = style?.sectionTitleStyle ??
        theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTitle) ...[
          Text(sectionTitle, style: sectionTitleStyle),
          SizedBox(height: spacing),
        ],
        if (direction == Axis.vertical)
          ..._buildVerticalList(filteredApps, spacing)
        else
          _buildHorizontalList(filteredApps, spacing),
      ],
    );
  }

  List<Widget> _buildVerticalList(List<AppInfo> apps, double spacing) {
    final widgets = <Widget>[];
    for (var i = 0; i < apps.length; i++) {
      widgets.add(CrossPromoCard(app: apps[i], style: style));
      if (i < apps.length - 1) {
        widgets.add(SizedBox(height: spacing));
      }
    }
    return widgets;
  }

  Widget _buildHorizontalList(List<AppInfo> apps, double spacing) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: apps.length,
        separatorBuilder: (_, _) => SizedBox(width: spacing),
        itemBuilder: (context, index) => SizedBox(
          width: 300,
          child: CrossPromoCard(app: apps[index], style: style),
        ),
      ),
    );
  }
}
