import 'package:flower_app/features/checkout/data/model/responce/checkout_details_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/payment_methods_dto.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/checkout_fixtures.dart';

void main() {
  group('CheckoutDetailsDto', () {
    test('should create CheckoutDetailsDto from JSON correctly', () {
      // Arrange & Act
      final result = CheckoutDetailsDto.fromJson(
        CheckoutFixtures.tCheckoutDetailsJson,
      );

      // Assert
      expect(result.subtotal, 200);
      expect(result.deliveryFee, 30);
      expect(result.total, 230);
      expect(result.estimatedDeliveryAt, CheckoutFixtures.tEstimatedDeliveryAt);
      expect(result.isGift, isFalse);
      expect(result.giftRecipientName, 'Mona Ahmed');
      expect(result.giftRecipientPhone, '01012345678');
    });

    test('should parse paymentMethods from JSON correctly', () {
      // Arrange & Act
      final result = CheckoutDetailsDto.fromJson(
        CheckoutFixtures.tCheckoutDetailsJson,
      );

      // Assert
      expect(result.paymentMethods, isNotNull);
      expect(result.paymentMethods!.length, 2);
      expect(result.paymentMethods!.first.method, CheckoutFixtures.tCod);
      expect(result.paymentMethods!.first.gateways, ['cash']);
      expect(result.paymentMethods!.last.method, CheckoutFixtures.tCard);
      expect(result.paymentMethods!.last.gateways, ['visa', 'mastercard']);
    });

    test('should convert CheckoutDetailsDto to JSON correctly', () {
      // Arrange & Act
      final result = CheckoutFixtures.tCheckoutDetailsDto.toJson();

      // Assert
      expect(result['subtotal'], 200);
      expect(result['deliveryFee'], 30);
      expect(result['total'], 230);
      expect(
        result['estimatedDeliveryAt'],
        CheckoutFixtures.tEstimatedDeliveryAt,
      );
      expect(result['isGift'], isFalse);
      expect(result['giftRecipientName'], 'Mona Ahmed');
      expect(result['giftRecipientPhone'], '01012345678');
    });

    test(
      'should convert CheckoutDetailsDto to CheckoutDetailsEntity correctly',
      () {
        // Arrange & Act
        final result = CheckoutFixtures.tCheckoutDetailsDto.toEntity();

        // Assert
        expect(result, isA<CheckoutDetailsEntity>());
        expect(result.subtotal, 200);
        expect(result.deliveryFee, 30);
        expect(result.total, 230);
        expect(
          result.estimatedDeliveryAt,
          CheckoutFixtures.tEstimatedDeliveryAt,
        );
        expect(result.isGift, isFalse);
        expect(result.giftRecipientName, 'Mona Ahmed');
        expect(result.giftRecipientPhone, '01012345678');
      },
    );

    test(
      'should map paymentMethods DTOs to PaymentMethodEntities correctly',
      () {
        // Arrange & Act
        final result = CheckoutFixtures.tCheckoutDetailsDto.toEntity();

        // Assert
        expect(result.paymentMethods.length, 2);
        expect(result.paymentMethods.first.method, CheckoutFixtures.tCod);
        expect(result.paymentMethods.first.gateways, ['cash']);
        expect(result.paymentMethods.last.method, CheckoutFixtures.tCard);
        expect(result.paymentMethods.last.gateways, ['visa', 'mastercard']);
      },
    );

    test('should fall back to safe defaults when every field is null', () {
      // Arrange & Act
      final result = CheckoutFixtures.tEmptyCheckoutDetailsDto.toEntity();

      // Assert
      expect(result.subtotal, 0);
      expect(result.deliveryFee, 0);
      expect(result.total, 0);
      expect(result.estimatedDeliveryAt, isEmpty);
      expect(result.paymentMethods, isEmpty);
      expect(result.isGift, isFalse);
      expect(result.giftRecipientName, isNull);
      expect(result.giftRecipientPhone, isNull);
    });

    test(
      'should fall back to empty method and gateways for partial payment methods',
      () {
        // Arrange
        final dto = CheckoutDetailsDto(paymentMethods: [PaymentMethodsDto()]);

        // Act
        final result = dto.toEntity();

        // Assert
        expect(result.paymentMethods.first.method, isEmpty);
        expect(result.paymentMethods.first.gateways, isEmpty);
      },
    );

    test('should keep the optional gift fields as null when not provided', () {
      // Arrange
      final dto = CheckoutDetailsDto(subtotal: 10, deliveryFee: 5, total: 15);

      // Act
      final result = dto.toEntity();

      // Assert
      expect(result.giftRecipientName, isNull);
      expect(result.giftRecipientPhone, isNull);
    });
  });
}
