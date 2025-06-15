import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';
import '../data/models/package_model.dart';
import '../data/models/payment_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users Collection
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw 'Failed to get user: $e';
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  // Orders Collection
  Future<String> createOrder(OrderModel order) async {
    try {
      final docRef = await _firestore.collection('orders').add(order.toJson());
      return docRef.id;
    } catch (e) {
      throw 'Failed to create order: $e';
    }
  }

  Future<OrderModel?> getOrder(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists && doc.data() != null) {
        return OrderModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw 'Failed to get order: $e';
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });
    } catch (e) {
      throw 'Failed to update order status: $e';
    }
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('user.id', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}),
                  )
                  .toList(),
        );
  }

  // Packages Collection
  Future<List<PackageModel>> getAvailablePackages() async {
    try {
      final snapshot = await _firestore.collection('packages').get();
      return snapshot.docs
          .map((doc) => PackageModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw 'Failed to get packages: $e';
    }
  }

  // Initialize default packages if they don't exist
  Future<void> initializeDefaultPackages() async {
    try {
      final packagesRef = _firestore.collection('packages');
      final snapshot = await packagesRef.get();

      if (snapshot.docs.isEmpty) {
        await packagesRef.add(PackageModel.nomadPackage.toJson());
        await packagesRef.add(PackageModel.proPackage.toJson());
      }
    } catch (e) {
      throw 'Failed to initialize default packages: $e';
    }
  }
}
