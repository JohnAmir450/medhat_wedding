import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the active locale (Arabic or English).
/// Arabic (`ar`) is the default.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar'));

  void setLocale(Locale locale) {
    if (locale.languageCode == 'ar' || locale.languageCode == 'en') {
      emit(locale);
    }
  }

  void toggle() {
    if (state.languageCode == 'ar') {
      emit(const Locale('en'));
    } else {
      emit(const Locale('ar'));
    }
  }

  static LocaleCubit of(BuildContext context) =>
      BlocProvider.of<LocaleCubit>(context);
}
