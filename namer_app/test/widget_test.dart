// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:namer_app/main.dart';

void main() {
  testWidgets('Namer App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the Word Generator title is shown.
    expect(find.text('✨ WORD GENERATOR'), findsOneWidget);

    // Verify that 'Like' and 'Next' buttons are present.
    expect(find.text('Like'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Verify that a BigCard is present.
    expect(find.byType(BigCard), findsOneWidget);

    // Tap the 'Next' button and trigger a frame.
    await tester.tap(find.text('Next'));
    await tester.pump();
  });
}
