import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';

/// Provides consistent horizontal padding, max content width, and
/// vertical rhythm for every section on the page.
class SectionWrapper extends StatelessWidget {
  const SectionWrapper({
    super.key,
    required this.child,
    this.backgroundColor,
    this.verticalPadding = 96,
  });

  final Widget child;
  final Color? backgroundColor;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: verticalPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: Responsive.contentMaxWidth(context)),
          child: child,
        ),
      ),
    );
  }
}

/// Small gold ornament divider used under section eyebrow labels.
class OrnamentDivider extends StatelessWidget {
  const OrnamentDivider({super.key, this.width = 60});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _line(),
        const SizedBox(width: 10),
        Icon(Icons.diamond_outlined, size: 12, color: AppColors.gold),
        const SizedBox(width: 10),
        _line(),
      ],
    );
  }

  Widget _line() => Container(
        width: width,
        height: 1,
        color: AppColors.gold.withOpacity(0.5),
      );
}

/// Eyebrow + heading pair used at the top of most sections.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    this.center = true,
  });

  final String eyebrow;
  final String title;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final crossAxis =
        center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Text(eyebrow, style: AppTextStyles.label()),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.left,
          style: AppTextStyles.heading(size: 34),
        ),
        const SizedBox(height: 16),
        const OrnamentDivider(),
      ],
    );
  }
}
