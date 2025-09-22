import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/app_localization.dart';

class CalendarPager extends StatefulWidget {
  final Function(DateTime date)? onTap;

  const CalendarPager({super.key, required this.onTap});

  @override
  _CalendarPagerState createState() => _CalendarPagerState();
}

class _CalendarPagerState extends State<CalendarPager> {
  DateTime selectedDate = DateTime.now();
  final PageController _pageController = PageController(initialPage: 1000);
  int currentPage = 1000;

  String _getWeekdayShort(BuildContext context, int weekday) {
    switch (weekday) {
      case 1:
        return AppLocalizations.of(context).translate("calendar_mon");
      case 2:
        return AppLocalizations.of(context).translate("calendar_tue");
      case 3:
        return AppLocalizations.of(context).translate("calendar_wed");
      case 4:
        return AppLocalizations.of(context).translate("calendar_thu");
      case 5:
        return AppLocalizations.of(context).translate("calendar_fri");
      case 6:
        return AppLocalizations.of(context).translate("calendar_sat");
      case 7:
        return AppLocalizations.of(context).translate("calendar_sun");
      default:
        return "";
    }
  }

  Future<void> _pickMonthYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // 🔹 يمنع اختيار الماضي
      lastDate: DateTime(2100),
      helpText: "Select month and year",
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      widget.onTap!(selectedDate);
      int weeksOffset =
      ((picked.difference(DateTime.now()).inDays) / 7).floor();
      _pageController.jumpToPage(1000 + weeksOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    int offset = (currentPage - 1000).clamp(0, 9999);
    DateTime startDate = DateTime.now().add(Duration(days: offset * 7));
    String currentMonthYear = DateFormat("MMMM yyyy").format(startDate);

    return Column(
      children: [
        // 🔹 Month-Year Header as Button
        TextButton(
          onPressed: _pickMonthYear,
          child: Text(
            currentMonthYear,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E535F),
            ),
          ),
        ),

        SizedBox(
          height: 80,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              if (page < 1000) {
                _pageController.jumpToPage(1000);
                return;
              }
              setState(() {
                currentPage = page;
              });
            },
            itemBuilder: (context, pageIndex) {
              int offset = (pageIndex - 1000).clamp(0, 9999);
              DateTime startDate =
              DateTime.now().add(Duration(days: offset * 7));

              final dates = List.generate(7, (index) {
                return startDate.add(Duration(days: index));
              });

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: dates.map((date) {
                  final isSelected = date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;

                  final isPast = date.isBefore(
                      DateTime.now().subtract(const Duration(days: 1)));

                  return GestureDetector(
                    onTap: isPast
                        ? null // 🔹 disable old days
                        : () {
                      setState(() {
                        selectedDate = date;
                      });
                      widget.onTap!(date);
                    },
                    child: Opacity(
                      opacity: isPast ? 0.4 : 1, // 🔹 fade old days
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeekdayShort(context, date.weekday),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF45818B)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
