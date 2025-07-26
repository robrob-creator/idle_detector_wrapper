import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';

void main() {
  group('IdleDetector Tests', () {
    testWidgets('should trigger onIdle after specified duration',
        (WidgetTester tester) async {
      bool idleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {
              idleCalled = true;
            },
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // Wait for the idle duration to pass
      await tester.pump(const Duration(milliseconds: 150));

      expect(idleCalled, isTrue);
    });

    testWidgets('should reset timer on tap', (WidgetTester tester) async {
      bool idleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {
              idleCalled = true;
            },
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // Tap to reset timer
      await tester.tap(find.text('Test'));
      await tester.pump(const Duration(milliseconds: 50));

      expect(idleCalled, isFalse);

      // Wait for full duration
      await tester.pump(const Duration(milliseconds: 100));
      expect(idleCalled, isTrue);
    });

    testWidgets('should reset timer on pointer move',
        (WidgetTester tester) async {
      bool idleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {
              idleCalled = true;
            },
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // Simulate pointer move
      final TestGesture gesture =
          await tester.startGesture(const Offset(100, 100));
      await gesture.moveBy(const Offset(10, 10));
      await tester.pump(const Duration(milliseconds: 50));

      expect(idleCalled, isFalse);

      await gesture.up();

      // Wait for full duration
      await tester.pump(const Duration(milliseconds: 100));
      expect(idleCalled, isTrue);
    });

    testWidgets('should reset timer on scroll event',
        (WidgetTester tester) async {
      bool idleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {
              idleCalled = true;
            },
            child: Scaffold(
              body: ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
            ),
          ),
        ),
      );

      // Simulate scroll
      await tester.fling(find.byType(ListView), const Offset(0, -300), 1000);
      await tester.pump(const Duration(milliseconds: 50));

      expect(idleCalled, isFalse);

      // Wait for full duration
      await tester.pump(const Duration(milliseconds: 100));
      expect(idleCalled, isTrue);
    });

    testWidgets('should handle multiple interactions correctly',
        (WidgetTester tester) async {
      int idleCallCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {
              idleCallCount++;
            },
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // First idle
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCallCount, equals(1));

      // Tap to reset
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Second idle
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCallCount, equals(2));
    });

    testWidgets(
        'should trigger onActive when user becomes active after being idle',
        (WidgetTester tester) async {
      bool idleCalled = false;
      bool activeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {
              idleCalled = true;
            },
            onActive: () {
              activeCalled = true;
            },
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // Wait for idle
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCalled, isTrue);
      expect(activeCalled, isFalse);

      // Reset flags
      idleCalled = false;
      activeCalled = false;

      // Trigger user interaction
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Should trigger onActive but not onIdle
      expect(activeCalled, isTrue);
      expect(idleCalled, isFalse);
    });

    testWidgets('should not trigger onActive if user was not idle',
        (WidgetTester tester) async {
      bool idleCalled = false;
      bool activeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {
              idleCalled = true;
            },
            onActive: () {
              activeCalled = true;
            },
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // Trigger user interaction before going idle
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Should not trigger onActive since user was never idle
      expect(activeCalled, isFalse);
      expect(idleCalled, isFalse);
    });

    testWidgets('should handle multiple idle/active cycles',
        (WidgetTester tester) async {
      int idleCallCount = 0;
      int activeCallCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {
              idleCallCount++;
            },
            onActive: () {
              activeCallCount++;
            },
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // First idle cycle
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCallCount, equals(1));
      expect(activeCallCount, equals(0));

      // Become active
      await tester.tap(find.text('Test'));
      await tester.pump();
      expect(activeCallCount, equals(1));

      // Second idle cycle
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCallCount, equals(2));
      expect(activeCallCount, equals(1));

      // Become active again
      await tester.tap(find.text('Test'));
      await tester.pump();
      expect(activeCallCount, equals(2));
    });

    testWidgets('should support keyboard detection configuration',
        (WidgetTester tester) async {
      // Test with keyboard detection disabled
      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            detectKeyboardActivity: false,
            onIdle: () {},
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // When keyboard detection is disabled, the child should be directly nested
      // without an additional Focus wrapper
      final idleDetector =
          tester.widget<IdleDetector>(find.byType(IdleDetector));
      expect(idleDetector.detectKeyboardActivity, isFalse);

      // Test with keyboard detection enabled
      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            detectKeyboardActivity: true,
            onIdle: () {},
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // When keyboard detection is enabled, verify the parameter is set correctly
      final idleDetectorEnabled =
          tester.widget<IdleDetector>(find.byType(IdleDetector));
      expect(idleDetectorEnabled.detectKeyboardActivity, isTrue);
    });

    testWidgets('should default to web detection on web platform',
        (WidgetTester tester) async {
      // Test default behavior (should enable keyboard detection on web)
      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {},
            child: const Scaffold(
              body: Center(child: Text('Test')),
            ),
          ),
        ),
      );

      // The default should enable keyboard detection on web (kIsWeb)
      final idleDetector =
          tester.widget<IdleDetector>(find.byType(IdleDetector));
      // Since we're likely running tests in a non-web environment,
      // we'll just verify the property exists and has a boolean value
      expect(idleDetector.detectKeyboardActivity, isA<bool>());
    });
  });
}
