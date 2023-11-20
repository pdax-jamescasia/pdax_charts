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

String formatDateMonthYear(DateTime dateTime) {
  DateFormat formatter =
      DateFormat('MMM d YYYY'); // Format for "Jan 4", "Oct 12", etc.
  String formattedDate = formatter.format(dateTime);
  return formattedDate;
}

String formatMonthYear(DateTime dateTime) {
  DateFormat formatter = DateFormat('MMM YYYY');
  String formattedMonthYear = formatter.format(dateTime);
  return formattedMonthYear;
}
