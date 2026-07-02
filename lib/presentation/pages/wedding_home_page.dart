import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../features/blessings/cubit/blessings_cubit.dart';
import '../../features/blessings/presentation/widgets/blessings_section.dart';
import '../widgets/countdown_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/venue_section.dart';

/// The single scrollable page that assembles every section of the
/// digital invitation: Hero -> Countdown -> Venue -> Guestbook.
class WeddingHomePage extends StatelessWidget {
  const WeddingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlessingsCubit(),
      child: const Scaffold(
        backgroundColor: AppColors.deepNavy,
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeroSection(),
              CountdownSection(),
              VenueSection(),
              BlessingsSection(),
              _Footer(),
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
            'Made with love, for our forever.',
            style: AppTextStyles.body(size: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
