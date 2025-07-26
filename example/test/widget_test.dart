// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('IdleDetector demo app loads correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the idle detector demo loads with initial state
    expect(find.text('Status: Active'), findsOneWidget);
    expect(find.text('Times gone idle: 0'), findsOneWidget);

    // Verify the keyboard detection toggle is present
    expect(find.text('Keyboard Detection:'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);

    // Verify the reset button is present
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('Keyboard detection toggle works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find the switch widget
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    // Get initial switch state (should be true by default)
    Switch switchWidget = tester.widget(switchFinder);
    expect(switchWidget.value, isTrue);

    // Tap the switch to toggle it
    await tester.tap(switchFinder);
    await tester.pump();

    // Verify switch state changed
    switchWidget = tester.widget(switchFinder);
    expect(switchWidget.value, isFalse);
  });
}
