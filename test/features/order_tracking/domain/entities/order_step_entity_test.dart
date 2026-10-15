import 'package:flower_app/features/order_tracking/domain/entities/order_step_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderStepEntity', () {
    test('keeps the title and date it was created with', () {
      final date = DateTime(2024, 9, 3, 2, 10);

      final step = OrderStepEntity(title: 'Received your order', dateTime: date);

      expect(step.title, 'Received your order');
      expect(step.dateTime, date);
    });

    test('dateTime defaults to null (the step has not been reached yet)', () {
      const step = OrderStepEntity(title: 'Delivered');

      expect(step.dateTime, isNull);
    });

    test('can be created as a compile-time constant', () {
      const a = OrderStepEntity(title: 'Out for delivery');
      const b = OrderStepEntity(title: 'Out for delivery');

      expect(identical(a, b), isTrue);
    });
  });
}
