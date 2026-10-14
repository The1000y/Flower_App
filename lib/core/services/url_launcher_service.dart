import 'package:flutter/services.dart' show PlatformException;
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart' show LaunchMode;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart' show LaunchOptions, PreferredLaunchMode, UrlLauncherPlatform;

export 'package:url_launcher/url_launcher.dart' show LaunchMode;

abstract interface class UrlLauncherService {
  Future<bool> launch(Uri uri, {LaunchMode mode = LaunchMode.platformDefault});
}

@LazySingleton(as: UrlLauncherService)
class UrlLauncherServiceImpl implements UrlLauncherService {
  final UrlLauncherPlatform _platform;

  UrlLauncherServiceImpl(this._platform);

  @override
  Future<bool> launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      return await _platform.launchUrl(
        uri.toString(),
        LaunchOptions(mode: _toPreferredMode(mode)),
      );
    } on PlatformException {
      return false;
    }
  }

  PreferredLaunchMode _toPreferredMode(LaunchMode mode) => switch (mode) {
    LaunchMode.platformDefault => PreferredLaunchMode.platformDefault,
    LaunchMode.inAppWebView => PreferredLaunchMode.inAppWebView,
    LaunchMode.inAppBrowserView => PreferredLaunchMode.inAppBrowserView,
    LaunchMode.externalApplication => PreferredLaunchMode.externalApplication,
    LaunchMode.externalNonBrowserApplication =>
      PreferredLaunchMode.externalNonBrowserApplication,
  };
}

@module
abstract class UrlLauncherModule {
  @lazySingleton
  UrlLauncherPlatform get urlLauncherPlatform => UrlLauncherPlatform.instance;
}
