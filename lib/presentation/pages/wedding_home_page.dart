import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../features/blessings/cubit/blessings_cubit.dart';
import '../../features/blessings/presentation/widgets/blessings_section.dart';
import '../widgets/common/scroll_fade_in.dart';
import '../widgets/countdown_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/venue_section.dart';

/// The single scrollable page that assembles every section of the
/// digital invitation: Hero -> Countdown -> Venue -> Guestbook.
///
/// Every section after the Hero is wrapped in [ScrollFadeIn] so it fades
/// and slides up the first time it enters the viewport, giving the page a
/// premium feel instead of a static one. The Hero already animates on
/// first load, so it's left un-wrapped.
class WeddingHomePage extends StatelessWidget {
  const WeddingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlessingsCubit(),
      child: Scaffold(
        backgroundColor: AppColors.deepNavy,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const HeroSection(),
              const ScrollFadeIn(id: 'countdown', child: CountdownSection()),
              const ScrollFadeIn(id: 'venue', child: VenueSection()),
              const ScrollFadeIn(id: 'blessings', child: BlessingsSection()),
              const _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            l10n.t('footer_text'),
            style: AppTextStyles.body(size: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
