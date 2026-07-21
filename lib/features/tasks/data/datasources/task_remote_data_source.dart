import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  /// Streams all tasks from the 'tasks' collection in Firestore.
  Stream<List<TaskModel>> getTasks();

  /// Adds a new task document to Firestore.
  Future<void> addTask(TaskModel task);

  /// Updates an existing task document in Firestore.
  Future<void> updateTask(TaskModel task);

  /// Deletes a task document by ID from Firestore.
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      firestore.collection('tasks');

  @override
  Stream<List<TaskModel>> getTasks() {
    return _tasksCollection.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromFirestore(doc))
              .toList(),
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
