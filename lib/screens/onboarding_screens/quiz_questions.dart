import 'package:flutter/material.dart';

class QuizQuestionsScreen extends StatefulWidget {
  const QuizQuestionsScreen({super.key});

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
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

  void _toggleOption(QuizQuestion question, int index) {
    setState(() {
      final selectedIndexes =
          _selections.putIfAbsent(question.id, () => <int>{});
      if (question.multiSelect) {
        if (selectedIndexes.contains(index)) {
          selectedIndexes.remove(index);
          return;
        }

        final maxSelections = question.maxSelections;
        if (maxSelections != null && selectedIndexes.length >= maxSelections) {
          return;
        }

        selectedIndexes.add(index);
      } else {
        selectedIndexes
          ..clear()
          ..add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.brightness == Brightness.dark
        ? const Color(0xFFCBD5F5)
        : const Color(0xFF64748B);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Know your patterns',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'These questions let us tailor a calmer routine just for you.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: secondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _questions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    final selected = _selections[question.id] ?? <int>{};
                    return _QuestionCard(
                      question: question,
                      selectedIndexes: selected,
                      onOptionTap: (optionIndex) =>
                          _toggleOption(question, optionIndex),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Awesome. We will craft your detox plan.'),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: const Text('Finish setup'),
              ),
            ],
          ),
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
        borderRadius: BorderRadius.circular(26),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 12),
            blurRadius: 24,
          ),
        ],
        border: Border.all(color: surfaceTint),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.prompt,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          if (question.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              question.subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(question.options.length, (index) {
              final isSelected = selectedIndexes.contains(index);
              return ChoiceChip(
                label: Text(question.options[index]),
                selected: isSelected,
                onSelected: (_) => onOptionTap(index),
                selectedColor: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.05),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isSelected ? Colors.white : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
