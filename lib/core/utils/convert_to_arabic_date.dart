import 'package:intl/intl.dart';

String convertToArabicDate(String isoString) {
  // Parse the ISO timestamp
  DateTime utcDateTime = DateTime.parse(isoString);

  // Convert to local timezone (optional, depending on your use case)
  DateTime localDateTime = utcDateTime.toLocal();

  // Determine AM or PM in Arabic
  String arabicPeriod = localDateTime.hour < 12 ? 'ص' : 'م';

  // Format time (12-hour format)
  String formattedDate = DateFormat('dd-MM-yyyy hh:mm').format(localDateTime);

  return 'تاريخ $formattedDate$arabicPeriod';
}
