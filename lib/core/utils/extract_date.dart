import 'package:intl/intl.dart';

String formatDate(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal(); // Convert to local time if needed
  return DateFormat('d/M/yyyy hh:mm a').format(dateTime);
}

String normalizeDate(String dateStr) {
  DateTime date;

  try {
    if (dateStr.contains('-')) {
      // Format: yyyy-MM-dd
      date = DateFormat('yyyy-MM-dd', 'en').parse(dateStr);
    } else if (dateStr.contains('/')) {
      // Format: dd/MM/yyyy
      date = DateFormat('dd/MM/yyyy', 'en').parse(dateStr);
    } else {
      throw FormatException("Unknown date format");
    }

    return DateFormat('dd/MM/yyyy', 'en').format(date);
  } catch (e) {
    print('Error parsing date: $e');
    return dateStr; // fallback to original string
  }
}