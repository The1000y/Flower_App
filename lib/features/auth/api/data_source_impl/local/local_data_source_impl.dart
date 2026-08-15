import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  Map<String, dynamic> dummyData = {
    "email": "user@example.com",
    "otp": "123456",
  };
  @override
  Future<BaseResponce<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  }) async {
    try {
      await Future.delayed(Duration(seconds: 1));

      if (verifyOtpRequest.email == dummyData["email"] &&
          verifyOtpRequest.otp == dummyData["otp"]) {
        return SuccessResponce<VerifyOtpResponse>(
          VerifyOtpResponse(
            data: Datadto(
              resetToken:
                  'reset_token_${DateTime.now().millisecondsSinceEpoch}',
              expiresAtUtc: DateTime.now().add(const Duration(minutes: 15)),
            ),
            errorCode: 0,
            isSuccess: true,
            message: "Operation completed successfully.",
          ),
        );
      } else {
        return ErrorResponce<VerifyOtpResponse>(
          Exception("Invalid OTP or email"),
        );
      }
    } catch (e) {
      return ErrorResponce<VerifyOtpResponse>(
        Exception("Invalid OTP or email"),
      );
    }
  }
}
