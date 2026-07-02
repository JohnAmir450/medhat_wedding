import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/extensions.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.deepNavy, AppColors.emerald],
        ),
      ),
      child: Stack(
        children: [
          _BackgroundOrnaments(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
                vertical: isMobile ? 48 : 80,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: isMobile
                      ? const _HeroMobileLayout()
                      : const _HeroDesktopLayout(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroDesktopLayout extends StatelessWidget {
  const _HeroDesktopLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: _CouplePhoto()),
        SizedBox(width: 72),
        Expanded(flex: 6, child: _InvitationText(center: false)),
      ],
    );
  }
}

class _HeroMobileLayout extends StatelessWidget {
  const _HeroMobileLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 8),
        _CouplePhoto(size: 240),
        SizedBox(height: 40),
        _InvitationText(center: true),
      ],
    );
  }
}

class _CouplePhoto extends StatelessWidget {
  const _CouplePhoto({this.size = 380});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size, // Fixed height ensures the container stays a perfect square
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.gold, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.25),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipOval(
          child: SizedBox(
            width: size - 12,  // accounting for padding
            height: size - 12, // same as width = perfect circle
            child: Image.asset(
              AppConstants.coupleImagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                final remoteUrl = AppConstants.coupleImageUrl;
                if (remoteUrl != null) {
                  return Image.network(
                    remoteUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _photoFallback(),
                  );
                }
                return _photoFallback();
              },
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 900.ms, curve: Curves.easeOut)
          .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack),
    );
  }

  Widget _photoFallback() => Container(
        color: AppColors.emerald,
        alignment: Alignment.center,
        child: const Icon(Icons.favorite, color: AppColors.gold, size: 48),
      );
}

class _InvitationText extends StatelessWidget {
  const _InvitationText({required this.center});
  final bool center;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = l10n.isArabic;
    final crossAxis =
        center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = center ? TextAlign.center : TextAlign.left;
    final effectiveTextAlign = isArabic ? TextAlign.center : textAlign;

    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Text(l10n.theWeddingOf, style: AppTextStyles.label())
            .animate()
            .fadeIn(delay: 200.ms, duration: 700.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 18),
        Text(
          '${l10n.brideName}\n${l10n.coupleAnd} ${l10n.groomName}',
          textAlign: effectiveTextAlign,
          style: AppTextStyles.script(size: 72),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 900.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 28),
        Container(height: 1, width: 90, color: AppColors.gold.withOpacity(0.5)),
        const SizedBox(height: 28),
        Text(
          AppConstants.weddingDateLabel,
          textAlign: effectiveTextAlign,
          style: AppTextStyles.heading(size: 22, weight: FontWeight.w500),
        ).animate().fadeIn(delay: 650.ms, duration: 700.ms),
        const SizedBox(height: 8),
        Text(
          AppConstants.weddingTimeLabel,
          textAlign: effectiveTextAlign,
          style: AppTextStyles.body(size: 16),
        ).animate().fadeIn(delay: 750.ms, duration: 700.ms),
        const SizedBox(height: 36),
        _ScrollHint(center: center)
            .animate()
            .fadeIn(delay: 1000.ms, duration: 700.ms),
      ],
    );
  }
}

class _ScrollHint extends StatelessWidget {
  const _ScrollHint({required this.center});
  final bool center;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.scrollToExplore, style: AppTextStyles.label(size: 11)),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_downward_rounded,
            color: AppColors.gold, size: 16),
      ],
    );
  }
}

/// Faint decorative circles to add depth without distracting from content.
class _BackgroundOrnaments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -80,
              child: _circle(220, AppColors.gold.withOpacity(0.05)),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: _circle(260, AppColors.gold.withOpacity(0.04)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}
