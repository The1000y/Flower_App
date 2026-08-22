import 'package:flower_app/features/auth/api/data_source_impl/remote/remote_data_source_impl.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteDataSourceImpl.register', () {
    final dataSource = RemoteDataSourceImpl();

    test('returns success for a valid request', () async {
      final response = await dataSource.register(
        RegisterRequest(
          fullName: 'John Doe',
          email: 'john@example.com',
          phoneNumber: '01012345678',
          gender: 1,
          password: 'P@ssw0rd',
          confirmPassword: 'P@ssw0rd',
        ),
      );

      expect(response.isSuccess, isTrue);
      expect(response.errorCode, 200);
      expect(response.message, 'Registration successful');
      expect(response.data, isTrue);
    });

    test('parses fromJson round-trip for a valid payload', () {
      const validJson = <String, dynamic>{
        'fullName': 'John Doe',
        'email': 'john@example.com',
        'phoneNumber': '01012345678',
        'gender': 1,
        'password': 'P@ssw0rd',
        'confirmPassword': 'P@ssw0rd',
      };

      final request = RegisterRequest.fromJson(validJson);

      expect(request.toJson(), validJson);
    });
  });
}