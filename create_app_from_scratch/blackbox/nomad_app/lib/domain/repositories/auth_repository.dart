import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  User? get currentUser;
  Stream<User?> get authStateChanges;

  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
