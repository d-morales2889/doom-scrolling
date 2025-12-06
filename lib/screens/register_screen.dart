import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final neutralText = theme.brightness == Brightness.dark
        ? const Color(0xFFCBD5F5)
        : const Color(0xFF64748B);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 84,
                child: Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.apps, color: primaryColor, size: 32),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join the clarity movement',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Stand with people who chose to break free from doomscrolling and reclaimed calm attention.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: neutralText,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _AuthButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata,
                onPressed: () =>
                    Navigator.of(context).pushNamed('/quiz-starter'),
              ),
              const SizedBox(height: 16),
              _AuthButton(
                label: 'Continue with Apple',
                icon: Icons.apple,
                onPressed: () =>
                    Navigator.of(context).pushNamed('/quiz-starter'),
              ),
              const SizedBox(height: 16),
              _AuthButton(
                label: 'Skip for now',
                icon: Icons.arrow_forward,
                onPressed: () =>
                    Navigator.of(context).pushNamed('/quiz-starter'),
                isTonal: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isTonal = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isTonal;

  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(32));
    if (isTonal) {
      return FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: shape,
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: shape,
      ),
    );
  }
}
