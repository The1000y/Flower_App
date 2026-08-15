import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';

import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  LocalDataSource localDataSource;
  AuthRepoImpl(this.localDataSource);
  @override
  Future<BaseResponce<ForgetPasswordEntity>> forgetPassword({
    required String email,
  }) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  @override
  Future<BaseResponce<ResetPassswordEntity>> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<BaseResponce<VerifyOtpEntity>> verifyOtp({
    required String email,
    required String otp,
  }) async {
  BaseResponce<VerifyOtpResponse> responce =  await localDataSource.verifyOtp(
      verifyOtpRequest: VerifyOtpRequest(email: email, otp: otp),
    );
    switch (responce) {
      
      case SuccessResponce<VerifyOtpResponse>():
        return SuccessResponce<VerifyOtpEntity>(
          responce.data.data!.toEntity(),
        );
      case ErrorResponce<VerifyOtpResponse>():
        return ErrorResponce<VerifyOtpEntity>(
          responce.error,
        );
    }
  }
}
