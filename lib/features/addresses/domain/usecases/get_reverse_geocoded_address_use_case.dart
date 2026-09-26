import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetReverseGeocodedAddressUseCase {
  AddressRepo addressRepo;

  GetReverseGeocodedAddressUseCase({required this.addressRepo});

  Future<Placemark?> call(LatLng latLng) async {
    return await addressRepo.getReverseGeocodedAddress(latLng);
  }
}
