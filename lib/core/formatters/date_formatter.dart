// import 'package:intl/intl.dart';
// String formatDate(String date) {
//   final parsedDate = DateTime.parse(date);
//   return DateFormat('d MMM yyyy').format(parsedDate);
// }

class DateFormatter {
  static String formatDate(String date) {
    final parsedDate = DateTime.parse(date);

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${parsedDate.day} '
        '${months[parsedDate.month - 1]} '
        '${parsedDate.year}';
  }
}