import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/config/base/base_state.dart';

void main() {
  group('BaseState', () {
    test('defaults are not loading, no error and no data', () {
      // Arrange & Act
      const state = BaseState<String>();

      // Assert
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isEmpty);
      expect(state.data, isNull);
    });

    test('states with identical values are equal', () {
      // Arrange
      const stateA = BaseState<int>(isLoading: true);
      const stateB = BaseState<int>(isLoading: true);

      // Assert
      expect(stateA, equals(stateB));
    });
  });
}