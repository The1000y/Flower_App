import '../../model/request/register_request/register_request.dart';
import '../../model/responce/register_responce/register_response.dart';

 abstract class RemoteDataSource {
   Future<RegisterResponse> register(RegisterRequest request);

 }