import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String title;
  final String description;
  final Timestamp createdAt;
  final double progress;

  GoalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.progress,
  });

  factory GoalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GoalModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      createdAt: data['createdAt'],
      progress: (data['progress'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'progress': progress,
    };
  }
}
