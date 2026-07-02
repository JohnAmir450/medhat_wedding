/// Formats the wedding date/time in Arabic and English without depending
/// on `intl`'s locale-data initialization (which needs an async call
/// before first use and can be easy to forget on Flutter Web). Everything
/// here is derived at runtime from [DateTime], so changing
/// `AppConstants.weddingDateTime` automatically updates both languages
/// correctly — nothing is hardcoded per-date.
class DateFormatter {
  DateFormatter._();

  static const _weekdaysEn = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
  static const _weekdaysAr = [
    'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد',
  ];
  static const _monthsEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _monthsAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];

  static String dateLabelEn(DateTime dt) {
    final weekday = _weekdaysEn[dt.weekday - 1];
    final month = _monthsEn[dt.month - 1];
    return '$weekday, ${dt.day}${_ordinalSuffix(dt.day)} $month ${dt.year}';
  }

  static String dateLabelAr(DateTime dt) {
    final weekday = _weekdaysAr[dt.weekday - 1];
    final month = _monthsAr[dt.month - 1];
    return '$weekday، ${dt.day} $month ${dt.year}';
  }

  static String timeLabelEn(DateTime dt) {
    return '${_hour12(dt)}:${dt.minute.toString().padLeft(2, '0')} ${_ampmEn(dt)} — Onwards';
  }

  static String timeLabelAr(DateTime dt) {
    return 'الساعة ${_hour12(dt)}:${dt.minute.toString().padLeft(2, '0')} ${_ampmAr(dt)}';
  }

  static int _hour12(DateTime dt) {
    final h = dt.hour % 12;
    return h == 0 ? 12 : h;
  }

  static String _ampmEn(DateTime dt) => dt.hour >= 12 ? 'PM' : 'AM';
  static String _ampmAr(DateTime dt) => dt.hour >= 12 ? 'مساءً' : 'صباحًا';

  static String _ordinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
