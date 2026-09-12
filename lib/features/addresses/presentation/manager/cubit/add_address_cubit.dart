import 'package:collection/collection.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/addresses/api/data_source_impl/local/address_dummy_data.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:flower_app/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_cities_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_current_location_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_governomets_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_reverse_geocoded_address_use_case.dart';
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

  AddressCubit(
    this._addAddressUseCase,
    this._getCitiesUseCase,
    this._getReverseGeocodedAddressUseCase,
    this._getCurrentLocationUseCase,
    this._getGovernoratesUseCase,
  ) : super(AddressState());

  void doEvent(AddressEvents event) {
    switch (event) {
      case InitializeAddressEvent():
        _initializeAddress();
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
      case FetchUserAddressesEvent():
        _fetchUserAddresses();
        break;
      case SelectAddressEvent():
        _selectAddress(event.selectedAddress);
        break;
      case SetClosestAddressEvent():
        _setClosestAddress(event.currentLocation);
        break;
    }
  }

  void _submitAddress({required AddAddressParams addaddressParams}) async {
    emit(
      state.copyWith(
        addAddressState: BaseState<AddressEntity>(isLoading: true),
      ),
    );
    try {
      final selectedGovernorateObj = state.governorates.firstWhereOrNull(
        (g) => g.id == state.selectedGovernorate,
      );

      final selectedAreaObj = state.citiesState.data?.firstWhereOrNull(
        (c) => c.id == state.selectedCity,
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
          emit(
            state.copyWith(
              userAddresses: updatedAddresses, // ✅ أضيف للـ list
              selectedAddress: result.data,
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
      print(e);
      print(s);

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

  Future<void> _initializeAddress() async {
    emit(state.copyWith(locationState: BaseState<LatLng>(isLoading: true)));

    var position = await _getCurrentLocationUseCase.call();

    try {
      final coordinates = position != null
          ? LatLng(position.latitude, position.longitude)
          : LatLng(30.047931723716083, 31.238564150922823);

      final governorates = await _getGovernoratesUseCase.call();

      final place = await _getReverseGeocodedAddressUseCase.call(coordinates);

      if (place == null) {
        emit(
          state.copyWith(
            locationState: BaseState<LatLng>(
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
          // cities: allCities,
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

      String fullAddress = '${place.street}, ${place.locality}';
      emit(
        state.copyWith(
          streetAddress: fullAddress,
          // selectedGovernorate: place.administrativeArea,
          // selectedCity: place.locality,
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
    // emit(state.copyWith(selectedGovernorate: governorateId, cities: []));
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

  Future<void> _fetchUserAddresses() async {
    emit(state.copyWith(fetchAddressesState: const BaseState(isLoading: true)));
    try {
      final addressDummmydata = AddressEntity(
        id: AddressDummyData.addressDummyData["id"],
        recipientName: AddressDummyData.addressDummyData["recipientName"],
        recipientPhone: AddressDummyData.addressDummyData["recipientPhone"],
        addressLine: AddressDummyData.addressDummyData["addressLine"],
        city: AddressDummyData.addressDummyData["city"],
        area: AddressDummyData.addressDummyData["area"],
        isDefault: AddressDummyData.addressDummyData["isDefault"],
        isServiceable: AddressDummyData.addressDummyData["isServiceable"],
        createdAt: AddressDummyData.addressDummyData["createdAt"],
      );
      emit(
        state.copyWith(
          fetchAddressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            data: [addressDummmydata],
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          fetchAddressesState: BaseState<List<AddressEntity>>(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  void _selectAddress(AddressEntity selectedAddress) {
    emit(state.copyWith(selectedAddress: selectedAddress));
  }

  void _setClosestAddress(LatLng currentLocation) {
    if (state.userAddresses.isEmpty) {
      emit(state.copyWith(selectedAddress: null));
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
      emit(state.copyWith(selectedAddress: closestAddress));
    } else {
      emit(state.copyWith(selectedAddress: null));
    }
  }
}
