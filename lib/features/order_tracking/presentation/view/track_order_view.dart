import 'package:flower_app/core/shared/app_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/constants/enums/order_status.dart';
import '../../../../core/shared/animations/animated_car_single_file.dart';
import '../../../../core/themes/app_colors/app_color.dart';
import '../../domain/entities/order_status_mapper.dart';
import '../../domain/entities/tracking_entity.dart';
import '../manager/tracking_event.dart';
import '../manager/tracking_state.dart';
import '../manager/tracking_view_model.dart';
import '../widgets/custom_delivery_boy_information_card.dart';
import '../widgets/custom_estimated_arrival_section.dart';
import '../widgets/custom_tracking_buttons_section.dart';
import '../widgets/order_status_section.dart';
import 'waiting_for_driver_view.dart';

class TrackOrderView extends StatelessWidget {
  const TrackOrderView({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        textStyle: textTheme.titleLarge,
        title: AppStrings.trackOrder,
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: BlocBuilder<TrackingViewModel, TrackingState>(
          builder: (context, state) {
            final data = state.trackingState.data;

            if (state.trackingState.isLoading && data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isWaitingForDriver) {
              return const WaitingForDriverView();
            }

            if (data == null) {
              return _TrackingMessage(
                message: state.trackingState.errorMessage.isEmpty
                    ? AppStrings.unexpectedError
                    : state.trackingState.errorMessage,
                onRetry: () => context.read<TrackingViewModel>().handle(
                  StartTrackingIntent(orderId),
                ),
              );
            }

            final status = orderStatusFromApi(data.status);

            if (status == OrderStatus.cancelled) {
              return _TrackingMessage(
                message: AppStrings.orderCancelledSubtitle,
                onRetry: () => Navigator.pop(context),
              );
            }

            if (!data.hasDriver) {
              return const WaitingForDriverView();
            }

            return _TrackingContent(tracking: data);
          },
        ),
      ),
    );
  }
}

class _TrackingContent extends StatelessWidget {
  const _TrackingContent({required this.tracking});

  final TrackingEntity tracking;

  @override
  Widget build(BuildContext context) {
    final driver = tracking.driver;
    final status = orderStatusFromApi(tracking.status);

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      if (tracking.estimatedDeliveryAt != null)
                        CustomEstimatedArrivalSection(
                          estimatedArrivalDateTime:
                              tracking.estimatedDeliveryAt!,
                        ),
                      if (driver != null) ...[
                        const Gap(32),
                        CustomDeliveryBoyInformationCard(
                          deliveryBoyName: driver.name ?? '',
                          deliveryBoyPhoneNumber: driver.phone ?? '',
                          deliveryBoyImageURL: driver.photoUrl,
                        ),
                      ],
                      const Gap(32),
                      AnimatedCar(
                        width: 340,
                        duration: const Duration(milliseconds: 600),
                        playing: status == OrderStatus.outForDelivery,
                        showRoad: true,
                        showSpeedLines: true,
                        roadColor: AppColors.white70,
                      ),
                      const Gap(32),
                      OrderStatusSection(tracking: tracking),
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
            isDelivered: status == OrderStatus.delivered,
          ),
        ),
      ],
    );
  }
}

class _TrackingMessage extends StatelessWidget {
  const _TrackingMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
