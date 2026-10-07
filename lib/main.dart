import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/network/firebase_options.dart';
import 'package:flower_app/config/routing/app_routes.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/locale/app_language.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/core/services/firebase_messaging_service.dart';
import 'package:flower_app/core/shared/app_widgets/notification_navigation_listener.dart';
import 'package:flower_app/core/themes/app_themes/app_them.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

final GlobalKey<NavigatorState> _navigatorKey =
    GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await configureDependencies();

  final localeCubit = getIt<LocaleCubit>();

  try {
    await localeCubit.load();
  } catch (e) {
    debugPrint('Failed to restore locale: $e');
  }

  unawaited(_initializeNotifications());

  runApp(
    ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CartCubit>(
            create: (_) => getIt<CartCubit>(),
          ),
          BlocProvider<LoginViewModel>(
            create: (_) => getIt<LoginViewModel>(),
          ),
          BlocProvider<LocaleCubit>.value(
            value: localeCubit,
          ),
        ],
        child: const FlowerApp(),
      ),
    ),
  );
}

Future<void> _initializeNotifications() async {
  try {
    await getIt<FirebaseMessagingService>().initialize();
  } catch (e) {
    debugPrint('Failed to initialize notifications: $e');
  }
}

class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, AppLanguage>(
      builder: (context, language) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          initialRoute: Routes.login,
          locale: language.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates:
              AppLocalizations.localizationsDelegates,
          theme: AppTheme.lightThem,
          debugShowCheckedModeBanner: false,
          title: 'Flower App',
          builder: (context, child) {
            return NotificationNavigationListener(
              navigatorKey: _navigatorKey,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}