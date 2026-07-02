import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    return SectionWrapper(
      backgroundColor: AppColors.emerald.withOpacity(0.2),
      child: Column(
        children: [
          const SectionTitle(
            eyebrow: 'GUESTBOOK',
            title: 'Blessings & Wishes',
          ),
          const SizedBox(height: 12),
          Text(
            "Leave a message of love for the happy couple",
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

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return BlocConsumer<BlessingsCubit, BlessingsState>(
      listenWhen: (prev, curr) => prev.submissionStatus != curr.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus == SubmissionStatus.success) {
          _messageController.clear();
          _nameController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Thank you for your blessing! 💛',
                style: AppTextStyles.body(color: AppColors.deepNavy),
              ),
            ),
          );
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
                    Text('Post anonymously', style: AppTextStyles.body(size: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_isAnonymous) ...[
                  TextFormField(
                    controller: _nameController,
                    enabled: !isSubmitting,
                    style: AppTextStyles.body(color: AppColors.ivory),
                    decoration: const InputDecoration(hintText: 'Your name'),
                    validator: (value) {
                      if (_isAnonymous) return null;
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
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
                  decoration: const InputDecoration(
                    hintText: 'Write your blessing or congratulations...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please write a message';
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
                        : const Text('SEND BLESSING'),
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

/// ----------------------- LIST -----------------------

class _BlessingsList extends StatelessWidget {
  const _BlessingsList();

  @override
  Widget build(BuildContext context) {
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
                state.errorMessage ?? 'Something went wrong.',
                style: AppTextStyles.body(color: AppColors.error),
              ),
            );
          case BlessingsStatus.success:
            if (state.blessings.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Be the first to leave a blessing!',
                  style: AppTextStyles.body(),
                ),
              );
            }
            return Column(
              children: [
                Text(
                  '${state.totalBlessings} blessing${state.totalBlessings == 1 ? '' : 's'} and counting',
                  style: AppTextStyles.label(size: 12),
                ),
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
                  blessing.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label(size: 12, color: AppColors.goldLight),
                ),
              ),
              Text(
                timeago.format(blessing.createdAt),
                style: AppTextStyles.body(size: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
