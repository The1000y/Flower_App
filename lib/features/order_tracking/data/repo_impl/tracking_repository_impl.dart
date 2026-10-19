import 'dart:async';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/order_tracking/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/order_tracking/data/model/tracking_dto.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/domain/exceptions/tracking_exception.dart';
import 'package:flower_app/features/order_tracking/domain/repo/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TrackingRepository)
class TrackingRepositoryImpl implements TrackingRepository {
  TrackingRepositoryImpl(TrackingRemoteDataSource remoteDataSource)
    : _remoteDataSource = remoteDataSource;

  final TrackingRemoteDataSource _remoteDataSource;
  final Map<String, _TrackingSession> _sessions = {};

  Duration get pollingInterval => const Duration(seconds: 5);
  static const int _maxConsecutiveFailures = 5;

  @override
  Future<BaseResponce<TrackingEntity>> getTracking(String orderId) async {
    if (orderId.trim().isEmpty) {
      return ErrorResponce<TrackingEntity>(
        const TrackingInvalidRequestException('Invalid order id'),
      );
    }

    final result = await _remoteDataSource.getOrderTracking(orderId);

    switch (result) {
      case SuccessResponce<TrackingDto>(:final data):
        final entity = data.toEntity();
        if (entity == null) {
          return ErrorResponce<TrackingEntity>(
            const TrackingServerException('Missing tracking response data'),
          );
        }
        return SuccessResponce<TrackingEntity>(entity);
      case ErrorResponce<TrackingDto>(:final error):
        return ErrorResponce<TrackingEntity>(error);
    }
  }

  @override
  Stream<BaseResponce<TrackingEntity>> startTracking(String orderId) {
    if (orderId.trim().isEmpty) {
      return Stream.value(
        ErrorResponce<TrackingEntity>(
          const TrackingInvalidRequestException('Invalid order id'),
        ),
      );
    }

    final existing = _sessions[orderId];
    if (existing != null && !existing.isClosed) {
      return existing.stream;
    }
    final session = _TrackingSession(orderId);
    session.onCancel = () => _handleLastListenerCancelled(session);
    _sessions[orderId] = session;
    unawaited(_fetch(session));
    session.timer = Timer.periodic(
      pollingInterval,
      (_) => unawaited(_fetch(session)),
    );
    return session.stream;
  }

  @override
  Future<void> stopTracking(String orderId) async {
    final session = _sessions.remove(orderId);
    if (session == null) return;
    await _closeSession(session);
  }

  @override
  Future<void> refreshTracking(String orderId) async {
    final session = _sessions[orderId];
    if (session == null || session.isClosed) return;
    await _fetch(session);
  }

  @override
  Future<void> dispose() async {
    final sessions = _sessions.values.toList();
    _sessions.clear();
    for (final session in sessions) {
      await _closeSession(session);
    }
  }

  Future<void> _stopSession(_TrackingSession session) async {
    if (_sessions[session.orderId] == session) {
      _sessions.remove(session.orderId);
    }
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
          session.failures = 0;
          _emit(session, SuccessResponce<TrackingEntity>(data));
          if (data.isTerminal) {
            await _stopSession(session);
          }
        case ErrorResponce<TrackingEntity>(:final error):
          _emit(session, ErrorResponce<TrackingEntity>(error));

          final tracking = error is TrackingException ? error : null;
          if (tracking?.countsAsFailure ?? true) session.failures++;

          if ((tracking?.stopsPolling ?? false) ||
              session.failures >= _maxConsecutiveFailures) {
            await _stopSession(session);
          }
      }
    } catch (error, stackTrace) {
      if (session.isClosed) return;
      session.addError(error, stackTrace);
      session.failures++;
      if (session.failures >= _maxConsecutiveFailures) {
        await _stopSession(session);
      }
    } finally {
      session.isFetching = false;
    }
  }

  void _emit(_TrackingSession session, BaseResponce<TrackingEntity> response) {
    if (session.isClosed) return;
    session.add(response);
  }

  Future<void> _handleLastListenerCancelled(_TrackingSession session) async {
    if (_sessions[session.orderId] != session) return;
    _sessions.remove(session.orderId);
    await _closeSession(session);
  }

  Future<void> _closeSession(_TrackingSession session) async {
    if (session.isClosed) return;
    session.isClosed = true;
    session.timer?.cancel();
    session.timer = null;
    await session.close();
  }
}

class _TrackingSession {
  _TrackingSession(this.orderId);

  final String orderId;
  final StreamController<BaseResponce<TrackingEntity>> _controller =
      StreamController<BaseResponce<TrackingEntity>>.broadcast();
  Timer? timer;
  bool isFetching = false;
  bool isClosed = false;
  int failures = 0;

  /// Built once: repeated session lookups reuse the same transformed stream
  /// instead of allocating a fresh transformer on every access.
  late final Stream<BaseResponce<TrackingEntity>> stream = _controller.stream
      .transform(
        StreamTransformer<
          BaseResponce<TrackingEntity>,
          BaseResponce<TrackingEntity>
        >.fromHandlers(
          handleError: (error, stackTrace, sink) {
            sink.add(
              ErrorResponce<TrackingEntity>(
                error is Exception ? error : Exception(error.toString()),
              ),
            );
          },
        ),
      );

  set onCancel(FutureOr<void> Function() callback) {
    _controller.onCancel = callback;
  }

  void add(BaseResponce<TrackingEntity> response) {
    if (_controller.isClosed) return;
    _controller.add(response);
  }

  void addError(Object error, StackTrace stackTrace) {
    if (_controller.isClosed) return;
    _controller.addError(error, stackTrace);
  }

  Future<void> close() async {
    if (_controller.isClosed) return;
    await _controller.close();
  }
}
