import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  // Users collection
  CollectionReference<Map<String, dynamic>> get usersCollection => 
      _firestore.collection('users');

  // Subscriptions collection
  CollectionReference<Map<String, dynamic>> get subscriptionsCollection => 
      _firestore.collection('subscriptions');

  // Plans collection
  CollectionReference<Map<String, dynamic>> get plansCollection => 
      _firestore.collection('plans');

  // Products collection
  CollectionReference<Map<String, dynamic>> get productsCollection => 
      _firestore.collection('products');

  // Generic methods for CRUD operations
  Future<void> setDocument(String collection, String documentId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(documentId).set(data);
  }

  Future<void> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String collection, String documentId) async {
    return await _firestore.collection(collection).doc(documentId).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDocumentsWhere(
    String collection, 
    String field, 
    dynamic value
  ) async {
    return await _firestore.collection(collection).where(field, isEqualTo: value).get();
  }

  Future<void> deleteDocument(String collection, String documentId) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  // Transaction methods
  Future<void> runTransaction(Function(Transaction) updateFunction) async {
    await _firestore.runTransaction((transaction) async {
      await updateFunction(transaction);
    });
  }
}