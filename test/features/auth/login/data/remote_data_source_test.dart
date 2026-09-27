import 'package:flower_app/features/auth/api/data_source_impl/remote/dummy.dart';

import 'package:flower_app/features/auth/api/data_source_impl/remote/remote_data_source_impl.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/auth_test_helpers.dart';

void main() {
  group('RemoteDataSourceImpl', () {
    test('returns success for valid credentials', () async {
      final dataSource = RemoteDataSourceImpl(FakeAuthApiClient());

      final result = await dataSource.login(
        LoginRequest(email: Dummy.email, password: Dummy.pass),
      );

      expect(result.isSuccess, isTrue);
      expect(result.data, isNotNull);
      expect(result.data?.accessToken, isNotNull);
    });

    test('returns failure for invalid credentials', () async {
      final dataSource = RemoteDataSourceImpl(
        FakeAuthApiClient(loginError: Exception('Invalid credentials')),
      );

      final result = await dataSource.login(
        LoginRequest(email: 'wrong@example.com', password: 'wrong'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.data, isNull);
    });

    test('returns failure for correct email wrong password', () async {
      final dataSource = RemoteDataSourceImpl(
        FakeAuthApiClient(loginError: Exception('Wrong password')),
      );

      final result = await dataSource.login(
        LoginRequest(email: Dummy.email, password: 'wrongpass'),
      );

      expect(result.isSuccess, isFalse);
    });
  });
}
