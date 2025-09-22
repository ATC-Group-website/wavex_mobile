import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String formatDate(BuildContext context, String? dateTimeString) {
  if (dateTimeString == null || dateTimeString.isEmpty) {
    return '';
  }

  try {
    // Parse UTC to local time
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();

    // Get current locale from context
    String locale = Localizations.localeOf(context).toString();

    // Format with locale
    String dayNumber = DateFormat('d', locale).format(dateTime); // 1
    String weekday =
        DateFormat('EEEE', locale).format(dateTime); // Thursday / الخميس
    String month = DateFormat('MMMM', locale).format(dateTime); // June / يونيو
    String year = DateFormat('y', locale).format(dateTime); // 2025

    return '$dayNumber $weekday - $month - $year';
  } catch (e) {
    return '';
  }
}
