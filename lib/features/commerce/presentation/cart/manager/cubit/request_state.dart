import 'package:equatable/equatable.dart';

/// Lifecycle of a single asynchronous operation.
///
/// Every network call in the Cart feature is described with one of four states,
/// so the UI never has to combine several booleans to know what is going on:
///
/// * [RequestIdle]    - nothing has happened yet.
/// * [RequestLoading] - the call is in flight.
/// * [RequestSuccess] - the call finished and produced [RequestSuccess.data].
/// * [RequestFailure] - the call failed with [RequestFailure.message].
///
/// Operations hold their own [RequestState] instance, which is what keeps them
/// independent: one operation loading never changes the state of another.
sealed class RequestState<T> extends Equatable {
  const RequestState();

  bool get isIdle => this is RequestIdle<T>;
  bool get isLoading => this is RequestLoading<T>;
  bool get isSuccess => this is RequestSuccess<T>;
  bool get isFailure => this is RequestFailure<T>;

  @override
  List<Object?> get props => const [];
}

/// The operation has not started yet.
class RequestIdle<T> extends RequestState<T> {
  const RequestIdle();
}

/// The operation is currently running.
class RequestLoading<T> extends RequestState<T> {
  const RequestLoading();
}

/// The operation completed successfully.
class RequestSuccess<T> extends RequestState<T> {
  final T data;

  const RequestSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

/// The operation failed with a human readable [message].
class RequestFailure<T> extends RequestState<T> {
  final String message;

  const RequestFailure(this.message);

  @override
  List<Object?> get props => [message];
}
