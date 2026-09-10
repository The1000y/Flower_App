import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:flower_app/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_cities_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_current_location_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_governomets_use_case.dart';
import 'package:flower_app/features/addresses/domain/usecases/get_reverse_geocoded_address_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'address_events.dart';
import 'address_state.dart';

@injectable
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
    }
  }

  void _submitAddress({required AddAddressParams addaddressParams}) async {
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
      final addAddressParams = AddAddressParams(
        recipientName: addaddressParams.recipientName,
        recipientPhone: addaddressParams.recipientPhone,
        addressLine: addaddressParams.addressLine,
        city: selectedGovernorateObj.nameEn,
        area: selectedAreaObj?.nameEn ?? '',
        lat: state.selectedCoordinates?.latitude ?? 0.0,
        lng: state.selectedCoordinates?.longitude ?? 0.0,
        label: addaddressParams.label,
      );
      final result = await _addAddressUseCase.call(addAddressParams);

      switch (result) {
        case SuccessResponce<AddressEntity>():
          emit(
            state.copyWith(
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

  // 🎯 2. Add the parameter to the function signature
  Future<void> _initializeAddress({AddressEntity? existingAddress}) async {
    emit(
      state.copyWith(locationState: const BaseState<LatLng>(isLoading: true)),
    );

    try {
      // Fetch the governorates using his clean UseCase
      final governorates = await _getGovernoratesUseCase.call();

      // 🎯 3. RESTORED EDIT LOGIC: Check if we are editing an existing address
      if (existingAddress != null) {
        final coordinates =
            (existingAddress.lat != null && existingAddress.lng != null)
            ? LatLng(existingAddress.lat!, existingAddress.lng!)
            : const LatLng(30.047931723716083, 31.238564150922823);

        final matchedGovernorate = governorates.firstWhere(
          (g) => g.nameEn.toLowerCase() == existingAddress.city.toLowerCase(),
          orElse: () => governorates.first,
        );

        // Fetch cities using his UseCase based on the matched governorate
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
        return; // Exit early since we are in edit mode
      }

      // 🎯 4. KEEP HIS EXACT CODE for handling a brand new address
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
    try {
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
    } catch (e) {
      emit(
        state.copyWith(
          citiesState: BaseState<List<CityEntity>>(
            errorMessage: e.toString(),
            isLoading: false,
          ),
        ),
      );
    }
  }

  Future<void> _selectCity(String cityId) async {
    emit(state.copyWith(selectedCity: cityId));
  }
}
