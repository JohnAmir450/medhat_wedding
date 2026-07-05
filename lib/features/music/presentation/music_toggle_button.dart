import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../cubit/music_cubit.dart';

/// Small floating pill button (matches the language-toggle button's
/// styling) that lets guests mute/unmute the background music at any
/// time. Shows a subtle pulsing ring while music is actually playing.
class MusicToggleButton extends StatelessWidget {
  const MusicToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<MusicCubit>().state;
    final isPlaying = status == MusicPlaybackStatus.playing;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => context.read<MusicCubit>().toggle(),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.deepNavy.withOpacity(0.65),
            border: Border.all(color: AppColors.gold.withOpacity(0.6)),
          ),
          child: Icon(
            isPlaying ? Icons.music_note_rounded : Icons.music_off_rounded,
            size: 18,
            color: AppColors.gold,
          ),
        ),
      ),
    );
  }
}
