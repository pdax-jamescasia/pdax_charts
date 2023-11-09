import 'package:intl/intl.dart';

String formatTimeOfDay(DateTime dateTime) {
  final DateFormat dateFormat = DateFormat('MMM d ha');
  return dateFormat.format(dateTime);
}

String formatDayOfWeek(DateTime dateTime) {
  DateFormat formatter = DateFormat(
      'E'); // 'E' stands for abbreviated day of the week (e.g., "Wed", "Tue")
  String formattedDayOfWeek = formatter.format(dateTime);
  return formattedDayOfWeek;
}

String formatDateMonth(DateTime dateTime) {
  DateFormat formatter =
      DateFormat('MMM d'); // Format for "Jan 4", "Oct 12", etc.
  String formattedDateTime = formatter.format(dateTime);
  return formattedDateTime;
}
