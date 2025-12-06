import 'package:doomscrolling_mobile_app/constants/animation_constants.dart';
import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _floatingController;
  late final Animation<double> _iconFadeIn;
  late final Animation<double> _iconScale;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;
  late final Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    // Entrance animations controller
    _entranceController = AnimationController(
      vsync: this,
      duration: AnimationDurations.slow,
    );

    // Continuous floating animation for icon - slower for calming effect
    _floatingController = AnimationController(
      vsync: this,
      duration: AnimationDurations.floating,
    )..repeat(reverse: true);

    // Icon animations
    _iconFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.3, curve: AnimationCurves.easeOut),
      ),
    );

    _iconScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.4, curve: AnimationCurves.gentleSpring),
      ),
    );

    // Title animations
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.6, curve: AnimationCurves.easeOut),
      ),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    // Subtitle animations
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 0.7, curve: AnimationCurves.easeOut),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    // Button animations
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 1.0, curve: AnimationCurves.gentleSpring),
      ),
    );

    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    // Floating animation - gentle breathing motion
    _floatingAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: AnimationCurves.veryGentle,
      ),
    );

    // Start entrance animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final subtitleColor = AppTextColors.secondary(theme.brightness);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  // Animated icon with floating effect
                  SizedBox(
                    height: 84,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _iconFadeIn,
                          _iconScale,
                          _floatingAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value),
                            child: Transform.scale(
                              scale: _iconScale.value,
                              child: Opacity(
                                opacity: _iconFadeIn.value,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        primaryColor,
                                        primaryColor.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.2),
                                        offset: const Offset(0, 6),
                                        blurRadius: 20,
                                      ),
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.08),
                                        offset: const Offset(0, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.self_improvement,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Animated title
                          SlideTransition(
                            position: _titleSlide,
                            child: FadeTransition(
                              opacity: _titleFade,
                              child: Text(
                                'Take a Breath',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 44,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Animated subtitle
                          SlideTransition(
                            position: _subtitleSlide,
                            child: FadeTransition(
                              opacity: _subtitleFade,
                              child: Text(
                                'Let\'s help you reclaim your time and reconnect with what truly matters.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: subtitleColor,
                                  fontSize: 17,
                                  height: 1.6,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
            // Animated button with blur backdrop
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _buttonSlide,
                child: FadeTransition(
                  opacity: _buttonFade,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.scaffoldBackgroundColor.withOpacity(0.0),
                          theme.scaffoldBackgroundColor.withOpacity(0.8),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                    child: _SpringButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/register'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Begin Your Journey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward,
                              size: 20, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A button with spring animation on press for premium feel
class _SpringButton extends StatefulWidget {
  const _SpringButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  State<_SpringButton> createState() => _SpringButtonState();
}

class _SpringButtonState extends State<_SpringButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                BrandColors.primary,
                BrandColors.primary.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: BrandColors.primary.withOpacity(0.25),
                offset: const Offset(0, 6),
                blurRadius: 20,
              ),
              BoxShadow(
                color: BrandColors.primary.withOpacity(0.12),
                offset: const Offset(0, 2),
                blurRadius: 10,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
