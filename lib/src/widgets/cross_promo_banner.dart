import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/catalog_service.dart';
import '../models/app_info.dart';
import '../models/cross_promo_style.dart';

/// A compact horizontal banner promoting a single app.
class CrossPromoBanner extends StatelessWidget {
  final AppInfo app;
  final CrossPromoStyle? style;
  final String locale;
  final CatalogService? catalogService;

  const CrossPromoBanner({
    super.key,
    required this.app,
    this.style,
    this.locale = 'en',
    this.catalogService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final radius = style?.cardRadius ?? 12.0;

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        padding: style?.cardPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: style?.cardColor ??
              colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radius * 0.5),
              child: _buildIcon(40),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    app.name,
                    style: style?.titleStyle ??
                        theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    app.descriptionFor(locale),
                    style: style?.descriptionStyle ??
                        theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(double size) {
    if (catalogService != null) {
      return Image.network(
        catalogService!.iconUrl(app.icon),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallbackIcon(size),
      );
    }
    return _fallbackIcon(size);
  }

  Widget _fallbackIcon(double size) {
    return Image.asset(
      'assets/${app.icon}',
      package: 'cross_promo',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  Future<void> _onTap() async {
    final url = _storeUrl;
    if (url == null) return;
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String? get _storeUrl {
    try {
      if (Platform.isIOS || Platform.isMacOS) return app.appStoreUrl;
      if (Platform.isAndroid) return app.playStoreUrl;
    } catch (_) {}
    return app.appStoreUrl ?? app.playStoreUrl;
  }
}
