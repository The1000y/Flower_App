import 'package:flower_app/config/base/base_responce.dart';

import '../entities/register_entity/register_entity.dart';
import '../entities/register_entity/register_request_entity.dart';

abstract class AuthRepo {
  Future<BaseResponce<RegisterEntity>> register(RegisterRequestEntity request);
}