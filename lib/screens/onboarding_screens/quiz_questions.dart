import 'package:doomscrolling_mobile_app/constants/animation_constants.dart';
import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class QuizQuestionsScreen extends StatefulWidget {
  const QuizQuestionsScreen({super.key});

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen>
    with TickerProviderStateMixin {
  final List<QuizQuestion> _questions = const [
    QuizQuestion(
      id: 'apps',
      prompt: 'Which apps are currently stealing your time?',
      subtitle: 'Select all that apply',
      options: [
        'TikTok',
        'Instagram Reels',
        'YouTube Shorts',
        'Twitter / X',
        'Reddit',
        'Other',
      ],
      multiSelect: true,
    ),
    QuizQuestion(
      id: 'when',
      prompt: 'When do you doom-scroll the most?',
      subtitle: 'Select all that apply',
      options: [
        'Right after waking up',
        'While on the toilet',
        'During work or study hours',
        'Late at night',
      ],
      multiSelect: true,
    ),
    QuizQuestion(
      id: 'feelings',
      prompt: 'How does your brain feel after a long scroll?',
      subtitle: 'Select all that apply',
      options: [
        'Foggy and numb',
        'Anxious or jealous',
        'Guilty or regretful',
        'Overstimulated but tired',
      ],
      multiSelect: true,
    ),
    QuizQuestion(
      id: 'screen_time',
      prompt: 'Be honest: What is your daily screen-time average?',
      options: [
        'Less than 1 hour',
        '1 - 3 hours',
        '3 - 5 hours',
        '5+ hours',
      ],
    ),
    QuizQuestion(
      id: 'ignored',
      prompt:
          'Have you ever ignored a person or task because you were scrolling?',
      options: [
        'Yes, frequently',
        'Yes, sometimes',
        'No, never',
      ],
    ),
    QuizQuestion(
      id: 'focus',
      prompt:
          'Do you find it hard to watch a movie or read without checking your phone?',
      options: [
        'Yes, I check constantly',
        'It is getting harder',
        'No, my focus is fine',
      ],
    ),
    QuizQuestion(
      id: 'attempts',
      prompt: 'How many times have you tried to limit social media before?',
      options: [
        'Never tried',
        '1 or 2 times',
        'Countless times',
      ],
    ),
    QuizQuestion(
      id: 'motivation',
      prompt: 'Why do you usually open these apps?',
      subtitle: 'Select all that apply',
      options: [
        'To escape stress or anxiety',
        'Pure boredom',
        'Fear of missing out',
        'Automatic reflex',
      ],
      multiSelect: true,
    ),
    QuizQuestion(
      id: 'reclaim',
      prompt:
          'If you reclaimed 3 hours a day, what would you do with that time?',
      subtitle: 'Select your top 3 goals',
      options: [
        'Start a side hustle',
        'Get fit or move more',
        'Learn a new skill',
        'Sleep better',
        'Other',
      ],
      multiSelect: true,
      maxSelections: 3,
    ),
    QuizQuestion(
      id: 'detox',
      prompt:
          'This journey requires consistency. Are you ready to take back control of your mind?',
      options: [
        'Yes, I am ready to take control',
        'No, I am okay with the brain rot',
      ],
    ),
  ];

  final Map<String, Set<int>> _selections = {};
  late final AnimationController _entranceController;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: AnimationDurations.slow,
    );
    _progressController = AnimationController(
      vsync: this,
      duration: AnimationDurations.medium,
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
    _progressController.dispose();
    super.dispose();
  }

  void _toggleOption(QuizQuestion question, int index) {
    setState(() {
      final selectedIndexes =
          _selections.putIfAbsent(question.id, () => <int>{});
      if (question.multiSelect) {
        if (selectedIndexes.contains(index)) {
          selectedIndexes.remove(index);
          _updateProgress();
          return;
        }

        final maxSelections = question.maxSelections;
        if (maxSelections != null && selectedIndexes.length >= maxSelections) {
          // Show feedback that max is reached
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You can only select up to $maxSelections options'),
              duration: const Duration(milliseconds: 1500),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        selectedIndexes.add(index);
      } else {
        selectedIndexes
          ..clear()
          ..add(index);
      }
      _updateProgress();
    });
  }

  void _updateProgress() {
    final answeredCount = _selections.values.where((s) => s.isNotEmpty).length;
    final progress = answeredCount / _questions.length;
    _progressController.animateTo(
      progress,
      duration: AnimationDurations.medium,
      curve: AnimationCurves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = AppTextColors.secondary(theme.brightness);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressController.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            BrandColors.primary,
                            BrandColors.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _entranceController,
                    child: Text(
                      'Understand Your Habits',
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
                      'Honest reflection leads to meaningful change. Take your time.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: secondary,
                        height: 1.6,
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: _questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final question = _questions[index];
                  final selected = _selections[question.id] ?? <int>{};

                  // Staggered entrance animation for cards
                  final delay = index * 50;
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
                      child: _QuestionCard(
                        question: question,
                        selectedIndexes: selected,
                        onOptionTap: (optionIndex) =>
                            _toggleOption(question, optionIndex),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: _SpringButton(
                onPressed: () {
                  // Show celebration animation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        '🌱 Beautiful. Your mindful journey begins now.',
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: BrandColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                child: const Text(
                  'Create My Path',
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

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    this.subtitle,
    this.multiSelect = false,
    this.maxSelections,
  });

  final String id;
  final String prompt;
  final String? subtitle;
  final List<String> options;
  final bool multiSelect;
  final int? maxSelections;
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selectedIndexes,
    required this.onOptionTap,
  });

  final QuizQuestion question;
  final Set<int> selectedIndexes;
  final ValueChanged<int> onOptionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceTint = theme.colorScheme.primary.withOpacity(0.04);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 6),
            blurRadius: 12,
            spreadRadius: -3,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
        border: Border.all(
          color: surfaceTint,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.prompt,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              height: 1.3,
              letterSpacing: -0.2,
            ),
          ),
          if (question.subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              question.subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTextColors.tertiary(theme.brightness),
                fontSize: 14,
                letterSpacing: 0.1,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(question.options.length, (index) {
              final isSelected = selectedIndexes.contains(index);
              return _AnimatedChip(
                label: question.options[index],
                isSelected: isSelected,
                onTap: () => onOptionTap(index),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Animated chip with spring selection animation
class _AnimatedChip extends StatefulWidget {
  const _AnimatedChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_AnimatedChip> createState() => _AnimatedChipState();
}

class _AnimatedChipState extends State<_AnimatedChip>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
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
    final theme = Theme.of(context);

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      offset: const Offset(0, 3),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 15,
              letterSpacing: 0.1,
            ),
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
