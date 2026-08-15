import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/forget_request/verify_otp_request.dart';
import 'package:flower_app/features/auth/data/model/responce/forget_responce/verify_otp_response.dart';

abstract interface class LocalDataSource {

Future<BaseResponce<VerifyOtpResponse>>  verifyOtp({required VerifyOtpRequest verifyOtpRequest});

}