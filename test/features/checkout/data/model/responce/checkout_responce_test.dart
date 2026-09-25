import 'package:flower_app/features/checkout/data/model/responce/checkout_details_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/checkout_error.dart';
import 'package:flower_app/features/checkout/data/model/responce/checkout_responce.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/checkout_fixtures.dart';

void main() {
  group('CheckoutResponce', () {
    test('should create CheckoutResponce from JSON correctly', () {
      // Arrange & Act
      final result = CheckoutResponce.fromJson(
        CheckoutFixtures.tCheckoutResponceJson,
      );

      // Assert
      expect(result.success, isTrue);
      expect(result.message, 'Checkout details fetched');
      expect(result.error, isNull);
    });

    test('should parse the nested checkout data from JSON', () {
      // Arrange & Act
      final result = CheckoutResponce.fromJson(
        CheckoutFixtures.tCheckoutResponceJson,
      );

      // Assert
      expect(result.data, isNotNull);
      expect(result.data!.subtotal, 200);
      expect(result.data!.total, 230);
      expect(result.data!.paymentMethods!.length, 2);
    });

    test('should convert CheckoutResponce to JSON correctly', () {
      // Arrange & Act
      final result = CheckoutFixtures.tCheckoutResponce.toJson();

      // Assert
      expect(result['success'], isTrue);
      expect(result['message'], 'Checkout details fetched');
      expect(result['data'], isA<CheckoutDetailsDto>());
      expect(result['error'], isNull);
    });

    test('should parse an error payload into CheckoutError', () {
      // Arrange
      final json = {
        'success': false,
        'message': 'Something failed',
        'data': null,
        'error': {'code': 'ADDRESS_REQUIRED', 'field': 'addressId'},
      };

      // Act
      final result = CheckoutResponce.fromJson(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.data, isNull);
      expect(result.error, isNotNull);
      expect(result.error!.code, 'ADDRESS_REQUIRED');
      expect(result.error!.field, 'addressId');
    });
  });

  group('CheckoutError', () {
    test('should create CheckoutError from JSON correctly', () {
      // Arrange & Act
      final result = CheckoutError.fromJson({
        'code': 'ADDRESS_REQUIRED',
        'field': 'addressId',
      });

      // Assert
      expect(result.code, 'ADDRESS_REQUIRED');
      expect(result.field, 'addressId');
    });

    test('should convert CheckoutError to JSON correctly', () {
      // Arrange
      final error = CheckoutError(code: 'ADDRESS_REQUIRED', field: 'addressId');

      // Act
      final result = error.toJson();

      // Assert
      expect(result['code'], 'ADDRESS_REQUIRED');
      expect(result['field'], 'addressId');
    });

    test('should keep both fields null when the json is empty', () {
      // Arrange & Act
      final result = CheckoutError.fromJson(const {});

      // Assert
      expect(result.code, isNull);
      expect(result.field, isNull);
    });
  });
}
