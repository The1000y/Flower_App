import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';

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
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return const TextStyle(color: AppColors.error);
        }
        return const TextStyle(color: AppColors.gray);
      }),

      hintStyle: TextStyle(
        color: AppColors.white70,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),

      errorStyle: const TextStyle(color: AppColors.error, fontSize: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.white60),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.white60),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.pinkBase, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pinkBase,
        foregroundColor: AppColors.white10,

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),

        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.whiteBase,
        foregroundColor: AppColors.gray,

        elevation: 0,

        minimumSize: Size(double.infinity, 50.h),

        side: const BorderSide(color: AppColors.gray, width: 1),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),

        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
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

    // Default font for the whole app
    fontFamily: GoogleFonts.roboto().fontFamily,
    textTheme: TextTheme(
      // Roboto
      titleLarge: TextStyle(
        color: AppColors.blackBase,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),

      titleMedium: TextStyle(
        color: AppColors.blackBase,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      bodyLarge: TextStyle(
        color: AppColors.blackBase,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),

      bodyMedium: TextStyle(
        color: AppColors.gray,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),

      bodySmall: TextStyle(
        color: AppColors.blackBase,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),

      labelLarge: TextStyle(color: AppColors.blackBase),
    ),
  );
}
