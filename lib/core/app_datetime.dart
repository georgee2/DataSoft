import 'package:intl/intl.dart';

class DateTimeFormating {
  static int daysBetween(from, to) {
    from = checkDateType(from);
    to = checkDateType(to);
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round() + 1;
  }

  static String formatMonthDate(date) {
    date = checkDateType(date);
    return DateFormat('dd MMM').format(date).toString();
  }

  static String formatYearDate(date) {
    date = checkDateType(date);
    return DateFormat(' yyyy').format(date).toString();
  }

  static String sendFormatDate(date) {
    date = checkDateType(date);
    return DateFormat('yyyy-MM-dd').format(date).toString();
  }

  static List formatTime(date) {
    DateTime time = DateFormat('HH:mm').parse(date.toString());
    return [DateFormat('h:mm').format(time), DateFormat('a').format(time)];
  }

  static formatCustomDate({required date, required String formatType}) {
    date = checkDateType(date);
    return DateFormat(formatType).format(date).toString();
  }

  static checkDateType(date) {
    return date.runtimeType == String ? DateTime.parse(date.toString()) : date;
  }

  static calculateHours(String startTime, String endTime) {
    Duration diff1 = DateTime.parse(startTime).difference(DateTime.parse(endTime));
    final toHours = diff1.inMinutes ~/ 60;
    final toMinutes = diff1.inMinutes % 60;
    return "$toHours.$toMinutes Hour";
  }
}
