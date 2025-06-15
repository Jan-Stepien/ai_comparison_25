import '../../data/models/user_model.dart';
import '../../data/models/payment_model.dart';

abstract class UserRepository {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUser(String userId);
  Future<void> updateUser(UserModel user);
  Future<String> createOrder(OrderModel order);
  Future<OrderModel?> getOrder(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
  Stream<List<OrderModel>> getUserOrders(String userId);
}
