import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar._();

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: duration,
      ),
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: duration,
      ),
    );
  }

  static SnackBar success({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return SnackBar(
      content: Text(message),
      backgroundColor: AppColors.success,
      duration: duration,
    );
  }

  static SnackBar error({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return SnackBar(
      content: Text(message),
      backgroundColor: AppColors.error,
      duration: duration,
    );
  }
}
