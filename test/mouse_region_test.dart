import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';

void main() {
  group('IdleDetector MouseRegion Tests', () {
    testWidgets('should handle mouse enter events',
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
              body: SizedBox(
                width: 200,
                height: 200,
                child: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Wait for idle timeout
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCalled, isTrue);

      // Reset for next test
      idleCalled = false;

      // Simulate mouse enter event
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: const Offset(100, 100));
      await gesture.moveTo(const Offset(100, 100));
      await tester.pump();

      expect(activeCalled, isTrue);
    });

    testWidgets('should handle mouse hover events',
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
              body: SizedBox(
                width: 200,
                height: 200,
                child: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Wait for idle timeout
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCalled, isTrue);

      // Simulate mouse hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: const Offset(50, 50));
      await gesture.moveTo(const Offset(60, 60));
      await tester.pump();

      expect(activeCalled, isTrue);
    });

    testWidgets('should handle mouse exit events', (WidgetTester tester) async {
      bool interactionDetected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () {},
            onActive: () => interactionDetected = true,
            child: const Scaffold(
              body: SizedBox(
                width: 200,
                height: 200,
                child: Text('Test'),
              ),
            ),
          ),
        ),
      );

      // Start idle
      await tester.pump(const Duration(milliseconds: 150));

      // Simulate mouse entering and then exiting the region
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: const Offset(100, 100));
      await gesture.moveTo(const Offset(300, 300)); // Move outside
      await tester.pump();

      expect(interactionDetected, isTrue);
    });

    testWidgets('should work with existing gesture detection',
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

      // Wait for idle
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCalled, isTrue);

      // Test tap still works alongside MouseRegion
      await tester.tap(find.text('Test'));
      await tester.pump();

      expect(activeCalled, isTrue);
    });
  });
}
