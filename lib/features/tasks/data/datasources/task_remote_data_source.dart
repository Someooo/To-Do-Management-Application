import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Stream<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TaskRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  String get _currentUserId {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception(
        'User is not authenticated. Unable to perform task operations.',
      );
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      firestore.collection('users').doc(_currentUserId).collection('tasks');

  @override
  Stream<List<TaskModel>> getTasks() {
    return _tasksCollection.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList(),
        );
  }

  @override
  Future<void> addTask(TaskModel task) async {
    if (task.id.isNotEmpty) {
      await _tasksCollection.doc(task.id).set(task.toFirestore());
    } else {
      await _tasksCollection.add(task.toFirestore());
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _tasksCollection.doc(task.id).update(task.toFirestore());
  }

  @override
  Future<void> deleteTask(String id) async {
    await _tasksCollection.doc(id).delete();
  }
}
