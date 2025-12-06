import 'package:flutter/animation.dart';

/// Standard animation durations for consistent timing across the app
/// Adjusted for more deliberate, calming feel
class AnimationDurations {
  AnimationDurations._();

  /// Fast animations (250ms) - for micro-interactions like button presses
  /// Slightly slower than typical for more deliberate feel
  static const Duration fast = Duration(milliseconds: 250);

  /// Medium animations (500ms) - for most UI transitions
  static const Duration medium = Duration(milliseconds: 500);

  /// Slow animations (900ms) - for page transitions and major UI changes
  /// More deliberate pacing
  static const Duration slow = Duration(milliseconds: 900);

  /// Extra slow (1200ms) - for dramatic reveals or celebrations
  static const Duration extraSlow = Duration(milliseconds: 1200);

  /// Gentle floating (4500ms) - for continuous subtle animations
  static const Duration floating = Duration(milliseconds: 4500);
}

/// Standard animation curves for consistent feel across the app
/// Emphasis on gentle, natural movement
class AnimationCurves {
  AnimationCurves._();

  /// Smooth ease out - gentle deceleration
  static const Curve easeOut = Curves.easeOutCubic;

  /// Ease in out - for reversible animations
  static const Curve easeInOut = Curves.easeInOutCubic;

  /// Gentle spring - subtle bounce for premium feel without being bouncy
  static const Curve gentleSpring = Curves.easeOutBack;

  /// Very gentle - for floating and breathing animations
  static const Curve veryGentle = Curves.easeInOutSine;

  /// Sharp - for quick, decisive movements (used sparingly)
  static const Curve sharp = Curves.easeOutExpo;
}

/// Standard delays for staggered animations
/// Increased for more breathing room
class AnimationDelays {
  AnimationDelays._();

  /// Tiny delay (75ms) - between closely related elements
  static const Duration tiny = Duration(milliseconds: 75);

  /// Short delay (150ms) - standard stagger between list items
  static const Duration short = Duration(milliseconds: 150);

  /// Medium delay (200ms) - between distinct UI sections
  static const Duration medium = Duration(milliseconds: 200);

  /// Long delay (300ms) - for dramatic sequential reveals
  static const Duration long = Duration(milliseconds: 300);
}
