import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/themes/app_colors/app_color.dart';
import '../manager/tracking_state.dart';
import '../manager/tracking_view_model.dart';
import '../widgets/map/order_info_panel.dart';
import '../widgets/map/order_route_map.dart';

class OrderMapView extends StatelessWidget {
  const OrderMapView({super.key});

  LatLng? _toLatLng(double? lat, double? lng) {
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrackingViewModel, TrackingState>(
        builder: (context, state) {
          final data = state.trackingState.data;

          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final address = _toLatLng(
            data.userAddress?.lat,
            data.userAddress?.lng,
          );
          final courier = _toLatLng(
            data.currentLocation?.lat,
            data.currentLocation?.lng,
          );

          final route = <LatLng>[?courier, ?address];

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    OrderRouteMap(
                      route: route,
                      origin: address,
                      originLabel: AppStrings.apartment,
                      destinationLabel: AppStrings.floweryAppbarTitle,
                      courier: courier,
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
              OrderInfoPanel(tracking: data),
            ],
          );
        },
      ),
    );
  }
}
