import 'package:flutter/material.dart';
import 'holiday_request_page.dart';

class HolidayDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const HolidayDetailPage({Key? key, required this.data}) : super(key: key);

  void _showCancelDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('휴가 취소'),
        content: const Text('정말로 이 휴가를 취소하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('아니오')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('예')),
        ],
      ),
    );
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('휴가가 취소되었습니다.')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('휴가 상세'), backgroundColor: const Color(0xFF181A20)),
      backgroundColor: const Color(0xFF181A20),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(data['status'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: data['status'] == '승인' ? const Color(0xFF5EEAD4).withOpacity(0.18) : data['status'] == '대기' ? const Color(0xFFFACC15).withOpacity(0.18) : Colors.red.withOpacity(0.18),
                  labelStyle: TextStyle(color: data['status'] == '승인' ? const Color(0xFF5EEAD4) : data['status'] == '대기' ? const Color(0xFFFACC15) : Colors.red),
                ),
                const SizedBox(width: 12),
                Text('${data['start']} ~ ${data['end']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 18),
            Text('사유: ${data['reason']}', style: const TextStyle(color: Color(0xFF8E95A7), fontSize: 16)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => HolidayRequestPage(data: data)),
                  ),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('편집'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5EEAD4),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _showCancelDialog(context),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('취소'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 