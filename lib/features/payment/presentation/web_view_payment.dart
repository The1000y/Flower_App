import 'dart:async';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPayment extends StatefulWidget {
  const WebViewPayment({
    super.key,
    required this.sessionUrl,
    required this.successUrl,
    required this.cancelUrl,
  });
  final String sessionUrl;
  final String successUrl;
  final String cancelUrl;

  @override
  State<WebViewPayment> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewPayment> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            return _handelUrl(request.url);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.sessionUrl));
  }


  FutureOr<NavigationDecision> _handelUrl(String url) {
  if (url.startsWith(widget.successUrl.split('?').first)) {
    if (!mounted) return NavigationDecision.prevent;
    Navigator.pushReplacementNamed(context, Routes.orderSuccess);
    return NavigationDecision.prevent;
  } else if (url.startsWith(widget.cancelUrl.split('?').first)) {
    if (!mounted) return NavigationDecision.prevent;
    Navigator.pushReplacementNamed(context, Routes.checkout);
    return NavigationDecision.prevent;
  } else {
    return NavigationDecision.navigate;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')   , actions: [
        IconButton(
          onPressed: () {
            _handelUrl(widget.successUrl);
          },
          icon: const Icon(Icons.web_asset_outlined),
        ),
        IconButton(
          onPressed: () {
            _handelUrl(widget.cancelUrl);
          },
          icon: const Icon(Icons.web_asset_off_rounded),
        )
      ],),
      body: WebViewWidget(controller: controller),
    );
  }
}
