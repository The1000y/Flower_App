import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

/// Label of the button created by [openScreenHome].
const openButtonLabel = 'open screen';

/// Text shown by the stub screen for any named route the widgets push.
///
/// The real destination screens (map, track order...) are NOT built in widget
/// tests; a named route just renders `route:<name>` so we can assert that the
/// navigation happened without dragging in the destination's dependencies.
String routeStubText(String routeName) => 'route:$routeName';

/// Minimal app shell for the order tracking tests: ScreenUtil (needed by
/// `CustomButton`) + MaterialApp + stub named routes.
Widget buildOrderTrackingTestApp(Widget home) {
  return ScreenUtilPlusInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    child: MaterialApp(
      home: home,
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => Scaffold(
          body: Center(child: Text(routeStubText(settings.name ?? ''))),
        ),
      ),
    ),
  );
}

/// Pumps [child] inside [buildOrderTrackingTestApp].
///
/// The surface is fixed (default 800x1400 logical pixels, pixel ratio 1):
/// flutter_test renders text with the "Ahem" font where every glyph is a
/// square as wide as the font size, so text rows come out much wider than on a
/// real device. A wide surface keeps those rows from overflowing for reasons
/// that have nothing to do with the real UI.
///
/// Uses a single `pump()` after `pumpWidget` (like the existing
/// `register_view_test`) - never `pumpAndSettle` - so screens with endless
/// animations (the driving car) can be pumped too.
Future<void> pumpOrderTrackingApp(
  WidgetTester tester,
  Widget child, {
  bool inScaffold = true,
  Size surfaceSize = const Size(800, 1400),
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    buildOrderTrackingTestApp(inScaffold ? Scaffold(body: child) : child),
  );
  await tester.pump();
}

/// A home screen with one button that pushes [screen]. Lets a test open a
/// screen "from somewhere" so the back button has a route to pop to.
Widget openScreenHome(Widget screen) {
  return Builder(
    builder: (context) => Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => screen),
          ),
          child: const Text(openButtonLabel),
        ),
      ),
    ),
  );
}
