import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';

const String validEmail = 'bassiony555@gmail.com';
const String validPassword = '12345678';

class FakeAuthRepo implements AuthRepo {
  FakeAuthRepo({this.shouldSucceed = true, this.failDelay = Duration.zero});

  final bool shouldSucceed;
  final Duration failDelay;

  RequestLogin? lastRequest;

  @override
  Future<BaseResponce<LoginEntity>> login(RequestLogin req) async {
    lastRequest = req;
    if (failDelay > Duration.zero) {
      await Future<void>.delayed(failDelay);
    }
    if (shouldSucceed) {
      return SuccessResponce(
        const LoginEntity(
          accessToken: 'access_token_test',
          refreshToken: 'refresh_token_test',
          expiresIn: 900,
          driverStatus: 'Approved',
        ),
      );
    }
    return ErrorResponce(Exception(AppStrings.invalidCredentials));
  }
}

void useInMemorySecureStorage([Map<String, String>? initialData]) {
  FlutterSecureStoragePlatform.instance =
      TestFlutterSecureStoragePlatform(initialData ?? {});
}

Future<String?> readStorageValue(String key) async {
  final storage = const FlutterSecureStorage();
  return storage.read(key: key);
}