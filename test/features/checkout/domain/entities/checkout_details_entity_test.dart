import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/checkout_fixtures.dart';

void main() {
  group('CheckoutDetailsEntity', () {
    test('should expose the values it was built with', () {
      // Arrange & Act
      const entity = CheckoutFixtures.tCheckoutDetailsEntity;

      // Assert
      expect(entity.subtotal, 200);
      expect(entity.deliveryFee, 30);
      expect(entity.total, 230);
      expect(entity.estimatedDeliveryAt, CheckoutFixtures.tEstimatedDeliveryAt);
      expect(entity.isGift, isFalse);
      expect(entity.giftRecipientName, 'Mona Ahmed');
      expect(entity.giftRecipientPhone, '01012345678');
    });

    test('states with identical values are equal', () {
      // Arrange
      const entityA = CheckoutFixtures.tCheckoutDetailsEntity;
      const entityB = CheckoutFixtures.tCheckoutDetailsEntity;

      // Assert
      expect(entityA, equals(entityB));
    });

    test('states with a different total are not equal', () {
      // Arrange
      const entityA = CheckoutFixtures.tCheckoutDetailsEntity;
      const entityB = CheckoutDetailsEntity(
        subtotal: 200,
        deliveryFee: 30,
        total: 999,
        estimatedDeliveryAt: CheckoutFixtures.tEstimatedDeliveryAt,
        paymentMethods: CheckoutFixtures.tPaymentMethodEntities,
        isGift: false,
        giftRecipientName: 'Mona Ahmed',
        giftRecipientPhone: '01012345678',
      );

      // Assert
      expect(entityA, isNot(equals(entityB)));
    });

    test('props should contain every field', () {
      // Arrange & Act
      const entity = CheckoutFixtures.tCheckoutDetailsEntity;

      // Assert
      expect(entity.props.length, 8);
      expect(entity.props, contains(entity.subtotal));
      expect(entity.props, contains(entity.giftRecipientPhone));
    });
  });

  group('PaymentMethodEntity', () {
    test('should expose the method and its gateways', () {
      // Arrange & Act
      const entity = CheckoutFixtures.tCodEntity;

      // Assert
      expect(entity.method, CheckoutFixtures.tCod);
      expect(entity.gateways, ['cash']);
    });

    test('states with identical values are equal', () {
      // Arrange
      const entityA = PaymentMethodEntity(
        method: CheckoutFixtures.tCard,
        gateways: ['visa'],
      );
      const entityB = PaymentMethodEntity(
        method: CheckoutFixtures.tCard,
        gateways: ['visa'],
      );

      // Assert
      expect(entityA, equals(entityB));
    });

    test('states with different gateways are not equal', () {
      // Arrange
      const entityA = PaymentMethodEntity(
        method: CheckoutFixtures.tCard,
        gateways: ['visa'],
      );
      const entityB = PaymentMethodEntity(
        method: CheckoutFixtures.tCard,
        gateways: ['mastercard'],
      );

      // Assert
      expect(entityA, isNot(equals(entityB)));
    });
  });
}
