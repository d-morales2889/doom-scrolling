import 'package:doomscrolling_mobile_app/screens/onboarding_screens/quiz_questions.dart';
import 'package:doomscrolling_mobile_app/screens/onboarding_screens/quiz_starter_screen.dart';
import 'package:doomscrolling_mobile_app/screens/register_screen.dart';
import 'package:doomscrolling_mobile_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root of the application with brand theme and onboarding entry.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doomscrolling Coach',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: const WelcomeScreen(),
      routes: {
        '/register': (_) => const RegisterScreen(),
        '/quiz-starter': (_) => const QuizStarterScreen(),
        '/quiz': (_) => const QuizQuestionsScreen(),
      },
    );
  }
}

// Brand colors
const Color kPrimaryColor = Color(0xFF4F46E5); // Electric Indigo
const Color kWarningColor = Color(0xFFFB7185); // Soft Coral
const Color kLightBackground = Color(0xFFF8FAFC);
const Color kDarkBackground = Color(0xFF0F172A);

ThemeData _buildLightTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: kLightBackground,
    colorScheme:
        base.colorScheme.copyWith(primary: kPrimaryColor, error: kWarningColor),
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: const Color(0xFF1E293B),
      displayColor: const Color(0xFF1E293B),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        elevation: 0,
      ),
    ),
    cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)))),
  );
}

ThemeData _buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: kDarkBackground,
    colorScheme:
        base.colorScheme.copyWith(primary: kPrimaryColor, error: kWarningColor),
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: const Color(0xFFE6EEF8),
      displayColor: const Color(0xFFE6EEF8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        elevation: 0,
      ),
    ),
    cardTheme: const CardTheme(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)))),
  );
}
