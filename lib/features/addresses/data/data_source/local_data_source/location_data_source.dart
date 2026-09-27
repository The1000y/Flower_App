import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract interface class LocationDataSource {
  Future<Position?> checkAndRequestLocationAccess();
  Future<Placemark?> getReverseGeocodedAddress(LatLng coordinates);
}
