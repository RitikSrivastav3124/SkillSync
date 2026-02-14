import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillsync/models/task_model.dart';
import '../models/goal_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;

  FirestoreService(this.uid);

  CollectionReference get _goalRef =>
      _db.collection('users').doc(uid).collection('goals');

  Future<void> addGoal(String title, String description) async {
    await _goalRef.add({
      'title': title,
      'description': description,
      'createdAt': Timestamp.now(),
      'progress': 0.0,
    });
  }

  Stream<List<GoalModel>> getGoals() {
    return _goalRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => GoalModel.fromFirestore(doc)).toList(),
        );
  }

  Future<void> deleteGoal(String goalId) async {
    await _goalRef.doc(goalId).delete();
  }

  CollectionReference taskRef(String goalId) =>
      _goalRef.doc(goalId).collection('tasks');

  Future<void> addTask(String goalId, String title) async {
    final snapshot = await taskRef(goalId).get();
    final orderNumber = snapshot.docs.length + 1;

    await taskRef(goalId).add({
      'title': title,
      'isCompleted': false,
      'createdAt': Timestamp.now(),
      'order': orderNumber,
    });
  }

  Stream<List<TaskModel>> getTasks(String goalId) {
    return taskRef(goalId)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList(),
        );
  }

  Future<void> deleteTask(String goalId, String taskId) async {
    await taskRef(goalId).doc(taskId).delete();
  }

  Future<void> updateTask(String goalId, String taskId, String newTitle) async {
    await taskRef(goalId).doc(taskId).update({'title': newTitle});
  }

  Future<void> toggleTask(
    String goalId,
    String taskId,
    bool currentStatus,
  ) async {
    await taskRef(goalId).doc(taskId).update({'isCompleted': !currentStatus});
  }
}
