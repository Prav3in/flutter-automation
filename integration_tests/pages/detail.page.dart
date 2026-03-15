import 'package:flutter_test/flutter_test.dart';
import '../locators/detail.screen.dart' as locators;
import '../utils/test_utils.dart';
import '../utils/test_logger.dart';

/// Page Object for the Detail screen.
/// Encapsulates all interactions and assertions for the photo detail view,
/// the info bottom sheet, and the delete confirmation dialog.
class DetailPage {
  final WidgetTester tester;

  static const _page = 'DetailPage';

  DetailPage(this.tester);

  // ─── Screen Verification ──────────────────────────────────────────────────────

  /// Asserts the detail screen scaffold is visible — screen has loaded.
  Future<void> verifyScreenLoaded() async {
    TestLogger.verify(_page, 'Detail screen scaffold is visible');
    expect(
      locators.DetailScreen.scaffold,
      findsOneWidget,
      reason: 'Detail screen scaffold should be visible',
    );
  }

  /// Asserts the photo title in the app bar matches [expectedTitle].
  Future<void> verifyPhotoTitle(String expectedTitle) async {
    TestLogger.verify(_page, 'Photo title matches "$expectedTitle"');
    expect(
      locators.DetailScreen.photoTitle,
      findsOneWidget,
      reason: 'Photo title should be present in app bar',
    );
    expect(
      find.text(expectedTitle),
      findsAtLeastNWidgets(1),
      reason: 'Photo title text should match "$expectedTitle"',
    );
  }

  /// Asserts the full-screen photo image is visible.
  Future<void> verifyPhotoImage() async {
    TestLogger.verify(_page, 'Full-screen photo image is visible');
    expect(
      locators.DetailScreen.photoImage,
      findsOneWidget,
      reason: 'Full-screen photo image should be visible',
    );
  }

  /// Asserts the Info action button is present at the bottom.
  Future<void> verifyInfoButton() async {
    TestLogger.verify(_page, 'Info button is visible');
    expect(
      locators.DetailScreen.infoButton,
      findsOneWidget,
      reason: 'Info button should be visible',
    );
  }

  /// Asserts the Delete action button is present at the bottom.
  Future<void> verifyDeleteButton() async {
    TestLogger.verify(_page, 'Delete button is visible');
    expect(
      locators.DetailScreen.deleteButton,
      findsOneWidget,
      reason: 'Delete button should be visible',
    );
  }

  /// Asserts the bottom action bar with both buttons is visible.
  Future<void> verifyActionBar() async {
    TestLogger.verify(_page, 'Action bar with info and delete buttons is visible');
    expect(locators.DetailScreen.actionBar, findsOneWidget);
    await verifyInfoButton();
    await verifyDeleteButton();
  }

  // ─── Info Bottom Sheet Verification ──────────────────────────────────────────

  /// Asserts the info bottom sheet is currently open.
  Future<void> verifyInfoSheetIsOpen() async {
    TestLogger.verify(_page, 'Info bottom sheet is open');
    expect(
      locators.DetailScreen.infoSheetTitle,
      findsOneWidget,
      reason: 'Info sheet title should be visible when sheet is open',
    );
  }

  /// Asserts the info sheet is dismissed and no longer in the tree.
  Future<void> verifyInfoSheetIsClosed() async {
    TestLogger.verify(_page, 'Info bottom sheet is closed');
    expect(
      locators.DetailScreen.infoSheetTitle,
      findsNothing,
      reason: 'Info sheet should be gone after dismissal',
    );
  }

  /// Asserts all four metadata rows are present in the info bottom sheet.
  /// Also verifies the sheet title matches [expectedPhotoTitle].
  Future<void> verifyInfoSheetContent(String expectedPhotoTitle) async {
    TestLogger.verify(_page, 'Info sheet content for "$expectedPhotoTitle" is correct');
    expect(
      find.text(expectedPhotoTitle),
      findsAtLeastNWidgets(1),
      reason: 'Info sheet title should match the photo name',
    );
    expect(locators.DetailScreen.infoRowLabel('date'), findsOneWidget,
        reason: 'Date label should be present');
    expect(locators.DetailScreen.infoRowValue('date'), findsOneWidget,
        reason: 'Date value should be present');
    expect(locators.DetailScreen.infoRowLabel('resolution'), findsOneWidget,
        reason: 'Resolution label should be present');
    expect(locators.DetailScreen.infoRowValue('resolution'), findsOneWidget,
        reason: 'Resolution value should be present');
    expect(locators.DetailScreen.infoRowLabel('format'), findsOneWidget,
        reason: 'Format label should be present');
    expect(locators.DetailScreen.infoRowValue('format'), findsOneWidget,
        reason: 'Format value should be present');
    expect(locators.DetailScreen.infoRowLabel('source'), findsOneWidget,
        reason: 'Source label should be present');
    expect(locators.DetailScreen.infoRowValue('source'), findsOneWidget,
        reason: 'Source value should be present');
  }

  // ─── Delete Dialog Verification ───────────────────────────────────────────────

  /// Asserts the delete confirmation dialog is open with all required elements.
  Future<void> verifyDeleteDialogIsOpen() async {
    TestLogger.verify(_page, 'Delete confirmation dialog is open');
    expect(locators.DetailScreen.deleteDialogTitle, findsOneWidget,
        reason: 'Delete dialog title should be visible');
    expect(locators.DetailScreen.deleteDialogContent, findsOneWidget,
        reason: 'Delete dialog content should be visible');
    expect(locators.DetailScreen.deleteDialogCancel, findsOneWidget,
        reason: 'Cancel button should be visible');
    expect(locators.DetailScreen.deleteDialogConfirm, findsOneWidget,
        reason: 'Delete confirm button should be visible');
  }

  /// Asserts the delete dialog is no longer visible.
  Future<void> verifyDeleteDialogIsClosed() async {
    TestLogger.verify(_page, 'Delete dialog is closed');
    expect(
      locators.DetailScreen.deleteDialogTitle,
      findsNothing,
      reason: 'Delete dialog should be dismissed',
    );
  }

  /// Asserts the detail screen is still open (user was not navigated away).
  Future<void> verifyRemainsOnDetailScreen() async {
    TestLogger.verify(_page, 'User remains on detail screen');
    expect(
      locators.DetailScreen.scaffold,
      findsOneWidget,
      reason: 'User should remain on the detail screen',
    );
  }

  // ─── Action Methods ───────────────────────────────────────────────────────────

  /// Taps the Info button and waits for the bottom sheet to open.
  Future<void> tapInfoButton() async {
    TestLogger.action(_page, 'Tapping info button');
    await tester.tap(locators.DetailScreen.infoButton);
    await TestUtils.settle(tester);
  }

  /// Taps the Delete button and waits for the confirmation dialog to appear.
  Future<void> tapDeleteButton() async {
    TestLogger.action(_page, 'Tapping delete button');
    await tester.tap(locators.DetailScreen.deleteButton);
    await TestUtils.settle(tester);
  }

  /// Taps the Cancel button inside the delete dialog.
  Future<void> tapCancelDelete() async {
    TestLogger.action(_page, 'Tapping cancel in delete dialog');
    await tester.tap(locators.DetailScreen.deleteDialogCancel);
    await TestUtils.settle(tester);
  }

  /// Taps the Delete confirm button inside the delete dialog.
  Future<void> confirmDelete() async {
    TestLogger.action(_page, 'Confirming delete in dialog');
    await tester.tap(locators.DetailScreen.deleteDialogConfirm);
    await TestUtils.settle(tester);
  }

  /// Dismisses the info bottom sheet by tapping outside it.
  Future<void> dismissInfoSheetByTappingOutside() async {
    TestLogger.action(_page, 'Dismissing info sheet by tapping outside');
    await TestUtils.tapOutsideOverlay(tester);
  }

  /// Dismisses the info bottom sheet by swiping it downward.
  Future<void> dismissInfoSheetBySwipingDown() async {
    TestLogger.action(_page, 'Dismissing info sheet by swiping down');
    await TestUtils.swipeDownBottomSheet(tester);
  }
}
