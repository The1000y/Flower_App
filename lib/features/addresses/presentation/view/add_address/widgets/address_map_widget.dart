import 'dart:async';

import 'package:flower_app/core/constants/apps_images/app_images.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'helper_methods/helper_methods.dart';

class AddressMapWidget extends StatefulWidget {
  const AddressMapWidget({
    super.key,
    required this.controllerMap,
    required this.isMapScroll,
    required this.cubit,
    required this.isLoading,
    required this.selectedCoordinates,
  });

  final Completer<GoogleMapController> controllerMap;
  final Function(bool) isMapScroll;
  final AddressCubit cubit;
  final bool isLoading;
  final LatLng? selectedCoordinates;

  @override
  State<AddressMapWidget> createState() => _AddressMapWidgetState();
}

class _AddressMapWidgetState extends State<AddressMapWidget> {
  LatLng? mapCenter;

  static final CameraTargetBounds egyptBounds = CameraTargetBounds(
    LatLngBounds(southwest: LatLng(22.0, 24.7), northeast: LatLng(31.7, 36.9)),
  );

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => widget.isMapScroll(false),
      onPointerUp: (_) => widget.isMapScroll(true),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: const BoxDecoration(color: AppColors.lightPink),
        child: widget.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    cameraTargetBounds: egyptBounds,
                    onCameraMove: (position) => mapCenter = position.target,
                    onCameraIdle: () {
                      if (mapCenter != null) {
                        widget.cubit.doEvent(
                          SelectLocationFromMapEvent(coordinates: mapCenter!),
                        );
                      }
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                      zoom: 14,
                      target:
                          widget.selectedCoordinates ??
                          const LatLng(30.047931723716083, 31.238564150922823),
                    ),
                    minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
                    onMapCreated: (controller) async {
                      if (!mounted) return;
                      widget.controllerMap.complete(controller);
                      setStyleMap(widget.controllerMap);
                    },
                  ),
                  Positioned(
                    bottom: 50,
                    right: 0,
                    left: 0,
                    top: 0,
                    child: Center(
                      child: Image.asset(AppImages.iconMap, scale: 2.4),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}