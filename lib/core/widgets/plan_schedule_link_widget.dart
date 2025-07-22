import 'package:flutter/material.dart';
import '../../features/schedules/models/schedule.dart';
import '../../features/plans/models/plan.dart';

class PlanScheduleLinkWidget extends StatelessWidget {
  final Schedule? schedule;
  final Plan? plan;
  final VoidCallback? onPlanTap;
  final VoidCallback? onScheduleTap;
  final VoidCallback? onLink;
  final VoidCallback? onUnlink;
  final bool showActions;

  const PlanScheduleLinkWidget({
    Key? key,
    this.schedule,
    this.plan,
    this.onPlanTap,
    this.onScheduleTap,
    this.onLink,
    this.onUnlink,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (schedule != null && schedule!.isPlanRelated && plan != null) {
      return _buildLinkedContent(context, theme);
    } else if (schedule != null && !schedule!.isPlanRelated) {
      return _buildUnlinkedSchedule(context, theme);
    } else if (plan != null) {
      return _buildUnlinkedPlan(context, theme);
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildLinkedContent(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.link,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '연동된 계획',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (showActions && onUnlink != null)
                IconButton(
                  icon: Icon(
                    Icons.link_off,
                    color: theme.colorScheme.error,
                    size: 18,
                  ),
                  onPressed: onUnlink,
                  tooltip: '연동 해제',
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPlanInfo(context, theme),
          if (schedule != null) ...[
            const SizedBox(height: 12),
            _buildScheduleInfo(context, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildUnlinkedSchedule(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '일정 정보',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (showActions && onLink != null)
                IconButton(
                  icon: Icon(
                    Icons.link,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  onPressed: onLink,
                  tooltip: '계획과 연동',
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildScheduleInfo(context, theme),
        ],
      ),
    );
  }

  Widget _buildUnlinkedPlan(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '계획 정보',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPlanInfo(context, theme),
        ],
      ),
    );
  }

  Widget _buildPlanInfo(BuildContext context, ThemeData theme) {
    if (plan == null) return const SizedBox.shrink();
    
    return GestureDetector(
      onTap: onPlanTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  plan!.method,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(plan!.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    plan!.status,
                    style: TextStyle(
                      color: _getStatusColor(plan!.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan!.goal,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (plan!.therapistName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    plan!.therapistName!,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleInfo(BuildContext context, ThemeData theme) {
    if (schedule == null) return const SizedBox.shrink();
    
    return GestureDetector(
      onTap: onScheduleTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  schedule!.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScheduleStatusColor(schedule!.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getScheduleStatusText(schedule!.status),
                    style: TextStyle(
                      color: _getScheduleStatusColor(schedule!.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  schedule!.time,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  schedule!.location,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  schedule!.patientName,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '완료':
        return Colors.green;
      case '진행중':
        return Colors.orange;
      case '대기':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getScheduleStatusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'waiting':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getScheduleStatusText(String status) {
    switch (status) {
      case 'done':
        return '완료';
      case 'in_progress':
        return '진행중';
      case 'waiting':
        return '대기';
      default:
        return status;
    }
  }
} 