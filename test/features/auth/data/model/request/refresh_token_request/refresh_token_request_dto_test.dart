import 'package:flower_app/features/auth/data/model/request/refresh_token_request/refresh_token_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RefreshTokenRequestDto', () {
    test('serialises the refresh token under the "token" key', () {
      const dto = RefreshTokenRequestDto(token: 'refresh-value');

      expect(dto.toJson(), {'token': 'refresh-value'});
    });

    test('parses the "token" key back', () {
      final dto = RefreshTokenRequestDto.fromJson({'token': 'refresh-value'});

      expect(dto.token, 'refresh-value');
    });
  });
}
