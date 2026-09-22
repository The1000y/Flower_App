import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/delivery_address_section.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/delivery_time_section.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/gift_section.dart';
// import 'package:flower_app/features/checkout/presentation/view/widgets/gift_section.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/order_summary_section.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/payment_method_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt.get<CheckoutCubit>()..doEvent(GetCheckoutEvent()),
        ),
        BlocProvider.value(
          value: getIt.get<AddressCubit>()..doEvent(FetchUserAddressesEvent()),
        ),
      ],

      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        appBar: AppBar(
          backgroundColor: AppColors.whiteBase,
          elevation: 0,
          scrolledUnderElevation:0,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const DeliveryTimeSection(),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 24,
                color: AppColors.lightGray,
              ),
              const SizedBox(height: 24),
              const DeliveryAddressSection(),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 24,
                color: AppColors.lightGray,
              ),
              const SizedBox(height: 24),
              const PaymentMethodSection(),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 24,
                color: AppColors.lightGray,
              ),
              const SizedBox(height: 24),
              const GiftSection(),

              const SizedBox(height: 24),
              const OrderSummarySection(),
            ],
          ),
        ),
      ),
    );
  }
}
