import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/addresses/presentation/manager/josn_helper/json_helper.dart';
import 'package:flower_app/features/addresses/presentation/manager/location_helper/location_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddressCubit extends Cubit<AddressState> {
  final AddAddressUseCase _addAddressUseCase;

  AddressCubit(this._addAddressUseCase) : super(AddressState());

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
        _submitAddress(addAddressRequest: event.addAddressRequest);
        break;
    }
  }

  void _submitAddress({required AddAddressRequest addAddressRequest}) async {
    emit(
      state.copyWith(
        addAddressState: BaseState<AddressEntity>(isLoading: true),
      ),
    );
    BaseResponce<AddressEntity> result = await _addAddressUseCase.call(
      addAddressRequest,
    );
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
  }

  Future<void> _initializeAddress() async {
    emit(state.copyWith(locationState: BaseState<LatLng>(isLoading: true)));

    var position = await LocationHelper.checkAndRequestLocationAccess();

    try {
      final coordinates = position != null
          ? LatLng(position.latitude, position.longitude)
          : LatLng(30.047931723716083, 31.238564150922823);

      final governorates = await JsonHelper.getCity();
      final allCities = await JsonHelper.getArea();
      final place = await LocationHelper.getReverseGeocodedAddress(coordinates);

      if (place == null) {
        emit(
          state.copyWith(
            locationState: BaseState<LatLng>(
              errorMessage: 'Could not get address details',
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
          cities: allCities,
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
      final place = await LocationHelper.getReverseGeocodedAddress(coordinates);
      if (place == null) {
        emit(
          state.copyWith(
            reverseGeocodeState: BaseState<String>(
              errorMessage: 'Could not get address details',
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
    emit(state.copyWith(selectedGovernorate: governorateId, cities: null));
    try {
      final filtredCity = state.cities
          .where((city) => city.governorateId == governorateId)
          .toList();
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
