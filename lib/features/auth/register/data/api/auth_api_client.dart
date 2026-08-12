import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/register_response.dart';
import '../models/register_request.dart';

class AuthApiClient{
final Dio _dio;
@injectable
AuthApiClient(this._dio);
Future<RegisterResponse> register(RegisterRequest request) async{
  try{
    await Future.delayed(const Duration(seconds: 2));
   final Map<String,dynamic> dummydata ={
      'message':'success',
      'token':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',

    };
   return RegisterResponse.fromJson(dummydata);

  }
  catch(e){
    rethrow;
  }
}
}




