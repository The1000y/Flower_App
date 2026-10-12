import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/order_tracking/domain/entities/order_step_entity.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';

const _titles = [
  'Received your order',
  'Preparing your order',
  'Out for delivery',
  'Delivered',
];
final _date = DateTime(2024, 9, 3, 2, 10);
const _formattedDate = '03 Sep 2024 - 2:10';

/// The four steps; only the first [withDates] have a date (= reached).
List<OrderStepEntity> _steps({int withDates = 4}) => [
  for (var i = 0; i < _titles.length; i++)
    OrderStepEntity(title: _titles[i], dateTime: i < withDates ? _date : null),
];

Widget _timeline({
  required int currentIndex,
  int withDates = 4,
  List<OrderStepEntity>? steps,
  double? stepHeight,
  Color? activeColor,
  Color? inactiveColor,
}) {
  return OrderStatusTimeline(
    steps: steps ?? _steps(withDates: withDates),
    currentIndex: currentIndex,
    stepHeight: stepHeight ?? 80,
    activeColor: activeColor,
    inactiveColor: inactiveColor,
  );
}

final _timelineFinder = find.byType(OrderStatusTimeline);

/// Fill level (0..1) of the connector line under each step, top to bottom.
List<double> _lineFactors(WidgetTester tester) => tester
    .widgetList<FractionallySizedBox>(
      find.descendant(
        of: _timelineFinder,
        matching: find.byType(FractionallySizedBox),
      ),
    )
    .map((box) => box.heightFactor!)
    .toList();

void _expectLineFactors(WidgetTester tester, List<double> expected) {
  final actual = _lineFactors(tester);
  expect(actual.length, expected.length, reason: 'number of connector lines');
  for (var i = 0; i < expected.length; i++) {
    expect(actual[i], closeTo(expected[i], 0.001), reason: 'line under step $i');
  }
}

/// Border color of each step's dot, top to bottom.
List<Color> _dotColors(WidgetTester tester) {
  final dots = find.descendant(
    of: _timelineFinder,
    matching: find.byWidgetPredicate((widget) {
      if (widget is! Container) return false;
      final decoration = widget.decoration;
      // Only the outer ring has a border; the inner filled circle does not.
      return decoration is BoxDecoration &&
          decoration.shape == BoxShape.circle &&
          decoration.border != null;
    }),
  );
  return tester
      .widgetList<Container>(dots)
      .map(
        (c) => ((c.decoration! as BoxDecoration).border! as Border).top.color,
      )
      .toList();
}

List<double> _stepHeights(WidgetTester tester) {
  final steps = find.descendant(
    of: _timelineFinder,
    matching: find.byType(TweenAnimationBuilder<double>),
  );
  return [
    for (var i = 0; i < steps.evaluate().length; i++)
      tester.getSize(steps.at(i)).height,
  ];
}

void main() {
  const active = AppColors.pinkBase;
  const inactive = AppColors.white70;

  group('OrderStatusTimeline - content', () {
    testWidgets('renders the title of every step in order', (tester) async {
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 3));

      for (final title in _titles) {
        expect(find.text(title), findsOneWidget);
      }
      final ys = [for (final t in _titles) tester.getTopLeft(find.text(t)).dy];
      expect(ys, orderedEquals([...ys]..sort()));
    });

    testWidgets('shows the date only for steps that have one', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        _timeline(currentIndex: 1, withDates: 2),
      );

      expect(find.byKey(const ValueKey('has-date')), findsNWidgets(2));
      expect(find.text(_formattedDate), findsNWidgets(2));
    });

    testWidgets('shows no dates when no step has one', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        _timeline(currentIndex: 0, withDates: 0),
      );

      expect(find.byKey(const ValueKey('has-date')), findsNothing);
      expect(find.text(_formattedDate), findsNothing);
    });

    testWidgets('renders nothing (and does not crash) with no steps', (
      tester,
    ) async {
      await pumpOrderTrackingApp(
        tester,
        const OrderStatusTimeline(steps: [], currentIndex: 0),
      );

      expect(tester.takeException(), isNull);
      expect(_dotColors(tester), isEmpty);
    });
  });

  group('OrderStatusTimeline - connector lines', () {
    testWidgets('has one line less than steps (none after the last step)', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 0));

      expect(_lineFactors(tester).length, _titles.length - 1);
    });

    testWidgets('a single step has no connector at all', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        _timeline(currentIndex: 0, steps: [_steps().first]),
      );

      expect(_lineFactors(tester), isEmpty);
    });

    testWidgets('every step has exactly the same height', (tester) async {
      // Mix of steps with and without a date: the date used to change a row's
      // height, which made some lines longer than others.
      await pumpOrderTrackingApp(
        tester,
        _timeline(currentIndex: 1, withDates: 2),
      );

      expect(_stepHeights(tester), everyElement(80.0));
    });

    testWidgets('stepHeight controls the height of every step', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        _timeline(currentIndex: 1, stepHeight: 100),
      );

      expect(_stepHeights(tester), everyElement(100.0));
    });

    testWidgets('a very long title is cut with an ellipsis and keeps the height', (
      tester,
    ) async {
      final longTitle = 'A very long step title ' * 30;
      await pumpOrderTrackingApp(
        tester,
        _timeline(
          currentIndex: 0,
          steps: [
            OrderStepEntity(title: longTitle, dateTime: _date),
            ..._steps().skip(1),
          ],
        ),
      );

      final text = tester.widget<Text>(find.text(longTitle));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(tester.takeException(), isNull);
      expect(_stepHeights(tester), everyElement(80.0));
    });
  });

  group('OrderStatusTimeline - progress states', () {
    testWidgets('first step reached: only the first dot and line are active', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 0));

      expect(_dotColors(tester), [active, inactive, inactive, inactive]);
      _expectLineFactors(tester, [1, 0, 0]);
    });

    testWidgets('second step reached: the lines follow the dots', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 1));

      expect(_dotColors(tester), [active, active, inactive, inactive]);
      _expectLineFactors(tester, [1, 1, 0]);
    });

    testWidgets('last step reached: every dot and line is active', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 3));

      expect(_dotColors(tester), [active, active, active, active]);
      _expectLineFactors(tester, [1, 1, 1]);
    });

    testWidgets('an index past the last step counts every step as reached', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 10));

      expect(_dotColors(tester), everyElement(active));
      _expectLineFactors(tester, [1, 1, 1]);
    });

    testWidgets('a negative index means nothing has been reached', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: -1));

      expect(_dotColors(tester), everyElement(inactive));
      _expectLineFactors(tester, [0, 0, 0]);
    });

    testWidgets('uses the custom active and inactive colors when given', (
      tester,
    ) async {
      await pumpOrderTrackingApp(
        tester,
        _timeline(
          currentIndex: 1,
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
        ),
      );

      expect(
        _dotColors(tester).map((c) => c.toARGB32()).toList(),
        [
          Colors.green.toARGB32(),
          Colors.green.toARGB32(),
          Colors.grey.toARGB32(),
          Colors.grey.toARGB32(),
        ],
      );
    });
  });

  group('OrderStatusTimeline - animation', () {
    testWidgets('the first build shows the final state without animating', (
      tester,
    ) async {
      // pumpOrderTrackingApp only pumps one zero-length frame after the build.
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 2));

      _expectLineFactors(tester, [1, 1, 1]);
      expect(_dotColors(tester), [active, active, active, inactive]);
    });

    testWidgets('fills the lines gradually when the status moves forward', (
      tester,
    ) async {
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 0));
      _expectLineFactors(tester, [1, 0, 0]);

      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 2));
      await tester.pump(); // starts the tween
      await tester.pump(const Duration(milliseconds: 350)); // half of 700 ms

      final midway = _lineFactors(tester);
      expect(midway[0], closeTo(1, 0.001), reason: 'already reached');
      expect(midway[1], allOf(greaterThan(0.0), lessThan(1.0)));
      expect(midway[2], allOf(greaterThan(0.0), lessThan(1.0)));

      await tester.pumpAndSettle();
      _expectLineFactors(tester, [1, 1, 1]);
      expect(_dotColors(tester), [active, active, active, inactive]);
    });

    testWidgets('plays backwards when the status moves back', (tester) async {
      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 3));
      _expectLineFactors(tester, [1, 1, 1]);

      await pumpOrderTrackingApp(tester, _timeline(currentIndex: 0));
      await tester.pumpAndSettle();

      _expectLineFactors(tester, [1, 0, 0]);
      expect(_dotColors(tester), [active, inactive, inactive, inactive]);
    });

    testWidgets('a date fades in when its step gets reached', (tester) async {
      await pumpOrderTrackingApp(
        tester,
        _timeline(currentIndex: 0, withDates: 1),
      );
      expect(find.byKey(const ValueKey('has-date')), findsOneWidget);

      await pumpOrderTrackingApp(
        tester,
        _timeline(currentIndex: 2, withDates: 3),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('has-date')), findsNWidgets(3));
      expect(find.text(_formattedDate), findsNWidgets(3));
    });
  });
}
