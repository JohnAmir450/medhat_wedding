import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// A single guestbook entry.
class BlessingModel extends Equatable {
  final String id;
  final String name; // "Anonymous" when [isAnonymous] is true
  final String message;
  final bool isAnonymous;
  final DateTime createdAt;

  const BlessingModel({
    required this.id,
    required this.name,
    required this.message,
    required this.isAnonymous,
    required this.createdAt,
  });

  factory BlessingModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final Timestamp? ts = data['createdAt'] as Timestamp?;
    return BlessingModel(
      id: doc.id,
      name: (data['isAnonymous'] as bool? ?? false)
          ? 'Anonymous'
          : (data['name'] as String? ?? 'Guest'),
      message: data['message'] as String? ?? '',
      isAnonymous: data['isAnonymous'] as bool? ?? false,
      createdAt: ts?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'message': message,
      'isAnonymous': isAnonymous,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props => [id, name, message, isAnonymous, createdAt];
}
