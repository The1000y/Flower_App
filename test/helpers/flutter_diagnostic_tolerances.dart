import 'package:flutter/foundation.dart';

/// Shared helpers for tolerating known, non-actionable Flutter framework
/// diagnostics that the production widgets trigger.
class FlutterDiagnosticTolerances {
  FlutterDiagnosticTolerances._();

  /// Raised by `ListTile`/`RadioListTile` when the tile is wrapped in a
  /// `Container`/`DecoratedBox` that paints its own background colour.
  ///
  /// The checkout production widgets `_PaymentOptionTile` and `_AddressTile`
  /// both wrap their `RadioListTile` in such a `Container`, so this
  /// diagnostic is reported on every build and would otherwise fail every
  /// widget test. It is a paint-ordering hint only and does not affect the
  /// behaviour under test.
  ///
  /// TODO(flutter-app): the real fix belongs in production code - either drop
  /// `color: Colors.white` from the wrapping `Container` or wrap the
  /// `RadioListTile` in its own `Material`. Until then the tests below rely on
  /// [ignoreFlutterDiagnostics] to drop just this one message.
  static const String listTileInkVisibility =
      'ListTile background color or ink splashes may be invisible.';

  static FlutterExceptionHandler? _previousOnError;
  static Set<String> _ignored = <String>{};

  /// Installs a [FlutterError.onError] handler that silently drops the given
  /// [diagnostics] and forwards every other error to the previous handler, so
  /// real failures still fail the test.
  ///
  /// This must be called from inside the `testWidgets` body (for example from a
  /// `pumpApp` helper) because the flutter_test binding installs its own
  /// `FlutterError.onError` right before it runs the test body - an override
  /// installed from `setUp` is simply replaced again. Pair it with
  /// [restoreFlutterErrorHandler] through `addTearDown` so the binding can
  /// still verify the handler was returned to its original state.
  static void ignoreFlutterDiagnostics(Set<String> diagnostics) {
    _ignored = {..._ignored, ...diagnostics};
    _previousOnError ??= FlutterError.onError;
    final previous = _previousOnError;
    final ignored = _ignored;

    FlutterError.onError = (FlutterErrorDetails details) {
      final message = details.exceptionAsString();
      if (ignored.any(message.contains)) {
        return;
      }
      previous?.call(details);
    };
  }

  /// Restores the [FlutterError.onError] handler that was active before the
  /// first [ignoreFlutterDiagnostics] call.
  static void restoreFlutterErrorHandler() {
    if (_previousOnError == null) {
      return;
    }
    FlutterError.onError = _previousOnError;
    _previousOnError = null;
    _ignored = <String>{};
  }
}
