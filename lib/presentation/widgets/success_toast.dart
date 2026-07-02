import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/extensions.dart';
import '../../core/theme/app_theme.dart';

/// A premium, custom overlay toast shown when a blessing is successfully
/// submitted. Shows the couple's image alongside a beautifully styled
/// thank-you message in the active language.
class SuccessToast {
  SuccessToast._();

  /// Shows the toast as a floating overlay. Automatically dismisses after
  /// [duration]. Returns immediately; the caller does not need to await.
  static void show(BuildContext context, {Duration duration = const Duration(seconds: 5)}) {
    // Use an OverlayEntry so it floats above everything, including the
    // bottom snackbar area.
    final overlay = OverlayEntry(
      builder: (_) => _ToastBody(duration: duration),
    );

    Overlay.of(context).insert(overlay);

    // Remove the overlay after the toast completes its lifecycle.
    Future.delayed(duration + 400.ms, () {
      if (overlay.mounted) overlay.remove();
    });
  }
}

class _ToastBody extends StatefulWidget {
  const _ToastBody({required this.duration});
  final Duration duration;

  @override
  State<_ToastBody> createState() => _ToastBodyState();
}

class _ToastBodyState extends State<_ToastBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Animate in.
    _controller.forward();

    // Animate out after the display duration.
    Future.delayed(widget.duration, () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = l10n.isArabic;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 24,
      left: 16,
      right: 16,
      child: ScaleTransition(
        scale: _scale,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              margin: EdgeInsets.only(
                left: isArabic ? 0 : 0,
                right: isArabic ? 0 : 0,
              ),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.emerald,
                    AppColors.deepNavy,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.gold.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ─── Couple image ───
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.6),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppConstants.coupleImagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.emerald,
                          child: Icon(
                            Icons.favorite,
                            color: AppColors.gold.withOpacity(0.6),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // ─── Message ───
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.blessingSubmitted,
                          style: AppTextStyles.label(
                            size: 13,
                            color: AppColors.gold,
                          ),
                          textAlign: isArabic ? TextAlign.end : TextAlign.start,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.toastThankYou,
                          style: AppTextStyles.body(
                            size: 13,
                            color: AppColors.ivory,
                            height: 1.4,
                          ),
                          textAlign: isArabic ? TextAlign.end : TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
