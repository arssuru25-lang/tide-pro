import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import 'auth_service.dart';

class FirestoreService {
  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static CollectionReference get tasks {
    final uid = AuthService.currentUser!.uid;

    return _db
        .collection('users')
        .doc(uid)
        .collection('tasks');
  }

  static Future<void> addTask(Task task) async {
    final docRef = await tasks.add(task.toMap());

    task.id = docRef.id;
  }

  static Future<void> updateTask(Task task) async {
    if (task.id == null) return;

    await tasks.doc(task.id).update(task.toMap());
  }

  static Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }

  static Stream<QuerySnapshot> taskStream() {
    return tasks.snapshots();
  }
}