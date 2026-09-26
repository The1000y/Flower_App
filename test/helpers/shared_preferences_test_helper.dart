import 'package:shared_preferences/shared_preferences.dart';

/// Builds a [SharedPreferences] instance backed by the in-memory test store.
///
/// [SharedPreferences.getInstance] resolves through the platform-channel mock,
/// so no binding initialisation or plugin registration is required.
Future<SharedPreferences> createTestSharedPreferences([
  Map<String, Object> initialValues = const <String, Object>{},
]) async {
  SharedPreferences.setMockInitialValues(initialValues);
  return SharedPreferences.getInstance();
}
