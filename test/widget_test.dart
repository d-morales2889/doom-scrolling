import 'package:flutter_test/flutter_test.dart';

import 'package:doomscrolling_mobile_app/main.dart';

void main() {
  testWidgets('Onboarding flow reaches quiz questions screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);

    await tester.tap(find.text('Start Quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Join the clarity movement'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text("Let's Start!"), findsOneWidget);
    expect(find.text('Your calm routine starts with you'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Know your patterns'), findsOneWidget);
    expect(find.text('Which apps are currently stealing your time?'),
        findsOneWidget);
  });
}
