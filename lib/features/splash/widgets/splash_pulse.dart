import 'package:flutter/material.dart';

class SplashPulse extends StatefulWidget {
  const SplashPulse({super.key});
  @override
  State<SplashPulse> createState() => _SplashPulseState();
}

class _SplashPulseState extends State<SplashPulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: false);
    _pulseAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withOpacity(0.13);
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        final scale = 1.0 + 1.2 * _pulseAnim.value;
        final opacity = (1.0 - _pulseAnim.value).clamp(0.0, 1.0);
        return Center(
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(opacity),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(opacity * 0.7),
                    blurRadius: 48,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 