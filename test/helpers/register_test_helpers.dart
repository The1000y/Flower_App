import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:flower_app/features/auth/domain/use_case/register_auth_use_case.dart';
import 'package:flower_app/features/auth/presentation/register/manager/register_view_model.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';

const String validEmail = 'bassiony555@gmail.com';
const String validPassword = 'P@ssw0rd';

final RegisterRequestEntity validRegisterEntity = RegisterRequestEntity(
  fullName: 'John Doe',
  email: validEmail,
  phoneNumber: '01012345678',
  gender: 1,
  password: validPassword,
  confirmPassword: validPassword,
);

class FakeAuthRepo implements AuthRepo {
  FakeAuthRepo({this.shouldSucceed = true});

  final bool shouldSucceed;

  RegisterRequestEntity? lastRequest;

  @override
  Future<BaseResponce<RegisterEntity>> register(
    RegisterRequestEntity request,
  ) async {
    lastRequest = request;
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
}

RegisterViewModel buildRegisterViewModel(FakeAuthRepo repo) {
  return RegisterViewModel(RegisterAuthUseCase(repo));
}

void useInMemorySecureStorage([Map<String, String>? initialData]) {
  FlutterSecureStoragePlatform.instance =
      TestFlutterSecureStoragePlatform(initialData ?? {});
}