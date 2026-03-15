import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../pages/gallery.page.dart';
import '../pages/detail.page.dart';
import '../utils/test_utils.dart';
import '../data/gallery.screen.dart';
import '../data/detail.screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Gallery Screen', () {
    late GalleryPage galleryPage;
    late DetailPage detailPage;

    Future<void> setUp(WidgetTester tester) async {
      galleryPage = GalleryPage(tester);
      detailPage = DetailPage(tester);
      await TestUtils.launchApp(tester);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:1] Verify Gallery Screen Loads Correctly
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:1] Verify Gallery Screen Loads Correctly',
      (tester) async {
        await setUp(tester);

        // Screen is displayed
        await galleryPage.verifyScreenLoaded();

        // Title and subtitle are correct
        await galleryPage.verifyTitle();
        await galleryPage.verifySubtitle(GalleryScreenData.totalPhotos);

        // Grid is visible
        await galleryPage.verifyGridIsVisible();

        // First N visible tiles each have image, name, date
        for (int id = 1; id <= GalleryScreenData.firstTileCheckCount; id++) {
          await galleryPage.verifyPhotoTileContent(id);
        }

        // At least N photos visible in viewport (varies with screen size)
        final visibleCount = await galleryPage.countVisiblePhotos();
        expect(
          visibleCount,
          greaterThanOrEqualTo(GalleryScreenData.minVisiblePhotos),
          reason: 'At least ${GalleryScreenData.minVisiblePhotos} photos should be visible in the initial viewport',
        );
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:2] Verify Photo Count Matches Grid Items
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:2] Verify Photo Count Matches Grid Items',
      (tester) async {
        await setUp(tester);

        await galleryPage.verifySubtitle(GalleryScreenData.totalPhotos);

        final totalCount = await galleryPage.countAllPhotos(
          totalPhotos: GalleryScreenData.totalPhotos,
        );
        expect(
          totalCount,
          equals(GalleryScreenData.totalPhotos),
          reason: 'Total photo count in grid should match subtitle (${GalleryScreenData.totalPhotos})',
        );
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:11] Verify Photo Deletion
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:11] Verify Photo Deletion',
      (tester) async {
        await setUp(tester);
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.tapDeleteButton();
        await detailPage.verifyDeleteDialogIsOpen();
        await detailPage.confirmDelete();

        // Back on gallery screen
        await galleryPage.verifyScreenLoaded();

        // Photo 1 is gone from the grid
        await galleryPage.verifyPhotoAbsent(GalleryScreenData.photo1);

        // Subtitle updated
        await galleryPage.verifySubtitle(GalleryScreenData.afterOneDeletion);
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:12] Verify Gallery Updates After Deletion
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:12] Verify Gallery Updates After Deletion',
      (tester) async {
        await setUp(tester);

        // Delete photo 1
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.tapDeleteButton();
        await detailPage.confirmDelete();

        // Gallery has updated — photo 1 is absent, photo 2 is still present
        await galleryPage.verifyPhotoAbsent(GalleryScreenData.photo1);
        await galleryPage.verifyPhotoTileContent(GalleryScreenData.photo2);

        // Total count is now 11
        final total = await galleryPage.countAllPhotos(
          totalPhotos: GalleryScreenData.totalPhotos,
        );
        expect(
          total,
          equals(GalleryScreenData.afterOneDeletion),
          reason: 'Grid should contain ${GalleryScreenData.afterOneDeletion} photos after one deletion',
        );
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:13] Verify Multiple Deletions
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:13] Verify Multiple Deletions',
      (tester) async {
        await setUp(tester);

        // Delete photo 1
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.tapDeleteButton();
        await detailPage.confirmDelete();
        await galleryPage.verifySubtitle(GalleryScreenData.afterOneDeletion);

        // Delete photo 2
        await galleryPage.tapPhoto(GalleryScreenData.photo2);
        await detailPage.tapDeleteButton();
        await detailPage.confirmDelete();
        await galleryPage.verifySubtitle(GalleryScreenData.afterTwoDeletions);

        // Both photos absent, subtitle reflects updated count
        await galleryPage.verifyPhotoAbsent(GalleryScreenData.photo1);
        await galleryPage.verifyPhotoAbsent(GalleryScreenData.photo2);
        await galleryPage.verifySubtitle(GalleryScreenData.afterTwoDeletions);
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:14] Verify Restore Deleted Photos Feature
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:14] Verify Restore Deleted Photos Feature',
      (tester) async {
        await setUp(tester);

        // Delete two photos
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.tapDeleteButton();
        await detailPage.confirmDelete();

        await galleryPage.tapPhoto(GalleryScreenData.photo2);
        await detailPage.tapDeleteButton();
        await detailPage.confirmDelete();

        await galleryPage.verifySubtitle(GalleryScreenData.afterTwoDeletions);

        // Double-tap the Gallery title to restore
        await galleryPage.doubleTapTitle();

        // All photos are back
        await galleryPage.verifySubtitle(GalleryScreenData.totalPhotos);
        await galleryPage.verifyPhotoTileContent(GalleryScreenData.photo1);
        await galleryPage.verifyPhotoTileContent(GalleryScreenData.photo2);
      },
    );

    // ─────────────────────────────────────────────────────────────────────────
    // [TID:15] Verify App State Consistency After Restore
    // ─────────────────────────────────────────────────────────────────────────
    testWidgets(
      '[TID:15] Verify App State Consistency After Restore',
      (tester) async {
        await setUp(tester);

        // Delete multiple photos
        for (int id = GalleryScreenData.photo1;
            id <= GalleryScreenData.photo4;
            id++) {
          await galleryPage.tapPhoto(id);
          await detailPage.tapDeleteButton();
          await detailPage.confirmDelete();
        }
        await galleryPage.verifySubtitle(GalleryScreenData.afterFourDeletions);

        // Restore via double-tap
        await galleryPage.doubleTapTitle();

        // Full gallery is restored
        await galleryPage.verifySubtitle(GalleryScreenData.totalPhotos);

        // Scroll through and verify all photos are present
        final totalAfterRestore = await galleryPage.countAllPhotos(
          totalPhotos: GalleryScreenData.totalPhotos,
        );
        expect(
          totalAfterRestore,
          equals(GalleryScreenData.totalPhotos),
          reason: 'All ${GalleryScreenData.totalPhotos} photos should be restored after double-tap',
        );

        // Gallery is fully functional — tap a restored photo
        await galleryPage.tapPhoto(GalleryScreenData.photo1);
        await detailPage.verifyScreenLoaded();
        await detailPage.verifyPhotoTitle(DetailScreenData.photo1Title);
      },
    );
  });
}
