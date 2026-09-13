import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flutter/material.dart';

class AddressFormFields extends StatelessWidget {
  const AddressFormFields({
    super.key,
    required this.formKey,
    required this.addressController,
    required this.phoneNumberController,
    required this.recipientNameController,
    required this.labelController,
    required this.state,
    required this.cubit,
    this.editingAddress,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController addressController;
  final TextEditingController phoneNumberController;
  final TextEditingController recipientNameController;
  final TextEditingController labelController;
  final AddressState state;
  final AddressCubit cubit;
  final AddressEntity? editingAddress;

  @override
  Widget build(BuildContext context) {
    final isLoading = state.addAddressState.isLoading;
    final filteredCities = state.citiesState.data ?? [];

    return Column(
      children: [
        CustomTextFormField(
          validator: (value) =>
              AuthValidators.addressFields(value, AppStrings.addressRequired),
          controller: addressController,
          label: AppStrings.addressTitle,
          hintText: AppStrings.enterAddressHint,
          readOnly: true,
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          validator: (value) =>
              AuthValidators.addressFields(value, AppStrings.labelRequired),
          controller: labelController,
          label: AppStrings.labelTitle,
          hintText: AppStrings.labelTitleHint,
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          controller: phoneNumberController,
          validator: AuthValidators.phone,
          label: AppStrings.phoneNumberLabel,
          hintText: AppStrings.phoneNumberHint,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          controller: recipientNameController,
          validator: (value) => AuthValidators.addressFields(
            value,
            AppStrings.recipientNameRequired,
          ),
          label: AppStrings.recipientNameLabel,
          hintText: AppStrings.enterRecipientNameHint,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 24),
        _LocationDropdowns(
          state: state,
          filteredCities: filteredCities,
          cubit: cubit,
        ),
        const SizedBox(height: 48),
        CustomButton(
          text: isLoading ? AppStrings.loadingAddress : AppStrings.saveAddress,
          onPressed: isLoading ? null : _submit,
          isEnabled: !isLoading,
          enabledColor: AppColors.pinkBase,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;

    final addressParams = AddAddressParams(
      recipientName: recipientNameController.text.trim(),
      recipientPhone: phoneNumberController.text.trim(),
      addressLine: addressController.text.trim(),
      city: state.selectedGovernorate ?? '',
      area: state.selectedCity ?? '',
      lat: state.selectedCoordinates?.latitude ?? 30.047931723716083,
      lng: state.selectedCoordinates?.longitude ?? 31.238564150922823,
      label: labelController.text.trim(),
    );

    if (editingAddress != null) {
      cubit.doEvent(UpdateExistingAddressEvent(
        id: editingAddress!.id,
        params: addressParams,
      ));
    } else {
      cubit.doEvent(SubmitAddressEvent(addAddressParams: addressParams));
    }
  }
}

class _LocationDropdowns extends StatelessWidget {
  const _LocationDropdowns({
    required this.state,
    required this.filteredCities,
    required this.cubit,
  });

  final AddressState state;
  final List<dynamic> filteredCities;
  final AddressCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 159,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: state.selectedGovernorate,
            hint: const Text(
              AppStrings.cityLabel,
              overflow: TextOverflow.ellipsis,
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
                cubit.doEvent(SelectGovernorateEvent(governorateId: value));
              }
            },
            validator: (value) => value == null || value.isEmpty
                ? 'Governorate is Required'
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue:
            filteredCities.any((city) => city.id == state.selectedCity)
                ? state.selectedCity
                : null,
            hint: const Text(
              AppStrings.areaLabel,
              overflow: TextOverflow.ellipsis,
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
                return AppStrings.cityRequired;
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
    );
  }
}