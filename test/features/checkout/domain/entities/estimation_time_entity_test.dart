import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/checkout_fixtures.dart';

void main() {
  group('EstimationTimeEntity', () {
    test('should expose the estimated delivery time', () {
      // Arrange & Act
      const entity = CheckoutFixtures.tEstimationTimeEntity;

      // Assert
      expect(entity.estimatedDeliveryAt, CheckoutFixtures.tEstimatedDeliveryAt);
    });

    test('states with identical values are equal', () {
      // Arrange
      const entityA = CheckoutFixtures.tEstimationTimeEntity;
      const entityB = CheckoutFixtures.tEstimationTimeEntity;

      // Assert
      expect(entityA, equals(entityB));
    });

    test('states with a different estimated delivery time are not equal', () {
      // Arrange
      const entityA = CheckoutFixtures.tEstimationTimeEntity;
      const entityB = EstimationTimeEntity(estimatedDeliveryAt: '2025-01-01');

      // Assert
      expect(entityA, isNot(equals(entityB)));
    });

    test('props should contain the estimated delivery time', () {
      // Arrange & Act
      const entity = CheckoutFixtures.tEstimationTimeEntity;

      // Assert
      expect(entity.props, [entity.estimatedDeliveryAt]);
    });
  });
}
