import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/config/routing/web_view_payment_args.dart';
import 'package:flower_app/core/shared/app_widgets/bottom_navigation_bar.dart';

import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/view/address_view.dart';
import 'package:flower_app/features/addresses/presentation/view/saved_address/saved_address_view.dart';

import 'package:flower_app/features/auth/presentation/forget_password/view/forget_password.dart';
import 'package:flower_app/features/auth/presentation/forget_password/view/reset_password.dart';
import 'package:flower_app/features/auth/presentation/forget_password/view/verification_view.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flower_app/features/auth/presentation/login/view/login_view.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_view_model.dart';
import 'package:flower_app/features/auth/presentation/register/view/register_view.dart';

import 'package:flower_app/features/checkout/presentation/view/checkout_view.dart';

import 'package:flower_app/features/commerce/presentation/bestseller/view/bestseller_view.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/commerce/presentation/cart/view/cart.dart';
import 'package:flower_app/features/commerce/presentation/categories/view/categories.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view/occasion_view.dart';
import 'package:flower_app/features/commerce/presentation/product_details/view/product_details.dart';

import 'package:flower_app/features/orders/presentation/manager/cubit/orders_cubit.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_intent.dart';
import 'package:flower_app/features/orders/presentation/view/my_orders_view.dart';
import 'package:flower_app/features/orders/presentation/view/order_success_view.dart';

import 'package:flower_app/features/order_tracking/presentation/manager/tracking_event.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_view_model.dart';
import 'package:flower_app/features/order_tracking/presentation/view/order_map_view.dart';
import 'package:flower_app/features/order_tracking/presentation/view/track_order_view.dart';

import 'package:flower_app/features/payment/presentation/web_view_payment.dart';

import 'package:flower_app/features/profile/presentation/manager/cubit/change_password_cubit.dart';
import 'package:flower_app/features/profile/presentation/manager/cubit/profile_view_model.dart';
import 'package:flower_app/features/profile/presentation/view/change_password_view.dart';
import 'package:flower_app/features/profile/presentation/view/notification_view.dart';
import 'package:flower_app/features/profile/presentation/view/profile_home_view.dart';
import 'package:flower_app/features/profile/presentation/view/update_profile_view.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/language.dart';

import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';
import 'package:flower_app/features/search/presentation/view/search_view.dart';

abstract class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginViewModel>(),
            child: const LoginView(),
          ),
        );

      case Routes.signUp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<RegisterViewModel>(),
            child: const RegisterView(),
          ),
        );

      case Routes.forgotPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgetPassword(),
        );

      case Routes.verificationCode:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => VerificationView(email: args['email']),
        );

      case Routes.resetPassword:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              ResetPassword(email: args['email'], otpcode: args['otpcode']),
        );

      case Routes.mainLayout:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Placeholder(),
        );

      case Routes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: getIt<CartCubit>(),
            child: PersistentBottomNavBarDemo(
              onCartTabSelected: () {
                getIt<CartCubit>().doEvent(CartRefreshRequestedEvent());
              },
            ),
          ),
        );

      case Routes.bestSeller:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const BestsellerView(),
        );

      case Routes.productDetails:
        final productId = settings.arguments as String? ?? '';

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductDetails(productId: productId),
        );

      case Routes.occasion:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OccasionView(),
        );

      case Routes.categories:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CategoriesView(),
        );

      case Routes.search:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<SearchCubit>(
            create: (_) => getIt<SearchCubit>(),
            child: const SearchView(),
          ),
        );

      case Routes.cart:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<CartCubit>.value(value: getIt<CartCubit>()),
              BlocProvider<AddressCubit>.value(value: getIt<AddressCubit>()),
            ],
            child: const CartView(),
          ),
        );

      case Routes.checkout:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CheckoutView(),
        );

      case Routes.shippingAddress:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Placeholder(),
        );

      case Routes.savedAddresses:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SavedAddressView(),
        );

      case Routes.addAddress:
        final editingAddress = settings.arguments as AddressEntity?;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AddressView(editingAddress: editingAddress),
        );

      case Routes.myOrders:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) =>
                getIt<OrdersCubit>()..doIntent(const FetchOrdersIntent()),
            child: const MyOrdersView(),
          ),
        );

      case Routes.orderDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Placeholder(),
        );

      case Routes.notification:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => NotificationView(
            message: settings.arguments is RemoteMessage
                ? settings.arguments as RemoteMessage
                : null,
          ),
        );

      case Routes.profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileViewModel>(),
            child: const ProfileHomeView(),
          ),
        );

      case Routes.editProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileViewModel>(),
            child: const UpdateProfileView(),
          ),
        );

      case Routes.changeLanguage:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(),
            body: const Padding(
              padding: EdgeInsets.all(16.0),
              child: LanguageBottomSheet(),
            ),
          ),
        );

      case Routes.changePassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChangePasswordCubit>(),
            child: const ChangePasswordView(),
          ),
        );

      case Routes.orderSuccess:
        final orderId = settings.arguments as String? ?? '';

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OrderSuccessView(orderId: orderId),
        );

      case Routes.webView:
        final args = settings.arguments as WebViewPaymentArgs;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WebViewPayment(
            orderId: args.orderId,
            successUrl: args.successUrl,
            cancelUrl: args.cancelUrl,
            sessionUrl: args.sessionUrl,
          ),
        );

      case Routes.trackOrder:
        final args = settings.arguments;
        final trackOrderId = args is String ? args.trim() : '';

        if (trackOrderId.isEmpty) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                Scaffold(body: Center(child: Text(AppStrings.unexpectedError))),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<TrackingViewModel>(
            create: (_) =>
                getIt<TrackingViewModel>()
                  ..handle(StartTrackingIntent(trackOrderId)),
            child: TrackOrderView(orderId: trackOrderId),
          ),
        );

      case Routes.orderMap:
        final trackingViewModel = settings.arguments as TrackingViewModel;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<TrackingViewModel>.value(
            value: trackingViewModel,
            child: const OrderMapView(),
          ),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
