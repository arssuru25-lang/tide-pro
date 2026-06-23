import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStatsService {
  static final _db = FirebaseFirestore.instance;

  static String get uid =>
      FirebaseAuth.instance.currentUser!.uid;

  static Future<void> createUserIfNeeded() async {
    final doc = _db.collection('users').doc(uid);

    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        'xp': 0,
        'level': 1,
        'streak': 0,
      });
    }
  }

  static Future<void> addXP(int amount) async {
    final doc = _db.collection('users').doc(uid);

    await doc.update({
      'xp': FieldValue.increment(amount),
    });
  }

  static Stream<DocumentSnapshot> statsStream() {
    return _db.collection('users').doc(uid).snapshots();
  }
  static Future<void> updateStreak() async {
  final doc = _db.collection('users').doc(uid);

  final snapshot = await doc.get();

  if (!snapshot.exists) return;

  final data = snapshot.data()!;

  final streak = data['streak'] ?? 0;
  final lastDate = data['lastCompleted'];

  final today = DateTime.now();

  if (lastDate == null) {
    await doc.update({
      'streak': 1,
      'lastCompleted': today.millisecondsSinceEpoch,
    });

    return;
  }

  final last =
      DateTime.fromMillisecondsSinceEpoch(lastDate);

  final difference =
      today.difference(
        DateTime(last.year, last.month, last.day),
      ).inDays;

  if (difference == 0) {
    return;
  }

  if (difference == 1) {
    await doc.update({
      'streak': streak + 1,
      'lastCompleted': today.millisecondsSinceEpoch,
    });
  } else {
    await doc.update({
      'streak': 1,
      'lastCompleted': today.millisecondsSinceEpoch,
    });
  }
}
}