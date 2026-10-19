sealed class TrackingEvent {}

class GetTrackingEvent extends TrackingEvent {
  final String orderId;

  GetTrackingEvent(this.orderId);
}

class StartTrackingIntent extends TrackingEvent {
  final String orderId;

  StartTrackingIntent(this.orderId);
}

class StopTrackingIntent extends TrackingEvent {}

class ConfirmDeliveryIntent extends TrackingEvent {}
