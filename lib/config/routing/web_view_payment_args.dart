class WebViewPaymentArgs {
  final String successUrl;
  final String cancelUrl;
  final String sessionUrl;
  final String orderId;

  WebViewPaymentArgs({
    required this.successUrl,
    required this.cancelUrl,
    required this.sessionUrl,
    required this.orderId,
  });
}
