/// Central place to configure the wedding invitation content.
/// Edit these values to personalize the invitation without touching
/// any UI code.
class AppConstants {
  AppConstants._();

  // Couple
  static const String groomName = 'Medhat';
  static const String brideName = 'Nesma';
  static const String coupleHashtag = '#MedhatAndNesma';

  // Date & Time — used by the countdown timer and hero section.
  // NOTE: Keep this in sync with [weddingDateLabel].
  static final DateTime weddingDateTime = DateTime(2026, 12, 12, 16, 0);
  static const String weddingDateLabel = 'Saturday, 12th December 2026';
  static const String weddingTimeLabel = '4:00 PM — Onwards';

  // Venue
  static const String venueName = 'The Grand Ballroom, Rosewood Estate';
  static const String venueAddress =
      '123 Rosewood Avenue, Beverly Hills, CA 90210';
  static const double venueLat = 34.0736;
  static const double venueLng = -118.4004;
  static const String googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=34.0736,-118.4004';

  // Firestore
  static const String blessingsCollection = 'blessings';

  // Couple photo — bundled locally as an asset (see pubspec.yaml `assets:`).
  // Using a local asset avoids the CORS / hotlink restrictions that Google
  // Drive "preview" links run into on Flutter Web (Image.network would
  // often fail to load them). If you'd rather serve it remotely, upload
  // the photo to Firebase Storage or any CDN and set [coupleImageUrl]
  // below — the hero section already falls back to it if the asset is
  // missing.
  static const String coupleImagePath = 'assets/images/couple.png';
  static const String? coupleImageUrl = null;
}
