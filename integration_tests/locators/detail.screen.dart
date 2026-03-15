import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object Model locators for the Detail Screen.
/// Keys are defined in lib/screens/detail_screen.dart.
class DetailScreen {
  DetailScreen._();

  // ─── Scaffold ────────────────────────────────────────────────────────────────

  /// Root Scaffold of the detail screen.
  static final Finder scaffold = find.byKey(const Key('detail_scaffold'));

  // ─── App Bar ─────────────────────────────────────────────────────────────────

  /// Photo title shown in the transparent app bar at the top.
  static final Finder photoTitle = find.byKey(const Key('detail_photo_title'));

  // ─── Image Viewer ─────────────────────────────────────────────────────────────

  /// The pinch-to-zoom InteractiveViewer wrapping the image.
  static final Finder interactiveViewer =
      find.byKey(const Key('detail_interactive_viewer'));

  /// The full-screen photo image inside the viewer.
  static final Finder photoImage = find.byKey(const Key('detail_photo_image'));

  // ─── Action Bar ───────────────────────────────────────────────────────────────

  /// The bottom Row containing the Info and Delete buttons.
  static final Finder actionBar = find.byKey(const Key('detail_action_bar'));

  /// The Info circular action button.
  static final Finder infoButton = find.byKey(const ValueKey('info_button'));

  /// The Delete circular action button.
  static final Finder deleteButton =
      find.byKey(const ValueKey('delete_button'));

  // ─── Info Bottom Sheet ────────────────────────────────────────────────────────

  /// The photo title heading inside the info bottom sheet.
  static final Finder infoSheetTitle =
      find.byKey(const Key('info_sheet_title'));

  /// Label text of an info row. [label] matches the displayed label
  /// e.g. 'date', 'resolution', 'format', 'source'
  static Finder infoRowLabel(String label) =>
      find.byKey(Key('info_row_label_$label'));

  /// Value text of an info row. [label] matches the displayed label
  /// e.g. 'date', 'resolution', 'format', 'source'
  static Finder infoRowValue(String label) =>
      find.byKey(Key('info_row_value_$label'));

  // ─── Delete Dialog ────────────────────────────────────────────────────────────

  /// "Delete photo?" title inside the delete confirmation dialog.
  static final Finder deleteDialogTitle =
      find.byKey(const Key('delete_dialog_title'));

  /// Body content text inside the delete confirmation dialog.
  static final Finder deleteDialogContent =
      find.byKey(const Key('delete_dialog_content'));

  /// Cancel button inside the delete confirmation dialog.
  static final Finder deleteDialogCancel =
      find.byKey(const Key('delete_dialog_cancel'));

  /// Confirm delete button inside the delete confirmation dialog.
  static final Finder deleteDialogConfirm =
      find.byKey(const Key('delete_dialog_confirm'));
}
