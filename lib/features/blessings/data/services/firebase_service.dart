import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/blessing_model.dart';

/// Thin wrapper around Cloud Firestore for the blessings (guestbook) feature.
/// Keeping all Firestore-specific code here means the Cubit / UI never
/// talks to `cloud_firestore` directly — easy to swap backends later.
class FirebaseService {
  FirebaseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _blessingsRef =>
      _firestore.collection(AppConstants.blessingsCollection);

  /// Real-time stream of blessings, newest first.
  Stream<List<BlessingModel>> streamBlessings() {
    return _blessingsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(BlessingModel.fromFirestore).toList());
  }

  /// Adds a new blessing document to Firestore.
  Future<void> addBlessing({
    required String name,
    required String message,
    required bool isAnonymous,
  }) async {
    final blessing = BlessingModel(
      id: '',
      name: isAnonymous ? 'Anonymous' : name.trim(),
      message: message.trim(),
      isAnonymous: isAnonymous,
      createdAt: DateTime.now(),
    );
    await _blessingsRef.add(blessing.toFirestore());
  }
}
