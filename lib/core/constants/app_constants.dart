/// Central place to configure the wedding invitation content.
/// Edit these values to personalize the invitation without touching
/// any UI code.
class AppConstants {
  AppConstants._();

  // Couple — kept in both scripts so the UI can switch with the language.
  static const String groomNameEn = 'Medhat';
  static const String brideNameEn = 'Nesma';
  static const String groomNameAr = 'مدحت';
  static const String brideNameAr = 'نسمة';
  static const String coupleHashtag = '#MedhatAndNesma';

  // Date & Time — used by the countdown timer and hero section.
  // 5th September 2026, 6:00 PM.
  static final DateTime weddingDateTime = DateTime(2026, 9, 5, 18, 0);

  // Venue
  static const String venueNameEn = 'Evangelical Church in Abu Qurqas al-Balad';
  static const String venueNameAr = 'الكنيسة الإنجيلية بأبو قرقاص البلد';
  static const String googleMapsUrl = 'https://maps.app.goo.gl/PApVrYTyzeSyR5un9';

  // Firestore
  static const String blessingsCollection = 'blessings';

  // Couple photo — bundled locally as an asset (see pubspec.yaml `assets:`).
  // Using a local asset avoids the CORS / hotlink restrictions that Google
  // Drive "preview" links run into on Flutter Web (Image.network would
  // often fail to load them). If you'd rather serve it remotely, upload
  // the photo to Firebase Storage or any CDN and set [coupleImageUrl]
  // below — the hero section and the blessing snackbar both fall back to
  // it if the asset is missing.
  static const String coupleImagePath = 'assets/images/couple.png';
  static const String? coupleImageUrl = null;

  // Splash / welcome screen
  static const Duration splashAutoAdvance = Duration(seconds: 4);
}
