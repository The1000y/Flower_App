import 'package:flower_app/features/auth/api/data_source_impl/local/dummy.dart';
import 'package:flower_app/features/auth/api/data_source_impl/local/local_data_source_impl.dart';
import 'package:flower_app/features/auth/data/model/request/login_request/request_login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalDataSourceImpl', () {
    final dataSource = LocalDataSourceImpl();

    test('returns success for valid credentials', () async {
      final result = await dataSource.login(
        RequestLogin(email: Dummy.email, password: Dummy.pass),
      );

      expect(result.isSuccess, isTrue);
      expect(result.data, isNotNull);
    });

    test('returns failure for invalid credentials', () async {
      final result = await dataSource.login(
        RequestLogin(email: 'wrong@example.com', password: 'wrong'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.data, isNull);
    });

    test('returns failure for correct email wrong password', () async {
      final result = await dataSource.login(
        RequestLogin(email: Dummy.email, password: 'wrongpass'),
      );

      expect(result.isSuccess, isFalse);
    });
  });
}