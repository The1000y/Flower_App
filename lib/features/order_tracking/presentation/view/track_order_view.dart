import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/shared/app_widgets/custom_app_bar.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/constants/enums/order_status.dart';
import '../../../../core/shared/animations/animated_car_single_file.dart';
import '../../domain/entities/tracking_entity.dart';
import '../manager/tracking_event.dart';
import '../manager/tracking_state.dart';
import '../manager/tracking_view_model.dart';
import '../widgets/custom_delivery_boy_information_card.dart';
import '../widgets/custom_estimated_arrival_section.dart';
import '../widgets/custom_tracking_buttons_section.dart';
import '../widgets/order_status_section.dart';
import 'order_map_view.dart';

class TrackOrderView extends StatefulWidget {
  const TrackOrderView({super.key, required this.orderId});

  final String orderId;

  @override
  State<TrackOrderView> createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  late final TrackingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<TrackingViewModel>();
    _viewModel.handle(StartTrackingEvent(widget.orderId));
  }

  @override
  void dispose() {
    _viewModel.handle(StopTrackingEvent());
    super.dispose();
  }

  void _openMap(TrackingEntity entity) {
    Navigator.pushNamed(
      context,
      Routes.orderMap,
      arguments: OrderMapRouteArguments(
        tracking: entity,
        viewModel: context.read<TrackingViewModel>(),
      ),
    );
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
      body: SafeArea(
        child: BlocBuilder<TrackingViewModel, TrackingState>(
          builder: (context, state) {
            final tracking = state.trackingState;
            final entity = tracking.data;

            if (tracking.isLoading && entity == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (entity == null) {
              return _TrackingError(
                message: tracking.errorMessage.isEmpty
                    ? AppStrings.somethingWentWrong
                    : tracking.errorMessage,
                onRetry: () => context
                    .read<TrackingViewModel>()
                    .handle(StartTrackingEvent(widget.orderId)),
              );
            }

            return _TrackingContent(
              entity: entity,
              onShowMap: () => _openMap(entity),
            );
          },
        ),
      ),
    );
  }
}

class _TrackingContent extends StatelessWidget {
  const _TrackingContent({required this.entity, required this.onShowMap});

  final TrackingEntity entity;
  final VoidCallback onShowMap;

  @override
  Widget build(BuildContext context) {
    final driver = entity.driver;
    final estimatedArrival = entity.estimatedDeliveryAt;

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
                      if (estimatedArrival != null) ...[
                        CustomEstimatedArrivalSection(
                          estimatedArrivalDateTime: estimatedArrival,
                        ),
                        const Gap(32),
                      ],
                      if (driver != null) ...[
                        CustomDeliveryBoyInformationCard(
                          deliveryBoyName: driver.name ?? '',
                          deliveryBoyPhoneNumber: driver.phone ?? '',
                          deliveryBoyImageURL: driver.photoUrl,
                        ),
                        const Gap(32),
                      ],
                      const AnimatedCar(
                        width: 340,
                        duration: Duration(milliseconds: 600),
                        showRoad: true,
                        showSpeedLines: true,
                        roadColor: AppColors.white70,
                      ),
                      const Gap(32),
                      OrderStatusSection(
                        status: OrderStatus.fromStatus(entity.status),
                      ),
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
            isDelivered: entity.isDelivered,
            onShowMap: onShowMap,
            onDelivered: () =>
                context.read<TrackingViewModel>().handle(StopTrackingEvent()),
          ),
        ),
      ],
    );
  }
}

class _TrackingError extends StatelessWidget {
  const _TrackingError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: textTheme.bodyMedium, textAlign: TextAlign.center),
            const Gap(16),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pinkBase,
              ),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}