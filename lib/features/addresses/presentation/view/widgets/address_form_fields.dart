import 'package:flower_app/config/utils/auth_validators.dart';

import 'package:flower_app/l10n/l10n.dart';
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
              AuthValidators.addressFields(value, context.l10n.addressRequired),
          controller: addressController,
          label: context.l10n.addressTitle,
          hintText: context.l10n.enterAddressHint,
          readOnly: true,
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          validator: (value) =>
              AuthValidators.addressFields(value, context.l10n.labelRequired),
          controller: labelController,
          label: context.l10n.labelTitle,
          hintText: context.l10n.labelTitleHint,
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          controller: phoneNumberController,
          validator: AuthValidators.phone,
          label: context.l10n.phoneNumberLabel,
          hintText: context.l10n.phoneNumberHint,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          controller: recipientNameController,
          validator: (value) => AuthValidators.addressFields(
            value,
            context.l10n.recipientNameRequired,
          ),
          label: context.l10n.recipientNameLabel,
          hintText: context.l10n.enterRecipientNameHint,
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
          text: isLoading ? context.l10n.loadingAddress : context.l10n.saveAddress,
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
      city: state.selectedCity ?? '',
      area: '',
      cityId: state.selectedCity ?? '',
      areaId: '',
      lat: state.selectedCoordinates?.latitude ?? 30.047931723716083,
      lng: state.selectedCoordinates?.longitude ?? 31.238564150922823,

      label: labelController.text.trim(),
    );

    if (editingAddress != null) {
      cubit.doEvent(
        UpdateExistingAddressEvent(
          id: editingAddress!.id,
          params: addressParams,
        ),
      );
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: state.selectedGovernorate,
            hint: Text(
              context.l10n.cityLabel,
              overflow: TextOverflow.ellipsis,
            ),
            decoration: InputDecoration(
              labelText: context.l10n.cityLabel,
              prefixIconColor: AppColors.pinkBase,
              prefixIcon: const Icon(Icons.location_city_outlined),
              filled: true,
              fillColor: AppColors.white50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.pinkBase,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.pinkBase,
                  width: 1.6,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.6,
                ),
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            items: state.governorates.map((governorate) {
              return DropdownMenuItem<String>(
                value: governorate.id,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_city_outlined,
                      size: 18,
                      color: AppColors.pinkBase,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        governorate.nameEn,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                cubit.doEvent(SelectGovernorateEvent(governorateId: value));
              }
            },
            validator: (value) => value == null || value.isEmpty
                ? context.l10n.governorateRequired
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
            hint: Text(
              context.l10n.areaLabel,
              overflow: TextOverflow.ellipsis,
            ),
            decoration: InputDecoration(
              labelText: context.l10n.areaLabel,
              prefixIconColor: AppColors.pinkBase,
              prefixIcon: const Icon(Icons.map_outlined),
              filled: true,
              fillColor: AppColors.white50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.pinkBase,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.pinkBase,
                  width: 1.6,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.error, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.6,
                ),
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            items: filteredCities.map((city) {
              return DropdownMenuItem<String>(
                value: city.id,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.pinkBase,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        city.nameEn,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
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
                return context.l10n.cityRequired;
              }
              return null;
            },
            disabledHint: Text(
              state.selectedGovernorate == null
                  ? context.l10n.selectGovernorate
                  : context.l10n.cityLabel,
            ),
          ),
        ),
      ],
    );
  }
}
