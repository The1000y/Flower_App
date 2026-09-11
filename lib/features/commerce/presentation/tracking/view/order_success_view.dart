import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../config/routing/routes.dart';
import '../../../../../core/constants/app_strings/app_strings.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/themes/app_colors/app_color.dart';
import '../manager/cubit/order_success_cubit.dart';

class OrderSuccessView extends StatelessWidget {
  final String? orderId;

  const OrderSuccessView({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderSuccessCubit(orderId: orderId),
      child: BlocListener<OrderSuccessCubit, OrderSuccessState>(
        listener: (context, state) {
          if (state.action == OrderSuccessAction.navigateToHome) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            );
          } else if (state.action == OrderSuccessAction.navigateToTrackOrder) {
            Navigator.pushNamed(
              context,
              Routes.trackOrder,
              arguments: state.orderId,
            );
          }
        },
        child: Builder(
          builder: (context) {
            final textTheme = Theme.of(context).textTheme;
            final cubit = context.read<OrderSuccessCubit>();

            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                cubit.onHomeTap();
              },
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackBase),
                    onPressed: () => cubit.onHomeTap(),
                  ),
                  title: Text(
                    AppStrings.trackOrder,
                    style: textTheme.titleLarge!.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.blackBase,
                    ),
                  ),
                  centerTitle: false,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 60.h),
                        Center(
                          child: Container(
                            width: 120.w,
                            height: 120.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.success.withOpacity(0.1),
                            ),
                            child: const Center(
                              child: Icon(Icons.check_circle, color: AppColors.success, size: 60),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          AppStrings.orderPlacedSuccess,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium!.copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackBase,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (orderId != null)
                          Text(
                            '${AppStrings.orderIdPrefix}$orderId',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium!.copyWith(
                              fontSize: 16.sp,
                              color: AppColors.blackBase,
                            ),
                          ),
                        SizedBox(height: 80.h),
                        CustomButton(
                          text: AppStrings.trackOrder,
                          onPressed: () => cubit.onTrackOrderTap(),
                          isEnabled: true,
                          enabledColor: AppColors.pinkBase,
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
