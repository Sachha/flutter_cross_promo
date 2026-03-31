import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_info.dart';
import '../models/cross_promo_style.dart';

/// A single card promoting one app.
///
/// Adapts to the host app's theme by default.
/// Use [style] to override specific visual properties.
class CrossPromoCard extends StatelessWidget {
  final AppInfo app;
  final CrossPromoStyle? style;

  const CrossPromoCard({
    super.key,
    required this.app,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final cardColor = style?.cardColor ?? colorScheme.surface;
    final cardRadius = style?.cardRadius ?? 16.0;
    final titleStyle = style?.titleStyle ??
        theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        );
    final descriptionStyle = style?.descriptionStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        );
    final buttonColor = style?.buttonColor ?? colorScheme.primary;
    final buttonTextColor =
        style?.buttonTextColor ?? colorScheme.onPrimary;
    final buttonLabel = style?.buttonLabel ?? 'Download';
    final cardPadding =
        style?.cardPadding ?? const EdgeInsets.all(16);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: cardPadding,
        child: Row(
          children: [
            // App icon
            ClipRRect(
              borderRadius: BorderRadius.circular(cardRadius * 0.6),
              child: SizedBox(
                width: 56,
                height: 56,
                child: app.icon,
              ),
            ),
            const SizedBox(width: 14),

            // Name + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(app.name, style: titleStyle, maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(app.description, style: descriptionStyle,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // CTA button
            _buildButton(buttonColor, buttonTextColor, buttonLabel,
                cardRadius),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      Color bgColor, Color textColor, String label, double radius) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: _onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius * 0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Future<void> _onTap() async {
    final url = _storeUrl;
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String? get _storeUrl {
    try {
      if (Platform.isIOS || Platform.isMacOS) return app.appStoreUrl;
      if (Platform.isAndroid) return app.playStoreUrl;
    } catch (_) {
      // Web or unsupported — fallback to whichever is available
    }
    return app.appStoreUrl ?? app.playStoreUrl;
  }
}
