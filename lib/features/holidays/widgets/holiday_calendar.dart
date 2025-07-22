import 'package:flutter/material.dart';

class HolidayCalendar extends StatefulWidget {
  final List<Map<String, dynamic>> holidays;
  final void Function(Map<String, dynamic>) onCellTap;
  final String? myUserId;
  const HolidayCalendar({Key? key, required this.holidays, required this.onCellTap, this.myUserId}) : super(key: key);
  @override
  State<HolidayCalendar> createState() => _HolidayCalendarState();
}

class _HolidayCalendarState extends State<HolidayCalendar> {
  DateTime? selectedDate;

  Color? _getWeekdayColor(DateTime date) {
    if (date.weekday == DateTime.saturday) return const Color(0xFF60A5FA).withOpacity(0.1);
    if (date.weekday == DateTime.sunday) return const Color(0xFFEF4444).withOpacity(0.1);
    return null;
  }

  Color? _getWeekdayTextColor(DateTime date) {
    if (date.weekday == DateTime.saturday) return const Color(0xFF60A5FA);
    if (date.weekday == DateTime.sunday) return const Color(0xFFEF4444);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final firstDay = DateTime(year, month, 1);
    final startWeekday = firstDay.weekday % 7;
    final lastDay = DateTime(year, month + 1, 0).day;
    
    List<List<DateTime?>> weeks = [];
    int day = 1 - startWeekday;
    for (int w = 0; w < 6; w++) {
      List<DateTime?> row = [];
      for (int d = 0; d < 7; d++) {
        if (day < 1 || day > lastDay) {
          row.add(null);
        } else {
          row.add(DateTime(year, month, day));
        }
        day++;
      }
      weeks.add(row);
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF23262F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2B3040), width: 1),
      ),
      child: Column(
        children: [
          // 요일 헤더
          Row(
            children: ['일','월','화','수','목','금','토'].map((e) => Expanded(
              child: Center(
                child: Text(
                  e, 
                  style: TextStyle(
                    color: e == '토' ? const Color(0xFF60A5FA) : e == '일' ? const Color(0xFFEF4444) : const Color(0xFF8E95A7),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),
          // 달력 그리드
          ...weeks.map((row) => Row(
            children: row.map((date) {
              if (date == null) return const Expanded(child: SizedBox.shrink());
              
              final today = date.year == now.year && date.month == now.month && date.day == now.day;
              final selected = selectedDate != null && date.year == selectedDate!.year && date.month == selectedDate!.month && date.day == selectedDate!.day;
              
              final dayHolidays = widget.holidays.where((e) {
                final start = DateTime.parse(e['start']);
                final end = DateTime.parse(e['end']);
                return !date.isBefore(start) && !date.isAfter(end);
              }).toList();

              Color? cellColor;
              IconData? icon;
              String? status;
              
              if (dayHolidays.isNotEmpty) {
                final h = dayHolidays.first;
                status = h['status'];
                
                if (h['reason'] == '공휴일') {
                  cellColor = const Color(0xFFFACC15).withOpacity(0.15);
                  icon = Icons.flag;
                } else {
                  cellColor = const Color(0xFF5EEAD4).withOpacity(0.15);
                  icon = Icons.person;
                }
              }

              if (today) cellColor = const Color(0xFFEF4444).withOpacity(0.15);
              cellColor ??= _getWeekdayColor(date);

              final textColor = today
                  ? const Color(0xFFEF4444)
                  : selected
                      ? const Color(0xFF5EEAD4)
                      : _getWeekdayTextColor(date) ?? Colors.white;

              return Expanded(
                child: GestureDetector(
                  onTap: dayHolidays.isNotEmpty ? () {
                    setState(() => selectedDate = date);
                    widget.onCellTap(dayHolidays.first);
                  } : null,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(8),
                      border: today ? Border.all(color: const Color(0xFFEF4444), width: 2) : null,
                    ),
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${date.day}', 
                              style: TextStyle(
                                color: textColor, 
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (icon != null) ...[
                              const SizedBox(width: 4),
                              Icon(
                                icon, 
                                size: 12, 
                                color: status == '승인' ? const Color(0xFF5EEAD4) : const Color(0xFFFACC15),
                              ),
                            ]
                          ],
                        ),
                        if (dayHolidays.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: status == '승인' 
                                  ? const Color(0xFF5EEAD4).withOpacity(0.2)
                                  : status == '대기'
                                      ? const Color(0xFFFACC15).withOpacity(0.2)
                                      : const Color(0xFFEF4444).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              status ?? '',
                              style: TextStyle(
                                color: status == '승인' 
                                    ? const Color(0xFF5EEAD4)
                                    : status == '대기'
                                        ? const Color(0xFFFACC15)
                                        : const Color(0xFFEF4444),
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }
} 