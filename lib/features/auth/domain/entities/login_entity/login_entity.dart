import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';

class LoginEntity {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String driverStatus;
  final UserEntity? user;

  const LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.driverStatus,
    this.user,
  });
}