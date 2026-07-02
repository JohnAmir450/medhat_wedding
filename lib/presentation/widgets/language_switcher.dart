import 'package:flutter/material.dart';

import '../../core/localization/extensions.dart';
import '../../core/theme/app_theme.dart';

/// A minimal, elegant floating button that toggles between Arabic and English.
/// Position it wherever suits the layout — typically top-right of the page.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = l10n.isArabic;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepNavy.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            final cubit = LocaleCubit.of(context);
            cubit.toggle();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isArabic ? Icons.language : Icons.language,
                  size: 16,
                  color: AppColors.gold,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.languageLabel,
                  style: AppTextStyles.label(
                    size: 12,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A smaller, icon-only version for tight spaces.
class LanguageSwitcherIcon extends StatelessWidget {
  const LanguageSwitcherIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepNavy.withOpacity(0.7),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Text(
          l10n.isArabic ? 'EN' : 'AR',
          style: AppTextStyles.label(
            size: 13,
            color: AppColors.gold,
          ),
        ),
        onPressed: () => LocaleCubit.of(context).toggle(),
        tooltip: l10n.languageLabel,
      ),
    );
  }
}
