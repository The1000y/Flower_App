import 'dart:async';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/config/errors/hadel_error_exception.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/get_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/start_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/stop_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/presentation/manager/cubit/tracking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit(
    this._getTrackingUseCase,
    this._startTrackingUseCase,
    this._stopTrackingUseCase,
  ) : super(const TrackingState());

  final GetTrackingUseCase _getTrackingUseCase;
  final StartTrackingUseCase _startTrackingUseCase;
  final StopTrackingUseCase _stopTrackingUseCase;

  StreamSubscription<BaseResponce<TrackingEntity>>? _subscription;
  String? _orderId;

  Future<void> getTracking(String orderId) async {
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

  void startTracking(String orderId) {
    if (_orderId == orderId && _subscription != null) return;
    _subscription?.cancel();
    _orderId = orderId;
    emit(
      state.copyWith(
        orderId: orderId,
        trackingState: const BaseState<TrackingEntity>(isLoading: true),
      ),
    );
    _subscription = _startTrackingUseCase(orderId).listen(
      (response) => _onStreamResponse(response, orderId),
      onError: (Object error) => _onStreamError(error, orderId),
    );
  }

  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
    final orderId = _orderId;
    _orderId = null;
    if (orderId != null) {
      await _stopTrackingUseCase(orderId);
    }
  }

  void _onStreamResponse(
    BaseResponce<TrackingEntity> response,
    String orderId,
  ) {
    if (isClosed || orderId != _orderId) return;
    _emitResult(response);
  }

  void _onStreamError(Object error, String orderId) {
    if (isClosed || orderId != _orderId) return;
    _emitError(error);
  }

  void _emitResult(BaseResponce<TrackingEntity> response) {
    switch (response) {
      case SuccessResponce<TrackingEntity>(:final data):
        emit(
          state.copyWith(trackingState: BaseState<TrackingEntity>(data: data)),
        );
      case ErrorResponce<TrackingEntity>(:final errorMessage):
        emit(
          state.copyWith(
            trackingState: state.trackingState.copyWith(
              isLoading: false,
              errorMessage: errorMessage,
            ),
          ),
        );
    }
  }

  void _emitError(Object error) {
    emit(
      state.copyWith(
        trackingState: state.trackingState.copyWith(
          isLoading: false,
          errorMessage: HandelErrorException().handelErrorexception(
            error is Exception ? error : Exception(error.toString()),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
