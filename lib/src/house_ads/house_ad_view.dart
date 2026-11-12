import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_info.dart';
import '../platform/store_link.dart';
import 'house_ad.dart';
import 'house_ad_strings.dart';
import 'house_ad_style.dart';

/// Stable keys of the house ad widgets.
abstract final class HouseAdKeys {
  static const view = ValueKey<String>('house-ad');
  static const skip = ValueKey<String>('house-ad-skip');
  static const label = ValueKey<String>('house-ad-label');
  static const self = ValueKey<String>('house-ad-self');
  static const qr = ValueKey<String>('house-ad-qr');

  static ValueKey<String> studio(String id) =>
      ValueKey<String>('house-ad-app-$id');

  static ValueKey<String> store(HouseAdStore s) =>
      ValueKey<String>('house-ad-store-${s.name}');
}

/// Default skip delay: short, but long enough to be seen.
const Duration kHouseAdDefaultSkipAfter = Duration(seconds: 7);

/// Opens a store link (url_launcher, store app on native, new tab on the
/// web). Never throws.
Future<void> openHouseAdLink(Uri uri) async {
  try {
    await launchUrl(uri, mode: storeLaunchMode);
  } catch (_) {
    // No browser or store app able to open the link: nothing to do.
  }
}

/// Full-screen house ad. "Skip" ([onClose]) is active after [skipAfter];
/// the system back gesture is blocked until then.
///
/// [links]: store links of [ad] for this device ([houseAdLinks]); one link
/// gives a store button, several give QR codes (with [HouseAdStyle.qr]) and
/// links, or a single QR of [qrLink] ([HouseInstallPanel.qrLink]). For a
/// [SelfAppAd], [selfName] is the host app's name and [selfHero] an optional
/// illustration above the title.
class HouseAdView extends StatefulWidget {
  const HouseAdView({
    super.key,
    required this.ad,
    required this.links,
    required this.onClose,
    this.strings,
    this.style = const HouseAdStyle(),
    this.skipAfter = kHouseAdDefaultSkipAfter,
    this.onOpen = openHouseAdLink,
    this.selfName = '',
    this.selfHero,
    this.qrLink,
    this.studioVisual,
  });

  final HouseAd ad;
  final Map<HouseAdStore, Uri> links;
  final VoidCallback onClose;

  /// Single QR for both stores ([HouseInstallPanel.qrLink]).
  final Uri? qrLink;

  /// Texts; default: [HouseAdStrings.of] the current locale.
  final HouseAdStrings? strings;
  final HouseAdStyle style;
  final Duration skipAfter;
  final Future<void> Function(Uri uri) onOpen;
  final String selfName;
  final Widget? selfHero;

  /// Visual of a [StudioAppAd] instead of the app icon (its promo video,
  /// [AppInfo.videoFor], played by the host app). Null, or a null result:
  /// the icon.
  final Widget? Function(BuildContext context, AppInfo app)? studioVisual;

  @override
  State<HouseAdView> createState() => _HouseAdViewState();
}

class _HouseAdViewState extends State<HouseAdView> {
  late int _left = widget.skipAfter.inSeconds;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    if (_left <= 0) return;
    _tick = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _left = _left > 0 ? _left - 1 : 0);
      if (_left == 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s =
        widget.strings ??
        HouseAdStrings.of(Localizations.localeOf(context).languageCode);
    final style = widget.style;
    final sp = style.spacing;
    final theme = Theme.of(context);
    final button = style.button ?? defaultHouseAdButton;
    final canSkip = _left == 0;
    final body = switch (widget.ad) {
      SelfAppAd() => _self(context, s),
      StudioAppAd(:final app) => _studio(context, s, app),
    };
    final content = SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: style.maxWidth),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  sp.gutter,
                  sp.medium,
                  sp.gutter,
                  0,
                ),
                child: Row(
                  children: [
                    Container(
                      key: HouseAdKeys.label,
                      padding: EdgeInsets.symmetric(
                        horizontal: sp.small,
                        vertical: sp.tiny,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: style.labelRadius,
                        border: Border.all(
                          color: style.edgeColor ?? theme.dividerColor,
                        ),
                      ),
                      child: Text(
                        s.label,
                        style: style.labelStyle ?? theme.textTheme.labelSmall,
                      ),
                    ),
                    SizedBox(width: sp.medium),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: button(
                          context,
                          HouseAdButton(
                            key: HouseAdKeys.skip,
                            kind: HouseAdButtonKind.skip,
                            label: canSkip ? s.skip : s.skipIn(_left),
                            onPressed: canSkip ? widget.onClose : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) {
                    final column = Column(
                      mainAxisAlignment: style.bodyAlignment,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: body,
                    );
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        sp.gutter,
                        sp.block,
                        sp.gutter,
                        sp.block,
                      ),
                      // At least as tall as the screen, so that the
                      // alignment has room to place a short body.
                      child: style.bodyAlignment == MainAxisAlignment.start
                          ? column
                          : ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: math.max(
                                  0,
                                  box.maxHeight - 2 * sp.block,
                                ),
                              ),
                              child: column,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return PopScope(
      canPop: canSkip,
      child: Scaffold(
        key: HouseAdKeys.view,
        body: style.background?.call(context, content) ?? content,
      ),
    );
  }

  List<Widget> _self(BuildContext context, HouseAdStrings s) {
    final style = widget.style;
    final sp = style.spacing;
    final text = Theme.of(context).textTheme;
    return [
      if (widget.selfHero case final hero?) ...[
        Center(child: hero),
        SizedBox(height: sp.block),
      ],
      Text(
        s.selfTitle(widget.selfName),
        key: HouseAdKeys.self,
        style: style.titleStyle ?? text.headlineMedium,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: sp.small),
      Text(
        s.selfBody,
        style: style.bodyStyle ?? text.bodyLarge,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: sp.block),
      HouseInstallPanel(
        links: widget.links,
        installLabel: s.install(widget.selfName),
        strings: s,
        style: style,
        onOpen: widget.onOpen,
        qrLink: widget.qrLink,
      ),
    ];
  }

  List<Widget> _studio(BuildContext context, HouseAdStrings s, AppInfo app) {
    final style = widget.style;
    final sp = style.spacing;
    final text = Theme.of(context).textTheme;
    final size = style.iconSize;
    return [
      Text(
        s.studio,
        style: style.overlineStyle ?? text.labelLarge,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: sp.medium),
      Center(
        child:
            widget.studioVisual?.call(context, app) ??
            ClipRRect(
              borderRadius: style.iconRadius,
              child: Image.asset(
                'assets/${app.icon}',
                package: 'cross_promo',
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => SizedBox(width: size, height: size),
              ),
            ),
      ),
      SizedBox(height: sp.medium),
      Text(
        app.name,
        key: HouseAdKeys.studio(app.id),
        style: style.titleStyle ?? text.headlineMedium,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: sp.small),
      Text(
        app.descriptionFor(Localizations.localeOf(context).languageCode),
        style: style.bodyStyle ?? text.bodyLarge,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: sp.block),
      HouseInstallPanel(
        links: widget.links,
        installLabel: s.install(app.name),
        strings: s,
        style: style,
        onOpen: widget.onOpen,
        qrLink: widget.qrLink,
      ),
    ];
  }
}

/// Installing the app of a house ad: on a phone (one store), a button to
/// the store page; on a computer (both stores), their QR codes to scan with
/// the phone ([HouseAdStyle.qr]), with clickable links, or a single QR of
/// [qrLink] above both links. Nothing without a link.
class HouseInstallPanel extends StatelessWidget {
  const HouseInstallPanel({
    super.key,
    required this.links,
    required this.installLabel,
    this.strings,
    this.style = const HouseAdStyle(),
    this.onOpen = openHouseAdLink,
    this.qrLink,
  });

  final Map<HouseAdStore, Uri> links;

  /// Link of a single QR on a computer, instead of one QR per store: an
  /// address that sends each phone to its own store (redirect served by the
  /// host app's site, by user agent). Null: one QR per store. Not used with
  /// a single link (phone: store button).
  final Uri? qrLink;

  /// Label of the store button on a phone ("Install Doku").
  final String installLabel;
  final HouseAdStrings? strings;
  final HouseAdStyle style;
  final Future<void> Function(Uri uri) onOpen;

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) return const SizedBox.shrink();
    final s =
        strings ??
        HouseAdStrings.of(Localizations.localeOf(context).languageCode);
    final sp = style.spacing;
    final button = style.button ?? defaultHouseAdButton;
    if (links.length == 1) {
      final MapEntry(key: store, value: uri) = links.entries.single;
      return button(
        context,
        HouseAdButton(
          key: HouseAdKeys.store(store),
          kind: HouseAdButtonKind.install,
          label: installLabel,
          onPressed: () => unawaited(onOpen(uri)),
        ),
      );
    }
    final qr = style.qr;
    String name(HouseAdStore st) =>
        st == HouseAdStore.appStore ? s.appStore : s.play;
    Widget storeButton(HouseAdStore st, Uri uri) => button(
      context,
      HouseAdButton(
        key: HouseAdKeys.store(st),
        kind: HouseAdButtonKind.store,
        label: name(st),
        onPressed: () => unawaited(onOpen(uri)),
      ),
    );
    final hint = qr == null
        ? null
        : Text(
            s.scan,
            style: style.hintStyle ?? Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          );
    if (qr != null && qrLink != null) {
      return Column(
        key: HouseAdKeys.qr,
        children: [
          qr(context, qrLink.toString(), style.qrSize),
          SizedBox(height: sp.xSmall),
          Wrap(
            spacing: sp.small,
            runSpacing: sp.xSmall,
            alignment: WrapAlignment.center,
            children: [
              for (final MapEntry(key: st, value: uri) in links.entries)
                storeButton(st, uri),
            ],
          ),
          SizedBox(height: sp.small),
          hint!,
        ],
      );
    }
    return Column(
      key: HouseAdKeys.qr,
      children: [
        Wrap(
          spacing: sp.block,
          runSpacing: sp.medium,
          alignment: WrapAlignment.center,
          children: [
            for (final MapEntry(key: st, value: uri) in links.entries)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (qr != null) ...[
                    qr(context, uri.toString(), style.qrSize),
                    SizedBox(height: sp.xSmall),
                  ],
                  storeButton(st, uri),
                ],
              ),
          ],
        ),
        if (hint != null) ...[SizedBox(height: sp.small), hint],
      ],
    );
  }
}
