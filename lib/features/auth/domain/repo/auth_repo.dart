import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';


abstract class AuthRepo {
  Future<BaseResponce<LoginEntity>> login(RequestLogin req);
}
