import 'package:flutter/material.dart';
import '../../features/schedules/models/schedule.dart';
import '../../features/plans/models/plan.dart';

class IntegratedShareWidget extends StatefulWidget {
  final Schedule schedule;
  final Plan? plan;
  final List<String> availableUsers;
  final Function(Schedule, List<String>, {String? message}) onShare;
  final Function(Schedule) onUnshare;
  final VoidCallback? onCancel;

  const IntegratedShareWidget({
    Key? key,
    required this.schedule,
    this.plan,
    required this.availableUsers,
    required this.onShare,
    required this.onUnshare,
    this.onCancel,
  }) : super(key: key);

  @override
  State<IntegratedShareWidget> createState() => _IntegratedShareWidgetState();
}

class _IntegratedShareWidgetState extends State<IntegratedShareWidget> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _selectedUsers = [];
  bool _includePlan = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF23262F),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.share,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '공유하기',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: widget.onCancel,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 공유할 내용 미리보기
          _buildSharePreview(theme),
          const SizedBox(height: 24),

          // 사용자 선택
          _buildUserSelection(theme),
          const SizedBox(height: 24),

          // 메시지 입력
          _buildMessageInput(theme),
          const SizedBox(height: 24),

          // 계획 포함 옵션
          if (widget.plan != null) ...[
            _buildPlanIncludeOption(theme),
            const SizedBox(height: 24),
          ],

          // 액션 버튼
          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildSharePreview(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '공유할 내용',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          
          // 일정 정보
          Row(
            children: [
              Icon(Icons.schedule, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.schedule.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${widget.schedule.time} • ${widget.schedule.location}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 계획 정보 (있는 경우)
          if (widget.plan != null && _includePlan) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.assignment, color: theme.colorScheme.secondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.plan!.method,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        widget.plan!.patient,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserSelection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '공유할 사용자',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: ListView.builder(
            itemCount: widget.availableUsers.length,
            itemBuilder: (context, index) {
              final user = widget.availableUsers[index];
              final isSelected = _selectedUsers.contains(user);
              
              return CheckboxListTile(
                title: Text(
                  user,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                value: isSelected,
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedUsers.add(user);
                    } else {
                      _selectedUsers.remove(user);
                    }
                  });
                },
                activeColor: theme.colorScheme.primary,
                checkColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '메시지 (선택사항)',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _messageController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: '공유할 메시지를 입력하세요...',
            hintStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPlanIncludeOption(ThemeData theme) {
    return Row(
      children: [
        Checkbox(
          value: _includePlan,
          onChanged: (value) {
            setState(() {
              _includePlan = value ?? false;
            });
          },
          activeColor: theme.colorScheme.primary,
          checkColor: Colors.white,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '계획 정보도 함께 공유',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                '연동된 계획 정보를 함께 공유합니다',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              '취소',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _selectedUsers.isEmpty ? null : _handleShare,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              '공유하기',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleShare() {
    if (_selectedUsers.isEmpty) return;
    
    widget.onShare(
      widget.schedule,
      _selectedUsers,
      message: _messageController.text.isNotEmpty ? _messageController.text : null,
    );
    
    Navigator.pop(context);
  }
} 