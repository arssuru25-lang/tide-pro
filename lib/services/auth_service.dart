import 'package:firebase_auth/firebase_auth.dart';
import 'user_stats_service.dart';
class AuthService {
  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await UserStatsService.createUserIfNeeded();
    return credential;
  }

  static Future<UserCredential> login({
  required String email,
  required String password,
}) async {

  final credential =
      await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  await UserStatsService.createUserIfNeeded();

  return credential;
}

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static User? get currentUser =>
      _auth.currentUser;
}