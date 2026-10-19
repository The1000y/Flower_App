import 'dart:async';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/domain/exceptions/tracking_exception.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/confirm_order_delivery_use_case.dart';
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
    this._confirmOrderDeliveryUseCase,
  ) : super(const TrackingState());

  final GetTrackingUseCase _getTrackingUseCase;
  final StartTrackingUseCase _startTrackingUseCase;
  final StopTrackingUseCase _stopTrackingUseCase;
  final ConfirmOrderDeliveryUseCase _confirmOrderDeliveryUseCase;

  StreamSubscription<BaseResponce<TrackingEntity>>? _subscription;

  void handle(TrackingEvent intent) {
    switch (intent) {
      case GetTrackingEvent():
        _getTracking(intent.orderId);
      case StartTrackingIntent():
        _startTracking(intent.orderId);
      case StopTrackingIntent():
        _stopTracking();
      case ConfirmDeliveryIntent():
        _confirmDelivery();
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

  Future<void> _confirmDelivery() async {
    final orderId = state.orderId;
    if (orderId == null || state.isConfirmingDelivery) return;
    emit(state.copyWith(isConfirmingDelivery: true, confirmDeliveryError: ''));
    final result = await _confirmOrderDeliveryUseCase(orderId);
    if (isClosed) return;
    switch (result) {
      case SuccessResponce<void>():
        emit(
          state.copyWith(
            isConfirmingDelivery: false,
            trackingState: state.trackingState.data != null
                ? BaseState<TrackingEntity>(
                    data: state.trackingState.data!.copyWith(
                      status: 'Delivered',
                      awaitingCustomerConfirmation: false,
                    ),
                  )
                : state.trackingState.copyWith(isLoading: false),
          ),
        );
      case ErrorResponce<void>(:final error, :final errorMessage):
        String message = errorMessage;
        if (error is TrackingException) {
          if (error.message?.isNotEmpty ?? false) {
            message = error.message!;
          }
        }
        emit(
          state.copyWith(
            isConfirmingDelivery: false,
            confirmDeliveryError: message,
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
