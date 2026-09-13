import 'package:firebase_core/firebase_core.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/network/firebase_notifcation.dart';
import 'package:flower_app/config/routing/app_routes.dart';
import 'package:flower_app/config/routing/routes.dart';

import 'package:flower_app/core/themes/app_themes/app_them.dart';
import 'package:flower_app/config/network/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseNotifcation.intialfireNotfication();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  runApp(
    ScreenUtilPlusInit(
      designSize: const Size(375, 812),

      minTextAdapt: true,

      splitScreenMode: true,

      child: const FlowerApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navkey = GlobalKey<NavigatorState>();

class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navkey,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: Routes.login,
      theme: AppTheme.lightThem,
      debugShowCheckedModeBanner: false,
      title: 'Flower App',
    );
  }
}
