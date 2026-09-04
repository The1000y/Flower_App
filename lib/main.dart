import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/app_routes.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/themes/app_themes/app_them.dart';
import 'package:flower_app/core/shared/app_widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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

class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: Routes.login,
      theme: AppThem.lightThem,
      debugShowCheckedModeBanner: false,
      title: 'Flower App',
    );
  }
}