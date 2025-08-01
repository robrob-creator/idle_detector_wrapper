import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('IdleDetector Timestamp Persistence Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPreferences.getInstance();
    });

    testWidgets('should have persistTimestamp enabled by default',
        (WidgetTester tester) async {
      bool idleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () => idleCalled = true,
            child: const Scaffold(body: Text('Test')),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);

      // Wait for idle timeout
      await tester.pump(const Duration(milliseconds: 150));

      expect(idleCalled, isTrue);
    });

    testWidgets(
        'should work with persistTimestamp disabled (backward compatibility)',
        (WidgetTester tester) async {
      bool idleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            persistTimestamp: false,
            onIdle: () => idleCalled = true,
            child: const Scaffold(body: Text('Test')),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);

      // Wait for idle timeout
      await tester.pump(const Duration(milliseconds: 150));

      expect(idleCalled, isTrue);
    });

    testWidgets('should use custom timestamp key', (WidgetTester tester) async {
      const customKey = 'custom_test_key';

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            timestampKey: customKey,
            onIdle: () {},
            child: const Scaffold(body: Text('Test')),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should handle user interaction correctly',
        (WidgetTester tester) async {
      bool idleCalled = false;
      bool activeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () => idleCalled = true,
            onActive: () => activeCalled = true,
            child: const Scaffold(
              body: Text('Test'),
            ),
          ),
        ),
      );

      // Tap to trigger user interaction
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Wait for idle timeout
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCalled, isTrue);

      // Tap again to trigger active
      await tester.tap(find.text('Test'));
      await tester.pump();

      expect(activeCalled, isTrue);
    });
  });
}
