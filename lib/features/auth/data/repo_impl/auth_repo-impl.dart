import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';

import 'package:flower_app/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final LocalDataSource loginApi;

  AuthRepoImpl(this.loginApi);
  @override
  Future<BaseResponce<LoginEntity>> login(RequestLogin req) async {
   try {
    final response = await loginApi.login(req);

    if (response.isSuccess == true && response.data != null) {
      return SuccessResponce(
        response.data!.tologinEntity(),
      );
    }

    return ErrorResponce(
      Exception(response.message ?? 'Login failed'),
    );
  } catch (e) {
    return ErrorResponce(
      e is Exception ? e : Exception(e.toString()),
    );
  }
  }
}
