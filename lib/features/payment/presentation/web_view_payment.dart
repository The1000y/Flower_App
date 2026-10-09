import 'dart:async';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/orders/presentation/view/order_success_view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  bool errorHappen = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
             debugPrint('NAVIGATION => ${request.url}');
            return _handleUrl(request.url);
          },
          // onHttpError: (error) {
          //   if (!mounted) return;
          //    showError();
          // },
          onWebResourceError: (WebResourceError error) {
             debugPrint('ERROR => ${error.errorCode}');
  debugPrint('DESCRIPTION => ${error.description}');
  debugPrint('URL => ${error.url}');
            if (error.isForMainFrame != true) return;
            if (!mounted) return;
            showError();
          },
        ),
      )
      // ..loadRequest(Uri.parse('https://this-url-does-not-exist.com'));
      ..loadRequest(Uri.parse(widget.sessionUrl));
      debugPrint(widget.successUrl);
      debugPrint(widget.cancelUrl);
  }

  void showError() => setState(() => errorHappen = true);

  FutureOr<NavigationDecision> _handleUrl(String url) {
    if (url.startsWith(widget.successUrl.split('?').first)) {
      if (!mounted) return NavigationDecision.prevent;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OrderSuccessView()),
        (_) => false,
      );
      return NavigationDecision.prevent;
    } else if (url.startsWith(widget.cancelUrl.split('?').first)) {
      if (!mounted) return NavigationDecision.prevent;
      Navigator.pop(context);
      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorHappen) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  'assets/lottie_json/Connection error.json',
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: CustomButton(
                text: AppStrings.tryAgain,
                onPressed: () {
                  if (!mounted) return;

                  setState(() {
                    errorHappen = false;
                  });
                  controller.loadRequest(Uri.parse(widget.sessionUrl));
                },
                isEnabled: true,
                enabledColor: AppColors.pinkBase,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
