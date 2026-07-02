import 'package:flutter/material.dart';

/// The two supported languages. Arabic is the app's default.
enum AppLanguage { ar, en }

extension AppLanguageX on AppLanguage {
  Locale get locale => this == AppLanguage.ar ? const Locale('ar') : const Locale('en');
  TextDirection get textDirection =>
      this == AppLanguage.ar ? TextDirection.rtl : TextDirection.ltr;
  bool get isArabic => this == AppLanguage.ar;

  /// Short label shown on the language-switcher button (shows the
  /// *other* language, e.g. while in Arabic the button reads "EN").
  String get switchLabel => this == AppLanguage.ar ? 'EN' : 'ع';
}
