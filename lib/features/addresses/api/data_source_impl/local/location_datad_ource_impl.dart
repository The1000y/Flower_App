import 'package:flower_app/features/addresses/data/data_source/local_data_source/location_data_source.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:injectable/injectable.dart';

@Injectable(as: LocationDataSource)
class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<Position?> checkAndRequestLocationAccess() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      enabled = await Geolocator.openLocationSettings();
    }

    if (!enabled) return null;

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition();
  }

  @override
  Future<Placemark?> getReverseGeocodedAddress(LatLng coordinates) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks[0];
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }
}
