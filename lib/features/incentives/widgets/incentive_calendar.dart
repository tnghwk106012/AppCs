import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncentiveCalendar extends StatefulWidget {
  final List<Map<String, dynamic>> incentives;
  final void Function(Map<String, dynamic>) onCellTap;
  const IncentiveCalendar({Key? key, required this.incentives, required this.onCellTap}) : super(key: key);
  @override
  State<IncentiveCalendar> createState() => _IncentiveCalendarState();
}

class _IncentiveCalendarState extends State<IncentiveCalendar> {
  DateTime? selectedDate;
  final _wonFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0);
  
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
              final dayIncs = widget.incentives.where((e) => e['date'] == "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}").toList();
              final totalAmount = dayIncs.fold<int>(0, (sum, e) => sum + (e['amount'] as int));
              
              Color? cellColor;
              if (today) {
                cellColor = const Color(0xFFEF4444).withOpacity(0.15);
              } else if (selected) {
                cellColor = const Color(0xFF5EEAD4).withOpacity(0.15);
              } else {
                cellColor = _getWeekdayColor(date);
              }

              final textColor = today
                  ? const Color(0xFFEF4444)
                  : selected
                      ? const Color(0xFF5EEAD4)
                      : _getWeekdayTextColor(date) ?? Colors.white;

              return Expanded(
                child: GestureDetector(
                  onTap: dayIncs.isNotEmpty ? () {
                    setState(() => selectedDate = date);
                    widget.onCellTap(dayIncs.first);
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
                        Text(
                          '${date.day}', 
                          style: TextStyle(
                            color: textColor, 
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (dayIncs.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${_wonFormat.format(totalAmount)}원', 
                            style: const TextStyle(
                              color: Color(0xFF5EEAD4), 
                              fontWeight: FontWeight.bold, 
                              fontSize: 10,
                            ),
                          ),
                          if (dayIncs.length > 1) ...[
                            const SizedBox(height: 1),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5EEAD4).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '+${dayIncs.length - 1}건',
                                style: const TextStyle(
                                  color: Color(0xFF5EEAD4),
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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

class _AnimatedGlowCell extends StatefulWidget {
  final Widget child;
  final bool glow;
  const _AnimatedGlowCell({required this.child, this.glow = false});
  @override
  State<_AnimatedGlowCell> createState() => _AnimatedGlowCellState();
}
class _AnimatedGlowCellState extends State<_AnimatedGlowCell> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnim;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        return Container(
          decoration: widget.glow
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.18 + 0.22 * _glowAnim.value),
                      blurRadius: 18 + 10 * _glowAnim.value,
                      spreadRadius: 1 + 2 * _glowAnim.value,
                    ),
                  ],
                )
              : null,
          child: widget.child,
        );
      },
    );
  }
} 