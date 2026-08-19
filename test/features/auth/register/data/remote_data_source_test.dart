import 'package:flower_app/features/auth/api/data_source_impl/remote/remote_data_source_impl.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flutter_test/flutter_test.dart';

const _sentinel = Object();

RegisterRequest requestWith({
  Object? fullName = _sentinel,
  Object? email = _sentinel,
  Object? phoneNumber = _sentinel,
  Object? gender = _sentinel,
  Object? password = _sentinel,
  Object? confirmPassword = _sentinel,
}) {
  return RegisterRequest(
    fullName: identical(fullName, _sentinel) ? 'John Doe' : fullName as String?,
    email: identical(email, _sentinel) ? 'john@example.com' : email as String?,
    phoneNumber:
        identical(phoneNumber, _sentinel) ? '01012345678' : phoneNumber as String?,
    gender: identical(gender, _sentinel) ? 1 : gender as int?,
    password:
        identical(password, _sentinel) ? 'P@ssw0rd' : password as String?,
    confirmPassword: identical(confirmPassword, _sentinel)
        ? 'P@ssw0rd'
        : confirmPassword as String?,
  );
}

void main() {
  const validJson = <String, dynamic>{
    'fullName': 'John Doe',
    'email': 'john@example.com',
    'phoneNumber': '01012345678',
    'gender': 1,
    'password': 'P@ssw0rd',
    'confirmPassword': 'P@ssw0rd',
  };

  group('RemoteDataSourceImpl.register', () {
    final dataSource = RemoteDataSourceImpl();

    test('returns failure when fullName is null', () async {
      final response = await dataSource.register(requestWith(fullName: null));

      expect(response.isSuccess, isFalse);
      expect(response.errorCode, 400);
      expect(response.message, 'Full name cannot be null');
    });

    test('returns failure when email is null', () async {
      final response = await dataSource.register(requestWith(email: null));

      expect(response.isSuccess, isFalse);
      expect(response.errorCode, 400);
      expect(response.message, 'Email cannot be null');
    });

    test('returns failure when phoneNumber is null', () async {
      final response =
          await dataSource.register(requestWith(phoneNumber: null));

      expect(response.isSuccess, isFalse);
      expect(response.errorCode, 400);
      expect(response.message, 'Phone number cannot be null');
    });

    test('returns failure when gender is null', () async {
      final response = await dataSource.register(requestWith(gender: null));

      expect(response.isSuccess, isFalse);
      expect(response.errorCode, 400);
      expect(response.message, 'Gender cannot be null');
    });

    test('returns failure when password is null', () async {
      final response = await dataSource.register(requestWith(password: null));

      expect(response.isSuccess, isFalse);
      expect(response.errorCode, 400);
      expect(response.message, 'Password cannot be null');
    });

    test('returns failure when confirmPassword is null', () async {
      final response =
          await dataSource.register(requestWith(confirmPassword: null));

      expect(response.isSuccess, isFalse);
      expect(response.errorCode, 400);
      expect(response.message, 'Confirm password cannot be null');
    });

    test('returns failure when passwords do not match', () async {
      final response = await dataSource.register(
        requestWith(confirmPassword: 'DifferentPassword'),
      );

      expect(response.isSuccess, isFalse);
      expect(response.errorCode, 400);
      expect(response.message, 'Passwords do not match');
    });

    test('returns success for a valid request', () async {
      final response = await dataSource.register(requestWith());

      expect(response.isSuccess, isTrue);
      expect(response.errorCode, 200);
      expect(response.message, 'Registration successful');
      expect(response.data, isTrue);
    });

    test('parses fromJson round-trip for a valid payload', () {
      final request = RegisterRequest.fromJson(validJson);

      expect(request.toJson(), validJson);
    });
  });
}