sealed class TrackingException implements Exception {
  const TrackingException(
    this.message, {
    this.stopsPolling = false,
    this.countsAsFailure = true,
  });

  final String? message;
  final bool stopsPolling;

  final bool countsAsFailure;

  @override
  String toString() => message ?? runtimeType.toString();
}

final class TrackingNotAvailableException extends TrackingException {
  const TrackingNotAvailableException([String? message])
    : super(message, countsAsFailure: false);
}

/// 400 / invalid or empty order id.
final class TrackingInvalidRequestException extends TrackingException {
  const TrackingInvalidRequestException([String? message])
    : super(message, stopsPolling: true);
}

final class TrackingUnauthorizedException extends TrackingException {
  const TrackingUnauthorizedException([String? message])
    : super(message, stopsPolling: true);
}

final class TrackingForbiddenException extends TrackingException {
  const TrackingForbiddenException([String? message])
    : super(message, stopsPolling: true);
}

final class TrackingNotFoundException extends TrackingException {
  const TrackingNotFoundException([String? message])
    : super(message, stopsPolling: true);
}

/// Timeouts / no connection: keep polling, but it counts as a failure.
final class TrackingNetworkException extends TrackingException {
  const TrackingNetworkException([String? message]) : super(message);
}

/// 5xx and anything else unexpected.
final class TrackingServerException extends TrackingException {
  const TrackingServerException([String? message]) : super(message);
}
