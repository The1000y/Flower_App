import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/network/firebase_options.dart';
import 'package:flower_app/config/routing/app_routes.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/core/services/notification_service.dart';
import 'package:flower_app/core/themes/app_themes/app_them.dart';
import 'package:flower_app/features/profile/presentation/manager/profile_view_model_factory.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await configureDependencies();

  // Restore the persisted language before the first frame so the app never
  // flashes the wrong locale. LocaleCubit falls back to English on failure, and
  // the guard keeps a storage error from aborting startup.
  final localeCubit = getIt<LocaleCubit>();
  try {
    await localeCubit.load();
  } catch (e) {
    debugPrint('Failed to restore locale: $e');
  }

  // Requesting notification permission and fetching the FCM token can be slow,
  // so it runs alongside the first frame instead of blocking it. Errors are
  // logged inside the service and cannot crash the app.
  unawaited(_initializeNotifications());

  runApp(
    ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: FlowerApp(
        localeCubit: localeCubit,
        navKey: getIt<GlobalKey<NavigatorState>>(),
        // Resolved here, at the composition root, and passed down explicitly.
        onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(
          settings,
          profileViewModelFactory: getIt<ProfileViewModelFactory>(),
        ),
      ),
    ),
  );
}

Future<void> _initializeNotifications() async {
  try {
    await getIt<NotificationService>().initialize();
  } catch (e) {
    debugPrint('Failed to initialize notifications: $e');
  }
}

class FlowerApp extends StatelessWidget {
  const FlowerApp({
    super.key,
    required this.localeCubit,
    required this.navKey,
    required this.onGenerateRoute,
  });

  final LocaleCubit localeCubit;
  final GlobalKey<NavigatorState> navKey;

  /// Route generator whose dependencies are already resolved at the composition
  /// root, so [AppRoutes] itself performs no service-locator lookups.
  final Route<dynamic> Function(RouteSettings) onGenerateRoute;

  @override
  Widget build(BuildContext context) {
    // `.value` keeps ownership (and disposal) of the DI-managed singleton with
    // the container instead of closing it when the widget tree is disposed.
    return BlocProvider<LocaleCubit>.value(
      value: localeCubit,
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            navigatorKey: navKey,
            onGenerateRoute: onGenerateRoute,
            initialRoute: Routes.login,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppTheme.lightThem,
            debugShowCheckedModeBanner: false,
            title: 'Flower App',
          );
        },
      ),
    );
  }
}
