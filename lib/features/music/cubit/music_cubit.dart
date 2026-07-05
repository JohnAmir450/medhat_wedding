import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';

enum MusicPlaybackStatus { loading, playing, paused }

/// Manages the looping background music track.
///
/// Browsers block audio-with-sound from starting until the page has
/// received a user gesture (a tap/click/keypress) — this is a security
/// policy, not a bug, and it can't be worked around. So the strategy
/// here is:
///   1. Try to autoplay immediately on app start (works on native
///      mobile/desktop builds, and on some browsers/PWA contexts).
///   2. If that's blocked (the common case on a fresh web tab), stay in
///      [MusicPlaybackStatus.paused] and wait for [unlockWithUserGesture]
///      to be called — wire that to the very first tap anywhere on the
///      page (see `RootScreen` in main.dart) so music starts the instant
///      the guest interacts with the invitation.
/// A floating toggle button (see `music_toggle_button.dart`) always lets
/// the guest mute/unmute manually regardless of how playback started.
class MusicCubit extends Cubit<MusicPlaybackStatus> {
  MusicCubit() : super(MusicPlaybackStatus.loading) {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();
  bool _userPaused = false;

  Future<void> _init() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _attemptPlay();
  }

  Future<void> _attemptPlay() async {
    try {
      await _player.play(
        AssetSource(AppConstants.backgroundMusicAssetPath),
        volume: AppConstants.backgroundMusicVolume,
      );
      emit(MusicPlaybackStatus.playing);
    } catch (_) {
      // Autoplay was blocked (typical on web before any user gesture).
      emit(MusicPlaybackStatus.paused);
    }
  }

  /// Call on the first user interaction with the page. No-ops once music
  /// is already playing, or if the guest has deliberately paused it.
  Future<void> unlockWithUserGesture() async {
    if (_userPaused || state == MusicPlaybackStatus.playing) return;
    await _attemptPlay();
  }

  /// Manual mute/unmute toggle for the floating music button.
  Future<void> toggle() async {
    if (state == MusicPlaybackStatus.playing) {
      await _player.pause();
      _userPaused = true;
      emit(MusicPlaybackStatus.paused);
    } else {
      _userPaused = false;
      await _attemptPlay();
    }
  }

  @override
  Future<void> close() async {
    await _player.dispose();
    return super.close();
  }
}
