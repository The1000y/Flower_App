import 'dart:async';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/domain/exceptions/tracking_exception.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/get_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/start_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/stop_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_event.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackingViewModel extends Cubit<TrackingState> {
  TrackingViewModel(
    this._getTrackingUseCase,
    this._startTrackingUseCase,
    this._stopTrackingUseCase,
  ) : super(const TrackingState());

  final GetTrackingUseCase _getTrackingUseCase;
  final StartTrackingUseCase _startTrackingUseCase;
  final StopTrackingUseCase _stopTrackingUseCase;

  StreamSubscription<BaseResponce<TrackingEntity>>? _subscription;

  void handle(TrackingEvent intent) {
    switch (intent) {
      case GetTrackingEvent():
        _getTracking(intent.orderId);
      case StartTrackingIntent():
        _startTracking(intent.orderId);
      case StopTrackingIntent():
        _stopTracking();
    }
  }

  Future<void> _getTracking(String orderId) async {
    emit(
      state.copyWith(
        orderId: orderId,
        trackingState: const BaseState<TrackingEntity>(isLoading: true),
      ),
    );
    final result = await _getTrackingUseCase(orderId);
    if (isClosed) return;
    _emitResult(result);
  }

  void _startTracking(String orderId) {
    if (state.orderId == orderId && _subscription != null) return;
    _subscription?.cancel();
    emit(
      state.copyWith(
        orderId: orderId,
        trackingState: const BaseState<TrackingEntity>(isLoading: true),
      ),
    );
    _subscription = _startTrackingUseCase(orderId).listen(
      (response) => _onStreamResponse(response, orderId),
      // The repository closes the stream when polling stops (terminal status,
      // fatal error, too many failures). Clearing the subscription lets the
      // Retry button start tracking again.
      onDone: () => _subscription = null,
    );
  }

  Future<void> _stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
    final orderId = state.orderId;
    if (orderId != null) {
      await _stopTrackingUseCase(orderId);
    }
  }

  void _onStreamResponse(
    BaseResponce<TrackingEntity> response,
    String orderId,
  ) {
    if (isClosed || state.orderId != orderId) return;
    _emitResult(response);
  }

  void _emitResult(BaseResponce<TrackingEntity> response) {
    switch (response) {
      case SuccessResponce<TrackingEntity>(:final data):
        emit(
          state.copyWith(
            isWaitingForDriver: false,
            trackingState: BaseState<TrackingEntity>(data: data),
          ),
        );

      case ErrorResponce<TrackingEntity>(:final error, :final errorMessage):
        if (error is TrackingNotAvailableException) {
          emit(
            state.copyWith(
              isWaitingForDriver: true,
              trackingState: const BaseState<TrackingEntity>(),
            ),
          );
          return;
        }
        final backendMessage = error is TrackingException
            ? error.message
            : null;

        emit(
          state.copyWith(
            isWaitingForDriver: false,
            trackingState: state.trackingState.copyWith(
              isLoading: false,
              errorMessage: (backendMessage?.isNotEmpty ?? false)
                  ? backendMessage!
                  : errorMessage,
            ),
          ),
        );
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
