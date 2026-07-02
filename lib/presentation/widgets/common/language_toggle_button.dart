import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_language.dart';
import '../../../core/localization/locale_cubit.dart';
import '../../../core/theme/app_theme.dart';

/// Small pill button that toggles between Arabic and English. Placed as a
/// floating overlay so it's reachable from anywhere on the page.
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LocaleCubit>().state;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => context.read<LocaleCubit>().toggle(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.deepNavy.withOpacity(0.65),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.gold.withOpacity(0.6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 15, color: AppColors.gold),
              const SizedBox(width: 6),
              Text(
                language.switchLabel,
                style: AppTextStyles.label(size: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
