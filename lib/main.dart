import 'package:firebase_core/firebase_core.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/network/firebase_notifcation.dart';
import 'package:flower_app/config/routing/app_routes.dart';
import 'package:flower_app/config/routing/routes.dart';

import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/core/themes/app_themes/app_them.dart';
import 'package:flower_app/config/network/firebase_options.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  FirebaseNotifcation.intialfireNotfication();

  final localeCubit = LocaleCubit();
  await localeCubit.load();

  runApp(
    ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,

      child: FlowerApp(localeCubit: localeCubit),
    ),
  );
}

final GlobalKey<NavigatorState> navkey = GlobalKey<NavigatorState>();

class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key, required this.localeCubit});

  final LocaleCubit localeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleCubit>(
      create: (_) => localeCubit,
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            navigatorKey: navkey,
            onGenerateRoute: AppRoutes.onGenerateRoute,
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