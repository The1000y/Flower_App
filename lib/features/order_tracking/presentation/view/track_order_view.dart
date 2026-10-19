import 'package:flower_app/core/shared/app_widgets/custom_app_bar.dart';
import 'package:flower_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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
        title: context.l10n.trackOrder,
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: BlocConsumer<TrackingViewModel, TrackingState>(
          listenWhen: (prev, curr) =>
              prev.confirmDeliveryError != curr.confirmDeliveryError &&
              curr.confirmDeliveryError.isNotEmpty,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.confirmDeliveryError)),
              );
          },
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
                    ? context.l10n.unexpectedError
                    : state.trackingState.errorMessage,
                onPressed: () => context.read<TrackingViewModel>().handle(
                  StartTrackingIntent(orderId),
                ),
              );
            }

            final status = orderStatusFromApi(data.status);

            if (status == OrderStatus.cancelled) {
              return _TrackingMessage(
                message: context.l10n.orderCancelledSubtitle,
                buttonText: context.l10n.backButton,
                onPressed: () => Navigator.pop(context),
              );
            }

            if (!data.hasDriver) {
              return const WaitingForDriverView();
            }

            return _TrackingContent(
              tracking: data,
              isConfirming: state.isConfirmingDelivery,
            );
          },
        ),
      ),
    );
  }
}

class _TrackingContent extends StatelessWidget {
  const _TrackingContent({required this.tracking, required this.isConfirming});

  final TrackingEntity tracking;
  final bool isConfirming;

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
            isAwaitingConfirmation:
                status == OrderStatus.awaitingDeliveryConfirmation,
            isConfirming: isConfirming,
            onConfirm: () => context.read<TrackingViewModel>().handle(
              ConfirmDeliveryIntent(),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackingMessage extends StatelessWidget {
  const _TrackingMessage({
    required this.message,
    required this.onPressed,
    this.buttonText,
  });

  final String message;
  final VoidCallback onPressed;
  final String? buttonText;

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
            TextButton(
              onPressed: onPressed,
              child: Text(buttonText ?? context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
