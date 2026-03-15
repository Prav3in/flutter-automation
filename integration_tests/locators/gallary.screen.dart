import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object Model locators for the Gallery (Home) Screen.
/// Keys are defined in lib/screens/home_screen.dart.
class GalleryScreen {
  GalleryScreen._();

  /// The main "Gallery" title text in the collapsing app bar.
  /// Key: Key('gallery_title_text')
  static final Finder header = find.byKey(const Key('gallery_title_text'));

  /// The photo count subtitle below the title (e.g. "12 photos").
  /// Key: ValueKey(12) — the value matches the current photo count.
  /// Use [photoCountText] for a more reliable text-based find.
  static final Finder subheader = find.byKey(const ValueKey(12));

  /// Find the subtitle by visible text — more stable than ValueKey
  /// when the photo count may change during a test.
  static Finder photoCountText(int count) =>
      find.text('$count photo${count == 1 ? '' : 's'}');

  /// The GestureDetector wrapping the title — double-tap to restore photos.
  /// Key: Key('gallery_title_gesture')
  static final Finder titleGesture =
      find.byKey(const Key('gallery_title_gesture'));

  /// The root Scaffold of the Gallery screen.
  /// Key: Key('home_scaffold')
  static final Finder scaffold = find.byKey(const Key('home_scaffold'));

  /// The scrollable body of the gallery.
  /// Key: Key('gallery_scroll_view')
  static final Finder scrollView =
      find.byKey(const Key('gallery_scroll_view'));

  /// A specific photo tile by its photo ID.
  /// Key: ValueKey(id) — e.g. GalleryScreen.photoTile(1)
  static Finder photoTile(int id) => find.byKey(ValueKey(id));

  /// The image inside a specific photo tile.
  /// Key: Key('photo_image_<id>')
  static Finder photoImage(int id) => find.byKey(Key('photo_image_$id'));

  /// The title text inside a specific photo tile.
  /// Key: Key('photo_title_<id>')
  static Finder photoTitle(int id) => find.byKey(Key('photo_title_$id'));

  /// The date text inside a specific photo tile.
  /// Key: Key('photo_date_<id>')
  static Finder photoDate(int id) => find.byKey(Key('photo_date_$id'));

  /// The empty state widget shown when all photos are deleted.
  /// Key: ValueKey('empty_state')
  static final Finder emptyState =
      find.byKey(const ValueKey('empty_state'));
}
