import 'package:collection/collection.dart';
import 'dart:developer' as developer;

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:flower_app/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/delete_address_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_addresses_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_cities_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_current_location_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_governomets_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_reverse_geocoded_address_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/set_default_address_usecase.dart';
import 'package:flower_app/features/addresses/domain/usecases/update_address_use_case.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@singleton
class AddressCubit extends Cubit<AddressState> {
  final AddAddressUseCase _addAddressUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetReverseGeocodedAddressUseCase _getReverseGeocodedAddressUseCase;
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final GetAddressesUseCase _getAddressesUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;

  AddressCubit(
    this._addAddressUseCase,
    this._getCitiesUseCase,
    this._getReverseGeocodedAddressUseCase,
    this._getCurrentLocationUseCase,
    this._getGovernoratesUseCase,
    this._updateAddressUseCase,
    this._getAddressesUseCase,
    this._deleteAddressUseCase,
    this._setDefaultAddressUseCase,
  ) : super(AddressState());

  void doEvent(AddressEvents event) {
    switch (event) {
      case InitializeAddressEvent():
        _initializeAddress(existingAddress: event.existingAddress);
        break;
      case SelectLocationFromMapEvent():
        _selectLocationFromMap(event.coordinates);
        break;
      case SelectGovernorateEvent():
        _selectGovernorate(event.governorateId);
        break;
      case SelectCityEvent():
        _selectCity(event.cityId);
        break;
      case SubmitAddressEvent():
        _submitAddress(addaddressParams: event.addAddressParams);
        break;
      case UpdateExistingAddressEvent():
        _updateExistingAddress(id: event.id, params: event.params);
        break;
      case FetchUserAddressesEvent():
        _loadAddresses();
        break;
      case SelectAddressEvent():
        _selectAddress(event.selectedAddress);
        break;
      case DeselectAddressEvent():
        _deselectAddress();
        break;
      case SetDefaultAddressEvent():
        _setDefaultAddress(event.id);
        break;
      case DeleteAddressEvent():
        _deleteAddress(event.id);
        break;
      case SetClosestAddressEvent():
        _setClosestAddress(event.currentLocation);
        break;
      case ResetAddAddressStateEvent():
        _resetAddAddressState();
        break;
    }
  }

  Future<void> _submitAddress({
    required AddAddressParams addaddressParams,
  }) async {
    emit(
      state.copyWith(
        addAddressState: BaseState<AddressEntity>(isLoading: true),
      ),
    );
    try {
      final selectedGovernorateObj = state.governorates.firstWhereOrNull(
        (g) => g.id == state.selectedGovernorate,
      );
      final selectedAreaObj = state.citiesState.data?.firstWhere(
        (city) => city.id == state.selectedCity,
        orElse: () => throw Exception('City not found'),
      );
      final addAddressParams = AddAddressParams(
        recipientName: addaddressParams.recipientName,
        recipientPhone: addaddressParams.recipientPhone,
        addressLine: addaddressParams.addressLine,
        city: selectedGovernorateObj?.nameEn ?? '',
        area: selectedAreaObj?.nameEn ?? '',
        lat: state.selectedCoordinates?.latitude ?? 0.0,
        lng: state.selectedCoordinates?.longitude ?? 0.0,
        label: addaddressParams.label,
      );
      final result = await _addAddressUseCase.call(addAddressParams);

      switch (result) {
        case SuccessResponce<AddressEntity>():
          final updatedAddresses = [...state.userAddresses, result.data];
          final updatedSavedAddresses = [
            ...(state.addressesState.data ?? const <AddressEntity>[]),
            result.data,
          ];
          emit(
            state.copyWith(
              userAddresses: updatedAddresses,
              selectedAddress: result.data,
              selectedAddressId: result.data.id,
              selectedAddressLabel:
                  '${result.data.addressLine} - ${result.data.area}',
              fetchAddressesState: BaseState<List<AddressEntity>>(
                isLoading: false,
                data: updatedSavedAddresses,
              ),
              addressesState: BaseState<List<AddressEntity>>(
                isLoading: false,
                data: updatedSavedAddresses,
              ),
              addAddressState: BaseState<AddressEntity>(
                isLoading: false,
                data: result.data,
              ),
            ),
          );
        case ErrorResponce<AddressEntity>():
          emit(
            state.copyWith(
              addAddressState: BaseState<AddressEntity>(
                isLoading: false,
                errorMessage: result.errorMessage,
              ),
            ),
          );
      }
    } catch (e, s) {
      developer.log(
        'Failed to submit address',
        error: e,
        stackTrace: s,
        name: 'AddressCubit',
      );

      emit(
        state.copyWith(
          addAddressState: BaseState(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _initializeAddress({AddressEntity? existingAddress}) async {
    emit(
      state.copyWith(locationState: const BaseState<LatLng>(isLoading: true)),
    );

    try {
      final governorates = await _getGovernoratesUseCase.call();

      if (existingAddress != null) {
        final coordinates =
            (existingAddress.lat != null && existingAddress.lng != null)
            ? LatLng(existingAddress.lat!, existingAddress.lng!)
            : const LatLng(30.047931723716083, 31.238564150922823);

        final matchedGovernorate = governorates.firstWhere(
          (g) => g.nameEn.toLowerCase() == existingAddress.city.toLowerCase(),
          orElse: () => governorates.first,
        );

        final citiesInGovernorate = await _getCitiesUseCase.call(
          matchedGovernorate.id,
        );

        final matchedCity = citiesInGovernorate.firstWhere(
          (c) => c.nameEn.toLowerCase() == existingAddress.area.toLowerCase(),
          orElse: () => citiesInGovernorate.isNotEmpty
              ? citiesInGovernorate.first
              : throw Exception("No cities found"),
        );

        emit(
          state.copyWith(
            selectedCoordinates: coordinates,
            streetAddress:
                '${existingAddress.addressLine}, ${existingAddress.city}',
            governorates: governorates,
            selectedGovernorate: matchedGovernorate.id,
            selectedCity: matchedCity.id,
            citiesState: BaseState<List<CityEntity>>(
              isLoading: false,
              data: citiesInGovernorate,
            ),
            locationState: BaseState<LatLng>(
              data: coordinates,
              isLoading: false,
            ),
          ),
        );
        return;
      }

      var position = await _getCurrentLocationUseCase.call();

      final coordinates = position != null
          ? LatLng(position.latitude, position.longitude)
          : const LatLng(30.047931723716083, 31.238564150922823);

      final place = await _getReverseGeocodedAddressUseCase.call(coordinates);

      if (place == null) {
        emit(
          state.copyWith(
            locationState: const BaseState<LatLng>(
              errorMessage: AppStrings.addressError,
              isLoading: false,
            ),
          ),
        );
        return;
      }

      final fullAddress = '${place.street}, ${place.locality}';

      emit(
        state.copyWith(
          selectedCoordinates: coordinates,
          streetAddress: fullAddress,
          governorates: governorates,
          locationState: BaseState<LatLng>(data: coordinates, isLoading: false),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          locationState: BaseState<LatLng>(
            errorMessage: e.toString(),
            isLoading: false,
          ),
        ),
      );
    }
  }

  Future<void> _selectLocationFromMap(LatLng coordinates) async {
    emit(state.copyWith(selectedCoordinates: coordinates));
    emit(
      state.copyWith(reverseGeocodeState: BaseState<String>(isLoading: true)),
    );
    try {
      final place = await _getReverseGeocodedAddressUseCase.call(coordinates);
      if (place == null) {
        emit(
          state.copyWith(
            reverseGeocodeState: BaseState<String>(
              errorMessage: AppStrings.addressError,
            ),
          ),
        );
        return;
      }

      final fullAddress = '${place.street}, ${place.locality}';
      emit(
        state.copyWith(
          streetAddress: fullAddress,
          reverseGeocodeState: BaseState<String>(
            isLoading: false,
            data: fullAddress,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          reverseGeocodeState: BaseState<String>(
            errorMessage: 'Could not get address details: $e',
          ),
        ),
      );
    }
  }

  Future<void> _selectGovernorate(String governorateId) async {
    emit(
      state.copyWith(
        selectedGovernorate: governorateId,
        selectedCity: null,
        citiesState: const BaseState(isLoading: true),
      ),
    );

    final filtredCity = await _getCitiesUseCase.call(governorateId);
    if (filtredCity.isEmpty) {
      emit(
        state.copyWith(
          citiesState: BaseState<List<CityEntity>>(
            errorMessage: 'No cities found for this governorate',
            isLoading: false,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        citiesState: BaseState<List<CityEntity>>(
          isLoading: false,
          data: filtredCity,
        ),
      ),
    );
  }

  Future<void> _selectCity(String cityId) async {
    emit(state.copyWith(selectedCity: cityId));
  }

  Future<void> _updateExistingAddress({
    required String id,
    required AddAddressParams params,
  }) async {
    emit(
      state.copyWith(
        addAddressState: BaseState<AddressEntity>(isLoading: true),
      ),
    );
    try {
      final selectedGovernorateObj = state.governorates.firstWhere(
        (city) => city.id == state.selectedGovernorate,
        orElse: () => throw Exception('Governorate not found'),
      );
      final selectedAreaObj = state.citiesState.data?.firstWhere(
        (city) => city.id == state.selectedCity,
        orElse: () => throw Exception('City not found'),
      );
      final resolvedParams = AddAddressParams(
        recipientName: params.recipientName,
        recipientPhone: params.recipientPhone,
        addressLine: params.addressLine,
        city: selectedGovernorateObj.nameEn,
        area: selectedAreaObj?.nameEn ?? '',
        lat: state.selectedCoordinates?.latitude ?? 0.0,
        lng: state.selectedCoordinates?.longitude ?? 0.0,
        label: params.label,
      );

      final result = await _updateAddressUseCase.execute(id, resolvedParams);

      final updatedUserAddresses = state.userAddresses
          .map((address) => address.id == id ? result : address)
          .toList();
      final updatedSavedAddresses =
          (state.addressesState.data ?? const <AddressEntity>[])
              .map((address) => address.id == id ? result : address)
              .toList();
      final wasSelected =
          state.selectedAddressId == id || state.selectedAddress?.id == id;

      emit(
        state.copyWith(
          userAddresses: updatedUserAddresses,
          fetchAddressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            data: updatedSavedAddresses,
          ),
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            data: updatedSavedAddresses,
          ),
          selectedAddress: wasSelected ? result : state.selectedAddress,
          selectedAddressId: wasSelected ? result.id : state.selectedAddressId,
          selectedAddressLabel: wasSelected
              ? '${result.addressLine} - ${result.area}'
              : state.selectedAddressLabel,
          addAddressState: BaseState<AddressEntity>(
            isLoading: false,
            data: result,
          ),
        ),
      );
    } catch (e, s) {
      developer.log(
        'Failed to update address',
        error: e,
        stackTrace: s,
        name: 'AddressCubit',
      );

      emit(
        state.copyWith(
          addAddressState: BaseState(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _loadAddresses({bool autoSelect = true}) async {
    final addressesState = state.addressesState;
    emit(
      state.copyWith(
        fetchAddressesState: addressesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
        addressesState: addressesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );
    try {
      final addresses = await _getAddressesUseCase.execute();

      emit(
        state.copyWith(
          userAddresses: addresses,
          fetchAddressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            data: addresses,
          ),
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            data: addresses,
          ),
        ),
      );

      if (autoSelect && state.selectedAddress == null && addresses.isNotEmpty) {
        final defaultAddress = addresses.where((a) => a.isDefault).isEmpty
            ? addresses.first
            : addresses.firstWhere((a) => a.isDefault);
        _selectAddress(defaultAddress);
      }
    } catch (e) {
      emit(
        state.copyWith(
          fetchAddressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: e.toString(),
          ),
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  void _selectAddress(AddressEntity address) {
    emit(
      state.copyWith(
        selectedAddress: address,
        selectedAddressId: address.id,
        selectedAddressLabel: '${address.addressLine} - ${address.area}',
      ),
    );
  }

  void _deselectAddress() {
    emit(
      state.copyWith(
        selectedAddress: null,
        selectedAddressId: null,
        selectedAddressLabel: null,
      ),
    );
  }

  Future<void> _setDefaultAddress(String id) async {
    final addressesState = state.addressesState;
    emit(
      state.copyWith(
        addressesState: addressesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
        fetchAddressesState: addressesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );
    try {
      await _setDefaultAddressUseCase.execute(id);
      await _loadAddresses();
    } catch (e) {
      emit(
        state.copyWith(
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: e.toString(),
          ),
          fetchAddressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _deleteAddress(String id) async {
    final addressesState = state.addressesState;
    emit(
      state.copyWith(
        addressesState: addressesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
        fetchAddressesState: addressesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );
    try {
      final isDeleted = await _deleteAddressUseCase.execute(id);

      if (isDeleted) {
        // FIX: clear the selected address if it was the one just deleted,
        // so a stale address is never sent to checkout.
        final selectedWasDeleted =
            state.selectedAddressId == id || state.selectedAddress?.id == id;
        if (selectedWasDeleted) {
          emit(
            state.copyWith(
              selectedAddress: null,
              selectedAddressId: null,
              selectedAddressLabel: null,
            ),
          );
        }
        await _loadAddresses(autoSelect: false);
      } else {
        emit(
          state.copyWith(
            addressesState: BaseState<List<AddressEntity>>(
              isLoading: false,
              errorMessage: 'Failed to delete address.',
            ),
            fetchAddressesState: BaseState<List<AddressEntity>>(
              isLoading: false,
              errorMessage: 'Failed to delete address.',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          addressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: e.toString(),
          ),
          fetchAddressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  void _setClosestAddress(LatLng currentLocation) {
    if (state.userAddresses.isEmpty) {
      _deselectAddress();
      return;
    }

    AddressEntity? closestAddress;
    double minDistance = double.infinity;

    for (var address in state.userAddresses) {
      if (address.lat == null || address.lng == null) continue;
      final distance =
          Geolocator.distanceBetween(
            currentLocation.latitude,
            currentLocation.longitude,
            address.lat!,
            address.lng!,
          ) /
          1000;

      if (distance < minDistance) {
        minDistance = distance;
        closestAddress = address;
      }
    }

    if (closestAddress != null) {
      _selectAddress(closestAddress);
    } else {
      _deselectAddress();
    }
  }

  void _resetAddAddressState() {
    emit(state.copyWith(addAddressState: const BaseState<AddressEntity>()));
  }
}
