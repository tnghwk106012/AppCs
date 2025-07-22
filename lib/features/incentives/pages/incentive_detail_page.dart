import 'package:flutter/material.dart';
import 'incentive_edit_page.dart';

class IncentiveDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const IncentiveDetailPage({Key? key, required this.data}) : super(key: key);
  @override
  State<IncentiveDetailPage> createState() => _IncentiveDetailPageState();
}

class _IncentiveDetailPageState extends State<IncentiveDetailPage> with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _controller;
  late Animation<double> _glowAnim;
  late String status;
  final List<String> statusList = ['지급완료', '예정', '보류'];
  List<Map<String, dynamic>> comments = [
    {'id': 1, 'text': '성과가 인상적입니다!', 'date': '2024-07-01'},
    {'id': 2, 'text': '증빙자료 첨부 바랍니다.', 'date': '2024-07-02'},
  ];
  final TextEditingController _commentCtl = TextEditingController();
  int _commentId = 3;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    status = widget.data['status'] ?? '지급완료';
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _commentCtl.dispose();
    super.dispose();
  }

  void addComment() {
    final text = _commentCtl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      comments.add({'id': _commentId++, 'text': text, 'date': DateTime.now().toString().substring(0, 10)});
      _commentCtl.clear();
    });
  }
  
  void removeComment(int id) {
    setState(() {
      comments.removeWhere((c) => c['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: const Text('성과 상세'), 
        backgroundColor: const Color(0xFF181A20), 
        elevation: 0.5, 
        shadowColor: theme.colorScheme.secondary.withOpacity(0.08)
      ),
      backgroundColor: const Color(0xFF181A20),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _glowAnim,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.secondary.withOpacity(0.18 + 0.22 * _glowAnim.value),
                        blurRadius: 24 + 12 * _glowAnim.value,
                        spreadRadius: 1 + 2 * _glowAnim.value,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.13), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified, color: theme.colorScheme.secondary, size: 22),
                          const SizedBox(width: 8),
                          Text('${data['date']}', style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text('${data['amount']}원', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: status,
                            dropdownColor: theme.colorScheme.surface,
                            items: statusList.map((s) => DropdownMenuItem(
                              value: s, 
                              child: Text(s, style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 13))
                            )).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => status = v);
                            },
                            style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 13),
                            underline: Container(),
                            icon: const Icon(Icons.expand_more, color: Color(0xFF5EEAD4)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (data['note'] != null && data['note'].toString().isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.sticky_note_2_outlined, color: theme.colorScheme.outline, size: 18),
                            const SizedBox(width: 6),
                            Expanded(child: Text(data['note'], style: TextStyle(color: theme.colorScheme.outline, fontSize: 16))),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.comment_outlined, color: theme.colorScheme.secondary, size: 20),
                const SizedBox(width: 8),
                Text('댓글', style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 18)),
                const Spacer(),
                Text('${comments.length}개', style: TextStyle(color: theme.colorScheme.outline, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_outline, color: theme.colorScheme.secondary, size: 16),
                            const SizedBox(width: 6),
                            Text('사용자', style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.w600, fontSize: 14)),
                            const Spacer(),
                            Text(comment['date'], style: TextStyle(color: theme.colorScheme.outline, fontSize: 12)),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => removeComment(comment['id']),
                              child: Icon(Icons.close, color: theme.colorScheme.outline, size: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(comment['text'], style: TextStyle(color: Colors.white, fontSize: 15)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentCtl,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요...',
                      hintStyle: TextStyle(color: theme.colorScheme.outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.secondary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: addComment,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.send, color: Colors.black, size: 20),
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