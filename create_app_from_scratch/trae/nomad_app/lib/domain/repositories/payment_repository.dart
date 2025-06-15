import 'package:nomad_app/domain/entities/subscription_entity.dart';

abstract class PaymentRepository {
  Future<String> createPaymentIntent(double amount, String currency);
  Future<bool> confirmPayment(String paymentIntentId, String paymentMethodId);
  Future<SubscriptionEntity> createSubscription(String userId, String planId);
  Future<bool> cancelSubscription(String subscriptionId);
  Future<List<SubscriptionEntity>> getUserSubscriptions(String userId);
}