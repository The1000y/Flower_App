import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressCubit>.value(value: getIt.get<AddressCubit>()),
        BlocProvider<CheckoutCubit>(
          create: (context) {
            return getIt.get<CheckoutCubit>()..doEvent(GetCheckoutEvent());
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.blackBase,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
          title: Text(
            AppStrings.checkoutTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ),

        body: Column(
          children: [
            //delivary Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text('Delivery time'),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.timer, color: AppColors.black100),
                      Text('Instant, '),
                      Text(
                        'Arrive by 03 Sep 2024, 11:00 AM',
                        style: TextStyle(color: AppColors.pinkBase),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 24,
              color: Color(0xffEAEAEA),
            ),
            SizedBox(height: 24),
            //delivary Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery address'),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gray.withValues(alpha: 0.27),
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: RadioListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text('HHHome'),
                      subtitle: Text(
                        'Home, 1234, Street, City, State, Country, Zip Code',
                      ),
                      secondary: IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: AppColors.gray,
                          size: 28.sp,
                        ),
                        onPressed: () {},
                      ),
                      value: 1,
                      groupValue: 1,
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gray.withValues(alpha: 0.27),
                          blurRadius: 5,
                          blurStyle: BlurStyle.outer,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: RadioListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text('HHHome'),
                      subtitle: Text(
                        'Home, 1234, Street, City, State, Country, Zip Code',
                      ),
                      secondary: IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: AppColors.gray,
                          size: 28.sp,
                        ),
                        onPressed: () {},
                      ),
                      value: 1,
                      groupValue: 1,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
