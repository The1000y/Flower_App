import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/domain/use_case/delete_remembered_email_use_case.dart';
import 'package:flower_app/features/auth/domain/use_case/load_remembered_email_use_case.dart';
import 'package:flower_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:flower_app/features/auth/domain/use_case/save_remembered_email_use_case.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';

const String validEmail = 'bassiony555@gmail.com';
const String validPassword = '12345678';

class FakeAuthRepo implements AuthRepo {
  FakeAuthRepo({this.shouldSucceed = true, this.failDelay = Duration.zero});

  final bool shouldSucceed;
  final Duration failDelay;

  LoginCredentials? lastRequest;

  @override
  Future<BaseResponce<LoginEntity>> login(LoginCredentials credentials) async {
    lastRequest = credentials;
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

  @override
  Future<String?> getRememberedEmail() => _storage.getRememberedEmail();

  @override
  Future<void> saveRememberedEmail(String email) =>
      _storage.saveRememberedEmail(email);

  @override
  Future<void> deleteRememberedEmail() => _storage.deleteRememberedEmail();
}

final SecureStorageService _storage =
    SecureStorageService(const FlutterSecureStorage());

LoginViewModel buildLoginViewModel(FakeAuthRepo repo) {
  return LoginViewModel(
    LoginUseCase(repo),
    LoadRememberedEmailUseCase(repo),
    SaveRememberedEmailUseCase(repo),
    DeleteRememberedEmailUseCase(repo),
  );
}

void useInMemorySecureStorage([Map<String, String>? initialData]) {
  FlutterSecureStoragePlatform.instance =
      TestFlutterSecureStoragePlatform(initialData ?? {});
}

Future<String?> readStorageValue(String key) async {
  final storage = const FlutterSecureStorage();
  return storage.read(key: key);
}