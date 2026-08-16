import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';

import '../entities/register_entity/register_entity.dart';


abstract class AuthRepo {
  Future<BaseResponce<RegisterEntity>> register(RegisterRequest request);
}
