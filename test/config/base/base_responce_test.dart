import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/config/base/base_responce.dart';

void main() {
  group('BaseResponce', () {
    test('SuccessResponce carries its data', () {
      // Arrange & Act
      final response = SuccessResponce<List<String>>(['a', 'b']);

      // Assert
      expect(response.data, equals(['a', 'b']));
    });

    test('ErrorResponce maps a generic exception to an error message', () {
      // Arrange & Act
      final response = ErrorResponce<int>(Exception('boom'));

      // Assert
      expect(response.errorMessage, isNotEmpty);
    });
  });
}