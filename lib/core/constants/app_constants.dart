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
  static final DateTime weddingDateTime = DateTime(2026, 9, 5, 18, 0);
  static const String weddingDateLabel = 'Saturday, 5th September 2026';
  static const String weddingTimeLabel = '6:00 PM — Onwards';

  // Venue
  static const String venueName = 'Evangelical Church in Abu Qurqas al-Balad';
  static const String venueNameAr = 'الكنيسة الإنجيلية بأبو قرقاص البلد';
  static const String venueAddress = '';
  static const double venueLat = 27.93;
  static const double venueLng = 30.84;
  static const String googleMapsUrl =
      'https://maps.app.goo.gl/PApVrYTyzeSyR5un9';

  // Firestore
  static const String blessingsCollection = 'blessings';

  // Couple photo — bundled locally as an asset.
  static const String coupleImagePath = 'assets/images/couple.png';
  static const String? coupleImageUrl = null;

  // Splash screen GIF — replace with your own GIF file at assets/gifs/splash.gif
  static const String splashGifPath = 'assets/gifs/splash.gif';
}
