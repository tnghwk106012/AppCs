import 'package:flutter/material.dart';

class AppInfoSection extends StatelessWidget {
  const AppInfoSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline, color: Color(0xFF5EEAD4)),
      title: const Text('앱 정보', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: const Text('버전, 약관, 개인정보처리방침'),
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF23262F),
          title: const Text('앱 정보', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('버전: 1.0.0', style: TextStyle(color: Color(0xFF8E95A7))),
              SizedBox(height: 10),
              Text('이용약관, 개인정보처리방침 등은 곧 지원됩니다.', style: TextStyle(color: Color(0xFF8E95A7))),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('닫기', style: TextStyle(color: Color(0xFF5EEAD4))),
            ),
          ],
        ),
      ),
    );
  }
} 