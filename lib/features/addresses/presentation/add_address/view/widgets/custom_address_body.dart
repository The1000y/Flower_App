import 'dart:async';

import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../manager/cubit/add_address_cubit.dart';
import '../../manager/cubit/address_events.dart';
import '../../manager/cubit/address_state.dart';
import 'address_form_fields.dart';
import 'address_map_widget.dart';

class CustomAddressBody extends StatefulWidget {
  const CustomAddressBody({
    super.key,
    required this.controllerMap,
    required this.isMapScroll,
  });

  final Completer<GoogleMapController> controllerMap;
  final Function(bool) isMapScroll;

  @override
  State<CustomAddressBody> createState() => _CustomAddressBodyState();
}

class _CustomAddressBodyState extends State<CustomAddressBody> {
  late TextEditingController addressController;
  late TextEditingController phoneNumberController;
  late TextEditingController recipientNameController;
  late TextEditingController labelController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AddressCubit cubit;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
    phoneNumberController = TextEditingController();
    recipientNameController = TextEditingController();
    labelController = TextEditingController();
    cubit = context.read<AddressCubit>();
    cubit.doEvent(InitializeAddressEvent());
  }

  @override
  void dispose() {
    addressController.dispose();
    phoneNumberController.dispose();
    recipientNameController.dispose();
    labelController.dispose();
    super.dispose();
  }

  Future<void> _animateCameraToLocation(LatLng coordinates) async {
    if (!widget.controllerMap.isCompleted) return;

    final controller = await widget.controllerMap.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: coordinates, zoom: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressCubit, AddressState>(
      listenWhen: (previous, current) =>
          previous.locationState.errorMessage !=
              current.locationState.errorMessage ||
          previous.addAddressState.errorMessage !=
              current.addAddressState.errorMessage ||
          previous.addAddressState.data != current.addAddressState.data ||
          previous.reverseGeocodeState.errorMessage !=
              current.reverseGeocodeState.errorMessage,
      listener: _handleStateChanges,
      builder: (context, state) {
        if (state.reverseGeocodeState.data != null &&
            state.reverseGeocodeState.data!.isNotEmpty) {
          addressController.text = state.reverseGeocodeState.data!;
        }

        return Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),
              AddressMapWidget(
                controllerMap: widget.controllerMap,
                isMapScroll: widget.isMapScroll,
                cubit: cubit,
                isLoading: state.locationState.isLoading,
                selectedCoordinates: state.selectedCoordinates,
              ),
              const SizedBox(height: 24),
              AddressFormFields(
                formKey: formKey,
                addressController: addressController,
                phoneNumberController: phoneNumberController,
                recipientNameController: recipientNameController,
                labelController: labelController,
                state: state,
                cubit: cubit,
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, AddressState state) {
    if (state.locationState.data != null && state.selectedCoordinates == null) {
      _animateCameraToLocation(state.locationState.data!);
    }

    final locationError = state.locationState.errorMessage;
    final addAddressError = state.addAddressState.errorMessage;
    final reverseGeocodeError = state.reverseGeocodeState.errorMessage;

    if (locationError.isNotEmpty) {
      _showError(context, locationError);
    }
    if (addAddressError.isNotEmpty) {
      _showError(context, addAddressError);
    }
    if (reverseGeocodeError.isNotEmpty) {
      _showError(context, reverseGeocodeError);
    }
    if (state.addAddressState.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.success,
          content: Text('Address added successfully'),
        ),
      );
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: AppColors.error, content: Text(message)),
    );
  }
}
