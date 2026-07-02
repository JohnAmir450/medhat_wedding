import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/extensions.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import 'common/section_wrapper.dart';

class CountdownSection extends StatefulWidget {
  const CountdownSection({super.key});

  @override
  State<CountdownSection> createState() => _CountdownSectionState();
}

class _CountdownSectionState extends State<CountdownSection> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    final diff = AppConstants.weddingDateTime.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;
    final isMobile = Responsive.isMobile(context);
    final hasArrived = _remaining == Duration.zero;

    return SectionWrapper(
      backgroundColor: AppColors.emerald.withOpacity(0.25),
      child: Column(
        children: [
          SectionTitle(
            eyebrow: l10n.countingDown,
            title: l10n.ourForeverBegins,
          ),
          const SizedBox(height: 48),
          if (hasArrived)
            Text(
              l10n.itsWeddingDay,
              style: AppTextStyles.heading(size: 26, color: AppColors.gold),
            )
          else
            Wrap(
              spacing: isMobile ? 14 : 28,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _TimeBox(value: days, label: l10n.days, compact: isMobile),
                _TimeBox(value: hours, label: l10n.hours, compact: isMobile),
                _TimeBox(value: minutes, label: l10n.minutes, compact: isMobile),
                _TimeBox(value: seconds, label: l10n.seconds, compact: isMobile),
              ],
            ),
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({
    required this.value,
    required this.label,
    this.compact = false,
  });

  final int value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 74.0 : 100.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(6),
        color: AppColors.deepNavy.withOpacity(0.4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.4),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Text(
              value.toString().padLeft(2, '0'),
              key: ValueKey<int>(value),
              style: AppTextStyles.heading(
                size: compact ? 26 : 34,
                color: AppColors.gold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.label(size: compact ? 9 : 11),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9));
  }
}
