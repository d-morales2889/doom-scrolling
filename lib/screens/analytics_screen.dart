import 'package:doomscrolling_mobile_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 80,
                  color: BrandColors.primary.withOpacity(0.3),
                ),
                const SizedBox(height: 24),
                Text(
                  'Analytics',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Coming soon',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppTextColors.secondary(theme.brightness),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
