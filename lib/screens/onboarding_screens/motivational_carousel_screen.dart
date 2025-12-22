import 'package:doomscrolling_mobile_app/constants/animation_constants.dart';
import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class MotivationalCarouselScreen extends StatefulWidget {
  const MotivationalCarouselScreen({super.key});

  @override
  State<MotivationalCarouselScreen> createState() =>
      _MotivationalCarouselScreenState();
}

class _MotivationalCarouselScreenState
    extends State<MotivationalCarouselScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<MotivationalPage> _pages = const [
    MotivationalPage(
      title: 'Welcome to the 1%',
      subtitle:
          'You have joined the minority of people who refuse to let algorithms control their life. Your subscription is active.',
      emoji: '🤝',
      gradient: [Color(0xFF6B9080), Color(0xFF4A7C6F)],
    ),
    MotivationalPage(
      title: 'You have done the hardest part',
      subtitle:
          'Most people know they have a problem, but they never act on it. By being here, you have already won the first battle.',
      emoji: '🏔️',
      gradient: [Color(0xFF5A8070), Color(0xFF4A6B60)],
    ),
    MotivationalPage(
      title: 'It won\'t always be easy',
      subtitle:
          'Your brain is used to cheap dopamine. In the next few days, it will fight back. You will feel bored, and you will feel the itch.',
      emoji: '🌩️',
      gradient: [Color(0xFF8E90A2), Color(0xFF7A7C8E)],
    ),
    MotivationalPage(
      title: 'Healing isn\'t a straight line',
      subtitle:
          'You might slip up. You might have a bad day. That is not failure; that is part of the rewiring process.',
      emoji: '〰️',
      gradient: [Color(0xFFA8AABC), Color(0xFF9496A8)],
    ),
    MotivationalPage(
      title: 'Every urge is a signal',
      subtitle:
          'When you feel the need to scroll, it\'s just your brain asking for comfort. We will teach you how to answer that call without a screen.',
      emoji: '🧱',
      gradient: [Color(0xFFC77D58), Color(0xFFB06847)],
    ),
    MotivationalPage(
      title: 'Trust the compound effect',
      subtitle:
          'One hour saved today seems small. But over a year, that is 15 days of pure life you get back.',
      emoji: '⏳',
      gradient: [Color(0xFF6B9080), Color(0xFF5A8070)],
    ),
    MotivationalPage(
      title: 'You are becoming free',
      subtitle:
          'You are no longer a "User." You are the Architect of your own attention.',
      emoji: '🦋',
      gradient: [Color(0xFF6B9080), Color(0xFF4A7C6F)],
    ),
    MotivationalPage(
      title: 'Your timeline starts now',
      subtitle:
          'Take a deep breath. Put your phone down after this setup. Let\'s get to work.',
      emoji: '🚀',
      gradient: [Color(0xFF6B9080), Color(0xFF4A7C6F)],
      isLaunch: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AnimationDurations.medium,
        curve: AnimationCurves.easeOut,
      );
    } else {
      // TODO: Navigate to main app
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // PageView with spring physics
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _MotivationalPageWidget(page: _pages[index]);
            },
          ),

          // Bottom navigation
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _PageIndicator(
                        isActive: index == _currentPage,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Continue button
                  _ContinueButton(
                    onPressed: _nextPage,
                    label: isLastPage ? 'Enter My Focus Garden' : 'Continue',
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

class MotivationalPage {
  const MotivationalPage({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
    this.isLaunch = false,
  });

  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradient;
  final bool isLaunch;
}

class _MotivationalPageWidget extends StatelessWidget {
  const _MotivationalPageWidget({required this.page});

  final MotivationalPage page;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: page.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji
              Text(
                page.emoji,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 40),

              // Title
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 24),

              // Subtitle
              Text(
                page.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AnimationDurations.fast,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _ContinueButton extends StatefulWidget {
  const _ContinueButton({
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AnimationDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: AnimationCurves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              color: BrandColors.primary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
