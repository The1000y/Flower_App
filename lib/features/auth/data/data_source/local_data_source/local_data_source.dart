import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/models/requests/forgot_password_request_dto.dart';
import 'package:flower_app/features/auth/data/models/responses/forgot_password_response_dto.dart';

import '../../models/requests/reset_password_request_dto.dart';
import '../../models/responses/reset_password_response_dto.dart';

abstract interface class LocalDataSource {

 Future<BaseResponce<ForgotPasswordResponseDto>> forgotPassword(
    ForgotPasswordRequestDto request,
  );

  Future<BaseResponce<ResetPasswordResponseDto>> resetPassword(
    ResetPasswordRequestDto request,
  );
}