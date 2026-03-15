import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../locators/gallary.screen.dart';
import '../utils/test_utils.dart';
import '../utils/test_logger.dart';

/// Page Object for the Gallery (Home) screen.
/// Encapsulates all interactions and assertions for the gallery view.
class GalleryPage {
  final WidgetTester tester;

  static const _page = 'GalleryPage';

  GalleryPage(this.tester);

  // ─── Verification Methods ─────────────────────────────────────────────────────

  /// Asserts the gallery scaffold is present — screen has loaded.
  Future<void> verifyScreenLoaded() async {
    TestLogger.verify(_page, 'Gallery screen scaffold is visible');
    expect(
      GalleryScreen.scaffold,
      findsOneWidget,
      reason: 'Gallery scaffold should be visible',
    );
  }

  /// Asserts the "Gallery" title text is displayed.
  Future<void> verifyTitle() async {
    TestLogger.verify(_page, 'Gallery title text is present');
    expect(
      GalleryScreen.header,
      findsOneWidget,
      reason: '"Gallery" title text should be present',
    );
  }

  /// Asserts the photo count subtitle shows the expected number.
  Future<void> verifySubtitle(int expectedCount) async {
    TestLogger.verify(_page, 'Subtitle shows "$expectedCount photos"');
    expect(
      GalleryScreen.photoCountText(expectedCount),
      findsOneWidget,
      reason: 'Subtitle should show "$expectedCount photos"',
    );
  }

  /// Asserts the scrollable grid is present on screen.
  Future<void> verifyGridIsVisible() async {
    TestLogger.verify(_page, 'Gallery scroll view is visible');
    expect(
      GalleryScreen.scrollView,
      findsOneWidget,
      reason: 'Gallery scroll view should be visible',
    );
  }

  /// Asserts a specific photo tile and all its child elements are visible.
  Future<void> verifyPhotoTileContent(int id) async {
    TestLogger.verify(_page, 'Photo tile $id has image, title and date');
    expect(GalleryScreen.photoTile(id), findsOneWidget,
        reason: 'Photo tile $id should exist');
    expect(GalleryScreen.photoImage(id), findsOneWidget,
        reason: 'Photo image $id should exist');
    expect(GalleryScreen.photoTitle(id), findsOneWidget,
        reason: 'Photo title $id should exist');
    expect(GalleryScreen.photoDate(id), findsOneWidget,
        reason: 'Photo date $id should exist');
  }

  /// Asserts a photo tile is NOT present in the widget tree (deleted).
  Future<void> verifyPhotoAbsent(int id) async {
    TestLogger.verify(_page, 'Photo tile $id is absent (deleted)');
    expect(
      GalleryScreen.photoTile(id),
      findsNothing,
      reason: 'Photo tile $id should have been removed',
    );
  }

  /// Asserts the empty state widget is displayed.
  Future<void> verifyEmptyState() async {
    TestLogger.verify(_page, 'Empty state widget is visible');
    expect(
      GalleryScreen.emptyState,
      findsOneWidget,
      reason: 'Empty state should be visible when no photos remain',
    );
  }

  // ─── Counting Methods ─────────────────────────────────────────────────────────

  /// Returns the number of photo tiles currently rendered in the viewport.
  /// SliverGrid only builds visible items, so this reflects what's on screen.
  Future<int> countVisiblePhotos({int totalPhotos = 12}) async {
    TestLogger.action(_page, 'Counting visible photos in viewport');
    int count = 0;
    for (int id = 1; id <= totalPhotos; id++) {
      if (TestUtils.isVisible(GalleryScreen.photoTile(id))) count++;
    }
    TestLogger.result(_page, '$count photo(s) visible in viewport');
    return count;
  }

  /// Scrolls through the entire grid and returns the total number of
  /// unique photo tiles encountered. Used to verify the full photo count.
  /// Restores scroll position to the top after counting.
  Future<int> countAllPhotos({int totalPhotos = 12}) async {
    TestLogger.action(_page, 'Counting all photos by scrolling grid');
    final seen = <int>{};

    for (int id = 1; id <= totalPhotos; id++) {
      if (TestUtils.isVisible(GalleryScreen.photoTile(id))) seen.add(id);
    }

    await scrollDown(600);

    for (int id = 1; id <= totalPhotos; id++) {
      if (TestUtils.isVisible(GalleryScreen.photoTile(id))) seen.add(id);
    }

    await scrollToTop();

    TestLogger.result(_page, '${seen.length} unique photo(s) found in grid');
    return seen.length;
  }

  // ─── Action Methods ───────────────────────────────────────────────────────────

  /// Taps a photo tile by ID and waits for the transition to settle.
  Future<void> tapPhoto(int id) async {
    TestLogger.action(_page, 'Tapping photo $id');
    expect(GalleryScreen.photoTile(id), findsOneWidget,
        reason: 'Photo $id must exist before tapping');
    await tester.tap(GalleryScreen.photoTile(id));
    await TestUtils.settle(tester);
  }

  /// Double-taps the Gallery title gesture detector to restore deleted photos.
  Future<void> doubleTapTitle() async {
    TestLogger.action(_page, 'Double-tapping Gallery title to restore photos');
    expect(GalleryScreen.titleGesture, findsOneWidget,
        reason: 'Gallery title gesture must be visible to double-tap');
    await TestUtils.doubleTap(tester, GalleryScreen.titleGesture);
  }

  /// Scrolls the gallery grid downward by [dy] logical pixels.
  Future<void> scrollDown([double dy = 400]) async {
    TestLogger.action(_page, 'Scrolling gallery down by ${dy}px');
    await tester.drag(GalleryScreen.scrollView, Offset(0, -dy));
    await TestUtils.settle(tester);
  }

  /// Scrolls the gallery grid back to the top.
  Future<void> scrollToTop() async {
    TestLogger.action(_page, 'Scrolling gallery back to top');
    await tester.drag(GalleryScreen.scrollView, const Offset(0, 2000));
    await TestUtils.settle(tester);
  }
}
