import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryTimeSection extends StatelessWidget {
  const DeliveryTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
           Text('Delivery time' , style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600  ,fontSize: 18),),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.schedule, color: AppColors.black100),
               Text('  Instant, ' , style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500  ,fontSize: 16),),
              BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, state) {
                  final estimatedTime =
                      state.estimationTimeState.data?.estimatedDeliveryAt ??
                      state.checkoutDetailsState.data?.estimatedDeliveryAt ??
                      '';
                  return Text(
                   'Arrive by $estimatedTime' ,
                    style: TextStyle(color: AppColors.success, fontSize: 16),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
