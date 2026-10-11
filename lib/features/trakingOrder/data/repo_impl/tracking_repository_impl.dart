import 'dart:async';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/trakingOrder/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/trakingOrder/data/model/tracking_dto.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/trakingOrder/domain/repo/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TrackingRepository)
class TrackingRepositoryImpl implements TrackingRepository {
  TrackingRepositoryImpl(TrackingRemoteDataSource remoteDataSource)
    : _remoteDataSource = remoteDataSource;

  final TrackingRemoteDataSource _remoteDataSource;
  final Map<String, _TrackingSession> _sessions = {};

  Duration get pollingInterval => const Duration(seconds: 5);

  @override
  Future<BaseResponce<TrackingEntity>> getTracking(String orderId) async {
    final result = await _remoteDataSource.getOrderTracking(orderId);
    switch (result) {
      case SuccessResponce<TrackingDto>(:final data):
        try {
          final entity = data.toEntity();
          if (entity == null) {
            return ErrorResponce<TrackingEntity>(
              Exception('Missing tracking response data'),
            );
          }
          return SuccessResponce<TrackingEntity>(entity);
        } catch (e) {
          return ErrorResponce<TrackingEntity>(Exception(e.toString()));
        }
      case ErrorResponce<TrackingDto>(:final error):
        return ErrorResponce<TrackingEntity>(error);
    }
  }

  @override
  Stream<BaseResponce<TrackingEntity>> startTracking(String orderId) {
    final existing = _sessions[orderId];
    if (existing != null && !existing.isClosed) {
      return existing.controller.stream;
    }
    final session = _TrackingSession(orderId);
    _sessions[orderId] = session;
    unawaited(_fetch(session));
    session.timer = Timer.periodic(
      pollingInterval,
      (_) => unawaited(_fetch(session)),
    );
    return session.controller.stream;
  }

  @override
  Future<void> stopTracking(String orderId) async {
    final session = _sessions.remove(orderId);
    if (session == null) return;
    await _closeSession(session);
  }

  Future<void> _fetch(_TrackingSession session) async {
    if (session.isClosed || session.isFetching) return;
    session.isFetching = true;
    try {
      final result = await getTracking(session.orderId);
      if (session.isClosed) return;
      switch (result) {
        case SuccessResponce<TrackingEntity>(:final data):
          _emit(session, SuccessResponce<TrackingEntity>(data));
          if (!data.isLive || data.isTerminal) {
            _sessions.remove(session.orderId);
            await _closeSession(session);
          }
        case ErrorResponce<TrackingEntity>(:final error):
          _emit(session, ErrorResponce<TrackingEntity>(error));
      }
    } finally {
      session.isFetching = false;
    }
  }

  void _emit(_TrackingSession session, BaseResponce<TrackingEntity> response) {
    if (session.isClosed || session.controller.isClosed) return;
    session.controller.add(response);
  }

  Future<void> _closeSession(_TrackingSession session) async {
    if (session.isClosed) return;
    session.isClosed = true;
    session.timer?.cancel();
    session.timer = null;
    if (!session.controller.isClosed) {
      await session.controller.close();
    }
  }
}

class _TrackingSession {
  _TrackingSession(this.orderId);

  final String orderId;
  final StreamController<BaseResponce<TrackingEntity>> controller =
      StreamController<BaseResponce<TrackingEntity>>.broadcast();
  Timer? timer;
  bool isFetching = false;
  bool isClosed = false;
}
