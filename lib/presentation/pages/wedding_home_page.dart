import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
      child: const Scaffold(
        backgroundColor: AppColors.deepNavy,
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeroSection(),
              ScrollFadeIn(id: 'countdown', child: CountdownSection()),
              ScrollFadeIn(id: 'venue', child: VenueSection()),
              ScrollFadeIn(id: 'blessings', child: BlessingsSection()),
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

  Future<void> _launchFacebookProfile() async {
    final Uri url =
        Uri.parse('https://web.facebook.com/john.amir.1804/'); // رابط بروفايلك
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = l10n.isArabic;

    final String baseText =
        isArabic ? 'صُـنع بـكل حـب بـواسـطة ' : 'Made with love by ';
    final String nameText = isArabic ? 'جـون أمـير' : 'John Amir';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      color: AppColors.deepNavy,
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.favorite,
              color: AppColors.gold.withOpacity(0.7), size: 24),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.body(size: 12, color: AppColors.textMuted),
              children: [
                TextSpan(text: baseText),
                TextSpan(
                  text: nameText,
                  style: isArabic
                      ? GoogleFonts.amiri(
                          color: AppColors.gold,
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                          textStyle: const TextStyle(
                              decoration: TextDecoration
                                  .underline), 
                        )
                      : GoogleFonts.greatVibes(
                          color: AppColors.gold,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.1,
                          textStyle: const TextStyle(
                              decoration: TextDecoration
                                  .underline), 
                        ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _launchFacebookProfile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
