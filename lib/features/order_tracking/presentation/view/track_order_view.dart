import 'package:flower_app/core/shared/app_widgets/custom_app_bar.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/constants/enums/order_status.dart';
import '../../../../core/shared/animations/animated_car_single_file.dart';
import '../widgets/custom_delivery_boy_information_card.dart';
import '../widgets/custom_estimated_arrival_section.dart';
import '../widgets/custom_tracking_buttons_section.dart';
import '../widgets/order_status_section.dart';

class TrackOrderView extends StatefulWidget {
  const TrackOrderView({super.key});

  @override
  State<TrackOrderView> createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  // TEMP: replace with the cubit state later
  OrderStatus _status = OrderStatus.received;

  // TEMP: cycles through the statuses so you can check each UI state
  void _nextStatus() {
    setState(() {
      _status =
          OrderStatus.values[(_status.index + 1) % OrderStatus.values.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        textStyle: textTheme.titleLarge,
        title: AppStrings.trackOrder,
        onBack: () => Navigator.pop(context),
      ),

      // TEMP debug button, delete before merging
      floatingActionButton: FloatingActionButton.small(
        onPressed: _nextStatus,
        child: const Icon(Icons.skip_next),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          CustomEstimatedArrivalSection(
                            estimatedArrivalDateTime: DateTime.now(),
                          ),
                          const Gap(32),
                          CustomDeliveryBoyInformationCard(
                            deliveryBoyName: 'Mohamed',
                            deliveryBoyPhoneNumber: '01014194042',
                            deliveryBoyImageURL: 'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=500',
                          ),

                          const Gap(32),

                          AnimatedCar(
                            width: 340,
                            duration: const Duration(milliseconds: 600),
                            showRoad: true,
                            showSpeedLines: true,
                            roadColor: AppColors.white70,
                          ),
                          const Gap(32),
                          OrderStatusSection(status: _status),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: CustomTrackingButtonsSection(
                isDelivered: _status == OrderStatus.delivered,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//ToDo: replace after create the cubit!:

// class OrderStatusSection extends StatelessWidget {
//   const OrderStatusSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<TrackOrderCubit, TrackOrderState, OrderStatus>(
//       selector: (state) => state.status,
//       builder: (context, status) {
//         final now = DateTime.now(); // replace with real timestamps from your API
//         return OrderStatusTimeline(
//           currentIndex: status.index,
//           steps: [
//             OrderStep(title: 'Received your order', dateTime: now),
//             OrderStep(
//               title: 'Preparing your order',
//               dateTime: status.index >= 1 ? now : null,
//             ),
//             OrderStep(
//               title: 'Out for delivery',
//               dateTime: status.index >= 2 ? now : null,
//             ),
//             OrderStep(
//               title: 'Delivered',
//               dateTime: status.index >= 3 ? now : null,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

//======================================================
