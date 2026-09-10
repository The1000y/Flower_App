import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/routing/routes.dart';
import '../../../../../core/constants/app_strings/app_strings.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/themes/app_colors/app_color.dart';

class OrderSuccessView extends StatelessWidget {
  final String? orderId;

  const OrderSuccessView({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _navigateToHome(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.blackBase),
            onPressed: () => _navigateToHome(context),
          ),
          title: Text(
            AppStrings.trackOrder,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.blackBase,
                ) ??
                TextStyle(fontSize: 18.sp, color: AppColors.blackBase),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(Icons.check_circle, color: AppColors.success, size: 60.w),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                AppStrings.orderPlacedSuccess,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackBase,
                    ) ??
                    TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackBase,
                    ),
              ),
              SizedBox(height: 12.h),
              if (orderId != null)
                Text(
                  '${AppStrings.orderIdPrefix}$orderId',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.white70,
                      ) ??
                      TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.white70,
                      ),
                ),
              const Spacer(),
              CustomButton(
                text: AppStrings.trackOrder,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.trackOrder,
                    arguments: orderId,
                  );
                },
                isEnabled: true,
                enabledColor: AppColors.pinkBase,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }
}
