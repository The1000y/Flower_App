import 'package:dio/dio.dart';
import 'package:flower_app/config/errors/friendly_error_message.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DioException dioException({
    DioExceptionType type = DioExceptionType.badResponse,
    dynamic responseData,
  }) {
    return DioException(
      requestOptions: RequestOptions(path: '/address'),
      type: type,
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/address'),
        data: responseData,
      ),
    );
  }

  group('FriendlyErrorMessage.from', () {
    test('maps an empty message to the generic fallback', () {
      expect(
        FriendlyErrorMessage.from(''),
        AppStrings.addressAddFailedServer,
      );
      expect(FriendlyErrorMessage.from(null), AppStrings.addressAddFailedServer);
    });

    test('keeps a safe, understandable backend message', () {
      expect(
        FriendlyErrorMessage.from('This phone number is already in use'),
        'This phone number is already in use',
      );
    });

    test('maps a not-serviceable backend message to the friendly message', () {
      final dioError = dioException(
        responseData: {'message': 'Address is not serviceable in this area'},
      );
      expect(
        FriendlyErrorMessage.from(dioError),
        AppStrings.addressAddFailedNotServiceable,
      );
    });

    test('recovers a not-serviceable business rejection message', () {
      expect(
        FriendlyErrorMessage.from(
          Exception('This address is outside our delivery area'),
        ),
        AppStrings.addressAddFailedNotServiceable,
      );
    });

    test('maps invalid-data messages to the invalid data message', () {
      expect(
        FriendlyErrorMessage.from(Exception('City not found')),
        AppStrings.addressAddFailedInvalid,
      );
      expect(
        FriendlyErrorMessage.from('Recipient name is required'),
        AppStrings.addressAddFailedInvalid,
      );
    });

    test('maps technical network failures to the generic message', () {
      expect(
        FriendlyErrorMessage.from(
          dioException(type: DioExceptionType.connectionError),
        ),
        AppStrings.addressAddFailedServer,
      );
      expect(
        FriendlyErrorMessage.from(
          dioException(type: DioExceptionType.receiveTimeout),
        ),
        AppStrings.addressAddFailedServer,
      );
      expect(
        FriendlyErrorMessage.from('connectionError'),
        AppStrings.addressAddFailedServer,
      );
    });

    test('maps raw exceptions and status codes to the generic message', () {
      expect(
        FriendlyErrorMessage.from(Exception('Null check operator used on a null value')),
        AppStrings.addressAddFailedServer,
      );
      expect(
        FriendlyErrorMessage.from('HTTP error 500'),
        AppStrings.addressAddFailedServer,
      );
    });
  });
}