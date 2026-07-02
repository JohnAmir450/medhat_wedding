import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_language.dart';
import 'locale_cubit.dart';

/// All user-facing copy in the app, in both languages. Add a key here once
/// and reference it everywhere via `AppLocalizations.of(context).t('key')`
/// (or the shorter `context.tr('key')` extension below).
class AppLocalizations {
  const AppLocalizations(this.language);

  final AppLanguage language;

  static AppLocalizations of(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state;
    return AppLocalizations(lang);
  }

  bool get isArabic => language.isArabic;

  String get groomName =>
      isArabic ? _ArConst.groomName : _EnConst.groomName;
  String get brideName =>
      isArabic ? _ArConst.brideName : _EnConst.brideName;
  String get venueName =>
      isArabic ? _ArConst.venueName : _EnConst.venueName;

  String t(String key) => (isArabic ? _ar : _en)[key] ?? key;

  static const Map<String, String> _en = {
    'the_wedding_of': 'The Wedding Of',
    'scroll_to_explore': 'SCROLL TO EXPLORE',
    'counting_down_to': 'COUNTING DOWN TO',
    'countdown_title': 'Our Forever Begins In',
    'days': 'Days',
    'hours': 'Hours',
    'minutes': 'Minutes',
    'seconds': 'Seconds',
    'arrived_message': "It's Our Wedding Day! 🎉",
    'join_us_at': 'JOIN US AT',
    'venue_title': 'Wedding Ceremony',
    'view_on_maps': 'VIEW ON GOOGLE MAPS',
    'guestbook_eyebrow': 'GUESTBOOK',
    'guestbook_title': 'Blessings & Wishes',
    'guestbook_subtitle': 'Leave a message of love for the happy couple',
    'post_anonymously': 'Post anonymously',
    'your_name_hint': 'Your name',
    'message_hint': 'Write your blessing or congratulations...',
    'send_blessing': 'SEND BLESSING',
    'name_validation': 'Please enter your name',
    'message_validation': 'Please write a message',
    'submit_generic_error': 'Something went wrong. Please try again.',
    'blessings_count_one': 'blessing so far',
    'blessings_count_many': 'blessings so far',
    'empty_blessings': 'Be the first to leave a blessing!',
    'load_error': 'Could not load blessings. Please try again.',
    'footer_text': 'Made with love, for our forever.',
    'thank_you_title': 'Medhat & Nesma',
    'thank_you_message':
        'Thank you for your kind words — we hope to see you there to make our joy complete.',
    'welcome_title': "You're Invited",
    'welcome_subtitle': 'To The Wedding Of',
    'skip': 'Skip',
    'loading': 'Loading',
    'anonymous_label': 'Anonymous',
  };

  static const Map<String, String> _ar = {
    'the_wedding_of': 'حفل زفاف',
    'scroll_to_explore': 'مرر للأسفل',
    'counting_down_to': 'العد التنازلي حتى',
    'countdown_title': 'يبدأ فرحنا بعد',
    'days': 'يوم',
    'hours': 'ساعة',
    'minutes': 'دقيقة',
    'seconds': 'ثانية',
    'arrived_message': '🎉 اليوم يوم فرحنا 🎉',
    'join_us_at': 'انضموا إلينا في',
    'venue_title': 'حفل الزفاف',
    'view_on_maps': 'عرض على خرائط جوجل',
    'guestbook_eyebrow': 'سجل التهاني',
    'guestbook_title': 'تهانينا ومباركاتنا',
    'guestbook_subtitle': 'اترك رسالة حب للعروسين',
    'post_anonymously': 'النشر بدون اسم',
    'your_name_hint': 'اسمك',
    'message_hint': 'اكتب تهنئتك أو مباركتك...',
    'send_blessing': 'إرسال التهنئة',
    'name_validation': 'من فضلك أدخل اسمك',
    'message_validation': 'من فضلك اكتب رسالة',
    'submit_generic_error': 'حدث خطأ ما، حاول مرة أخرى.',
    'blessings_count_one': 'تهنئة حتى الآن',
    'blessings_count_many': 'تهنئة حتى الآن',
    'empty_blessings': 'كن أول من يرسل تهنئة!',
    'load_error': 'تعذر تحميل التهاني، حاول مرة أخرى.',
    'footer_text': 'صُنع بحب، لأجل فرحتنا الدائمة.',
    'thank_you_title': 'مدحت ونسمة',
    'thank_you_message': 'شكرًا لكلامكم الجميل، نتمنى نشوفكم علشان تكمل فرحتنا',
    'welcome_title': 'أنتم مدعوون',
    'welcome_subtitle': 'لحضور حفل زفاف',
    'skip': 'تخطي',
    'loading': 'جاري التحميل',
    'anonymous_label': 'مجهول',
  };
}

class _EnConst {
  static const groomName = 'Medhat';
  static const brideName = 'Nesma';
  static const venueName = 'Evangelical Church in Abu Qurqas al-Balad';
}

class _ArConst {
  static const groomName = 'مدحت';
  static const brideName = 'نسمة';
  static const venueName = 'الكنيسة الإنجيلية بأبو قرقاص البلد';
}

/// Convenience: `context.tr('key')` instead of the longer static call.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String tr(String key) => AppLocalizations.of(this).t(key);
}
