import 'package:flutter/material.dart';
import '../dashboard/dashboard_page.dart';
import '../plans/pages/plan_page.dart';
import '../schedules/pages/schedule_page.dart';
import '../shared/pages/share_page.dart';
import '../incentives/pages/incentive_list_page.dart';
import '../holidays/pages/holiday_calendar_page.dart';
import '../settings/pages/settings_page.dart';

class MainTabScaffold extends StatefulWidget {
  const MainTabScaffold({Key? key}) : super(key: key);
  @override
  State<MainTabScaffold> createState() => MainTabScaffoldState();
}

class MainTabScaffoldState extends State<MainTabScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const SchedulePage(),
    const PlanPage(),
    const SharePage(),
    const IncentiveListPage(),
    const HolidayCalendarPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF23262F),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF2B3040),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF23262F),
          selectedItemColor: const Color(0xFF5EEAD4),
          unselectedItemColor: const Color(0xFF8E95A7),
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              activeIcon: Icon(Icons.calendar_today_rounded),
              label: '일정',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_rounded),
              activeIcon: Icon(Icons.assignment_rounded),
              label: '계획',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.share_rounded),
              activeIcon: Icon(Icons.share_rounded),
              label: '공유',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_rounded),
              activeIcon: Icon(Icons.emoji_events_rounded),
              label: '성과',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.beach_access_rounded),
              activeIcon: Icon(Icons.beach_access_rounded),
              label: '휴가',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              activeIcon: Icon(Icons.settings_rounded),
              label: '설정',
            ),
          ],
        ),
      ),
    );
  }
} 