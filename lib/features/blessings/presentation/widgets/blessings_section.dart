import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

/// ----------------------- LIST (auto-scrolling marquee) -----------------------

class _BlessingsList extends StatelessWidget {
  const _BlessingsList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final GlobalKey<_AutoScrollBlessingsRowState> scrollRowKey = GlobalKey();

    return BlocConsumer<BlessingsCubit, BlessingsState>(
      listenWhen: (prev, curr) => prev.submissionStatus != curr.submissionStatus,
      listener: (context, state) {
        // When user writes a blessing, instantly scroll back to the start
        if (state.submissionStatus == SubmissionStatus.success) {
          scrollRowKey.currentState?.resetToStart();
        }
      },
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

            // Arrange list depending on blessing date (Newest first)
            final sortedBlessings = List<BlessingModel>.from(state.blessings)
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final count = state.totalBlessings;
            final countLabel =
                '$count ${count == 1 ? l10n.t('blessings_count_one') : l10n.t('blessings_count_many')}';
            return Column(
              children: [
                Text(countLabel, style: AppTextStyles.label(size: 12)),
                const SizedBox(height: 24),
                _AutoScrollBlessingsRow(
                  key: scrollRowKey,
                  blessings: sortedBlessings,
                ),
              ],
            );
        }
      },
    );
  }
}

class _AutoScrollBlessingsRow extends StatefulWidget {
  const _AutoScrollBlessingsRow({super.key, required this.blessings});
  final List<BlessingModel> blessings;

  @override
  State<_AutoScrollBlessingsRow> createState() => _AutoScrollBlessingsRowState();
}

class _AutoScrollBlessingsRowState extends State<_AutoScrollBlessingsRow>
    with SingleTickerProviderStateMixin {
  static const double _cardWidth = 280;
  static const double _cardHeight = 168;
  static const double _cardSpacing = 16;
  static const double _pxPerSecond = 26; 

  final ScrollController _scrollController = ScrollController();
  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;
  bool _paused = false;
  Timer? _resumeTimer;

  bool get _shouldAutoScroll => widget.blessings.length >= 3;

  double get _singlePassWidth =>
      widget.blessings.length * (_cardWidth + _cardSpacing);

  @override
  void initState() {
    super.initState();
    if (_shouldAutoScroll) {
      _ticker = createTicker(_onTick)..start();
    }
  }

  @override
  void didUpdateWidget(covariant _AutoScrollBlessingsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldAutoScroll && _ticker == null) {
      _ticker = createTicker(_onTick)..start();
    } else if (!_shouldAutoScroll) {
      _ticker?.dispose();
      _ticker = null;
    }
  }

  /// Forces the list back to the zero position to instantly show a new submission
  void resetToStart() {
    _resumeTimer?.cancel();
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
    // Pause briefly so the user can read their posted text before it flows away again
    setState(() => _paused = true);
    _scheduleResume();
  }

  void _onTick(Duration elapsed) {
    if (_paused || !_scrollController.hasClients) {
      _lastElapsed = elapsed;
      return;
    }
    final dtSeconds =
        (elapsed - _lastElapsed).inMicroseconds / Duration.microsecondsPerSecond;
    _lastElapsed = elapsed;

    final passWidth = _singlePassWidth;
    if (passWidth <= 0) return;

    double next = _scrollController.offset + (_pxPerSecond * dtSeconds);
    if (next >= passWidth) {
      next -= passWidth; // Seamless loops back around
    }
    _scrollController.jumpTo(next);
  }

  void _pause() {
    _resumeTimer?.cancel();
    setState(() => _paused = true);
  }

  void _scheduleResume() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _paused = false);
    });
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _resumeTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _shouldAutoScroll
        ? [...widget.blessings, ...widget.blessings]
        : widget.blessings;

    final row = SizedBox(
      height: _cardHeight,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: _cardSpacing),
        itemBuilder: (context, index) {
          return SizedBox(
            width: _cardWidth,
            height: _cardHeight,
            child: _BlessingCard(blessing: items[index]),
          );
        },
      ),
    );

    if (!_shouldAutoScroll) {
      return Center(
        child: SizedBox(
          width: (_cardWidth + _cardSpacing) * items.length,
          child: row,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => _pause(),
      onExit: (_) => _scheduleResume(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification && notification.dragDetails != null) {
            _pause();
          } else if (notification is ScrollEndNotification) {
            _scheduleResume();
          }
          return false;
        },
        child: row,
      ),
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