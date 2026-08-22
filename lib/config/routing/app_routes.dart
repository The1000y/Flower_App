import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flower_app/features/auth/presentation/login/view/login_view.dart';
import 'package:flower_app/core/shared/app_widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 abstract class AppRoutes {
 static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginViewModel>(),
            child: const LoginView(),
          ),
        );

        return MaterialPageRoute(builder: (_) => const Placeholder());
            
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.verificationCode:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      // Main Layout
      case Routes.mainLayout:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      // Home
      case Routes.home:
        return MaterialPageRoute(builder: (_) =>  PersistenBottomNavBarDemo());

      case Routes.bestSeller:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.productDetails:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.occasion:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.categories:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.search:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      // Cart & Checkout
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.checkout:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.shippingAddress:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.savedAddresses:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.addAddress:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      // Orders
      case Routes.myOrders:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.orderDetails:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      // Notifications
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      // Profile
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.editProfile:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.changeLanguage:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.changePassword:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      // Tracking
      case Routes.orderSuccess:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.trackOrder:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      case Routes.orderMap:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
