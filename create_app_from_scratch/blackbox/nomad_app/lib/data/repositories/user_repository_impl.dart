import '../../domain/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/models/payment_model.dart';
import '../../services/database_service.dart';

class UserRepositoryImpl implements UserRepository {
  final DatabaseService _databaseService;

  UserRepositoryImpl(this._databaseService);

  @override
  Future<void> createUser(UserModel user) async {
    await _databaseService.createUser(user);
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    return await _databaseService.getUser(userId);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _databaseService.updateUser(user);
  }

  @override
  Future<String> createOrder(OrderModel order) async {
    return await _databaseService.createOrder(order);
  }

  @override
  Future<OrderModel?> getOrder(String orderId) async {
    return await _databaseService.getOrder(orderId);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _databaseService.updateOrderStatus(orderId, status);
  }

  @override
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _databaseService.getUserOrders(userId);
  }
}
