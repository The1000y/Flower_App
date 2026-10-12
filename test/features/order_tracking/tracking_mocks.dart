import 'package:flower_app/features/order_tracking/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/order_tracking/domain/repo/tracking_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockTrackingRepository extends Mock implements TrackingRepository {}

class MockTrackingRemoteDataSource extends Mock
    implements TrackingRemoteDataSource {}
