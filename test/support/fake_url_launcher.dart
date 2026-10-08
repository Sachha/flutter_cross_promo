import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// Records launched links instead of opening them.
class FakeUrlLauncher extends UrlLauncherPlatform
    with MockPlatformInterfaceMixin {
  final List<String> urls = [];
  final List<PreferredLaunchMode> modes = [];

  /// When true, [launchUrl] fails like Android without any store app.
  bool fail = false;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    if (fail) throw PlatformException(code: 'ACTIVITY_NOT_FOUND');
    urls.add(url);
    modes.add(options.mode);
    return true;
  }

  /// Installs a new fake as the platform instance and returns it.
  static FakeUrlLauncher install() {
    final fake = FakeUrlLauncher();
    UrlLauncherPlatform.instance = fake;
    return fake;
  }
}
