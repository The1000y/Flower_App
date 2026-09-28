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
      child: FlowerApp(localeCubit: localeCubit),
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
  FlowerApp({super.key, required this.localeCubit})
    : // Owned here, in the app root, and handed to the single widget that needs
      // to navigate ([NotificationNavigationListener]). Nothing in the
      // notification pipeline resolves it from the container.
      _navigatorKey = GlobalKey<NavigatorState>();

  final LocaleCubit localeCubit;

  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  Widget build(BuildContext context) {
    // `.value` keeps ownership (and disposal) of the DI-managed singleton with
    // the container instead of closing it when the widget tree is disposed.
    return BlocProvider<LocaleCubit>.value(
      value: localeCubit,
      child: BlocBuilder<LocaleCubit, AppLanguage>(
        builder: (context, language) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            initialRoute: Routes.login,
            locale: language.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppTheme.lightThem,
            debugShowCheckedModeBanner: false,
            title: 'Flower App',
            builder: (context, child) => NotificationNavigationListener(
              navigatorKey: _navigatorKey,
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
