import 'package:doomscrolling_mobile_app/constants/animation_constants.dart';
import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:doomscrolling_mobile_app/screens/onboarding_screens/personalized_plan_screen.dart';
import 'package:flutter/material.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen>
    with SingleTickerProviderStateMixin {
  final Set<String> _selectedGoals = {};
  late final AnimationController _entranceController;

  final List<Goal> _goals = const [
    Goal(
      id: 'deep_focus',
      emoji: '🧠',
      text: 'Regain Deep Focus',
      color: Color(0xFF6B46C1), // Deep Purple
    ),
    Goal(
      id: 'sleep',
      emoji: '😴',
      text: 'Fix Sleep Schedule',
      color: Color(0xFF1E3A8A), // Midnight Blue
    ),
    Goal(
      id: 'brain_fog',
      emoji: '🧘',
      text: 'Eliminate Brain Fog',
      color: Color(0xFF6B9080), // Sage Green
    ),
    Goal(
      id: 'time',
      emoji: '⏳',
      text: 'Reclaim 2+ Hours Daily',
      color: Color(0xFFEA580C), // Vibrant Orange
    ),
    Goal(
      id: 'family',
      emoji: '❤️',
      text: 'Be Present with Family',
      color: Color(0xFFE11D48), // Soft Red
    ),
    Goal(
      id: 'social_comparison',
      emoji: '🛡️',
      text: 'Stop Social Comparison',
      color: Color(0xFFEAB308), // Gold
    ),
    Goal(
      id: 'discipline',
      emoji: '🧗',
      text: 'Build Iron Discipline',
      color: Color(0xFF475569), // Slate Grey
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

  void _toggleGoal(String goalId) {
    setState(() {
      if (_selectedGoals.contains(goalId)) {
        _selectedGoals.remove(goalId);
      } else {
        _selectedGoals.add(goalId);
      }
    });
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
                      'What\'s Your Goal?',
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
                      'Select all that resonate with you. We\'ll personalize your journey.',
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

            // Goals
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: _goals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  final delay = index * 80;

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
                      child: _GoalPill(
                        goal: goal,
                        isSelected: _selectedGoals.contains(goal.id),
                        onTap: () => _toggleGoal(goal.id),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: _SpringButton(
                onPressed: _selectedGoals.isNotEmpty
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const PersonalizedPlanScreen(),
                          ),
                        );
                      }
                    : null,
                isEnabled: _selectedGoals.isNotEmpty,
                child: Text(
                  _selectedGoals.isEmpty
                      ? 'Select at least one goal'
                      : 'Continue (${_selectedGoals.length} selected)',
                  style: const TextStyle(
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

class Goal {
  const Goal({
    required this.id,
    required this.emoji,
    required this.text,
    required this.color,
  });

  final String id;
  final String emoji;
  final String text;
  final Color color;
}

class _GoalPill extends StatefulWidget {
  const _GoalPill({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  final Goal goal;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_GoalPill> createState() => _GoalPillState();
}

class _GoalPillState extends State<_GoalPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationDurations.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AnimationCurves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: AnimationDurations.fast,
          curve: AnimationCurves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.goal.color
                : widget.goal.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? widget.goal.color
                  : widget.goal.color.withOpacity(0.3),
              width: widget.isSelected ? 2 : 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.goal.color.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Emoji
              Text(
                widget.goal.emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Text(
                  widget.goal.text,
                  style: TextStyle(
                    color: widget.isSelected ? Colors.white : widget.goal.color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              // Checkmark
              AnimatedContainer(
                duration: AnimationDurations.fast,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? Colors.white.withOpacity(0.3)
                      : Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected
                        ? Colors.white
                        : widget.goal.color.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: widget.isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
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
    this.isEnabled = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isEnabled;

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
      onTapDown: widget.isEnabled ? _handleTapDown : null,
      onTapUp: widget.isEnabled ? _handleTapUp : null,
      onTapCancel: widget.isEnabled ? _handleTapCancel : null,
      onTap: widget.isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: AnimationDurations.fast,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isEnabled
                  ? [
                      BrandColors.primary,
                      BrandColors.primary.withOpacity(0.9),
                    ]
                  : [
                      BrandColors.primary.withOpacity(0.3),
                      BrandColors.primary.withOpacity(0.3),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: widget.isEnabled
                ? [
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
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: TextStyle(
              color: widget.isEnabled
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
