// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:innerexec/main.dart';

void main() {
  testWidgets('Onboarding screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const InnerExecApp());

    // Verify that the onboarding screen displays the main title.
    expect(find.text('Create a\nWinning CV'), findsOneWidget);
    
    // Verify that the description text is displayed.
    expect(find.text('Build a professional CV that stands out and wins interviews.'), findsOneWidget);
  });
}
