import 'package:flutter/material.dart';

/// Optional style overrides for cross-promo widgets.
///
/// When null, widgets adapt to the host app's [Theme].
class CrossPromoStyle {
  /// Background color of app cards.
  final Color? cardColor;

  /// Border radius of app cards.
  final double? cardRadius;

  /// Title text style (app name).
  final TextStyle? titleStyle;

  /// Description text style.
  final TextStyle? descriptionStyle;

  /// Section header text style ("Discover our apps").
  final TextStyle? sectionTitleStyle;

  /// Color of the CTA button.
  final Color? buttonColor;

  /// Text color of the CTA button.
  final Color? buttonTextColor;

  /// CTA button label (default: "Download" / platform-adaptive).
  final String? buttonLabel;

  /// Padding inside each card.
  final EdgeInsets? cardPadding;

  /// Spacing between cards.
  final double? cardSpacing;

  const CrossPromoStyle({
    this.cardColor,
    this.cardRadius,
    this.titleStyle,
    this.descriptionStyle,
    this.sectionTitleStyle,
    this.buttonColor,
    this.buttonTextColor,
    this.buttonLabel,
    this.cardPadding,
    this.cardSpacing,
  });
}
