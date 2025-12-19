import 'package:doomscrolling_mobile_app/constants/animation_constants.dart';
import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:doomscrolling_mobile_app/screens/onboarding_screens/goal_screen.dart';
import 'package:flutter/material.dart';

class SocialProofScreen extends StatefulWidget {
  const SocialProofScreen({super.key});

  @override
  State<SocialProofScreen> createState() => _SocialProofScreenState();
}

class _SocialProofScreenState extends State<SocialProofScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  final List<Testimonial> _testimonials = const [
    Testimonial(
      name: 'Chamath Palihapitiya',
      credential: 'Former VP of User Growth at Facebook',
      headline: 'We ripped society apart',
      body:
          'The short-term, dopamine-driven feedback loops that we have created are destroying how society works. No civil discourse, no cooperation, misinformation, mistruth.',
      source: 'Talk at Stanford Graduate School of Business',
    ),
    Testimonial(
      name: 'Dr. Anna Lembke',
      credential: 'Professor of Psychiatry, Stanford School of Medicine',
      headline: 'A hypodermic needle for the brain',
      body:
          'The smartphone is the modern-day hypodermic needle, delivering digital dopamine 24/7 for a wired generation. We\'ve transformed the world from a place of scarcity to a place of overwhelming abundance.',
      source: 'Her bestseller book, "Dopamine Nation"',
    ),
    Testimonial(
      name: 'Sean Parker',
      credential: 'Founding President of Facebook',
      headline: 'Exploiting human vulnerability',
      body:
          'We needed to sort of give you a little dopamine hit every once in a while... It\'s a social-validation feedback loop... exactly the kind of thing that a hacker like myself would come up with, because you\'re exploiting a vulnerability in human psychology.',
      source: 'Interview with Axios',
    ),
    Testimonial(
      name: 'Tristan Harris',
      credential: 'Former Google Design Ethicist / "The Social Dilemma"',
      headline: 'You are the product',
      body:
          'If you are not paying for the product, you are not the customer; you are the product being sold. It\'s a race to the bottom of the brain stem to extract your attention.',
      source: 'The Social Dilemma / Center for Humane Technology',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: AnimationDurations.slow,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryText = AppTextColors.secondary(theme.brightness);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _entranceController,
                    child: Text(
                      'They Know the Truth',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: _entranceController,
                    child: Text(
                      'Tech insiders who built these systems are warning us about the danger.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: secondaryText,
                        height: 1.6,
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Testimonials
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: _testimonials.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final testimonial = _testimonials[index];
                  final delay = index * 100;

                  final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _entranceController,
                      curve: Interval(
                        (delay / 1000).clamp(0.0, 0.5),
                        ((delay + 400) / 1000).clamp(0.0, 1.0),
                        curve: AnimationCurves.easeOut,
                      ),
                    ),
                  );

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: _TestimonialCard(testimonial: testimonial),
                    ),
                  );
                },
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: _SpringButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GoalScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
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

class Testimonial {
  const Testimonial({
    required this.name,
    required this.credential,
    required this.headline,
    required this.body,
    required this.source,
  });

  final String name;
  final String credential;
  final String headline;
  final String body;
  final String source;
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({required this.testimonial});

  final Testimonial testimonial;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryText = AppTextColors.secondary(theme.brightness);
    final tertiaryText = AppTextColors.tertiary(theme.brightness);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: BrandColors.primary.withOpacity(0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and credential
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                testimonial.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                testimonial.credential,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BrandColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Headline
          Text(
            '"${testimonial.headline}"',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              height: 1.3,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),

          // Body
          Text(
            testimonial.body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: secondaryText,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Source
          Row(
            children: [
              Icon(
                Icons.source_outlined,
                size: 14,
                color: tertiaryText,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Source: ${testimonial.source}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: tertiaryText,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
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
          padding: const EdgeInsets.symmetric(vertical: 16),
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
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
