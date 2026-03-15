class GalleryScreenData {
  GalleryScreenData._();

  // Photo counts
  static const int totalPhotos = 12;
  static const int minVisiblePhotos = 4;
  static const int firstTileCheckCount = 6;
  static const int afterOneDeletion = 11;
  static const int afterTwoDeletions = 10;
  static const int afterFourDeletions = 8;

  // Photo IDs used across tests
  static const int photo1 = 1;
  static const int photo2 = 2;
  static const int photo3 = 3;
  static const int photo4 = 4;

  // Restored photo titles (used in TID:15)
  static const String restoredPhoto1Title = 'Photo 1';
}
