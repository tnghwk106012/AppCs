import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'dart:math';
import 'widgets/splash_particles.dart';
import '../onboarding/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnim;
  late Animation<double> _moveAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800));
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));
    _glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
    
    _fadeAnim = CurvedAnimation(parent: _mainController, curve: Curves.easeInOut);
    _moveAnim = Tween<double>(begin: 0, end: 18).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeInOutCubic));
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOutCubic));
    _pulseAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _glowAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
    
    _mainController.forward();
    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
    
    Future.delayed(const Duration(milliseconds: 4200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF11151D),
                  Color(0xFF232536),
                  Color(0xFF1B1F2A),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, _) => SplashParticles(progress: _pulseAnim.value),
          ),
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_fadeAnim, _moveAnim, _scaleAnim, _pulseAnim, _glowAnim]),
              builder: (context, child) {
                final pulseScale = 1.0 + 0.03 * sin(_pulseAnim.value * 2 * pi);
                final glowIntensity = 0.4 + 0.3 * sin(_glowAnim.value * 2 * pi);
                final blur = 14.0 * _fadeAnim.value + 18.0 * (1 - _fadeAnim.value) * (0.5 + 0.5 * sin(_pulseAnim.value * 2 * pi));
                return Opacity(
                  opacity: _fadeAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value * pulseScale,
                    child: Transform.translate(
                      offset: Offset(0, -_moveAnim.value),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                            child: const SizedBox(width: 320, height: 180),
                          ),
                          _UltimateLogoText(
                            strength: _fadeAnim.value, 
                            pulse: _pulseAnim.value,
                            glow: glowIntensity,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UltimateLogoText extends StatelessWidget {
  final double strength;
  final double pulse;
  final double glow;
  const _UltimateLogoText({
    this.strength = 1.0, 
    this.pulse = 0.0,
    this.glow = 0.0,
  });
  
  @override
  Widget build(BuildContext context) {
    final colorAnim = Color.lerp(const Color(0xFF5EEAD4), const Color(0xFF5A6CFF), 0.5 + 0.5 * sin(pulse * 2 * pi))!;
    final logoSize = 160.0 + 12.0 * pow(sin(pulse * 2 * pi), 3);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorAnim.withOpacity(0.18 + 0.08 * glow),
                colorAnim.withOpacity(0.08 + 0.04 * glow),
              ],
            ),
            border: Border.all(
              color: colorAnim.withOpacity(0.3 + 0.12 * glow),
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colorAnim.withOpacity(0.15 + 0.1 * glow),
                blurRadius: 44 + 12 * glow,
                spreadRadius: 0,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1 + 0.06 * glow),
                blurRadius: 22 + 6 * glow,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colorAnim.withOpacity(0.25 + 0.08 * glow),
                    colorAnim.withOpacity(0.1 + 0.06 * glow),
                  ],
                ),
                border: Border.all(
                  color: colorAnim.withOpacity(0.35 + 0.15 * glow),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorAnim.withOpacity(0.12 + 0.08 * glow),
                    blurRadius: 22 + 8 * glow,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.flash_on_rounded,
                color: colorAnim.withOpacity(0.98),
                size: 52,
              ),
            ),
          ),
        ),
        const SizedBox(height: 56),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            children: [
              Text(
                'CareSync',
                style: TextStyle(
                  fontSize: 52.0 + 6.0 * pow(sin(pulse * 2 * pi), 3),
                  fontWeight: FontWeight.w100,
                  letterSpacing: 3.5,
                  color: Color.lerp(const Color(0xFFE9ECF4), colorAnim, 0.5 + 0.5 * strength),
                  shadows: [
                    Shadow(
                      color: colorAnim.withOpacity(0.18 + 0.12 * glow),
                      blurRadius: 14 + 10 * glow,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorAnim.withOpacity(0.12 + 0.04 * glow),
                      colorAnim.withOpacity(0.06 + 0.02 * glow),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorAnim.withOpacity(0.25 + 0.12 * glow),
                    width: 1.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorAnim.withOpacity(0.1 + 0.06 * glow),
                      blurRadius: 18 + 6 * glow,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  'Enterprise Platform',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorAnim.withOpacity(0.95),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MutedFuturisticLoader extends StatefulWidget {
  const _MutedFuturisticLoader({Key? key}) : super(key: key);
  @override
  State<_MutedFuturisticLoader> createState() => _MutedFuturisticLoaderState();
}

class _MutedFuturisticLoaderState extends State<_MutedFuturisticLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColors = [
      const Color(0xFF5EEAD4), // _secondary
      const Color(0xFF5A6CFF), // _primary
      const Color(0xFF8E95A7), // _textMuted
    ];
    return SizedBox(
      width: 48,
      height: 24,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final t = (_controller.value + i * 0.22) % 1.0;
              final scale = 0.7 + 0.5 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
              final color = dotColors[i];
              return Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 10 * scale,
                  height: 10 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.82),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.18),
                        blurRadius: 8 * scale,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
} 