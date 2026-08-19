import 'package:flower_app/features/auth/api/data_source_impl/remote/dummy.dart';
import 'package:flower_app/features/auth/api/data_source_impl/remote/remote_data_source_impl.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/login_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteDataSourceImpl', () {
    final dataSource = RemoteDataSourceImpl();

    test('returns success for valid credentials', () async {
      final result = await dataSource.login(
        LoginRequest(email: Dummy.email, password: Dummy.pass),
      );

      expect(result.isSuccess, isTrue);
      expect(result.data, isNotNull);
    });

    test('returns failure for invalid credentials', () async {
      final result = await dataSource.login(
        LoginRequest(email: 'wrong@example.com', password: 'wrong'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.data, isNull);
    });

    test('returns failure for correct email wrong password', () async {
      final result = await dataSource.login(
        LoginRequest(email: Dummy.email, password: 'wrongpass'),
      );

      expect(result.isSuccess, isFalse);
    });
  });
}