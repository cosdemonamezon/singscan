
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatTo(String pattern) {
    final format = DateFormat(pattern, 'th');
    return format.format(this);
  }
    String parseDDMMYYHm() {
    final date = DateFormat.yMMMd('th').format(DateTime.now());
    final time = DateFormat.Hm('th').format(DateTime.now());
    return 'วันที่ $date เวลา $time';
  }
}

// extension AppDateTime on TemporalDateTime {
//   String parseHm() {
//     return DateFormat.Hm('th').format(getDateTimeInUtc().add(Duration(hours: 7)));
//   }

//   String parseDDMMYYHm() {
//     final date = DateFormat.yMMMd('th').format(getDateTimeInUtc().add(Duration(hours: 7)));
//     final time = DateFormat.Hm('th').format(getDateTimeInUtc().add(Duration(hours: 7)));
//     return 'วันที่ $date เวลา $time';
//   }
// }
