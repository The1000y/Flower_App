import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/data_source_impl/local/local_data_source_impl.dart';
import 'package:flower_app/features/auth/api/data_source_impl/remote/remote_data_source_impl.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/domain/use_case/delete_remembered_email_use_case.dart';
import 'package:flower_app/features/auth/domain/use_case/load_remembered_email_use_case.dart';
import 'package:flower_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:flower_app/features/auth/domain/use_case/register_auth_use_case.dart';
import 'package:flower_app/features/auth/domain/use_case/save_remembered_email_use_case.dart';
import 'package:flower_app/features/auth/presentation/login/manager/login_view_model.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';

const String validEmail = 'bassiony555@gmail.com';
const String validPassword = '12345678';
const String validRegisterPassword = 'P@ssw0rd';

final RegisterRequestEntity validRegisterEntity = RegisterRequestEntity(
  fullName: 'John Doe',
  email: validEmail,
  phoneNumber: '01012345678',
  gender: 1,
  password: validRegisterPassword,
  confirmPassword: validRegisterPassword,
);

class FakeAuthRepo implements AuthRepo {
  FakeAuthRepo({this.shouldSucceed = true, this.failDelay = Duration.zero});

  final bool shouldSucceed;
  final Duration failDelay;

  LoginCredentials? lastLoginRequest;
  RegisterRequestEntity? lastRegisterRequest;
  bool? lastRememberMe;

  @override
  Future<BaseResponce<LoginEntity>> login(
    LoginCredentials credentials, {
    bool rememberMe = false,
  }) async {
    lastLoginRequest = credentials;
    lastRememberMe = rememberMe;

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
  Future<BaseResponce<RegisterEntity>> register(
    RegisterRequestEntity request,
  ) async {
    lastRegisterRequest = request;

    if (shouldSucceed) {
      return SuccessResponce(
        RegisterEntity(
          isSuccess: true,
          errorCode: 200,
          message: 'Registration successful',
          data: true,
        ),
      );
    }

    return ErrorResponce<RegisterEntity>(Exception(AppStrings.registerError));
  }

  @override
  Future<String?> getRememberedEmail() {
    return _storage.getRememberedEmail();
  }

  @override
  Future<void> saveRememberedEmail(String email) {
    return _storage.saveRememberedEmail(email);
  }

  @override
  Future<void> deleteRememberedEmail() {
    return _storage.deleteRememberedEmail();
  }

  @override
  Future<BaseResponce<ForgetPasswordEntity>> forgetPassword({
    required String email,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponce<ResetPassswordEntity>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponce<VerifyOtpEntity>> verifyOtp({
    required String email,
    required String otp,
  }) {
    throw UnimplementedError();
  }
}

final SecureStorageService _storage = SecureStorageService(
  const FlutterSecureStorage(),
);

AuthRepoImpl buildPasswordRecoveryRepo(LocalDataSource localDataSource) {
  return AuthRepoImpl(
    localDataSource,
    RemoteDataSourceImpl(),
    SecureStorageService(const FlutterSecureStorage()),
  );
}

AuthRepoImpl buildLoginRepo(
  RemoteDataSource remoteDataSource,
  SecureStorageService secureStorage,
) {
  return AuthRepoImpl(LocalDataSourceImpl(), remoteDataSource, secureStorage);
}

LoginViewModel buildLoginViewModel(FakeAuthRepo repo) {
  return LoginViewModel(
    LoginUseCase(repo),
    LoadRememberedEmailUseCase(repo),
    SaveRememberedEmailUseCase(repo),
    DeleteRememberedEmailUseCase(repo),
  );
}

RegisterViewModel buildRegisterViewModel(FakeAuthRepo repo) {
  return RegisterViewModel(RegisterAuthUseCase(repo));
}

void useInMemorySecureStorage([Map<String, String>? initialData]) {
  FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform(
    initialData ?? {},
  );
}

Future<String?> readStorageValue(String key) async {
  final storage = const FlutterSecureStorage();

  return storage.read(key: key);
}
