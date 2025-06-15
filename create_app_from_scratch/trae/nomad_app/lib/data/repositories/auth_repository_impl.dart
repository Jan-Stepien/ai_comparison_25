import 'package:firebase_auth/firebase_auth.dart';
import 'package:nomad_app/domain/repositories/auth_repository.dart';
import 'package:nomad_app/services/auth/firebase_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) {
    return _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) {
    return _authService.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }

  @override
  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }
}