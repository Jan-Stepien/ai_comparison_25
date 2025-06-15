import 'package:nomad_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(UserEntity user);
  Future<UserEntity?> getUser(String userId);
  Future<void> updateUser(UserEntity user);
  Future<void> updateShippingDetails(String userId, ShippingDetails shippingDetails);
}