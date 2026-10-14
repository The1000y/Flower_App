import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../core/themes/app_colors/app_color.dart';
import '../widgets/custom_delivery_boy_information_card.dart';
import '../widgets/custom_estimated_arrival_section.dart';
import '../widgets/map/order_route_map.dart';

class OrderMapView extends StatelessWidget {
  const OrderMapView({super.key});

  static const _apartment = LatLng(30.0430, 31.2330);
  static const _flowery = LatLng(30.0485, 31.2410);
  static const _courier = LatLng(30.0452, 31.2392);
  static const _route = <LatLng>[
    _apartment,
    LatLng(30.0430, 31.2375),
    LatLng(30.0452, 31.2375),
    LatLng(30.0452, 31.2410),
    _flowery,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const OrderRouteMap(
                  route: _route,
                  origin: _apartment,
                  originLabel: AppStrings.apartment,
                  destination: _flowery,
                  destinationLabel: AppStrings.floweryAppbarTitle,
                  courier: _courier,
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 8,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.pinkBase,
                    ),
                    padding: const EdgeInsets.only(left: 8),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.whiteBase,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const _OrderInfoPanel(),
        ],
      ),
    );
  }
}

class _OrderInfoPanel extends StatelessWidget {
  const _OrderInfoPanel();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomEstimatedArrivalSection(
                estimatedArrivalDateTime: DateTime(2024, 9, 3, 11),
              ),
              const Gap(16),
              CustomDeliveryBoyInformationCard(
                deliveryBoyName: 'Muhamed',
                deliveryBoyPhoneNumber: '01014194042',
                deliveryBoyImageURL:
                'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=500',
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: AppStrings.orderDetails,
                  onPressed: () {},
                  isEnabled: true,
                  enabledColor: AppColors.pinkBase,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}