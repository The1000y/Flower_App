import 'dart:async';
import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/addresses/presentation/view/widgets/helper_methods/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class CustomAddressBody extends StatefulWidget {
  CustomAddressBody({
    super.key,
    required this.controllerMap,
    required this.isMapScroll,
  });

  final Completer<GoogleMapController> controllerMap;
  Function(bool) isMapScroll;

  @override
  State<CustomAddressBody> createState() => _CustomAddressBodyState();
}

class _CustomAddressBodyState extends State<CustomAddressBody> {
  late TextEditingController addressController;
  late TextEditingController phoneNumberController;
  late TextEditingController recipientNameController;
  late TextEditingController cityController;
  late TextEditingController areaController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AddressCubit cubit;
  LatLng? mapCenter;

  late TextTheme textTheme;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    cubit = context.read<AddressCubit>();
    cubit.doEvent(InitializeAddressEvent());
  }

  void _initializeControllers() {
    addressController = TextEditingController();
    phoneNumberController = TextEditingController();
    recipientNameController = TextEditingController();
    cityController = TextEditingController();
    areaController = TextEditingController();
  }

  @override
  void dispose() {
    addressController.dispose();
    phoneNumberController.dispose();
    recipientNameController.dispose();
    cityController.dispose();
    areaController.dispose();
    super.dispose();
  }

  Future<void> _animateCameraToLocation(LatLng coordinates) async {
    if (widget.controllerMap.isCompleted) {
      final controller = await widget.controllerMap.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: coordinates, zoom: 14),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final CameraTargetBounds egyptBounds = CameraTargetBounds(
      LatLngBounds(
        southwest: LatLng(22.0, 24.7),
        northeast: LatLng(31.7, 36.9),
      ),
    );
    textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AddressCubit, AddressState>(
      listenWhen: (previous, current) {
        return previous.locationState.errorMessage !=
                current.locationState.errorMessage ||
            previous.addAddressState.errorMessage !=
                current.addAddressState.errorMessage ||
            previous.addAddressState.data != current.addAddressState.data ||
            previous.reverseGeocodeState.errorMessage !=
                current.reverseGeocodeState.errorMessage;
      },
      listener: (context, state) {
        if (state.locationState.data != null &&
            state.selectedCoordinates == null) {
          // لو لم نحدد موقع بعد
          _animateCameraToLocation(state.locationState.data!);
        }

        if (state.locationState.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(state.locationState.errorMessage),
            ),
          );
        }

        if (state.addAddressState.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(state.addAddressState.errorMessage),
            ),
          );
        }
        if (state.addAddressState.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: AppColors.success,
              content: Text("✅ Address added successfully"),
            ),
          );
        }

        // أخطاء reverse geocoding
        if (state.reverseGeocodeState.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(state.reverseGeocodeState.errorMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.reverseGeocodeState.data != null &&
            state.reverseGeocodeState.data!.isNotEmpty) {
          addressController.text = state.reverseGeocodeState.data!;
        }
        final addAddressState = state.addAddressState;
        final isLoading = addAddressState.isLoading;
        final isLocationLoading = state.locationState.isLoading;
        final filteredCities = state.citiesState.data ?? [];
        return Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),

              Listener(
                onPointerDown: (_) {
                  widget.isMapScroll(false); // لما تحط إيدك على الخريطة
                },
                onPointerUp: (_) {
                  widget.isMapScroll(true); // لما تشيل إيدك
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(color: AppColors.lightPink),
                  child: Stack(
                    children: [
                      // لو كانت الخريطة لم تُحمّل بعد
                      if (isLocationLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        Stack(
                          children: [
                            GoogleMap(
                              cameraTargetBounds: egyptBounds,
                              onCameraMove: (position) {
                                mapCenter = position.target;
                              },
                              onCameraIdle: () async {
                                if (mapCenter != null) {
                                  cubit.doEvent(
                                    SelectLocationFromMapEvent(
                                      coordinates: mapCenter!,
                                    ),
                                  );
                                }
                              },
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              initialCameraPosition: CameraPosition(
                                zoom: 14,
                                target:
                                    state.selectedCoordinates ??
                                    const LatLng(
                                      30.047931723716083,
                                      31.238564150922823,
                                    ),
                              ),
                              minMaxZoomPreference: const MinMaxZoomPreference(
                                5,
                                20,
                              ),
                              onMapCreated: (controller) async {
                                if (!mounted) return;
                                widget.controllerMap.complete(controller);
                                setStyleMap(widget.controllerMap);
                              },
                            ),
                            if (!isLocationLoading)
                              Positioned(
                                bottom: 50,
                                right: 0,
                                left: 0,
                                top: 0,
                                child: Center(
                                  child: Image.asset(
                                    'assets/Vector.png',
                                    scale: 2.4,
                                  ),
                                ),
                              ),
                          ],
                        ),

                      // الصورة (الـ marker) في المنتصف
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              CustomTextFormField(
                validator: (value) {
                  return AuthValidators.addressFields(
                    value,
                    'Address is Required',
                  );
                },
                controller: addressController,
                label: AppStrings.addressTitle,
                hintText: AppStrings.enterAddressHint,
                readOnly: true,
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                controller: phoneNumberController,
                validator: (value) {
                  return AuthValidators.phone(value);
                },
                label: AppStrings.phoneNumberLabel,
                hintText: AppStrings.phoneNumberHint,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 24),

              CustomTextFormField(
                controller: recipientNameController,
                validator: (value) {
                  return AuthValidators.addressFields(
                    value,
                    'Name is Required',
                  );
                },
                label: AppStrings.recipientNameLabel,
                hintText: AppStrings.enterRecipientNameHint,
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 159,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: state.selectedGovernorate,
                      hint: Text(
                        AppStrings.cityLabel,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      decoration: InputDecoration(
                        labelText: AppStrings.cityLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: state.governorates.map((governorate) {
                        return DropdownMenuItem<String>(
                          value: governorate.id,
                          child: Text(governorate.nameEn),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          cubit.doEvent(
                            SelectGovernorateEvent(governorateId: value),
                          );
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Governorate is Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value:
                          (filteredCities.any(
                            (city) => city.id == state.selectedCity,
                          ))
                          ? state.selectedCity
                          : null,
                      hint: Text(
                        AppStrings.areaLabel,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      decoration: InputDecoration(
                        labelText: AppStrings.areaLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: filteredCities.map((city) {
                        return DropdownMenuItem<String>(
                          value: city.id,
                          child: Text(city.nameEn),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          cubit.doEvent(SelectCityEvent(cityId: value));
                        }
                      },
                      validator: (value) {
                        if (state.selectedGovernorate != null &&
                            (value == null || value.isEmpty)) {
                          return 'City is Required';
                        }
                        return null;
                      },
                      disabledHint: Text(
                        state.selectedGovernorate == null
                            ? 'Select Governorate !!'
                            : AppStrings.cityLabel,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: isLoading
                    ? AppStrings.loadingAddress
                    : AppStrings.saveAddress,
                onPressed: isLoading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          final selectedGovernorateObj = state.governorates
                              .firstWhere(
                                (city) => city.id == state.selectedGovernorate,
                                orElse: () =>
                                    throw Exception('Governorate not found'),
                              );
                          final selectedAreaObj = filteredCities.firstWhere(
                            (city) => city.id == state.selectedCity,
                            orElse: () => throw Exception('City not found'),
                          );

                          final address = AddAddressRequest(
                            recipientName: recipientNameController.text.trim(),
                            recipientPhone: phoneNumberController.text.trim(),
                            addressLine: addressController.text.trim(),
                            city: selectedGovernorateObj.nameEn,
                            area: selectedAreaObj
                                .nameEn, // المنطقة نفس اسم المدينة
                            lat: state.selectedCoordinates?.latitude,
                            lng: state.selectedCoordinates?.longitude,
                            label: null,
                          );
                          cubit.doEvent(
                            SubmitAddressEvent(addAddressRequest: address),
                          );
                        }
                      },
                isEnabled: !isLoading,
                enabledColor: AppColors.pinkBase,
              ),
            ],
          ),
        );
      },
    );
  }
}
