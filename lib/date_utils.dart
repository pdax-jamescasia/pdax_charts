import 'package:intl/intl.dart';

String formatTimeOfDay(DateTime dateTime) {
  int hour = dateTime.hour;

  // Determine if it's AM or PM
  String period = hour < 12 ? 'AM' : 'PM';

  // Convert the hour to 12-hour format
  if (hour > 12) {
    hour -= 12;
  }
  if (hour == 0) {
    hour = 12;
  }

  // Construct the formatted string
  String formattedTime = '$hour$period';

  return formattedTime;
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
