import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/models/user_model.dart';

abstract class UserRepository {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUser(String userId);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
}

class FirestoreUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;
  static const String _usersCollection = 'users';

  FirestoreUserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      throw RepositoryException('Failed to create user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc =
          await _firestore.collection(_usersCollection).doc(userId).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw RepositoryException('Failed to get user: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .update(user.toMap());
    } catch (e) {
      throw RepositoryException('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).delete();
    } catch (e) {
      throw RepositoryException('Failed to delete user: ${e.toString()}');
    }
  }

  Future<void> createSubscription(
    String userId,
    SubscriptionModel subscription,
  ) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection('subscriptions')
          .doc(subscription.id)
          .set(subscription.toMap());
    } catch (e) {
      throw RepositoryException(
        'Failed to create subscription: ${e.toString()}',
      );
    }
  }

  Future<SubscriptionModel?> getActiveSubscription(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_usersCollection)
              .doc(userId)
              .collection('subscriptions')
              .where('status', isEqualTo: 'active')
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return SubscriptionModel.fromMap(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw RepositoryException('Failed to get subscription: ${e.toString()}');
    }
  }
}

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}
