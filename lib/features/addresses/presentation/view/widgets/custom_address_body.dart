import 'dart:async';

import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/addresses/presentation/view/widgets/address_form_fields.dart';
import 'package:flower_app/features/addresses/presentation/view/widgets/address_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomAddressBody extends StatefulWidget {
  const CustomAddressBody({
    super.key,
    required this.controllerMap,
    required this.isMapScroll,
    this.editingAddress,
  });

  final Completer<GoogleMapController> controllerMap;
  final Function(bool) isMapScroll;
  final AddressEntity? editingAddress;

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
  String _lastLocationError = '';
  String _lastAddAddressError = '';
  String _lastReverseGeocodeError = '';

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
    phoneNumberController = TextEditingController();
    recipientNameController = TextEditingController();
    labelController = TextEditingController();
    cubit = context.read<AddressCubit>();
    cubit.doEvent(InitializeAddressEvent(existingAddress: widget.editingAddress));

    if (widget.editingAddress != null) {
      recipientNameController.text = widget.editingAddress!.recipientName;
      phoneNumberController.text = widget.editingAddress!.recipientPhone;
      addressController.text = widget.editingAddress!.addressLine;
      labelController.text = widget.editingAddress!.label ?? '';
    }
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
      previous.locationState.errorMessage != current.locationState.errorMessage ||
          previous.locationState.data != current.locationState.data ||
          previous.addAddressState.errorMessage != current.addAddressState.errorMessage ||
          previous.addAddressState.data != current.addAddressState.data ||
          previous.reverseGeocodeState.errorMessage != current.reverseGeocodeState.errorMessage ||
          previous.reverseGeocodeState.data != current.reverseGeocodeState.data,
      listener: _handleStateChanges,
      builder: (context, state) {

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
                editingAddress: widget.editingAddress,
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

    if (state.reverseGeocodeState.data != null &&
        state.reverseGeocodeState.data!.isNotEmpty) {
      addressController.text = state.reverseGeocodeState.data!;
    }

    final locationError = state.locationState.errorMessage;
    final addAddressError = state.addAddressState.errorMessage;
    final reverseGeocodeError = state.reverseGeocodeState.errorMessage;

    if (locationError != _lastLocationError) {
      _lastLocationError = locationError;
      if (locationError.isNotEmpty) _showError(context, locationError);
    }
    if (addAddressError != _lastAddAddressError) {
      _lastAddAddressError = addAddressError;
      if (addAddressError.isNotEmpty) _showError(context, addAddressError);
    }
    if (reverseGeocodeError != _lastReverseGeocodeError) {
      _lastReverseGeocodeError = reverseGeocodeError;
      if (reverseGeocodeError.isNotEmpty) {
        _showError(context, reverseGeocodeError);
      }
    }

    if (state.addAddressState.data != null) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      cubit.doEvent(ResetAddAddressStateEvent());
    }
  }

  void _showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(backgroundColor: AppColors.error, content: Text(message)),
    );
  }
}