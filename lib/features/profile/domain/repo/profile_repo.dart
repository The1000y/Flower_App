import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';

/// Contract for reading the signed-in user.
///
/// Declared as an `abstract interface class` so implementations are forced to
/// use `implements` rather than `extends`: a repository contract is an
/// interface, and inheriting it would let a concrete implementation leak base
/// members into the domain layer.
abstract interface class ProfileRepo {
  /// Returns the signed-in user, or an error response. Implementations must not
  /// throw: failures are reported through [BaseResponce] so the presentation
  /// layer has a single shape to handle.
  Future<BaseResponce<UserEntity>> getProfile();
}
