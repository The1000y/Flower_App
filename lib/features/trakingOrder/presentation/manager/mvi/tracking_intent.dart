sealed class TrackingIntent {}

class GetTrackingIntent extends TrackingIntent {
  final String orderId;

  GetTrackingIntent(this.orderId);
}

class StartTrackingIntent extends TrackingIntent {
  final String orderId;

  StartTrackingIntent(this.orderId);
}

class StopTrackingIntent extends TrackingIntent {}
