import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../presentation/widgets/common/section_wrapper.dart';
import '../../cubit/blessings_cubit.dart';
import '../../cubit/blessings_state.dart';
import '../../data/models/blessing_model.dart';

class BlessingsSection extends StatefulWidget {
  const BlessingsSection({super.key});

  @override
  State<BlessingsSection> createState() => _BlessingsSectionState();
}

class _BlessingsSectionState extends State<BlessingsSection> {
  @override
  void initState() {
    super.initState();
    context.read<BlessingsCubit>().subscribeToBlessings();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionWrapper(
      backgroundColor: AppColors.emerald.withOpacity(0.2),
      child: Column(
        children: [
          SectionTitle(
            eyebrow: l10n.t('guestbook_eyebrow'),
            title: l10n.t('guestbook_title'),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.t('guestbook_subtitle'),
            textAlign: TextAlign.center,
            style: AppTextStyles.body(size: 15),
          ),
          const SizedBox(height: 48),
          const _BlessingForm(),
          const SizedBox(height: 56),
          const _BlessingsList(),
        ],
      ),
    );
  }
}

/// ----------------------- FORM -----------------------

class _BlessingForm extends StatefulWidget {
  const _BlessingForm();

  @override
  State<_BlessingForm> createState() => _BlessingFormState();
}

class _BlessingFormState extends State<_BlessingForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isAnonymous = false;

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<BlessingsCubit>().submitBlessing(
          name: _nameController.text,
          message: _messageController.text,
          isAnonymous: _isAnonymous,
        );
  }

  /// Shows a premium custom toast (couple photo + a warm thank-you message
  /// in the active language) instead of a plain default SnackBar.
  void _showThankYouToast(BuildContext context, AppLocalizations l10n) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        content: _ThankYouToast(l10n: l10n),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<BlessingsCubit, BlessingsState>(
      listenWhen: (prev, curr) => prev.submissionStatus != curr.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus == SubmissionStatus.success) {
          _messageController.clear();
          _nameController.clear();
          setState(() => _isAnonymous = false);
          _showThankYouToast(context, l10n);
        } else if (state.submissionStatus == SubmissionStatus.error &&
            state.submissionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              content: Text(
                state.submissionError!,
                style: AppTextStyles.body(color: AppColors.ivory),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.submissionStatus == SubmissionStatus.submitting;

        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 640),
          padding: EdgeInsets.all(isMobile ? 24 : 36),
          decoration: BoxDecoration(
            color: AppColors.deepNavy.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.gold.withOpacity(0.3)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Anonymous toggle
                Row(
                  children: [
                    Switch(
                      value: _isAnonymous,
                      activeColor: AppColors.gold,
                      onChanged: isSubmitting
                          ? null
                          : (v) => setState(() => _isAnonymous = v),
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.t('post_anonymously'), style: AppTextStyles.body(size: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_isAnonymous) ...[
                  TextFormField(
                    controller: _nameController,
                    enabled: !isSubmitting,
                    style: AppTextStyles.body(color: AppColors.ivory),
                    decoration: InputDecoration(hintText: l10n.t('your_name_hint')),
                    validator: (value) {
                      if (_isAnonymous) return null;
                      if (value == null || value.trim().isEmpty) {
                        return l10n.t('name_validation');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _messageController,
                  enabled: !isSubmitting,
                  maxLines: 4,
                  style: AppTextStyles.body(color: AppColors.ivory),
                  decoration: InputDecoration(
                    hintText: l10n.t('message_hint'),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.t('message_validation');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : () => _submit(context),
                    child: isSubmitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.deepNavy,
                            ),
                          )
                        : Text(l10n.t('send_blessing')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Custom "thank you" toast content: the couple's circular photo next to
/// a localized, warmly-worded message. Rendered inside a transparent,
/// floating SnackBar so it looks like a bespoke pop-up rather than a
/// default system toast.
class _ThankYouToast extends StatelessWidget {
  const _ThankYouToast({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.2),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      // Row automatically mirrors for RTL locales via the ambient
      // Directionality, so no manual reordering is needed here.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 1.2),
            ),
            child: ClipOval(
              child: SizedBox(
                width: 52,
                height: 52,
                child: Image.asset(
                  AppConstants.coupleImagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.emerald,
                    alignment: Alignment.center,
                    child: const Icon(Icons.favorite, color: AppColors.gold, size: 22),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              l10n.t('thank_you_message'),
              style: AppTextStyles.body(size: 13.5, color: AppColors.ivory, height: 1.5),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.15, end: 0);
  }
}

/// ----------------------- LIST -----------------------

class _BlessingsList extends StatelessWidget {
  const _BlessingsList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<BlessingsCubit, BlessingsState>(
      builder: (context, state) {
        switch (state.status) {
          case BlessingsStatus.initial:
          case BlessingsStatus.loading:
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          case BlessingsStatus.error:
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                state.errorMessage ?? l10n.t('load_error'),
                style: AppTextStyles.body(color: AppColors.error),
              ),
            );
          case BlessingsStatus.success:
            if (state.blessings.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  l10n.t('empty_blessings'),
                  style: AppTextStyles.body(),
                ),
              );
            }
            final count = state.totalBlessings;
            final countLabel = l10n.isArabic
                ? '$count ${count == 1 ? l10n.t('blessings_count_one') : l10n.t('blessings_count_many')}'
                : '$count ${count == 1 ? l10n.t('blessings_count_one') : l10n.t('blessings_count_many')}';
            return Column(
              children: [
                Text(countLabel, style: AppTextStyles.label(size: 12)),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 560),
                  child: SingleChildScrollView(
                    child: _ResponsiveBlessingsGrid(blessings: state.blessings),
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}

class _ResponsiveBlessingsGrid extends StatelessWidget {
  const _ResponsiveBlessingsGrid({required this.blessings});
  final List<BlessingModel> blessings;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.isMobile(context)
        ? 1
        : Responsive.isTablet(context)
            ? 2
            : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: blessings.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 160,
      ),
      itemBuilder: (context, index) {
        final blessing = blessings[index];
        return _BlessingCard(blessing: blessing)
            .animate()
            .fadeIn(duration: 400.ms, delay: (index * 40).ms)
            .slideY(begin: 0.1, end: 0);
      },
    );
  }
}

class _BlessingCard extends StatelessWidget {
  const _BlessingCard({required this.blessing});
  final BlessingModel blessing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final displayName = blessing.isAnonymous ? l10n.t('anonymous_label') : blessing.name;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.deepNavy.withOpacity(0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote, color: AppColors.gold.withOpacity(0.6), size: 20),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              blessing.message,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body(size: 14, color: AppColors.ivory),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.gold.withOpacity(0.2),
                child: Icon(
                  blessing.isAnonymous ? Icons.visibility_off : Icons.person,
                  size: 13,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayName,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label(size: 12, color: AppColors.goldLight),
                ),
              ),
              Text(
                timeago.format(blessing.createdAt, locale: l10n.isArabic ? 'ar' : 'en'),
                style: AppTextStyles.body(size: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
