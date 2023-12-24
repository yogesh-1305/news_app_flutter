import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getCustomDateFormat(String? date,
      [String format = "dd MMM yyyy"]) {
    if (date != null) {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat(format).format(dateTime);
    } else {
      return "";
    }
  }

  static String utcToLocalTime(String utcTime,
      {String? format = 'EEE, dd MMM yy'}) {
    final utcDateTime = DateTime.parse(utcTime);
    final localDateTime = utcDateTime.toLocal();
    // format the date time to Mon, 12 Aug 2019
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(localDateTime);
    return formatted.toString();
  }

  static String getHoursAgo(String date) {
    final utcDateTime = DateTime.parse(date);
    final localDateTime = utcDateTime.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localDateTime);
    if (difference.inDays > 31) {
      return utcToLocalTime(date, format: 'EEE, dd MMM yy');
    } else if (difference.inDays > 7) {
      var week = (difference.inDays / 7).floor();
      if (week == 1) return '1 week ago';
      return '$week weeks ago';
    } else if (difference.inDays == 1) {
      return '${difference.inDays} day ago';
    } else if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours == 1) {
      return '${difference.inHours} hour ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hour ago';
    } else if (difference.inMinutes == 1) {
      return '${difference.inMinutes} minute ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return '${difference.inSeconds} seconds ago';
    }
  }
}
