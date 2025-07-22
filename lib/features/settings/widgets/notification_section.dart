import 'package:flutter/material.dart';

class NotificationSection extends StatefulWidget {
  const NotificationSection({Key? key}) : super(key: key);
  @override
  State<NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  bool notificationsOn = true;
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: notificationsOn,
      onChanged: (v) {
        setState(() => notificationsOn = v);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF23262F),
            title: const Text('알림 설정', style: TextStyle(color: Colors.white)),
            content: Text(v ? '알림이 활성화되었습니다.' : '알림이 비활성화되었습니다.', style: const TextStyle(color: Color(0xFF8E95A7))),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('확인', style: TextStyle(color: Color(0xFF5EEAD4))),
              ),
            ],
          ),
        );
      },
      title: const Text('알림', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: const Text('앱 푸시 알림 수신 여부', style: TextStyle(color: Color(0xFF8E95A7))),
      activeColor: const Color(0xFF5EEAD4),
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: const Color(0xFF23262F),
    );
  }
} 