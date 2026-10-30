import 'package:intl/intl.dart';

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


  static String formatRelativeTime(String? date) {
    if (date == null || date.isEmpty) return 'N/A';

    final dateTime = parseUtc(date);
    if (dateTime == null) return 'N/A';

    final now = DateTime.now();

    if (dateTime.isAfter(now)) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    }

    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    }

    if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }

    if (difference.inDays < 31) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    }

    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }

    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  static DateTime? parseUtc(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      var normalized = value.contains('T') ? value : value.replaceFirst(' ', 'T');

      // Only treat as "needs Z" if there's no existing timezone info
      final hasTimezone = normalized.endsWith('Z') ||
          RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(normalized);

      final withTz = hasTimezone ? normalized : '${normalized}Z';
      return DateTime.parse(withTz).toLocal();
    } catch (e) {
      // log("Failed to parse date: $value, error: $e");
      return null;
    }
  }


}