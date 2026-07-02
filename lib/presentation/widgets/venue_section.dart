import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/responsive.dart';
import 'common/section_wrapper.dart';

class VenueSection extends StatelessWidget {
  const VenueSection({super.key});

  Future<void> _openMaps() async {
    final uri = Uri.parse(AppConstants.googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final l10n = AppLocalizations.of(context);
    final dateLabel = l10n.isArabic
        ? DateFormatter.dateLabelAr(AppConstants.weddingDateTime)
        : DateFormatter.dateLabelEn(AppConstants.weddingDateTime);
    final timeLabel = l10n.isArabic
        ? DateFormatter.timeLabelAr(AppConstants.weddingDateTime)
        : DateFormatter.timeLabelEn(AppConstants.weddingDateTime);

    return SectionWrapper(
      child: Column(
        children: [
          SectionTitle(
            eyebrow: l10n.t('join_us_at'),
            title: l10n.t('venue_title'),
          ),
          const SizedBox(height: 48),
          Container(
            padding: EdgeInsets.all(isMobile ? 28 : 48),
            decoration: BoxDecoration(
              color: AppColors.emerald.withOpacity(0.35),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gold.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.gold, size: 40),
                const SizedBox(height: 20),
                Text(
                  l10n.venueName,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading(size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  '$dateLabel · $timeLabel',
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyles.body(size: 14, color: AppColors.goldLight),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _openMaps,
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: Text(l10n.t('view_on_maps')),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }
}
