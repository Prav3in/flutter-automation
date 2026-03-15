import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../pages/gallery.page.dart';
import '../pages/detail.page.dart';
import '../utils/test_utils.dart';
import '../data/gallery.screen.dart';
import '../data/detail.screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Detail Screen', () {
    late GalleryPage galleryPage;
    late DetailPage detailPage;

    Future<void> setUp(WidgetTester tester) async {
      galleryPage = GalleryPage(tester);
      detailPage = DetailPage(tester);
      await TestUtils.launchApp(tester);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:3] Verify Opening Photo Details
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:3] Verify Opening Photo Details',
      (tester) async {
        await setUp(tester);
        await galleryPage.tapPhoto(GalleryScreenData.photo1);

        // Detail screen is open
        await detailPage.verifyScreenLoaded();

        // All required elements are present
        await detailPage.verifyPhotoTitle(DetailScreenData.photo1Title);
        await detailPage.verifyPhotoImage();
        await detailPage.verifyInfoButton();
        await detailPage.verifyDeleteButton();
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:4] Verify Photo Display in Details Screen
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:4] Verify Photo Display in Details Screen',
      (tester) async {
        await setUp(tester);

        // Tap a specific photo
        await galleryPage.tapPhoto(GalleryScreenData.photo3);

        // The correct photo and title are shown
        await detailPage.verifyPhotoTitle(DetailScreenData.photo3Title);
        await detailPage.verifyPhotoImage();
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:5] Verify Info Popover Opens
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:5] Verify Info Popover Opens',
      (tester) async {
        await setUp(tester);
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.tapInfoButton();

        // Bottom sheet is open
        await detailPage.verifyInfoSheetIsOpen();

        // Sheet title and all four metadata rows are present
        await detailPage.verifyInfoSheetContent(DetailScreenData.photo1Title);
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:6] Verify Info Popover Content
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:6] Verify Info Popover Content',
      (tester) async {
        await setUp(tester);
        await galleryPage.tapPhoto(GalleryScreenData.photo2);
        await detailPage.tapInfoButton();

        // All four metadata rows with label + value pairs are present
        await detailPage.verifyInfoSheetContent(DetailScreenData.photo2Title);

        // Spot-check specific values
        expect(find.text(DetailScreenData.resolution), findsOneWidget,
            reason: 'Resolution value should be visible');
        expect(find.text(DetailScreenData.format), findsOneWidget,
            reason: 'Format value should be visible');
        expect(find.text(DetailScreenData.source), findsOneWidget,
            reason: 'Source value should be visible');
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:7] Verify Popover Can Be Closed by Tapping Outside
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:7] Verify Popover Can Be Closed by Tapping Outside',
      (tester) async {
        await setUp(tester);
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.tapInfoButton();
        await detailPage.verifyInfoSheetIsOpen();

        // Tap outside the sheet to dismiss
        await detailPage.dismissInfoSheetByTappingOutside();

        // Sheet is gone, detail screen remains
        await detailPage.verifyInfoSheetIsClosed();
        await detailPage.verifyRemainsOnDetailScreen();
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:8] Verify Popover Can Be Closed by Swiping Down
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:8] Verify Popover Can Be Closed by Swiping Down',
      (tester) async {
        await setUp(tester);
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.tapInfoButton();
        await detailPage.verifyInfoSheetIsOpen();

        // Swipe the sheet downward to dismiss
        await detailPage.dismissInfoSheetBySwipingDown();

        // Sheet is gone, detail screen remains
        await detailPage.verifyInfoSheetIsClosed();
        await detailPage.verifyRemainsOnDetailScreen();
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:9] Verify Delete Dialog Appears
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:9] Verify Delete Dialog Appears',
      (tester) async {
        await setUp(tester);
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.tapDeleteButton();

        // Confirmation dialog with all required elements
        await detailPage.verifyDeleteDialogIsOpen();

        // Verify dialog text content
        expect(find.text(DetailScreenData.deleteDialogTitle), findsOneWidget);
        expect(find.text(DetailScreenData.deleteDialogMessage), findsOneWidget);
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:10] Verify Cancel Delete Action
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:10] Verify Cancel Delete Action',
      (tester) async {
        await setUp(tester);
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.tapDeleteButton();
        await detailPage.verifyDeleteDialogIsOpen();

        // Cancel the deletion
        await detailPage.tapCancelDelete();

        // Dialog is gone, detail screen remains, photo still exists
        await detailPage.verifyDeleteDialogIsClosed();
        await detailPage.verifyRemainsOnDetailScreen();
        await detailPage.verifyPhotoImage();
      },
    );
  });
}
