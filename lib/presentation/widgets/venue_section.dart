import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
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

    return SectionWrapper(
      child: Column(
        children: [
          const SectionTitle(
            eyebrow: 'JOIN US AT',
            title: 'Wedding Ceremony & Reception',
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
                  AppConstants.venueName,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading(size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  AppConstants.venueAddress,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(size: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  '${AppConstants.weddingDateLabel} · ${AppConstants.weddingTimeLabel}',
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyles.body(size: 14, color: AppColors.goldLight),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _openMaps,
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: const Text('VIEW ON GOOGLE MAPS'),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }
}
