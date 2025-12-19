import 'package:doomscrolling_mobile_app/constants/animation_constants.dart';
import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:doomscrolling_mobile_app/screens/onboarding_screens/social_proof_screen.dart';
import 'package:flutter/material.dart';

class EducationalCarouselScreen extends StatefulWidget {
  const EducationalCarouselScreen({super.key});

  @override
  State<EducationalCarouselScreen> createState() =>
      _EducationalCarouselScreenState();
}

class _EducationalCarouselScreenState extends State<EducationalCarouselScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<CarouselPage> _pages = const [
    CarouselPage(
      title: 'The Dopamine Trap',
      subtitle:
          'Social apps are engineered to hijack your brain\'s reward system. It isn\'t a lack of willpower; it\'s biology.',
      category: 'The Science',
      emoji: '🧠',
      gradient: [Color(0xFF6B9080), Color(0xFF4A7C6F)],
    ),
    CarouselPage(
      title: 'Cognitive Erosion',
      subtitle:
          'Constant switching thins your prefrontal cortex, destroying your ability to focus on deep work.',
      category: 'The Damage',
      emoji: '⚡',
      gradient: [Color(0xFFC77D58), Color(0xFFB06847)],
    ),
    CarouselPage(
      title: '"Popcorn Brain"',
      subtitle:
          'Your brain is now wired for 15-second clips, making real life feel slow, boring, and anxious.',
      category: 'The Symptom',
      emoji: '🍿',
      gradient: [Color(0xFFA8AABC), Color(0xFF8E90A2)],
    ),
    CarouselPage(
      title: 'Neuroplasticity',
      subtitle:
          'The good news? Your brain is resilient. You can reset your dopamine baseline.',
      category: 'The Hope',
      emoji: '✨',
      gradient: [Color(0xFF6B9080), Color(0xFF5A8070)],
    ),
    CarouselPage(
      title: 'The Mindful Method',
      subtitle:
          'We use CBT and gamification to permanently rewire your habits.',
      category: 'The Solution',
      emoji: '🌱',
      gradient: [Color(0xFF6B9080), Color(0xFF4A7C6F)],
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SocialProofScreen(),
        ),
      );
    }
  }

  void _skipToEnd() {
    // TODO: Navigate to next screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _CarouselPageWidget(page: _pages[index]);
            },
          ),

          // Top Skip button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipToEnd,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
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
                    label: 'Continue',
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

class CarouselPage {
  const CarouselPage({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.emoji,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final String category;
  final String emoji;
  final List<Color> gradient;
}

class _CarouselPageWidget extends StatelessWidget {
  const _CarouselPageWidget({required this.page});

  final CarouselPage page;

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
              // Category label
              Text(
                page.category,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 32),

              // Emoji
              Text(
                page.emoji,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
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
                  fontSize: 18,
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
