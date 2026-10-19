import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toEstimatedArrivalFormat() =>
      DateFormat('d MMMM yyyy, h:mm a').format(toLocal());
}
