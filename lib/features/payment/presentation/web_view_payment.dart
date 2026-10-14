import 'dart:async';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
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
          onUrlChange: (change) {
            final url = change.url;
            if (url == null) return;
            debugPrint('URL CHANGE => $url');
            if (_isSuccess(url)) {
              _onSuccess();
              return;
            } else if (_isCancel(url)) {
              _onCancel();
              return;
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('ERROR => ${error.errorCode}');
            debugPrint('DESCRIPTION => ${error.description}');
            debugPrint('URL => ${error.url}');
            final url = error.url;
            if (url != null && _isSuccess(url)) {
              _onSuccess();
              return;
            }
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

  bool _handled = false;

  bool _isSuccess(String url) =>
      url.startsWith(widget.successUrl.split('?').first);

  bool _isCancel(String url) =>
      url.startsWith(widget.cancelUrl.split('?').first);

  FutureOr<NavigationDecision> _handleUrl(String url) async {
    if (_isSuccess(url)) {
      _onSuccess();
      return NavigationDecision.prevent;
    }
    if (_isCancel(url)) {
      _onCancel();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<void> _onSuccess() async {
    if (_handled) return; // عشان متتنفذش مرتين
    _handled = true;
    debugPrint('SUCCESS HIT');
    await getIt<CartCubit>().doEvent(ResetCartStateEvent());
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.orderSuccess,
      (route) => false,
    );
  }

  void _onCancel() {
    if (_handled) return;
    _handled = true;
    if (!mounted) return;
    Navigator.pop(context);
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



//http://localhost:8080/payments/callback
//http://localhost:8080/payments/callback