import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/reset_password_request_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/forgot_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/reset_password_response_dto.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/entities/login_credentials.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  AuthRepoImpl(this._localDataSource, this._remoteDataSource, this._secureStorage);

  @override
  Future<BaseResponce<ForgetPasswordEntity>> forgetPassword({required String email}) async {
    final response = await _localDataSource.forgotPassword(ForgotPasswordRequestDto(email: email));
    return switch (response) {
      SuccessResponce<ForgotPasswordResponseDto>() => SuccessResponce(response.data.toDomain()),
      ErrorResponce<ForgotPasswordResponseDto>() => ErrorResponce(response.error),
    };
  }

  @override
  Future<BaseResponce<ResetPassswordEntity>> resetPassword({required String email, required String otp, required String password}) async {
    final response = await _localDataSource.resetPassword(ResetPasswordRequestDto(email: email, newPassword: password, resetCode: otp));
    return switch (response) {
      SuccessResponce<ResetPasswordResponseDto>() => SuccessResponce(response.data.toDomain()),
      ErrorResponce<ResetPasswordResponseDto>() => ErrorResponce(response.error),
    };
  }

  @override
  Future<BaseResponce<VerifyOtpEntity>> verifyOtp({required String email, required String otp}) async {
    final response = await _localDataSource.verifyOtp(verifyOtpRequest: VerifyOtpRequest(email: email, otp: otp));
    return switch (response) {
      SuccessResponce<VerifyOtpResponse>() => SuccessResponce(response.data.data!.toEntity()),
      ErrorResponce<VerifyOtpResponse>() => ErrorResponce(response.error),
    };
  }

  @override
  Future<BaseResponce<LoginEntity>> login(LoginCredentials credentials, {bool rememberMe = false}) async {
    try {
      final response = await _remoteDataSource.login(LoginRequest(email: credentials.email, password: credentials.password));
      if (response.isSuccess == true && response.data != null) {
        final login = response.data!.toLoginEntity();
        // Tokens are always persisted so every commerce API request is authorized.
        await _secureStorage.saveAccessToken(login.accessToken);
        await _secureStorage.saveRefreshToken(login.refreshToken);
        return SuccessResponce(login);
      }
      return ErrorResponce(Exception(response.message ?? AppStrings.loginFailed));
    } catch (error) {
      return ErrorResponce(error is Exception ? error : Exception(error.toString()));
    }
  }

  @override
  Future<String?> getRememberedEmail() => _secureStorage.getRememberedEmail();
  @override
  Future<void> saveRememberedEmail(String email) => _secureStorage.saveRememberedEmail(email);
  @override
  Future<void> deleteRememberedEmail() => _secureStorage.deleteRememberedEmail();

  @override
  Future<BaseResponce<RegisterEntity>> register(RegisterRequestEntity entity) async {
    try {
      final request = RegisterRequest.fromEntity(entity);
      final response = await _remoteDataSource.register(request);

      if (response.isSuccess == true) {
        return SuccessResponce(response.toRegisterEntity());
      }

      return ErrorResponce(Exception(response.message ?? AppStrings.registerError));
    } catch (error) {
      return ErrorResponce(error is Exception ? error : Exception(error.toString()));
    }
  }
}