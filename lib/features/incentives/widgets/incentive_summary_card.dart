import 'package:flutter/material.dart';

class IncentiveSummaryCard extends StatefulWidget {
  final List<Map<String, dynamic>> incentives;
  const IncentiveSummaryCard({Key? key, required this.incentives}) : super(key: key);
  @override
  State<IncentiveSummaryCard> createState() => _IncentiveSummaryCardState();
}

class _IncentiveSummaryCardState extends State<IncentiveSummaryCard> with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _controller;
  late Animation<double> _glowAnim;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void _onTapDown(_) {
    setState(() => _pressed = true);
    _controller.forward();
  }
  void _onTapUp(_) {
    setState(() => _pressed = false);
    _controller.reverse();
  }
  @override
  Widget build(BuildContext context) {
    int total = widget.incentives.fold(0, (sum, e) => sum + (e['amount'] as int));
    Map<String, dynamic>? last = widget.incentives.isNotEmpty ? widget.incentives.last : null;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (d) => _onTapUp(d),
      onTapCancel: () {
        setState(() => _pressed = false);
        _controller.reverse();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _glowAnim,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.18 + 0.22 * _glowAnim.value),
                    blurRadius: 24 + 12 * _glowAnim.value,
                    spreadRadius: 1 + 2 * _glowAnim.value,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.13), width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('총 성과', style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 15)),
                        const SizedBox(height: 6),
                        Text('$total원', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 22)),
                      ],
                    ),
                    if (last != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('최근 성과', style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 15)),
                          const SizedBox(height: 6),
                          Text('${last['amount']}원', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('${last['date']}', style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 13)),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 