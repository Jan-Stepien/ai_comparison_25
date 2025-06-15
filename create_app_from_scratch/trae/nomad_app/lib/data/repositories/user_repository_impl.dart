import 'package:nomad_app/data/models/user_model.dart';
import 'package:nomad_app/domain/entities/user_entity.dart';
import 'package:nomad_app/domain/repositories/user_repository.dart';
import 'package:nomad_app/services/database/firestore_service.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreService _firestoreService;

  UserRepositoryImpl(this._firestoreService);

  @override
  Future<void> createUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _firestoreService.setDocument('users', user.id, userModel.toJson());
  }

  @override
  Future<UserEntity?> getUser(String userId) async {
    final docSnapshot = await _firestoreService.getDocument('users', userId);
    if (docSnapshot.exists) {
      return UserModel.fromJson(docSnapshot.data()!).toEntity();
    }
    return null;
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _firestoreService.updateDocument('users', user.id, userModel.toJson());
  }

  @override
  Future<void> updateShippingDetails(String userId, ShippingDetails shippingDetails) async {
    final shippingModel = ShippingDetailsModel.fromEntity(shippingDetails);
    await _firestoreService.updateDocument('users', userId, {
      'shippingDetails': shippingModel.toJson(),
    });
  }
}