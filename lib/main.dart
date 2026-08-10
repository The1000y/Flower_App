import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'core/shared/app_widgets/bottom_navigation_bar.dart';
import 'core/shared/app_widgets/custom_button.dart';
import 'core/shared/app_widgets/test_screen.dart';

void main(){
  runApp(
     ScreenUtilPlusInit(
      designSize: const Size(375, 812),

      minTextAdapt: true,

      splitScreenMode: true,
    
    child:  FlowerApp()));
}

class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flower App',
      home: PersistenBottomNavBarDemo(),
    );
  }
}