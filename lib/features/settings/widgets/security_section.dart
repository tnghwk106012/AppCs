import 'package:flutter/material.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lock, color: Color(0xFF5EEAD4)),
      title: const Text('보안 설정', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: const Text('앱 잠금, 생체인증 등'),
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF23262F),
          title: const Text('보안 설정', style: TextStyle(color: Colors.white)),
          content: const Text('앱 잠금, 생체인증 등은 곧 지원됩니다.', style: TextStyle(color: Color(0xFF8E95A7))),
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