import 'dart:async';
import 'package:doomscrolling_mobile_app/constants/animation_constants.dart';
import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:doomscrolling_mobile_app/screens/analytics_screen.dart';
import 'package:doomscrolling_mobile_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: BrandColors.primary,
        unselectedItemColor:
            AppTextColors.tertiary(Theme.of(context).brightness),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Original home screen content moved to _HomeTab
class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  bool _showInterventionModal = false;

  // Mocked data - would come from onboarding in real app
  final List<Goal> _selectedGoals = const [
    Goal(id: 'deep_focus', emoji: '🧠', text: 'Regain Deep Focus'),
    Goal(id: 'sleep', emoji: '😴', text: 'Fix Sleep Schedule'),
    Goal(id: 'brain_fog', emoji: '🧘', text: 'Eliminate Brain Fog'),
  ];

  // Mock clean time tracking
  int _dayCount = 1;
  Duration _cleanTime = const Duration(hours: 4, minutes: 23);

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

    // Mock timer for clean time
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          _cleanTime = _cleanTime + const Duration(minutes: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _showIntervention() {
    setState(() {
      _showInterventionModal = true;
    });
  }

  void _closeIntervention() {
    setState(() {
      _showInterventionModal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryText = AppTextColors.secondary(theme.brightness);
    final primaryGoal = _selectedGoals.first;

    // Calculate ring progress based on time of day (0-100%)
    final now = DateTime.now();
    final dayProgress = (now.hour * 60 + now.minute) / (24 * 60);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              child: Column(
                children: [
                  // Header - Day count with streak
                  FadeTransition(
                    opacity: _entranceController,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Day $_dayCount',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 36,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '🔥',
                              style: TextStyle(fontSize: 32),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current Streak',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Dopamine Ring
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _entranceController,
                      curve: const Interval(0.2, 1.0),
                    ),
                    child: _DopamineRing(
                      progress: dayProgress,
                      emoji: primaryGoal.emoji,
                      cleanTime: _cleanTime,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Goals List Header
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _entranceController,
                      curve: const Interval(0.4, 1.0),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What you\'re healing',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // All Goals List
                  ..._selectedGoals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final goal = entry.value;
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _entranceController,
                        curve: Interval(
                          0.4 + (index * 0.1),
                          1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GoalCard(
                          goal: goal,
                          secondaryText: secondaryText,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            // Panic Button (Sticky Footer)
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _entranceController,
                  curve: const Interval(0.6, 1.0),
                ),
                child: _PanicButton(onPressed: _showIntervention),
              ),
            ),

            // Intervention Modal
            if (_showInterventionModal)
              _InterventionModal(onClose: _closeIntervention),
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
  });

  final String id;
  final String emoji;
  final String text;
}

class Symptom {
  const Symptom({
    required this.id,
    required this.emoji,
    required this.label,
  });

  final String id;
  final String emoji;
  final String label;
}

class _DopamineRing extends StatelessWidget {
  const _DopamineRing({
    required this.progress,
    required this.emoji,
    required this.cleanTime,
  });

  final double progress;
  final String emoji;
  final Duration cleanTime;

  @override
  Widget build(BuildContext context) {
    final hours = cleanTime.inHours;
    final minutes = cleanTime.inMinutes % 60;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 16,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                BrandColors.primary.withOpacity(0.1),
              ),
            ),
          ),
          // Progress ring
          SizedBox(
            width: 280,
            height: 280,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress),
              duration: AnimationDurations.slow,
              curve: AnimationCurves.easeOut,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 16,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    BrandColors.primary,
                  ),
                  strokeCap: StrokeCap.round,
                );
              },
            ),
          ),
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 12),
              Text(
                '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Clean Time',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTextColors.secondary(
                        Theme.of(context).brightness,
                      ),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.secondaryText,
  });

  final Goal goal;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: BrandColors.primary.withOpacity(0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            goal.emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              goal.text,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Icon(
            Icons.check_circle,
            color: BrandColors.primary.withOpacity(0.3),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _PanicButton extends StatefulWidget {
  const _PanicButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_PanicButton> createState() => _PanicButtonState();
}

class _PanicButtonState extends State<_PanicButton>
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
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                BrandColors.warning,
                BrandColors.warning.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: BrandColors.warning.withOpacity(0.3),
                offset: const Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.bolt,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'I feel the urge...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      letterSpacing: 0.3,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterventionModal extends StatelessWidget {
  const _InterventionModal({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: BrandColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.self_improvement,
                  color: BrandColors.warning,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Take a Breath',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                'You\'re feeling the urge. That\'s okay. Let\'s work through this together.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTextColors.secondary(theme.brightness),
                  height: 1.5,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Placeholder for intervention content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BrandColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Intervention tools will be added here',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BrandColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
