import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';

import '../entities/register_entity/register_entity.dart';


abstract class AuthRepo {
  Future<BaseResponce<RegisterEntity>> register(RegisterRequest request);
  Future<BaseResponce<LoginEntity>> login(RequestLogin req);
}


