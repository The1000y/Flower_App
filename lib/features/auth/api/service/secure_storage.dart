import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppStrings.accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: AppStrings.accessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppStrings.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: AppStrings.refreshToken);
  }

  Future<void> saveRememberedEmail(String email) async {
    await _storage.write(key: AppStrings.rememberedEmail, value: email);
  }

  Future<String?> getRememberedEmail() async {
    return _storage.read(key: AppStrings.rememberedEmail);
  }

  Future<void> deleteRememberedEmail() async {
    await _storage.delete(key: AppStrings.rememberedEmail);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
