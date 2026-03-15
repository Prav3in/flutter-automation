import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallary/main.dart';

class TestUtils {
  TestUtils._();

  static const Duration _settleTimeout = Duration(seconds: 10);
  static const Duration _networkDelay = Duration(seconds: 2);

  /// Pumps MyApp and waits for the initial frame to render.
  static Future<void> launchApp(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(_networkDelay);
  }

  /// Pumps until all animations and async operations settle.
  static Future<void> settle(WidgetTester tester) async {
    await tester.pumpAndSettle(_settleTimeout);
  }

  /// Pumps for a fixed duration — useful after network-dependent operations.
  static Future<void> wait(
    WidgetTester tester, [
    Duration duration = _networkDelay,
  ]) async {
    await tester.pump(duration);
  }

  /// Taps a screen coordinate outside any overlay (dialog/sheet) to dismiss it.
  /// Defaults to top-left corner which is always outside any centered overlay.
  static Future<void> tapOutsideOverlay(
    WidgetTester tester, {
    Offset position = const Offset(20, 80),
  }) async {
    await tester.tapAt(position);
    await settle(tester);
  }

  /// Drags a BottomSheet downward to dismiss it via the drag gesture.
  static Future<void> swipeDownBottomSheet(WidgetTester tester) async {
    final sheet = find.byType(BottomSheet);
    expect(sheet, findsOneWidget, reason: 'BottomSheet must be visible to swipe');
    await tester.drag(sheet, const Offset(0, 500));
    await settle(tester);
  }

  /// Returns true if the given finder matches at least one widget.
  static bool isVisible(Finder finder) => finder.evaluate().isNotEmpty;

  /// Performs a double-tap by tapping twice with a short interval.
  static Future<void> doubleTap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(finder);
    await settle(tester);
  }
}
