import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  static Future<Position?> checkAndRequestLocationAccess() async {
    var serviceLocationEnabled = await checkAndRequestLocationServices();
    if (serviceLocationEnabled != true) {
      return null;
    }
    return await checkAndRequestLocationPermission();
  }

  static Future<bool> checkAndRequestLocationServices() async {
    bool serviceLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceLocationEnabled) {
      serviceLocationEnabled = await Geolocator.openLocationSettings();
    }
    return serviceLocationEnabled;
  }

  static Future<Position?> checkAndRequestLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<Placemark?> getReverseGeocodedAddress(
    LatLng coordinates,
  ) async {
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
