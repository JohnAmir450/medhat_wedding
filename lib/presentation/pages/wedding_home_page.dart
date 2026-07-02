import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/extensions.dart';
import '../../core/theme/app_theme.dart';
import '../../features/blessings/cubit/blessings_cubit.dart';
import '../../features/blessings/presentation/widgets/blessings_section.dart';
import '../widgets/animations/scroll_reveal.dart';
import '../widgets/countdown_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/language_switcher.dart';
import '../widgets/venue_section.dart';

/// The single scrollable page that assembles every section of the
/// digital invitation: Hero -> Countdown -> Venue -> Guestbook.
class WeddingHomePage extends StatelessWidget {
  const WeddingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = l10n.isArabic;

    return BlocProvider(
      create: (_) => BlessingsCubit(),
      child: Scaffold(
        backgroundColor: AppColors.deepNavy,
        body: Stack(
          children: [
            Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    HeroSection(),
                    ScrollReveal(child: CountdownSection()),
                    ScrollReveal(child: VenueSection()),
                    ScrollReveal(child: BlessingsSection()),
                    ScrollReveal(child: _Footer()),
                  ],
                ),
              ),
            ),
            // ─── Floating Language Switcher ───
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: isArabic ? null : 20,
              left: isArabic ? 20 : null,
              child: const LanguageSwitcher(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      color: AppColors.deepNavy,
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.favorite, color: AppColors.gold.withOpacity(0.7), size: 18),
          const SizedBox(height: 8),
          Text(
            l10n.footerText,
            style: AppTextStyles.body(size: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
