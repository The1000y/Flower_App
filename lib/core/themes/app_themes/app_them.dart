import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';

class AppThem {
  AppThem._();

  static ThemeData lightThem = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.lightPink,
    colorScheme: ColorScheme.light(
      primary: AppColors.pinkBase,
      onPrimary: AppColors.white10,

      secondary: AppColors.pink60,
      onSecondary: AppColors.white10,

      error: AppColors.error,
      onError: AppColors.white10,

      surface: AppColors.white10,
      onSurface: AppColors.blackBase,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteBase,
      foregroundColor: AppColors.blackBase,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
       floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: AppColors.whiteBase,

      labelStyle: const TextStyle(color: AppColors.gray),

      hintStyle: const TextStyle(color: AppColors.white70),

      errorStyle: const TextStyle(color: AppColors.error, fontSize: 10),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.white60),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.pinkBase, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pinkBase,
        foregroundColor: AppColors.white10,

        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blackBase,

        side: const BorderSide(color: AppColors.gray),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

        textStyle: const TextStyle(fontSize: 14),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      side: const BorderSide(color: AppColors.gray),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),

      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.pinkBase;
        }

        return Colors.transparent;
      }),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.blackBase),

      bodyMedium: TextStyle(color: AppColors.gray),

      bodySmall: TextStyle(color: AppColors.gray),

      labelLarge: TextStyle(color: AppColors.blackBase),
    ),
  );
}
