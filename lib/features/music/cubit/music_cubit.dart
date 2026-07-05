import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';

enum MusicPlaybackStatus { loading, playing, paused }

/// Manages the looping background music track.
///
/// Browsers block audio-with-sound from starting until the page has
/// received a user gesture — this is a security policy, not a bug, and
/// it can't be worked around. The tricky part (and the reason this can
/// work on desktop but silently fail on mobile) is that the gesture
/// "grace period" browsers give you is short, and mobile Safari in
/// particular expects the actual `play()` call to happen almost
/// synchronously within the gesture handler. If that call still has to
/// fetch and decode the audio asset first, the extra latency on a phone
/// is often just enough to blow past that window — so playback gets
/// silently blocked with no error.
///
/// The fix is to do the expensive part (loading the asset into the
/// browser's `<audio>` element) *ahead of time*, during [_init], while
/// there's no gesture requirement yet — that's allowed. Then the actual
/// gesture-triggered call in [unlockWithUserGesture] only has to call
/// `resume()`, which is fast enough to stay inside the gesture window on
/// both desktop and mobile.
class MusicCubit extends Cubit<MusicPlaybackStatus> {
  MusicCubit() : super(MusicPlaybackStatus.loading) {
    _init();
  }

  final AudioPlayer _player = AudioPlayer();
  bool _userPaused = false;
  bool _sourceReady = false;

  Future<void> _init() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(AppConstants.backgroundMusicVolume);
    try {
      // Loads/decodes the track into the underlying <audio> element
      // without requiring a user gesture — only *playing* it does.
      await _player.setSource(AssetSource(AppConstants.backgroundMusicAssetPath));
      _sourceReady = true;
    } catch (_) {
      _sourceReady = false;
    }
    // Some browsers/contexts (native apps, certain desktop configs) allow
    // this immediately; most mobile/desktop web browsers will block it,
    // which is expected and handled below.
    await _attemptPlay();
  }

  Future<void> _attemptPlay() async {
    try {
      if (_sourceReady) {
        await _player.resume();
      } else {
        await _player.play(
          AssetSource(AppConstants.backgroundMusicAssetPath),
          volume: AppConstants.backgroundMusicVolume,
        );
      }
      emit(MusicPlaybackStatus.playing);
    } catch (_) {
      // Autoplay was blocked (typical on web before any user gesture).
      emit(MusicPlaybackStatus.paused);
    }
  }

  /// Call on the first user interaction with the page. No-ops once music
  /// is already playing, or if the guest has deliberately paused it.
  /// Kept synchronous-as-possible on the call site (see `main.dart`) so
  /// the browser still recognizes it as gesture-triggered on mobile.
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
