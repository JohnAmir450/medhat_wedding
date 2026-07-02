/// Centralized bilingual string maps for the wedding invitation.
/// Arabic is the default language.
class AppLocalizations {
  final String _locale;

  const AppLocalizations(this._locale);

  bool get isArabic => _locale == 'ar';

  // ─── Helpers ───
  String _t(String ar, String en) => isArabic ? ar : en;

  // ─── Global ───
  String get appTitle => _t('مدحت & نسمه — دعوة زفاف', 'Medhat & Nesma — Wedding Invitation');

  // ─── Couple ───
  String get coupleAnd => _t('و', '&');
  String get brideName => 'نسمه';
  String get groomName => 'مدحت';
  String get coupleNames => _t('$brideName $coupleAnd $groomName', '$groomName & $brideName');

  // ─── Hero ───
  String get theWeddingOf => _t('زفاف', 'The Wedding Of');
  String get scrollToExplore => _t('اسحب لاستكشاف', 'SCROLL TO EXPLORE');

  // ─── Countdown ───
  String get countingDown => _t('العد التنازلي لـ', 'COUNTING DOWN TO');
  String get ourForeverBegins => _t('تبدأ قصتنا الجميلة', 'Our Forever Begins In');
  String get itsWeddingDay => _t('🎉 إنه يوم زفافنا', "🎉 It's Our Wedding Day!");
  String get days => _t('يوم', 'Days');
  String get hours => _t('ساعة', 'Hours');
  String get minutes => _t('دقيقة', 'Minutes');
  String get seconds => _t('ثانية', 'Seconds');

  // ─── Venue ───
  String get joinUsAt => _t('انضم إلينا في', 'JOIN US AT');
  String get ceremonyTitle => _t('حفل الزفاف', 'Wedding Ceremony & Reception');
  String get viewOnMaps => _t('عرض على خرائط جوجل', 'VIEW ON GOOGLE MAPS');

  // ─── Guestbook / Blessings ───
  String get guestbook => _t('سجل الزوار', 'GUESTBOOK');
  String get blessingsTitle => _t('البركات والتهاني', 'Blessings & Wishes');
  String get blessingsSubtitle => _t('اترك كلمة حب للعروسين', "Leave a message of love for the happy couple");
  String get postAnonymously => _t('نشر باسم مجهول', 'Post anonymously');
  String get yourNameHint => _t('أدخل اسمك', 'Your name');
  String get blessingHint => _t('اكتب بركتك أو تهانئك...', 'Write your blessing or congratulations...');
  String get nameRequired => _t('يرجى إدخال اسمك', 'Please enter your name');
  String get messageRequired => _t('يرجى كتابة رسالة', 'Please write a message');
  String get sendBlessing => _t('إرسال البركة', 'SEND BLESSING');
  String get beFirstBlessing => _t('كن أول من يترك بركة!', 'Be the first to leave a blessing!');
  String blessingsCount(int count) => _t(
    '$count بركة',
    '$count blessing${count == 1 ? '' : 's'} and counting',
  );
  String get loadingBlessings => _t('جاري تحميل البركات...', 'Loading blessings...');
  String get blessingsError => _t('تعذر تحميل البركات. حاول مرة أخرى.', 'Could not load blessings. Please try again.');

  // ─── Blessing Form Validation ───
  String get emptyBlessingError => _t('يرجى كتابة بركة قبل الإرسال', 'Please write a blessing before submitting.');
  String get nameOrAnonymousError => _t('يرجى إدخال اسمك، أو النشر كمجهول', 'Please enter your name, or post anonymously.');

  // ─── Success Toast ───
  String get toastThankYou => _t(
    'شكرًا لكلامكم الجميل، نتمنى نشوفكم علشان تكمل فرحتنا',
    'Thank you for your kind words — we hope to see you to complete our joy!',
  );
  String get blessingSubmitted => _t('شكراً لبركتك! 💛', 'Thank you for your blessing! 💛');

  // ─── Submission Errors ───
  String get submissionError => _t('حدث خطأ ما. حاول مرة أخرى.', 'Something went wrong. Please try again.');

  // ─── Footer ───
  String get footerText => _t('صنع بحب، لأجل أبدنا.', 'Made with love, for our forever.');

  // ─── Splash ───
  String get skip => _t('تخطي', 'Skip');
  String get welcome => _t('أهلاً وسهلاً', 'Welcome');

  // ─── Language ───
  String get languageLabel => isArabic ? 'English' : 'العربية';
}
