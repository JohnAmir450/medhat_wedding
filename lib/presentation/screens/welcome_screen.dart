import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/extensions.dart';
import '../../core/theme/app_theme.dart';
import '../pages/wedding_home_page.dart';

/// Premium welcome (splash) screen that plays an introduction GIF
/// before transitioning to the main invitation page.
///
/// Replace [AppConstants.splashGifPath] with your own GIF file.
/// The screen auto-advances after the GIF duration and includes a
/// minimal "Skip" button for immediate access.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Start fade-in for the splash content.
    _fadeController.forward();

    // Auto-advance after 4 seconds (adjust to your GIF's length).
    Future.delayed(const Duration(seconds: 4), _onFinished);
  }

  void _onFinished() {
    if (!mounted) return;
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const WeddingHomePage(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // ─── Center content: Splash GIF / Placeholder ───
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Premium placeholder animation while waiting for the real GIF.
                  // Replace AppConstants.splashGifPath with your own GIF file.
                  _SplashGifPlaceholder(),
                  const SizedBox(height: 48),
                  Text(
                    '${AppConstants.groomName} & ${AppConstants.brideName}',
                    style: AppTextStyles.script(size: 52),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 1200.ms)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    width: 80,
                    color: AppColors.gold.withOpacity(0.6),
                  )
                      .animate()
                      .fadeIn(delay: 900.ms, duration: 800.ms)
                      .scaleX(begin: 0, end: 1),
                  const SizedBox(height: 16),
                  Text(
                    l10n.welcome,
                    style: AppTextStyles.label(size: 14),
                  )
                      .animate()
                      .fadeIn(delay: 1100.ms, duration: 800.ms),
                ],
              ),
            ),

            // ─── Skip button ───
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 20,
              child: SafeArea(
                child: TextButton(
                  onPressed: _navigateToHome,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.gold,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    side: BorderSide(
                      color: AppColors.gold.withOpacity(0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.skip,
                        style: AppTextStyles.label(
                          size: 12,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 12, color: AppColors.gold),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Bottom hint ───
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Text(
                l10n.coupleNames,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(
                  size: 12,
                  color: AppColors.textMuted,
                ),
              )
                  .animate()
                  .fadeIn(delay: 1500.ms, duration: 1000.ms),
            ),
          ],
        ),
      ),
    );
  }
}

/// A beautiful animated placeholder that simulates a rich splash while
/// the actual GIF file is being prepared.
///
/// Replace with a real GIF player once you drop your `.gif` into
/// `assets/gifs/splash.gif`:
///
/// ```dart
/// Image.asset(
///   AppConstants.splashGifPath,
///   fit: BoxFit.contain,
/// )
/// ```
class _SplashGifPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.15),
            blurRadius: 50,
            spreadRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.favorite_rounded,
          size: 64,
          color: AppColors.gold.withOpacity(0.7),
        )
            .animate()
            .shimmer(
              delay: 500.ms,
              duration: 2000.ms,
              color: AppColors.goldLight,
            )
            .then()
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.08, 1.08),
              duration: 1500.ms,
            )
            .then()
            .scale(
              begin: const Offset(1.08, 1.08),
              end: const Offset(1, 1),
              duration: 1500.ms,
            ),
      ),
    );
  }
}
