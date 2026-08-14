import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../domain/models/register_response.dart';
import '../../domain/models/register_request.dart';
@injectable
class AuthApiClient{
final Dio _dio;

AuthApiClient(this._dio);
Future<RegisterResponse> register(RegisterRequest request) async{
  try{
    await Future.delayed(const Duration(seconds: 2));
   final Map<String,dynamic> dummydata ={
     "isSuccess": true,
     "errorCode": 0,
     "message": "Operation completed successfully.",
     "data": true
    };
   return RegisterResponse.fromJson(dummydata);
    /*
      // --------------------------------------------------------
      // ⚠️ الكود الحقيقي (Uncomment لما الباك إند يشتغل):
      // --------------------------------------------------------
      // final response = await _dio.post(
      //   '/api/v1/auth/register', // 💡 عدل المسار ده للمسار الفعلي بتاعك
      //   data: request.toJson(),
      // );
      // return RegisterResponse.fromJson(response.data);
      */

  }
  catch(e){
    rethrow;
  }
}
}




