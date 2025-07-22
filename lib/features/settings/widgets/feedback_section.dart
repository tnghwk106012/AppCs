import 'package:flutter/material.dart';

class FeedbackSection extends StatelessWidget {
  const FeedbackSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.feedback, color: Color(0xFF5EEAD4)),
      title: const Text('피드백/문의', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: const Text('버그 신고, 개선 제안'),
      onTap: () => showDialog(
        context: context,
        builder: (ctx) {
          final ctl = TextEditingController();
          return AlertDialog(
            backgroundColor: const Color(0xFF23262F),
            title: const Text('피드백/문의', style: TextStyle(color: Colors.white)),
            content: TextField(
              controller: ctl,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: '버그 신고, 개선 제안, 문의사항을 입력해 주세요.',
                hintStyle: TextStyle(color: Color(0xFF8E95A7)),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF181A20),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('취소', style: TextStyle(color: Color(0xFF5EEAD4))),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  showDialog(
                    context: context,
                    builder: (c2) => AlertDialog(
                      backgroundColor: const Color(0xFF23262F),
                      title: const Text('감사합니다!', style: TextStyle(color: Colors.white)),
                      content: const Text('피드백이 정상적으로 전송되었습니다.', style: TextStyle(color: Color(0xFF8E95A7))),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(c2).pop(),
                          child: const Text('닫기', style: TextStyle(color: Color(0xFF5EEAD4))),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5EEAD4), foregroundColor: Colors.black),
                child: const Text('전송'),
              ),
            ],
          );
        },
      ),
    );
  }
} 