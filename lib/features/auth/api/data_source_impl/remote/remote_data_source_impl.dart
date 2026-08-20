import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  const RemoteDataSourceImpl();

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    return RegisterResponse(
      isSuccess: true,
      errorCode: 200,
      message: 'Registration successful',
      data: true,
    );
  }
}