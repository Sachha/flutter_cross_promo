import 'package:flutter/material.dart';

/// Which button of the house ad a [HouseAdButtonBuilder] renders.
enum HouseAdButtonKind {
  /// "Skip" in the top corner (disabled during the countdown).
  skip,

  /// Store button on a phone (one store): the main call to action.
  install,

  /// Store link under a QR code on a computer.
  store,
}

/// What a [HouseAdButtonBuilder] renders. [onPressed] is null while the
/// button is disabled (skip countdown).
@immutable
class HouseAdButton {
  const HouseAdButton({
    required this.key,
    required this.kind,
    required this.label,
    required this.onPressed,
  });

  final Key key;
  final HouseAdButtonKind kind;
  final String label;
  final VoidCallback? onPressed;
}

/// Renders a button of the house ad with the host app's design system.
typedef HouseAdButtonBuilder =
    Widget Function(BuildContext context, HouseAdButton button);

/// Renders a QR code of [data], [size] logical pixels wide. Without one, a
/// computer only gets the store links.
typedef HouseAdQrBuilder =
    Widget Function(BuildContext context, String data, double size);

/// Spacing of the house ad, in logical pixels.
@immutable
class HouseAdSpacing {
  const HouseAdSpacing({
    this.gutter = 20,
    this.block = 24,
    this.medium = 12,
    this.small = 8,
    this.xSmall = 6,
    this.tiny = 4,
  });

  /// Side margins of the screen.
  final double gutter;

  /// Between blocks (top and bottom of the body, before the install panel).
  final double block;

  final double medium;
  final double small;
  final double xSmall;
  final double tiny;
}

/// Look of the house ad. Every field is optional: by default the view
/// follows the host app's [Theme] (Material buttons, text theme).
@immutable
class HouseAdStyle {
  const HouseAdStyle({
    this.background,
    this.button,
    this.qr,
    this.titleStyle,
    this.bodyStyle,
    this.overlineStyle,
    this.labelStyle,
    this.hintStyle,
    this.edgeColor,
    this.labelRadius = const BorderRadius.all(Radius.circular(8)),
    this.iconRadius = const BorderRadius.all(Radius.circular(20)),
    this.maxWidth = 640,
    this.iconSize = 96,
    this.qrSize = 148,
    this.spacing = const HouseAdSpacing(),
  });

  /// Wraps the content (inside the [Scaffold]), for a background image or
  /// gradient.
  final Widget Function(BuildContext context, Widget child)? background;

  /// Buttons; default: Material buttons.
  final HouseAdButtonBuilder? button;

  /// QR codes on a computer; none by default.
  final HouseAdQrBuilder? qr;

  /// App name, or title of the host app's ad.
  final TextStyle? titleStyle;

  /// Description.
  final TextStyle? bodyStyle;

  /// "From the same studio".
  final TextStyle? overlineStyle;

  /// "Ad" label in the corner.
  final TextStyle? labelStyle;

  /// "Scan with your phone".
  final TextStyle? hintStyle;

  /// Border of the "Ad" label.
  final Color? edgeColor;

  final BorderRadius labelRadius;
  final BorderRadius iconRadius;
  final double maxWidth;
  final double iconSize;
  final double qrSize;
  final HouseAdSpacing spacing;
}

/// Default buttons: filled for the install button, outlined for skip, text
/// for the store links.
Widget defaultHouseAdButton(BuildContext context, HouseAdButton b) =>
    switch (b.kind) {
      HouseAdButtonKind.install => FilledButton(
        key: b.key,
        onPressed: b.onPressed,
        child: Text(b.label),
      ),
      HouseAdButtonKind.skip => OutlinedButton(
        key: b.key,
        onPressed: b.onPressed,
        child: Text(b.label),
      ),
      HouseAdButtonKind.store => TextButton(
        key: b.key,
        onPressed: b.onPressed,
        child: Text(b.label),
      ),
    };
