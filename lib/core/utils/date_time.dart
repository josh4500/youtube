import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String hourMinute({bool withMeridian = true}) {
    return DateFormat(withMeridian ? 'h:mm a' : 'h:mm').format(this);
  }
}
