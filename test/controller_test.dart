import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';

void main() {
  group('IdleDetector Controller Tests', () {
    testWidgets('should pause and resume idle detection',
        (WidgetTester tester) async {
      final controller = IdleDetectorController();
      bool idleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            controller: controller,
            onIdle: () => idleCalled = true,
            child: const Scaffold(body: Text('Test')),
          ),
        ),
      );

      // Pause the detector
      controller.pause();
      expect(controller.isPaused, isTrue);

      // Wait longer than idle time - should not trigger idle
      await tester.pump(const Duration(milliseconds: 200));
      expect(idleCalled, isFalse);

      // Resume the detector
      controller.resume();
      expect(controller.isPaused, isFalse);

      // Now wait for idle time - should trigger idle
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCalled, isTrue);
    });

    testWidgets('should reset idle detection', (WidgetTester tester) async {
      final controller = IdleDetectorController();
      bool idleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            controller: controller,
            onIdle: () => idleCalled = true,
            child: const Scaffold(body: Text('Test')),
          ),
        ),
      );

      // Wait for idle
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCalled, isTrue);
      expect(controller.isIdle, isTrue);

      // Reset
      controller.reset();
      expect(controller.isIdle, isFalse);
    });

    testWidgets('should provide remaining time', (WidgetTester tester) async {
      final controller = IdleDetectorController();

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 1000),
            controller: controller,
            child: const Scaffold(body: Text('Test')),
          ),
        ),
      );

      // Check remaining time is available
      await tester.pump(const Duration(milliseconds: 100));
      final remainingTime = controller.remainingTime;
      expect(remainingTime, isNotNull);
      expect(remainingTime!.inMilliseconds, lessThan(1000));
      expect(remainingTime.inMilliseconds,
          greaterThan(800)); // Should be around 900ms
    });

    testWidgets('should handle pause with remaining time',
        (WidgetTester tester) async {
      final controller = IdleDetectorController();
      bool idleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 200),
            controller: controller,
            onIdle: () => idleCalled = true,
            child: const Scaffold(body: Text('Test')),
          ),
        ),
      );

      // Wait part of the idle time
      await tester.pump(const Duration(milliseconds: 100));

      // Pause
      controller.pause();
      final remainingWhenPaused = controller.remainingTime;
      expect(remainingWhenPaused, isNotNull);
      expect(remainingWhenPaused!.inMilliseconds, lessThan(200));

      // Wait longer than original idle time while paused
      await tester.pump(const Duration(milliseconds: 300));
      expect(idleCalled, isFalse); // Should not trigger while paused

      // Resume
      controller.resume();

      // Should trigger idle after the remaining time
      await tester.pump(remainingWhenPaused);
      expect(idleCalled, isTrue);
    });

    testWidgets('should not handle user interactions when paused',
        (WidgetTester tester) async {
      final controller = IdleDetectorController();
      bool idleCalled = false;
      bool activeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            controller: controller,
            onIdle: () => idleCalled = true,
            onActive: () => activeCalled = true,
            child: const Scaffold(body: Text('Test')),
          ),
        ),
      );

      // Wait for idle
      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCalled, isTrue);

      // Pause
      controller.pause();

      // Try to interact - should not trigger active callback
      await tester.tap(find.text('Test'));
      await tester.pump();

      expect(activeCalled, isFalse);
      expect(controller.isIdle, isTrue); // Should remain idle
    });

    testWidgets('should work without controller', (WidgetTester tester) async {
      bool idleCalled = false;

      // Test that the widget still works without a controller
      await tester.pumpWidget(
        MaterialApp(
          home: IdleDetector(
            idleTime: const Duration(milliseconds: 100),
            onIdle: () => idleCalled = true,
            child: const Scaffold(body: Text('Test')),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 150));
      expect(idleCalled, isTrue);
    });
  });
}
