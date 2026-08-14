import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/storage_keys.dart';
import '../../../domain/entities/register_entity/register_params.dart';
import '../../../data/data_source/local_data_source/auth_local_data_source.dart';


@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  AuthLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: StorageKeys.kUserToken, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: StorageKeys.kUserToken);
  }

  @override
  Future<void> saveUser(RegisterParams user) async {
    final userMap = {
      'fullName': user.fullName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'gender': user.gender,
    };
    await _secureStorage.write(
      key: StorageKeys.kUserData,
      value: jsonEncode(userMap),
    );
  }

  @override
  Future<void> clearCache() async {
    await _secureStorage.deleteAll();
  }
}
