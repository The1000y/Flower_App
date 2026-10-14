import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/themes/app_colors/app_color.dart';

Future<BitmapDescriptor> buildPinBitmap({
  required String label,
  required IconData icon,
  required double dpr,
}) async {
  const chipHeight = 24.0;
  const hPad = 8.0;
  const gap = 4.0;
  const chipIconSize = 14.0;
  const pinSize = 32.0;
  const pinBottomInset = 2.5;

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

Future<BitmapDescriptor> svgToBitmap(
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