import 'package:flower_app/features/checkout/data/model/responce/payment_methods_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/checkout_fixtures.dart';

void main() {
  group('PaymentMethodsDto', () {
    test('should create PaymentMethodsDto from JSON correctly', () {
      // Arrange
      final json = {
        'method': CheckoutFixtures.tCod,
        'gateways': ['cash'],
      };

      // Act
      final result = PaymentMethodsDto.fromJson(json);

      // Assert
      expect(result.method, CheckoutFixtures.tCod);
      expect(result.gateways, ['cash']);
    });

    test('should convert PaymentMethodsDto to JSON correctly', () {
      // Arrange
      final dto = PaymentMethodsDto(
        method: CheckoutFixtures.tCard,
        gateways: ['visa'],
      );

      // Act
      final result = dto.toJson();

      // Assert
      expect(result['method'], CheckoutFixtures.tCard);
      expect(result['gateways'], ['visa']);
    });

    test('should keep both fields null when the json is empty', () {
      // Arrange & Act
      final result = PaymentMethodsDto.fromJson(const {});

      // Assert
      expect(result.method, isNull);
      expect(result.gateways, isNull);
    });

    test('should parse every payment method of the fixture list', () {
      // Arrange & Act
      final results = CheckoutFixtures.tPaymentMethodsDtos
          .map((dto) => PaymentMethodsDto.fromJson(dto.toJson()))
          .toList();

      // Assert
      expect(results.length, 2);
      expect(results.first.method, CheckoutFixtures.tCod);
      expect(results.last.method, CheckoutFixtures.tCard);
      expect(results.last.gateways, ['visa', 'mastercard']);
    });
  });
}
