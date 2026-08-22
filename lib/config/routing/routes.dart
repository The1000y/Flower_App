abstract class Routes {
  // Auth
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String forgotPassword = '/forgot_password';
  static const String verificationCode = '/verification_code';
  static const String resetPassword = '/reset_password';

  // Main Layout
  static const String mainLayout = '/main_layout';

  // Home

  static const String home = '/';
  static const String homeSection = '/home/sections';
  static const String bestSeller = '/products/best-sellers';
  static const String productDetails = '/product_details';
  static const String occasion = '/occasion';
  static const String categories = '/categories';
  static const String search = '/search';

  // Cart & Checkout
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String shippingAddress = '/shipping_address';
  static const String savedAddresses = '/saved_addresses';
  static const String addAddress = '/add_address';

  // Orders
  static const String myOrders = '/my_orders';
  static const String orderDetails = '/order_details';

  // Notifications
  static const String notifications = '/notifications';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/edit_profile';
  static const String changeLanguage = '/change_language';
  static const String changePassword = '/change_password';

  // Tracking
  static const String orderSuccess = '/order_success';
  static const String trackOrder = '/track_order';
  static const String orderMap = '/order_map';
}