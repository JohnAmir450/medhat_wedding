/// Convenience extension to access localized strings from any BuildContext.
/// Usage: `context.l10n.wedding`
library extensions;

export 'app_localizations.dart';
export 'locale_cubit.dart';

import 'package:flutter/material.dart';
import 'package:wedding_invitation/core/localization/locale_cubit.dart';
import 'app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n {
    final locale = LocaleCubit.of(this).state;
    return AppLocalizations(locale.languageCode);
  }

}
