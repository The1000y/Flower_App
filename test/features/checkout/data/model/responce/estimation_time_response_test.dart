import 'package:flower_app/features/checkout/data/model/responce/estimation_time_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/estimation_time_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/checkout_fixtures.dart';

void main() {
  group('EstimationTimeResponse', () {
    test('should create EstimationTimeResponse from JSON correctly', () {
      // Arrange & Act
      final result = EstimationTimeResponse.fromJson(
        CheckoutFixtures.tEstimationTimeResponseJson,
      );

      // Assert
      expect(result.success, isTrue);
      expect(result.message, 'Estimation time fetched');
      expect(result.error, isNull);
    });

    test('should parse the nested estimation data from JSON', () {
      // Arrange & Act
      final result = EstimationTimeResponse.fromJson(
        CheckoutFixtures.tEstimationTimeResponseJson,
      );

      // Assert
      expect(result.data, isNotNull);
      expect(
        result.data!.estimatedDeliveryAt,
        CheckoutFixtures.tEstimatedDeliveryAt,
      );
    });

    test('should convert EstimationTimeResponse to JSON correctly', () {
      // Arrange & Act
      final result = CheckoutFixtures.tEstimationTimeResponse.toJson();

      // Assert
      expect(result['success'], isTrue);
      expect(result['message'], 'Estimation time fetched');
      expect(result['data'], isA<EstimationTimeDto>());
      expect(result['error'], isNull);
    });

    test('should parse an error payload into Error', () {
      // Arrange
      final json = {
        'success': false,
        'message': 'Failed',
        'data': null,
        'error': {'code': 'NOT_FOUND', 'field': 'addressId'},
      };

      // Act
      final result = EstimationTimeResponse.fromJson(json);

      // Assert
      expect(result.success, isFalse);
      expect(result.error, isNotNull);
      expect(result.error!.code, 'NOT_FOUND');
      expect(result.error!.field, 'addressId');
    });

    test('estimationTimeResponseFromJson should parse a raw json string', () {
      // Arrange
      final raw =
          '{"success": true, "data": {"estimatedDeliveryAt": "${CheckoutFixtures.tEstimatedDeliveryAt}"}}';

      // Act
      final result = estimationTimeResponseFromJson(raw);

      // Assert
      expect(result.success, isTrue);
      expect(
        result.data!.estimatedDeliveryAt,
        CheckoutFixtures.tEstimatedDeliveryAt,
      );
    });

    test(
      'estimationTimeResponseToJson should encode every key of the response',
      () {
        // Arrange
        final raw =
            '{"success":true,"message":"Estimation time fetched",'
            '"data":{"estimatedDeliveryAt":"${CheckoutFixtures.tEstimatedDeliveryAt}"},'
            '"error":null}';

        // Act
        final result = estimationTimeResponseToJson(
          estimationTimeResponseFromJson(raw),
        );

        // Assert
        expect(result, raw);
      },
    );

    test(
      'estimationTimeResponseFromJson and estimationTimeResponseToJson should round trip',
      () {
        // Arrange
        final raw =
            '{"success":true,"message":"Estimation time fetched",'
            '"data":{"estimatedDeliveryAt":"${CheckoutFixtures.tEstimatedDeliveryAt}"},'
            '"error":null}';

        // Act
        final result = estimationTimeResponseFromJson(
          estimationTimeResponseToJson(estimationTimeResponseFromJson(raw)),
        );

        // Assert
        expect(result.success, isTrue);
        expect(result.message, 'Estimation time fetched');
        expect(
          result.data!.estimatedDeliveryAt,
          CheckoutFixtures.tEstimatedDeliveryAt,
        );
      },
    );
  });

  group('Error', () {
    test('should create Error from JSON correctly', () {
      // Arrange & Act
      final result = Error.fromJson({
        'code': 'NOT_FOUND',
        'field': 'addressId',
      });

      // Assert
      expect(result.code, 'NOT_FOUND');
      expect(result.field, 'addressId');
    });

    test('should convert Error to JSON correctly', () {
      // Arrange
      final error = Error(code: 'NOT_FOUND', field: 'addressId');

      // Act
      final result = error.toJson();

      // Assert
      expect(result['code'], 'NOT_FOUND');
      expect(result['field'], 'addressId');
    });

    test('should keep both fields null when the json is empty', () {
      // Arrange & Act
      final result = Error.fromJson(const {});

      // Assert
      expect(result.code, isNull);
      expect(result.field, isNull);
    });
  });
}
