import 'package:flutter/material.dart';
import '../widgets/profile_section.dart';
import '../widgets/notification_section.dart';
import '../widgets/security_section.dart';
import '../widgets/feedback_section.dart';
import '../widgets/appinfo_section.dart';
import '../widgets/custom_settings_section.dart';
import '../../../core/theme/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ThemeData appTheme = csTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.colorScheme.background,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appTheme.colorScheme.primary.withOpacity(0.10),
                border: Border.all(
                  color: appTheme.colorScheme.primary.withOpacity(0.22),
                  width: 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.settings_rounded,
                color: appTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '설정',
              style: appTheme.textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Colors.white),
            tooltip: '도움말',
            onPressed: () {
              // TODO: 도움말 페이지로 이동
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF181A20),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        children: [
          ProfileSection(),
          const Divider(color: Color(0xFF23262F)),
          CustomSettingsSection(),
          const Divider(color: Color(0xFF23262F)),
          NotificationSection(),
          const Divider(color: Color(0xFF23262F)),
          SecuritySection(),
          const Divider(color: Color(0xFF23262F)),
          FeedbackSection(),
          const Divider(color: Color(0xFF23262F)),
          AppInfoSection(),
          const Divider(color: Color(0xFF23262F)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: Colors.black),
              label: const Text('로그아웃', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5EEAD4),
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF23262F),
        title: const Text('로그아웃', style: TextStyle(color: Colors.white)),
        content: const Text('정말 로그아웃 하시겠습니까?', style: TextStyle(color: Color(0xFF8E95A7))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소', style: TextStyle(color: Color(0xFF5EEAD4))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: 실제 로그아웃 처리
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5EEAD4), foregroundColor: Colors.black),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
} 