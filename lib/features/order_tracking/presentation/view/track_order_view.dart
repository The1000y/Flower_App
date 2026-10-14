import 'package:flower_app/core/shared/app_widgets/custom_app_bar.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/order_tracking/presentation/view/waiting_for_driver_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_strings/app_strings.dart';
import '../../../../core/constants/enums/order_status.dart';
import '../../../../core/shared/animations/animated_car_single_file.dart';
import '../widgets/custom_delivery_boy_information_card.dart';
import '../widgets/custom_estimated_arrival_section.dart';
import '../widgets/custom_tracking_buttons_section.dart';
import '../widgets/order_status_section.dart';

import 'dart:async';

class TrackOrderView extends StatefulWidget {
  const TrackOrderView({super.key});

  @override
  State<TrackOrderView> createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  static const _waitingDuration = Duration(seconds: 5);

  // TEMP: replace with the cubit state later
  OrderStatus _status = OrderStatus.received;

  bool _isWaitingForDriver = true;
  Timer? _waitingTimer;

  @override
  void initState() {
    super.initState();
    _waitingTimer = Timer(_waitingDuration, () {
      if (mounted) setState(() => _isWaitingForDriver = false);
    });
  }

  @override
  void dispose() {
    _waitingTimer?.cancel();
    super.dispose();
  }

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

      floatingActionButton: _isWaitingForDriver
          ? null
          : FloatingActionButton.small(
        onPressed: _nextStatus,
        child: const Icon(Icons.skip_next),
      ),

      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          layoutBuilder: (current, previous) => Stack(
            fit: StackFit.expand,
            children: [...previous, ?current],
          ),
          child: _isWaitingForDriver
              ? const WaitingForDriverView(key: ValueKey('waiting'))
              : _buildTrackingContent(),
        ),
      ),
    );
  }

  Widget _buildTrackingContent() {
    return Column(
      key: const ValueKey('tracking'),
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
                      const CustomDeliveryBoyInformationCard(
                        deliveryBoyName: 'Mohamed',
                        deliveryBoyPhoneNumber: '01014194042',
                        deliveryBoyImageURL:
                        'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=500',
                      ),
                      const Gap(32),
                      AnimatedCar(
                        width: 340,
                        duration: const Duration(milliseconds: 600),
                        playing: _status == OrderStatus.outForDelivery,
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
    );
  }
}