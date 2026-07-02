import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/blessing_model.dart';
import '../data/services/firebase_service.dart';
import 'blessings_state.dart';

/// Manages the guestbook: subscribes to the real-time Firestore stream of
/// blessings and handles submitting new ones.
class BlessingsCubit extends Cubit<BlessingsState> {
  BlessingsCubit({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService(),
        super(const BlessingsState());

  final FirebaseService _firebaseService;
  StreamSubscription<List<BlessingModel>>? _subscription;

  /// Starts listening to the blessings collection. Call once when the
  /// blessings section becomes visible (e.g. in initState).
  void subscribeToBlessings() {
    emit(state.copyWith(status: BlessingsStatus.loading));
    _subscription?.cancel();
    _subscription = _firebaseService.streamBlessings().listen(
      (blessings) {
        emit(state.copyWith(
          status: BlessingsStatus.success,
          blessings: blessings,
        ));
      },
      onError: (Object error) {
        emit(state.copyWith(
          status: BlessingsStatus.error,
          errorMessage: 'Could not load blessings. Please try again.',
        ));
      },
    );
  }

  /// Submits a new blessing. Validates that the message isn't empty and
  /// that a name is provided when posting non-anonymously.
  Future<void> submitBlessing({
    required String name,
    required String message,
    required bool isAnonymous,
  }) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.error,
        submissionError: 'Please write a blessing before submitting.',
      ));
      return;
    }
    if (!isAnonymous && name.trim().isEmpty) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.error,
        submissionError: 'Please enter your name, or post anonymously.',
      ));
      return;
    }

    emit(state.copyWith(submissionStatus: SubmissionStatus.submitting));
    try {
      await _firebaseService.addBlessing(
        name: name,
        message: trimmedMessage,
        isAnonymous: isAnonymous,
      );
      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
      // Reset back to idle shortly after so the UI can show a fresh form.
      emit(state.copyWith(submissionStatus: SubmissionStatus.idle));
    } catch (e) {
      emit(state.copyWith(
        submissionStatus: SubmissionStatus.error,
        submissionError: 'Something went wrong. Please try again.',
      ));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
