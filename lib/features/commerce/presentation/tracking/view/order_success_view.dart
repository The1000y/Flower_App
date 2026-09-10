import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/routing/routes.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/themes/app_colors/app_color.dart';

class OrderSuccessView extends StatelessWidget {

  final String? orderId;
  
  const OrderSuccessView({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    // استخدام PopScope لتنفيذ AC رقم 5 (منع الرجوع للـ Checkout)
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _navigateToHome(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => _navigateToHome(context),
          ),
          title: Text(
            'Track order', // كما هو موضح في التصميم بجانب زر الرجوع
            style: TextStyle(fontSize: 18.sp, color: Colors.black),
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

              // أيقونة النجاح (يفضل استخدام SVG من assets)
              // SvgPicture.asset(AppImages.successIcon, width: 120.w),
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1), // لون الدوائر الخارجية
                ),
                child: Center(
                  child: Icon(Icons.check_circle, color: Colors.green, size: 60.w),
                ),
              ),

              SizedBox(height: 32.h),

              Text(
                'Your order placed\nsuccessfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12.h),

              // إضافة رقم الطلب تطبيقاً لـ Acceptance Criteria #2
              if (orderId != null)
                Text(
                  'Order ID: $orderId',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),

              const Spacer(),

              // زر التتبع الأساسي
              CustomButton(
                text: 'Track order',
                onPressed: () {},
                isEnabled: true,
                enabledColor: AppColors.pinkBase,
              ),

              SizedBox(height: 40.h), // مسافة من الأسفل
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home, // استبدله باسم الـ Route الخاص بالـ Home عندك
          (route) => false, // يمسح كل الـ Stack عشان الـ User ميرجعش للـ Cart
    );
  }
}