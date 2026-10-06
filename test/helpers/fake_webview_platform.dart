// ignore_for_file: depend_on_referenced_packages, use_super_parameters
import 'package:flutter/material.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

/// A [WebViewPlatform] that records everything `WebViewPayment` does with its
/// controller and navigation delegate, so the widget can be exercised without
/// a real platform web view.
///
/// The two ignored lints are unavoidable: the platform interface is a
/// transitive dependency that `webview_flutter` only partially re-exports, and
/// its implementation constructors are named, so they cannot be forwarded with
/// super parameters.
class FakeWebViewPlatform extends WebViewPlatform {
  final List<FakePlatformWebViewController> controllers = [];
  final List<FakePlatformNavigationDelegate> delegates = [];

  FakePlatformWebViewController get lastController => controllers.last;
  FakePlatformNavigationDelegate get lastDelegate => delegates.last;

  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    final controller = FakePlatformWebViewController(params);
    controllers.add(controller);
    return controller;
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    final delegate = FakePlatformNavigationDelegate(params);
    delegates.add(delegate);
    return delegate;
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) => FakePlatformWebViewWidget(params);
}

class FakePlatformWebViewController extends PlatformWebViewController {
  FakePlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) : super.implementation(params);

  final List<LoadRequestParams> loadRequests = [];
  final List<JavaScriptMode> javaScriptModes = [];
  PlatformNavigationDelegate? navigationDelegate;

  String? get loadedUrl =>
      loadRequests.isEmpty ? null : loadRequests.first.uri.toString();

  @override
  Future<void> loadRequest(LoadRequestParams params) async {
    loadRequests.add(params);
  }

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    javaScriptModes.add(javaScriptMode);
  }

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {
    navigationDelegate = handler;
  }
}

class FakePlatformNavigationDelegate extends PlatformNavigationDelegate {
  FakePlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) : super.implementation(params);

  NavigationRequestCallback? onNavigationRequest;

  /// Runs the callback the production `NavigationDelegate` registered, i.e.
  /// simulates the web view navigating to [url].
  Future<NavigationDecision> navigate(String url) async =>
      onNavigationRequest!(
        NavigationRequest(url: url, isMainFrame: true),
      );

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback handler,
  ) async {
    onNavigationRequest = handler;
  }
}

class FakePlatformWebViewWidget extends PlatformWebViewWidget {
  FakePlatformWebViewWidget(PlatformWebViewWidgetCreationParams params)
    : super.implementation(params);

  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 400,
    height: 600,
    child: ColoredBox(color: Colors.black12),
  );
}
