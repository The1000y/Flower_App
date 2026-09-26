import 'package:flower_app/features/checkout/data/model/responce/estimation_time_dto.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/checkout_fixtures.dart';

void main() {
  group('EstimationTimeDto', () {
    test('should create EstimationTimeDto from JSON correctly', () {
      // Arrange & Act
      final result = EstimationTimeDto.fromJson(
        CheckoutFixtures.tEstimationTimeJson,
      );

      // Assert
      expect(result.estimatedDeliveryAt, CheckoutFixtures.tEstimatedDeliveryAt);
    });

    test('should convert EstimationTimeDto to JSON correctly', () {
      // Arrange & Act
      final result = CheckoutFixtures.tEstimationTimeDto.toJson();

      // Assert
      expect(
        result['estimatedDeliveryAt'],
        CheckoutFixtures.tEstimatedDeliveryAt,
      );
    });

    test(
      'should convert EstimationTimeDto to EstimationTimeEntity correctly',
      () {
        // Arrange & Act
        final result = CheckoutFixtures.tEstimationTimeDto.toEntity();

        // Assert
        expect(result, isA<EstimationTimeEntity>());
        expect(
          result.estimatedDeliveryAt,
          CheckoutFixtures.tEstimatedDeliveryAt,
        );
      },
    );

    test(
      'should fall back to an empty string when estimatedDeliveryAt is null',
      () {
        // Arrange & Act
        final result = CheckoutFixtures.tEmptyEstimationTimeDto.toEntity();

        // Assert
        expect(result.estimatedDeliveryAt, isEmpty);
      },
    );

    test('estimationTimeDtoFromJson should parse a raw json string', () {
      // Arrange
      final raw =
          '{"estimatedDeliveryAt": "${CheckoutFixtures.tEstimatedDeliveryAt}"}';

      // Act
      final result = estimationTimeDtoFromJson(raw);

      // Assert
      expect(result.estimatedDeliveryAt, CheckoutFixtures.tEstimatedDeliveryAt);
    });

    test(
      'estimationTimeDtoToJson should encode the dto to a raw json string',
      () {
        // Arrange
        final raw =
            '{"estimatedDeliveryAt":"${CheckoutFixtures.tEstimatedDeliveryAt}"}';

        // Act
        final result = estimationTimeDtoToJson(estimationTimeDtoFromJson(raw));

        // Assert
        expect(result, raw);
      },
    );

    test(
      'estimationTimeDtoFromJson and estimationTimeDtoToJson should round trip',
      () {
        // Arrange
        final raw =
            '{"estimatedDeliveryAt":"${CheckoutFixtures.tEstimatedDeliveryAt}"}';

        // Act
        final result = estimationTimeDtoFromJson(
          estimationTimeDtoToJson(estimationTimeDtoFromJson(raw)),
        );

        // Assert
        expect(
          result.estimatedDeliveryAt,
          CheckoutFixtures.tEstimatedDeliveryAt,
        );
      },
    );
  });
}
