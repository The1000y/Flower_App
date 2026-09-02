import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressState extends Equatable {
  // الموقع الحالي (من الجهاز)
  final Position? currentLocation;

  // الإحداثيات المختارة من الخريطة
  final LatLng? selectedCoordinates;

  // العنوان الكامل (Street + Locality)
  final String streetAddress;

  // قائمة المحافظات (entities)
  final List<GovernorateEntity> governorates;

  // قائمة كل المناطق (entities)
  final List<CityEntity> cities;

  // المحافظة المختارة (ID)
  final String? selectedGovernorate;

  // المنطقة المختارة (ID)
  final String? selectedCity;

  // State للموقع الأولي (loading, error, success)
  final BaseState<LatLng> locationState;

  // State لـ reverse geocoding عند تحريك الخريطة
  final BaseState<String> reverseGeocodeState;

  // State لتحديث قائمة المدن بعد اختيار محافظة
  final BaseState<List<CityEntity>> citiesState;

  // State لحفظ العنوان
  final BaseState<AddressEntity> addAddressState;

  const AddressState({
    this.currentLocation,
    this.selectedCoordinates,
    this.streetAddress = '',
    this.governorates = const [],
    this.cities = const [],
    this.selectedGovernorate,
    this.selectedCity,
    this.locationState = const BaseState(),
    this.reverseGeocodeState = const BaseState(),
    this.citiesState = const BaseState(),
    this.addAddressState = const BaseState(),
  });

  AddressState copyWith({
    Position? currentLocation,
    LatLng? selectedCoordinates,
    String? streetAddress,
    List<GovernorateEntity>? governorates,
    List<CityEntity>? cities,
    String? selectedGovernorate,
    String? selectedCity,
    BaseState<LatLng>? locationState,
    BaseState<String>? reverseGeocodeState,
    BaseState<List<CityEntity>>? citiesState,
    BaseState<AddressEntity>? addAddressState,
  }) {
    return AddressState(
      currentLocation: currentLocation ?? this.currentLocation,
      selectedCoordinates: selectedCoordinates ?? this.selectedCoordinates,
      streetAddress: streetAddress ?? this.streetAddress,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedCity: selectedCity ?? this.selectedCity,
      locationState: locationState ?? this.locationState,
      reverseGeocodeState: reverseGeocodeState ?? this.reverseGeocodeState,
      citiesState: citiesState ?? this.citiesState,
      addAddressState: addAddressState ?? this.addAddressState,
    );
  }

  @override
  List<Object?> get props => [
    currentLocation,
    selectedCoordinates,
    streetAddress,
    governorates,
    cities,
    selectedGovernorate,
    selectedCity,
    locationState,
    reverseGeocodeState,
    citiesState,
    addAddressState,
  ];
}
