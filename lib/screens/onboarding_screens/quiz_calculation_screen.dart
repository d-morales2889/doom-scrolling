import 'package:doomscrolling_mobile_app/constants/animation_constants.dart';
import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class QuizCalculationScreen extends StatefulWidget {
  const QuizCalculationScreen({
    super.key,
    required this.dailyHours,
  });

  final double dailyHours;

  @override
  State<QuizCalculationScreen> createState() => _QuizCalculationScreenState();
}

class _QuizCalculationScreenState extends State<QuizCalculationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _progressController;
  late final Animation<double> _fadeAnimation;

  String _currentText = '';
  bool _showingCalculation = false;
  bool _showingResult = false;
  double _yearsLost = 0;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: AnimationDurations.medium,
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: AnimationCurves.easeOut,
      ),
    );

    _startCalculation();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _startCalculation() async {
    // Initial fade in
    _fadeController.forward();

    // Show "Analyzing your habits..." for 1 second
    setState(() {
      _currentText = 'Analyzing your habits...';
    });
    await Future.delayed(const Duration(milliseconds: 1200));

    // Show calculation
    setState(() {
      _showingCalculation = true;
      _currentText = 'Calculating time impact...';
    });

    // Start progress animation
    _progressController.forward();
    await Future.delayed(const Duration(milliseconds: 2500));

    // Calculate result
    // Formula: (Daily Hours ÷ 16 waking hours) × 50 Years
    _yearsLost = (widget.dailyHours / 16) * 50;

    // Show result
    setState(() {
      _showingResult = true;
    });
  }

  String _getFormulaText() {
    return '${widget.dailyHours.toStringAsFixed(1)} hours ÷ 16 waking hours × 50 years';
  }

  String _getResultText() {
    if (_yearsLost < 1) {
      final months = (_yearsLost * 12).round();
      return '$months months';
    } else {
      return '${_yearsLost.toStringAsFixed(1)} years';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryText = AppTextColors.secondary(theme.brightness);

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              BrandColors.primary,
                              BrandColors.primary.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: BrandColors.primary.withOpacity(0.2),
                              offset: const Offset(0, 8),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.calculate_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        _currentText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Content
                      AnimatedSwitcher(
                        duration: AnimationDurations.medium,
                        child: _showingResult
                            ? _buildResult(theme, secondaryText)
                            : _showingCalculation
                                ? _buildCalculation(theme, secondaryText)
                                : _buildLoadingIndicator(theme),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showingResult)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: _ContinueButton(
                    onPressed: () {
                      // TODO: Navigate to next screen
                      Navigator.of(context).pop();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Column(
      key: const ValueKey('loading'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              BrandColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculation(ThemeData theme, Color secondaryText) {
    return Column(
      key: const ValueKey('calculation'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        AnimatedBuilder(
          animation: _progressController,
          builder: (context, child) {
            return Column(
              children: [
                Container(
                  height: 6,
                  width: 200,
                  decoration: BoxDecoration(
                    color: BrandColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
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
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${(_progressController.value * 100).round()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildResult(ThemeData theme, Color secondaryText) {
    return SingleChildScrollView(
      key: const ValueKey('result'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Result card
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  BrandColors.warning.withOpacity(0.15),
                  BrandColors.warning.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: BrandColors.warning.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'At your current pace, you could lose',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: secondaryText,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _getResultText(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 48,
                    color: BrandColors.warning,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'of your life to scrolling',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: secondaryText,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Formula explanation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: BrandColors.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: BrandColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'How we calculated this',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: BrandColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _getFormulaText(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on your answer of ${widget.dailyHours.toStringAsFixed(1)} hours per day, 16 waking hours, and an average of 50 years remaining.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: secondaryText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatefulWidget {
  const _ContinueButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

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
          child: const Text(
            'Continue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
