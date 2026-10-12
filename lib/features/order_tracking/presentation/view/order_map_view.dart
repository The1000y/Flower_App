import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/constants/app_svgs/app_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../core/themes/app_colors/app_color.dart';
import '../widgets/custom_delivery_boy_information_card.dart';
import '../widgets/custom_estimated_arrival_section.dart';

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class OrderMapView extends StatelessWidget {
  const OrderMapView({super.key});

  // ---- DUMMY DATA (UI only). Replace with real data / routing API later. ----
  static const _apartment = LatLng(30.0430, 31.2330);
  static const _flowery = LatLng(30.0485, 31.2410);
  static const _courier = LatLng(30.0452, 31.2392);
  static const _route = <LatLng>[
    _apartment,
    LatLng(30.0430, 31.2375),
    LatLng(30.0452, 31.2375),
    LatLng(30.0452, 31.2410),
    _flowery,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Map takes all remaining height above the info panel
          Expanded(
            child: Stack(
              children: [
                const OrderRouteMap(
                  route: _route,
                  origin: _apartment,
                  originLabel: 'Apartment',
                  destination: _flowery,
                  destinationLabel: 'Flowery',
                  courier: _courier,
                ),

                // Floating back button (respects the status bar)
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 8,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.pinkBase,
                    ),
                    padding: const EdgeInsets.only(left: 8), // centers the iOS-style arrow
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.whiteBase,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const _OrderInfoPanel(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom panel (fixed): arrival time, delivery boy, button
// ---------------------------------------------------------------------------

class _OrderInfoPanel extends StatelessWidget {
  const _OrderInfoPanel();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomEstimatedArrivalSection(
                estimatedArrivalDateTime: DateTime(2024, 9, 3, 11),
              ),
              const Gap(16),
              CustomDeliveryBoyInformationCard(
                deliveryBoyName: 'Muhamed',
                deliveryBoyPhoneNumber: '01014194042',
                deliveryBoyImageURL:
                'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=500',
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: AppStrings.orderDetails,
                  onPressed: () {},
                  isEnabled: true,
                  enabledColor: AppColors.pinkBase,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable map (google_maps_flutter). Needs only plain data, so it works with
// dummy OR real routes later.
// ---------------------------------------------------------------------------

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

  /// Current courier position; null hides the scooter.
  final LatLng? courier;

  @override
  State<OrderRouteMap> createState() => _OrderRouteMapState();
}

class _OrderRouteMapState extends State<OrderRouteMap> {
  // Same style file the addresses map already uses.
  static const _stylePath = 'assets/jsons/style_map.json';

  GoogleMapController? _controller;

  // Loaded once (needs devicePixelRatio, so it starts in didChangeDependencies)
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
      style = null; // falls back to the default Google style
    }

    final icons = await Future.wait([
      _buildPinBitmap(
        label: widget.originLabel,
        icon: Icons.home_outlined,
        dpr: dpr,
      ),
      _buildPinBitmap(
        label: widget.destinationLabel,
        icon: Icons.local_florist_outlined,
        dpr: dpr,
      ),
      _svgToBitmap(AppSvgs.motorcycle, width: 52, dpr: dpr),
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

  // ---- camera ----------------------------------------------------------

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
    } catch (_) {
      // If the map has no size yet, the initial camera (route center) is kept.
    }
  }

  // ---- build -----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Tiny placeholder while the marker bitmaps + style load (a few ms).
    if (!_ready) return const ColoredBox(color: AppColors.lightPink);

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('origin'),
        position: widget.origin,
        icon: _originIcon!,
        anchor: const Offset(0.5, 1.0), // pin tip sits on the coordinate
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
      // leaves room under the status bar / back button
      padding: const EdgeInsets.only(top: 40),
      // clean look like the design
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

// ---------------------------------------------------------------------------
// Marker bitmaps (Google markers are images, not widgets, so we draw them)
// ---------------------------------------------------------------------------

/// Draws: [icon + label] pink chip on top, pink location pin underneath.
Future<BitmapDescriptor> _buildPinBitmap({
  required String label,
  required IconData icon,
  required double dpr,
}) async {
  const chipHeight = 24.0;
  const hPad = 8.0;
  const gap = 4.0;
  const chipIconSize = 14.0;
  const pinSize = 32.0;
  const pinBottomInset = 2.5; // empty space under the glyph's tip

  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: const TextStyle(
        color: AppColors.whiteBase,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  final chipWidth = hPad + chipIconSize + gap + textPainter.width + hPad;
  final width = math.max(chipWidth, pinSize);
  final height = chipHeight + pinSize - pinBottomInset;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(dpr);

  // chip
  final chipLeft = (width - chipWidth) / 2;
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(chipLeft, 0, chipWidth, chipHeight),
      const Radius.circular(chipHeight / 2),
    ),
    Paint()..color = AppColors.pinkBase,
  );
  _paintIcon(
    canvas,
    icon,
    size: chipIconSize,
    color: AppColors.whiteBase,
    offset: Offset(chipLeft + hPad, (chipHeight - chipIconSize) / 2),
  );
  textPainter.paint(
    canvas,
    Offset(
      chipLeft + hPad + chipIconSize + gap,
      (chipHeight - textPainter.height) / 2,
    ),
  );

  // pin
  _paintIcon(
    canvas,
    Icons.location_on,
    size: pinSize,
    color: AppColors.pinkBase,
    offset: Offset((width - pinSize) / 2, chipHeight),
  );

  final image = await recorder.endRecording().toImage(
    (width * dpr).ceil(),
    (height * dpr).ceil(),
  );
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(
    data!.buffer.asUint8List(),
    width: width,
    height: height,
  );
}

/// Paints a Material icon glyph on a canvas.
void _paintIcon(
    Canvas canvas,
    IconData icon, {
      required double size,
      required Color color,
      required Offset offset,
    }) {
  final painter = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size,
        height: 1,
        color: color,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}

/// Rasterizes an SVG asset (the delivery scooter) into a marker bitmap.
Future<BitmapDescriptor> _svgToBitmap(
    String assetName, {
      required double width,
      required double dpr,
    }) async {
  final info = await vg.loadPicture(SvgAssetLoader(assetName), null);

  final scale = (width * dpr) / info.size.width;
  final pxWidth = (info.size.width * scale).ceil();
  final pxHeight = (info.size.height * scale).ceil();

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(scale);
  canvas.drawPicture(info.picture);

  final image = await recorder.endRecording().toImage(pxWidth, pxHeight);
  info.picture.dispose();

  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.bytes(
    data!.buffer.asUint8List(),
    width: width,
    height: width * info.size.height / info.size.width,
  );
}