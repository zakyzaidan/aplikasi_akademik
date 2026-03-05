import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateOnly(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static String formatTimeOnly(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

  static String formatDateTimeWithDay(DateTime dateTime) {
    return DateFormat('EEEE, dd-MM-yyyy HH:mm', 'id_ID').format(dateTime);
  }

  static DateTime parseDateTime(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }

  static String toIso8601String(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}
