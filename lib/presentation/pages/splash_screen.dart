import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';

/// A short, elegant welcome screen shown before the invitation itself.
///
/// Drop an animated GIF at `assets/images/splash.gif` (and list it under
/// `assets:` in pubspec.yaml) to play a custom intro — this widget will
/// display it automatically. If no GIF is bundled, it falls back to a
/// tasteful animated monogram built from flutter_animate so the splash
/// still looks intentional out of the box.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _autoAdvanceTimer;
  bool _hasGif = true;

  @override
  void initState() {
    super.initState();
    // Acts as "when the GIF finishes" — Flutter has no native completion
    // callback for asset GIFs, so we advance after a fixed, configurable
    // duration (see AppConstants.splashAutoAdvance). Tune it to match the
    // real length of your intro GIF.
    _autoAdvanceTimer = Timer(AppConstants.splashAutoAdvance, widget.onFinished);
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: _hasGif
                      ? Image.asset(
                          'assets/images/splash.gif',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            // No splash.gif bundled yet — show the fallback
                            // animated monogram instead.
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) setState(() => _hasGif = false);
                            });
                            return const _FallbackIntroArt();
                          },
                        )
                      : const _FallbackIntroArt(),
                ),
                const SizedBox(height: 28),
                Text(
                  l10n.t('welcome_title'),
                  style: AppTextStyles.label(size: 13),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                const SizedBox(height: 12),
                Text(
                  l10n.isArabic
                      ? '${AppConstants.brideNameAr} & ${AppConstants.groomNameAr}'
                      : '${AppConstants.brideNameEn} & ${AppConstants.groomNameEn}',
                  style: AppTextStyles.script(size: 44),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms, duration: 700.ms).scale(
                    begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
              ],
            ),
          ),
          Positioned(
            top: 24,
            right: l10n.isArabic ? null : 24,
            left: l10n.isArabic ? 24 : null,
            child: SafeArea(
              child: TextButton(
                onPressed: widget.onFinished,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.gold,
                  backgroundColor: AppColors.emerald.withOpacity(0.4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: AppColors.gold.withOpacity(0.5)),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.t('skip'), style: AppTextStyles.label(size: 12)),
                    const SizedBox(width: 6),
                    Icon(
                      l10n.isArabic
                          ? Icons.arrow_back_ios_new_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.gold,
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

/// Fallback intro shown when no `splash.gif` asset is bundled: a pulsing
/// gold ring around a heart monogram — simple, elegant, on-brand.
class _FallbackIntroArt extends StatelessWidget {
  const _FallbackIntroArt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold.withOpacity(0.5)),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.05, 1.05),
                duration: 1400.ms,
                curve: Curves.easeInOut,
              )
              .fadeIn(duration: 600.ms),
          const Icon(Icons.favorite, color: AppColors.gold, size: 56)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.1, 1.1),
                duration: 900.ms,
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }
}
