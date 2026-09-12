import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> setStyleMap(Completer<GoogleMapController> controllerMap) async {
  String style = await rootBundle.loadString('assets/jsons/style_map.json');
  controllerMap.future.then((controller) => controller.setMapStyle(style));
}

Future<BitmapDescriptor> loadIcon() async {
  return await BitmapDescriptor.asset(
    ImageConfiguration(size: Size(33, 38)),
    'assets/Vector.png',
  );
}









