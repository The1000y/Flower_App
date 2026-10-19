import 'package:flower_app/features/order_tracking/data/repo_impl/tracking_order_update_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../tracking_mocks.dart';

void main() {
  late MockTrackingRepository trackingRepository;
  late TrackingOrderUpdateHandler handler;

  setUp(() {
    trackingRepository = MockTrackingRepository();
    handler = TrackingOrderUpdateHandler(trackingRepository);
  });

  test('forwards the order id to the tracking repository refresh', () async {
    when(
      () => trackingRepository.refreshTracking('o-1'),
    ).thenAnswer((_) async {});

    await handler.onOrderUpdated('o-1');

    verify(() => trackingRepository.refreshTracking('o-1')).called(1);
  });
}
