import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';

abstract interface class AuthRepo {

 Future<BaseResponce<ForgetPasswordEntity>> forgetPassword({required String email});
 Future<BaseResponce<ResetPassswordEntity>> resetPassword({required String email,required String otp,required String password});


}