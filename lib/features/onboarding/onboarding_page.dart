import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../auth/presentation/pages/login_page.dart';
import '../splash/widgets/splash_particles.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _page = 0;

  void _next() {
    if (_page < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutCubic);
    } else {
      _finish();
    }
  }
  void _prev() {
    if (_page > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOutCubic);
    }
  }
  void _finish() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // 전역 다크 배경 (스플래시와 동일)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF11151D),
          ),
          // 파티클 효과 (스플래시와 동일)
          const SplashParticles(),
          // 웨이브/블러 효과 (필요시 subtle하게 유지)
          Positioned(
            left: -60,
            top: 80,
            child: Opacity(
              opacity: 0.10,
              child: _OnboardingWave(
                color: theme.colorScheme.primary,
                width: 320,
                height: 120,
                blur: 18,
              ),
            ),
          ),
          Positioned(
            right: -40,
            bottom: 120,
            child: Opacity(
              opacity: 0.08,
              child: _OnboardingWave(
                color: theme.colorScheme.primary,
                width: 260,
                height: 90,
                blur: 12,
              ),
            ),
          ),
          // 메인 슬라이드 (Center)
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 600,
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  // 1. 브랜드/신뢰
                  _OnboardingSlide(
                    background: const [Color(0xFF1B1F2A), Color(0xFF232536)],
                    child: SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                                ],
                              ),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                                width: 2.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                  blurRadius: 32,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 12),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 16,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.flash_on_rounded,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.95),
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 36),
                            child: Column(
                              children: [
                                Text(
                                  'CareSync',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context).colorScheme.onBackground,
                                    letterSpacing: 2.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        Theme.of(context).colorScheme.primary.withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                                        blurRadius: 12,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Enterprise Platform',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.85),
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 44),
                            child: Text(
                              '조직을 위한 스마트 일정·메모·성과 통합 플랫폼',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.75),
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 56),
                          _OnboardingAnimatedParticles(key: UniqueKey()),
                        ],
                      ),
                    ),
                  ),
                  // 2. 주요 기능/가치
                  _OnboardingSlide(
                    background: const [Color(0xFF232536), Color(0xFF11151D)],
                    child: SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _OnboardingFeatureCard(
                                key: UniqueKey(),
                                icon: Icons.event_note_rounded,
                                title: '일정',
                                desc: '스마트 일정 관리',
                              ),
                              const SizedBox(width: 18),
                              _OnboardingFeatureCard(
                                key: UniqueKey(),
                                icon: Icons.checklist_rounded,
                                title: '계획',
                                desc: '목표와 실행을 한눈에',
                              ),
                              const SizedBox(width: 18),
                              _OnboardingFeatureCard(
                                key: UniqueKey(),
                                icon: Icons.share_rounded,
                                title: '공유',
                                desc: '팀과 함께 협업',
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _OnboardingFeatureCard(
                                key: UniqueKey(),
                                icon: Icons.emoji_events_rounded,
                                title: '성과',
                                desc: '보상·동기부여',
                              ),
                              const SizedBox(width: 18),
                              _OnboardingFeatureCard(
                                key: UniqueKey(),
                                icon: Icons.beach_access_rounded,
                                title: '휴가',
                                desc: '연차·휴가 관리',
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text('모든 업무를 한 곳에서, 더 쉽고 안전하게',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.85))),
                          const SizedBox(height: 32),
                          _OnboardingAnimatedParticles(key: UniqueKey()),
                        ],
                      ),
                    ),
                  ),
                  // 3. 보안/신뢰/CTA
                  _OnboardingSlide(
                    background: const [Color(0xFF1B1F2A), Color(0xFF232536)],
                    child: SizedBox.expand(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                  Theme.of(context).colorScheme.primary.withOpacity(0.04),
                                ],
                              ),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                width: 1.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                                  blurRadius: 24,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                      Theme.of(context).colorScheme.primary.withOpacity(0.06),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                                    width: 1.2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.verified_user_rounded,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 36),
                            child: Column(
                              children: [
                                Text(
                                  '신뢰할 수 있는',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Enterprise Platform',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: _OnboardingMultiMessageText(
                              messages: const [
                                '복잡한 업무, CareSync로 간편하게',
                                '효율과 신뢰, 두 마리 토끼를 잡다',
                                '스마트한 협업, CareSync에서 시작하세요',
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                                textStyle: const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              onPressed: _finish,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('지금 시작하기'),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.2),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          _OnboardingAnimatedParticles(key: UniqueKey()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 인디케이터/버튼 (하단, 자연스럽게 띄움, 별도 배경/gradient 없음)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FuturisticIndicator(current: _page, total: 3),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_page > 0)
                        _OnboardingNavButton(
                          label: '이전',
                          onTap: _prev,
                          isPrimary: false,
                        ),
                      if (_page > 0) const SizedBox(width: 24),
                      if (_page < 2)
                        _OnboardingNavButton(
                          label: '다음',
                          onTap: _next,
                          isPrimary: true,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final List<Color> background;
  final Widget child;
  const _OnboardingSlide({required this.background, required this.child, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: background,
        ),
      ),
      child: child,
    );
  }
}

class _FuturisticShape extends StatelessWidget {
  final bool reverse;
  const _FuturisticShape({this.reverse = false});
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: reverse ? 0.7 : -0.7,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: reverse
                ? [const Color(0xFF5A6CFF), const Color(0xFF5EEAD4)]
                : [const Color(0xFF5EEAD4), const Color(0xFF5A6CFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      ),
    );
  }
}

class _FuturisticFeatureDot extends StatelessWidget {
  final Color color;
  const _FuturisticFeatureDot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.4)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _FuturisticIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _FuturisticIndicator({required this.current, required this.total});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) => AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: i == current ? 28 : 12,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: i == current
                ? [const Color(0xFF5EEAD4), const Color(0xFF5A6CFF)]
                : [Colors.white24, Colors.white10],
          ),
          boxShadow: i == current
              ? [BoxShadow(color: const Color(0xFF5EEAD4).withOpacity(0.18), blurRadius: 8, spreadRadius: 1)]
              : [],
        ),
      )),
    );
  }
}

class _OnboardingLogoPulse extends StatefulWidget {
  const _OnboardingLogoPulse({Key? key}) : super(key: key);
  @override
  State<_OnboardingLogoPulse> createState() => _OnboardingLogoPulseState();
}

class _OnboardingLogoPulseState extends State<_OnboardingLogoPulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = 0.5 + 0.5 * sin(_controller.value * 2 * pi);
        final logoSize = 80.0 + 2.0 * t;
        
        return Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? const Color(0xFF2A3142) : const Color(0xFFF8FAFC),
            border: Border.all(
              color: color.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 20 + 2 * t,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
              child: Icon(
                Icons.flash_on_rounded, 
                color: color.withOpacity(0.8), 
                size: 28
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _OnboardingFeatureCard({Key? key, required this.icon, required this.title, required this.desc}) : super(key: key);
  @override
  State<_OnboardingFeatureCard> createState() => _OnboardingFeatureCardState();
}

class _OnboardingFeatureCardState extends State<_OnboardingFeatureCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _hoverController;
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _hoverController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _hoverController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _hoverController]),
      builder: (context, child) {
        final scale = 0.92 + 0.08 * Curves.easeOutCubic.transform(_controller.value);
        final hoverScale = 1.0 + 0.02 * _hoverController.value;
        final finalScale = scale * hoverScale;
        
        return Transform.scale(
          scale: finalScale,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _hoverController.forward();
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 110,
              height: 140,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2330) : const Color(0xFFFAFBFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark 
                    ? const Color(0xFF2A3142) 
                    : const Color(0xFFE5E7EB),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.06),
                    blurRadius: _isHovered ? 20 : 12,
                    spreadRadius: 0,
                    offset: Offset(0, _isHovered ? 6 : 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(0.08),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 24,
                      color: primaryColor.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? const Color(0xFFE5E7EB) : const Color(0xFF111827),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.desc,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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

class _OnboardingSubtleParticles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withOpacity(0.13);
    return SizedBox(
      width: 180,
      height: 36,
      child: Stack(
        children: List.generate(7, (i) {
          final t = i / 7.0;
          return Positioned(
            left: 12.0 + 22.0 * i,
            top: 18 + 8 * sin(i * 1.7),
            child: Container(
              width: 10 + 4 * cos(i * 1.2),
              height: 10 + 4 * cos(i * 1.2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.18),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _OnboardingAnimatedParticles extends StatefulWidget {
  const _OnboardingAnimatedParticles({Key? key}) : super(key: key);
  @override
  State<_OnboardingAnimatedParticles> createState() => _OnboardingAnimatedParticlesState();
}

class _OnboardingAnimatedParticlesState extends State<_OnboardingAnimatedParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withOpacity(0.13);
    return SizedBox(
      width: 180,
      height: 36,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: List.generate(7, (i) {
              final t = i / 7.0;
              final phase = _controller.value * 2 * pi;
              return Positioned(
                left: 12.0 + 22.0 * i + 6 * sin(phase + i),
                top: 18 + 8 * sin(i * 1.7 + phase),
                child: Container(
                  width: 10 + 4 * cos(i * 1.2 + phase),
                  height: 10 + 4 * cos(i * 1.2 + phase),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.18),
                        blurRadius: 8,
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

class _OnboardingMultiMessageText extends StatefulWidget {
  final List<String> messages;
  const _OnboardingMultiMessageText({required this.messages});
  @override
  State<_OnboardingMultiMessageText> createState() => _OnboardingMultiMessageTextState();
}

class _OnboardingMultiMessageTextState extends State<_OnboardingMultiMessageText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  int _index = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _cycle();
  }
  void _cycle() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      await _controller.reverse();
      if (!mounted) return;
      setState(() => _index = (_index + 1) % widget.messages.length);
      await _controller.forward();
      if (!mounted) return;
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Text(
        widget.messages[_index],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onBackground,
          fontFamily: 'Inter',
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

// 온보딩 네비게이션 버튼 위젯 (Material 3 스타일, padding/shape/elevation/hover 효과)
class _OnboardingNavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  const _OnboardingNavButton({required this.label, required this.onTap, this.isPrimary = false});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: isPrimary
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: theme.colorScheme.primary.withOpacity(0.18),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 1.1),
              ),
              child: Text(label),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary, width: 1.2),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 1.1),
              ),
              child: Text(label),
            ),
    );
  }
}

// 미래적 물결/라이트/블러 효과 위젯
class _OnboardingWave extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final double blur;
  const _OnboardingWave({required this.color, required this.width, required this.height, this.blur = 0});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            if (blur > 0)
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: blur,
                spreadRadius: blur * 0.2,
              ),
          ],
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.4, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
} 