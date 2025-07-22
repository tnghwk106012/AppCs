import 'dart:math';
import 'package:flutter/material.dart';

class SplashParticles extends StatefulWidget {
  final double progress;
  const SplashParticles({super.key, this.progress = 0.0});
  @override
  State<SplashParticles> createState() => _SplashParticlesState();
}

class _SplashParticlesState extends State<SplashParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _random = Random();
  final int _particleCount = 18;
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _particles = List.generate(_particleCount, (i) => _Particle.random(_random, i));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      const Color(0xFF5A6CFF),
      const Color(0xFF5EEAD4),
      const Color(0xFF8E95A7),
      const Color(0xFF232536),
      const Color(0xFF1B1F2A),
      const Color(0xFF4C5BD8),
      const Color(0xFF23C981),
      const Color(0xFFFFB547),
      const Color(0xFFFF4D4F),
      const Color(0xFFF5F6FA),
    ];
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final sync = (widget.progress + _controller.value) % 1.0;
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlesPainter(
            particles: _particles,
            progress: sync,
            colors: colors,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double baseX, baseY, baseRadius, amplitude, speed, blur, phase, pulseSpeed, pulseStrength, waveSpeed, waveStrength, popChance;
  final int colorIdx;
  _Particle({
    required this.baseX,
    required this.baseY,
    required this.baseRadius,
    required this.amplitude,
    required this.speed,
    required this.blur,
    required this.phase,
    required this.pulseSpeed,
    required this.pulseStrength,
    required this.waveSpeed,
    required this.waveStrength,
    required this.popChance,
    required this.colorIdx,
  });
  factory _Particle.random(Random random, int colorIdx) {
    return _Particle(
      baseX: 0.5 + (random.nextDouble() - 0.5) * 0.9,
      baseY: 0.5 + (random.nextDouble() - 0.5) * 0.9,
      baseRadius: 18 + random.nextDouble() * 38,
      amplitude: 24 + random.nextDouble() * 60,
      speed: 0.5 + random.nextDouble() * 1.7,
      blur: 14 + random.nextDouble() * 32,
      phase: random.nextDouble() * 2 * pi,
      pulseSpeed: 0.7 + random.nextDouble() * 1.5,
      pulseStrength: 0.10 + random.nextDouble() * 0.28,
      waveSpeed: 0.5 + random.nextDouble() * 1.2,
      waveStrength: 0.10 + random.nextDouble() * 0.22,
      popChance: random.nextDouble(),
      colorIdx: colorIdx % 12,
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final List<Color> colors;
  _ParticlesPainter({required this.particles, required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final appear = Curves.easeInOut.transform((sin(t * pi) + 1) / 2);
      final angle = 2 * pi * (p.colorIdx / particles.length) + p.phase;
      final dist = p.amplitude * appear + 16 * sin(progress * 2 * pi * p.waveSpeed + p.phase) * p.waveStrength;
      final dx = center.dx + cos(angle) * dist + (p.baseX - 0.5) * size.width * (1 - appear);
      final dy = center.dy + sin(angle) * dist + (p.baseY - 0.5) * size.height * (1 - appear);
      final pulse = 1 + p.pulseStrength * sin(progress * 2 * pi * p.pulseSpeed + p.phase);
      double pop = 1.0;
      if (p.popChance > 0.7) {
        final popT = (progress * 2 + p.phase) % 1.0;
        if (popT > 0.85) {
          pop = 1.0 + 2.5 * pow((popT - 0.85) * 7, 2) * (1.0 - (popT - 0.85) * 7).clamp(0.0, 1.0);
        }
      }
      final radius = p.baseRadius * (0.7 + 0.5 * appear) * pulse * pop;
      final opacity = (0.18 * appear + 0.08) * (0.7 + 0.3 * pulse) * (pop > 1.0 ? (2.0 - pop).clamp(0.0, 1.0) : 1.0);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors[p.colorIdx].withOpacity(opacity),
            colors[p.colorIdx].withOpacity(0.06 * appear),
          ],
        ).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: radius))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.blur * (0.7 + 0.5 * appear) * (0.8 + 0.4 * pulse) * (pop > 1.0 ? 1.5 : 1.0))
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) => true;
} 