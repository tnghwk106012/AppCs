import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(radius: 24, backgroundColor: Color(0xFF5EEAD4), child: Icon(Icons.person, color: Colors.black)),
      title: const Text('프로필 관리', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: const Text('이름, 이메일, 비밀번호 변경'),
      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF5EEAD4), size: 18),
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF23262F),
          title: const Text('프로필 관리', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('이름, 이메일, 비밀번호 변경 기능은 곧 지원됩니다.', style: TextStyle(color: Color(0xFF8E95A7))),
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