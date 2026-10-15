import 'dart:math' as math;

import 'package:flower_app/core/constants/app_svgs/app_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/themes/app_colors/app_color.dart';
import 'map_marker_helpers.dart';

class OrderRouteMap extends StatefulWidget {
  const OrderRouteMap({
    super.key,
    required this.route,
    required this.origin,
    required this.originLabel,
    required this.destination,
    required this.destinationLabel,
    this.courier,
  });

  final List<LatLng> route;
  final LatLng origin;
  final String originLabel;
  final LatLng destination;
  final String destinationLabel;
  final LatLng? courier;

  @override
  State<OrderRouteMap> createState() => _OrderRouteMapState();
}

class _OrderRouteMapState extends State<OrderRouteMap> {
  static const _stylePath = 'assets/jsons/style_map.json';

  GoogleMapController? _controller;

  bool _resourcesStarted = false;
  bool _ready = false;
  String? _mapStyle;
  BitmapDescriptor? _originIcon;
  BitmapDescriptor? _destinationIcon;
  BitmapDescriptor? _courierIcon;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resourcesStarted) return;
    _resourcesStarted = true;
    _loadResources(MediaQuery.devicePixelRatioOf(context));
  }

  Future<void> _loadResources(double dpr) async {
    String? style;
    try {
      style = await rootBundle.loadString(_stylePath);
    } catch (_) {
      style = null;
    }

    final icons = await Future.wait([
      buildPinBitmap(
        label: widget.originLabel,
        icon: Icons.home_outlined,
        dpr: dpr,
      ),
      buildPinBitmap(
        label: widget.destinationLabel,
        icon: Icons.local_florist_outlined,
        dpr: dpr,
      ),
      svgToBitmap(AppSvgs.motorcycle, width: 52, dpr: dpr),
    ]);

    if (!mounted) return;
    setState(() {
      _mapStyle = style;
      _originIcon = icons[0];
      _destinationIcon = icons[1];
      _courierIcon = icons[2];
      _ready = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  LatLngBounds _routeBounds() {
    var minLat = widget.route.first.latitude;
    var maxLat = minLat;
    var minLng = widget.route.first.longitude;
    var maxLng = minLng;

    for (final p in widget.route) {
      minLat = math.min(minLat, p.latitude);
      maxLat = math.max(maxLat, p.latitude);
      minLng = math.min(minLng, p.longitude);
      maxLng = math.max(maxLng, p.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  LatLng _routeCenter() {
    final b = _routeBounds();
    return LatLng(
      (b.southwest.latitude + b.northeast.latitude) / 2,
      (b.southwest.longitude + b.northeast.longitude) / 2,
    );
  }

  Future<void> _fitRoute() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      await controller.moveCamera(
        CameraUpdate.newLatLngBounds(_routeBounds(), 64),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const ColoredBox(color: AppColors.lightPink);

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('origin'),
        position: widget.origin,
        icon: _originIcon!,
        anchor: const Offset(0.5, 1.0),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: widget.destination,
        icon: _destinationIcon!,
        anchor: const Offset(0.5, 1.0),
      ),
      if (widget.courier != null)
        Marker(
          markerId: const MarkerId('courier'),
          position: widget.courier!,
          icon: _courierIcon!,
          anchor: const Offset(0.5, 0.5),
        ),
    };

    final polylines = <Polyline>{
      Polyline(
        polylineId: const PolylineId('route'),
        points: widget.route,
        color: AppColors.pinkBase,
        width: 3,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };

    return GoogleMap(
      style: _mapStyle,
      initialCameraPosition: CameraPosition(target: _routeCenter(), zoom: 14),
      markers: markers,
      polylines: polylines,
      padding: const EdgeInsets.only(top: 40),
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      myLocationButtonEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      onMapCreated: (controller) {
        _controller = controller;
        WidgetsBinding.instance.addPostFrameCallback((_) => _fitRoute());
      },
    );
  }
}