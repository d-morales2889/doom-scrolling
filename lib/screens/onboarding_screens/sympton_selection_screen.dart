import 'package:doomscrolling_mobile_app/constants/animation_constants.dart';
import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class SymptomSelectionScreen extends StatefulWidget {
  const SymptomSelectionScreen({super.key});

  @override
  State<SymptomSelectionScreen> createState() => _SymptomSelectionScreenState();
}

class _SymptomSelectionScreenState extends State<SymptomSelectionScreen>
    with SingleTickerProviderStateMixin {
  final Set<String> _selectedSymptoms = {};
  late final AnimationController _entranceController;

  final List<SymptomSection> _sections = const [
    SymptomSection(
      title: 'How is your mind reacting?',
      subtitle: 'Select all symptoms you experience frequently.',
      category: 'Mental Health (The Mind)',
      symptoms: [
        Symptom(
          id: 'brain_fog',
          emoji: '🧠',
          label: 'Brain Fog',
          description: 'Difficulty thinking clearly',
        ),
        Symptom(
          id: 'goldfish_attention',
          emoji: '🐠',
          label: '"Goldfish" Attention',
          description: 'Can\'t focus for >10 mins',
        ),
        Symptom(
          id: 'high_anxiety',
          emoji: '⚡',
          label: 'High Anxiety',
          description: 'Restless when not scrolling',
        ),
        Symptom(
          id: 'emotional_numbness',
          emoji: '😶',
          label: 'Emotional Numbness',
          description: 'Feeling "flat"',
        ),
        Symptom(
          id: 'information_overload',
          emoji: '🤯',
          label: 'Information Overload',
          description: 'Overwhelmed',
        ),
      ],
    ),
    SymptomSection(
      title: 'Have you noticed these physical side effects?',
      subtitle: 'The body keeps the score.',
      category: 'Physical Health (The Body)',
      symptoms: [
        Symptom(
          id: 'revenge_bedtime',
          emoji: '😴',
          label: 'Revenge Bedtime Procrastination',
          description: 'Staying up late',
        ),
        Symptom(
          id: 'eye_strain',
          emoji: '👀',
          label: 'Eye Strain / Headaches',
          description: '',
        ),
        Symptom(
          id: 'chronic_fatigue',
          emoji: '🔋',
          label: 'Chronic Fatigue',
          description: 'Tired even after sleeping',
        ),
        Symptom(
          id: 'sedentary',
          emoji: '📉',
          label: 'Sedentary Routine',
          description: 'Skipping exercise',
        ),
        Symptom(
          id: 'tech_neck',
          emoji: '👎',
          label: '"Tech Neck" / Posture Pain',
          description: '',
        ),
      ],
    ),
    SymptomSection(
      title: 'How is your presence with others?',
      subtitle: 'Addiction thrives in isolation.',
      category: 'Social Life (The Connection)',
      symptoms: [
        Symptom(
          id: 'phubbing',
          emoji: '📵',
          label: '"Phubbing"',
          description: 'Checking phone while talking to people',
        ),
        Symptom(
          id: 'social_isolation',
          emoji: '🏠',
          label: 'Social Isolation',
          description: 'Canceling plans to stay home',
        ),
        Symptom(
          id: 'comparison_trap',
          emoji: '😞',
          label: 'Comparison Trap',
          description: 'Feeling jealous of others\' lives',
        ),
        Symptom(
          id: 'ignoring_responsibilities',
          emoji: '🙉',
          label: 'Ignoring Responsibilities',
          description: 'Work/Chores piling up',
        ),
        Symptom(
          id: 'hiding_usage',
          emoji: '🤫',
          label: 'Hiding Usage',
          description: 'Scrolling in secret/bathroom',
        ),
      ],
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

  void _toggleSymptom(String symptomId) {
    setState(() {
      if (_selectedSymptoms.contains(symptomId)) {
        _selectedSymptoms.remove(symptomId);
      } else {
        _selectedSymptoms.add(symptomId);
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
                      'Recognize the Signs',
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
                      'Understanding your symptoms is the first step to healing.',
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

            // Sections
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: _sections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 32),
                itemBuilder: (context, sectionIndex) {
                  final section = _sections[sectionIndex];
                  final delay = sectionIndex * 100;

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
                      child: _SectionCard(
                        section: section,
                        selectedSymptoms: _selectedSymptoms,
                        onSymptomTap: _toggleSymptom,
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
                onPressed: _selectedSymptoms.isNotEmpty
                    ? () {
                        // TODO: Navigate to next screen
                        Navigator.of(context).pop();
                      }
                    : null,
                isEnabled: _selectedSymptoms.isNotEmpty,
                child: Text(
                  _selectedSymptoms.isEmpty
                      ? 'Select at least one symptom'
                      : 'Continue (${_selectedSymptoms.length} selected)',
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

class SymptomSection {
  const SymptomSection({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.symptoms,
  });

  final String title;
  final String subtitle;
  final String category;
  final List<Symptom> symptoms;
}

class Symptom {
  const Symptom({
    required this.id,
    required this.emoji,
    required this.label,
    this.description = '',
  });

  final String id;
  final String emoji;
  final String label;
  final String description;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.section,
    required this.selectedSymptoms,
    required this.onSymptomTap,
  });

  final SymptomSection section;
  final Set<String> selectedSymptoms;
  final ValueChanged<String> onSymptomTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryText = AppTextColors.secondary(theme.brightness);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category label
        Text(
          section.category,
          style: theme.textTheme.labelLarge?.copyWith(
            color: BrandColors.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),

        // Title
        Text(
          section.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),

        // Subtitle
        Text(
          section.subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: secondaryText,
            fontSize: 15,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),

        // Symptoms
        Column(
          children: section.symptoms.map((symptom) {
            final isSelected = selectedSymptoms.contains(symptom.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SymptomOption(
                symptom: symptom,
                isSelected: isSelected,
                onTap: () => onSymptomTap(symptom.id),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SymptomOption extends StatefulWidget {
  const _SymptomOption({
    required this.symptom,
    required this.isSelected,
    required this.onTap,
  });

  final Symptom symptom;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_SymptomOption> createState() => _SymptomOptionState();
}

class _SymptomOptionState extends State<_SymptomOption>
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? BrandColors.primary.withOpacity(0.08)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? BrandColors.primary
                  : theme.colorScheme.primary.withOpacity(0.12),
              width: widget.isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Circular checkbox
              AnimatedContainer(
                duration: AnimationDurations.fast,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? BrandColors.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected
                        ? BrandColors.primary
                        : theme.colorScheme.primary.withOpacity(0.3),
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
              const SizedBox(width: 12),

              // Emoji
              Text(
                widget.symptom.emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),

              // Label and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.symptom.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (widget.symptom.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.symptom.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTextColors.tertiary(theme.brightness),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
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
