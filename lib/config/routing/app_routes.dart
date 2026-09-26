import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model_factory.dart';
import 'package:flower_app/features/auth/presentation/forget_password/view/forget_password.dart';
import 'package:flower_app/features/auth/presentation/forget_password/view/reset_password.dart';
import 'package:flower_app/features/auth/presentation/forget_password/view/verification_view.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flower_app/features/auth/presentation/login/view/login_view.dart';
import 'package:flower_app/core/shared/app_widgets/bottom_navigation_bar.dart';
import 'package:flower_app/features/commerce/presentation/bestseller/view/bestseller_view.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/categories.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view/occasion_view.dart';
import 'package:flower_app/features/commerce/presentation/product_details/view/product_details.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/notification_view.dart';
import 'package:flower_app/features/profile/presentation/view/profile_view.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit_factory.dart';
import 'package:flower_app/features/search/presentation/view/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/register/manager/register_view_model.dart';
import '../../features/auth/presentation/register/view/register_view.dart';

abstract class AppRoutes {
  /// Builds a [Route] for [settings].
  ///
  /// [profileViewModelFactory] and [searchCubitFactory] are injected instead of
  /// resolved from the service locator so route construction stays testable;
  /// they are only needed for the routes that own those dependencies.
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, {
    ProfileViewModelFactory? profileViewModelFactory,
    SearchCubitFactory? searchCubitFactory,
  }) {
    switch (settings.name) {
      // Auth
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginViewModel>(),
            child: const LoginView(),
          ),
        );

      case Routes.signUp:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<RegisterViewModel>(),
            child: const RegisterView(),
          ),
        );

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPassword());

      case Routes.verificationCode:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => VerificationView(email: args['email']),
        );

      case Routes.resetPassword:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) =>
              ResetPassword(email: args['email'], otpcode: args['otpcode']),
        );

      // Main Layout
      case Routes.mainLayout:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      // Home
      case Routes.home:
        final profileViewModel = profileViewModelFactory?.create();
        return MaterialPageRoute(
          builder: (_) =>
              PersistenBottomNavBarDemo(profileViewModel: profileViewModel),
        );

      case Routes.bestSeller:
        return MaterialPageRoute(builder: (_) => const BestsellerView());

      case Routes.productDetails:
        final productId = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => ProductDetails(productId: productId),
        );

      case Routes.occasion:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OccasionView(),
        );

      case Routes.categories:
        return MaterialPageRoute(builder: (_) => const CategoriesView());

      case Routes.search:
        final searchCubit = searchCubitFactory?.create();
        if (searchCubit == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Search is unavailable')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SearchCubit>.value(
            value: searchCubit,
            child: const SearchView(),
          ),
        );

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
      case Routes.notification:
        // The message may be absent (e.g. deep link without payload); the view
        // owns the empty-state defaults instead of the route generator.
        return MaterialPageRoute(
          builder: (_) => NotificationView(
            message: settings.arguments is RemoteMessage
                ? settings.arguments as RemoteMessage
                : null,
          ),
        );

      // Profile
      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) {
            final viewModel = profileViewModelFactory?.create();
            if (viewModel == null) {
              return const Scaffold(
                body: Center(child: Text('Profile is unavailable')),
              );
            }
            return BlocProvider<ProfileViewModel>.value(
              value: viewModel,
              child: const ProfileView(),
            );
          },
        );

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
