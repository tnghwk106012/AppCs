import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/splash/splash_page.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/main/main_tab_scaffold.dart';
import 'features/plans/pages/plan_page.dart';
import 'features/schedules/pages/schedule_page.dart';
import 'features/shared/pages/share_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/incentives/pages/incentive_list_page.dart';
import 'features/holidays/pages/holiday_calendar_page.dart';
import 'features/settings/pages/settings_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainTabScaffold(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainTabScaffold(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/plans',
      builder: (context, state) => const PlanPage(),
    ),
    GoRoute(
      path: '/schedules',
      builder: (context, state) => const SchedulePage(),
    ),
    GoRoute(
      path: '/shares',
      builder: (context, state) => const SharePage(),
    ),
    GoRoute(
      path: '/incentives',
      builder: (context, state) => const IncentiveListPage(),
    ),
    GoRoute(
      path: '/holidays',
      builder: (context, state) => const HolidayCalendarPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
); 