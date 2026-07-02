import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_language.dart';

/// Holds the currently selected app language. Defaults to Arabic per the
/// product requirement; call [toggle] or [setLanguage] to switch.
class LocaleCubit extends Cubit<AppLanguage> {
  LocaleCubit() : super(AppLanguage.ar);

  void toggle() {
    emit(state == AppLanguage.ar ? AppLanguage.en : AppLanguage.ar);
  }

  void setLanguage(AppLanguage language) => emit(language);
}
