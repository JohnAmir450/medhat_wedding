import 'package:equatable/equatable.dart';

import '../data/models/blessing_model.dart';

/// Status of the real-time blessings stream.
enum BlessingsStatus { initial, loading, success, error }

/// Status of the "submit a new blessing" form, tracked separately so the
/// list can stay visible/interactive while a submission is in flight.
enum SubmissionStatus { idle, submitting, success, error }

class BlessingsState extends Equatable {
  final BlessingsStatus status;
  final List<BlessingModel> blessings;
  final String? errorMessage;

  final SubmissionStatus submissionStatus;
  final String? submissionError;

  const BlessingsState({
    this.status = BlessingsStatus.initial,
    this.blessings = const [],
    this.errorMessage,
    this.submissionStatus = SubmissionStatus.idle,
    this.submissionError,
  });

  int get totalBlessings => blessings.length;

  BlessingsState copyWith({
    BlessingsStatus? status,
    List<BlessingModel>? blessings,
    String? errorMessage,
    SubmissionStatus? submissionStatus,
    String? submissionError,
  }) {
    return BlessingsState(
      status: status ?? this.status,
      blessings: blessings ?? this.blessings,
      errorMessage: errorMessage,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submissionError: submissionError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        blessings,
        errorMessage,
        submissionStatus,
        submissionError,
      ];
}
