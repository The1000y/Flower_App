import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/app_routes.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/config/utils/app_config.dart';
import 'package:flower_app/core/themes/app_themes/app_them.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view/occasion_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(environment: AppConfig.appEnv);
  runApp(
    ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        if (MediaQuery.of(context).size.width == 0) {
          return const SizedBox.shrink();
        }
        return const FlowerApp();
      },
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
      theme: AppTheme.lightThem,
      debugShowCheckedModeBanner: false,
      title: 'Flower App',
    );
  }
}
