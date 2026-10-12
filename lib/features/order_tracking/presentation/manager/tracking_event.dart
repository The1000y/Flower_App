sealed class TrackingEvent {}

class GetTrackingEvent extends TrackingEvent {
  final String orderId;

  GetTrackingEvent(this.orderId);
}

class StartTrackingEvent extends TrackingEvent {
  final String orderId;

  StartTrackingEvent(this.orderId);
}

class StopTrackingEvent extends TrackingEvent {}
