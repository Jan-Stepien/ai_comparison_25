import 'package:nomad_app/data/models/subscription_model.dart';
import 'package:nomad_app/domain/entities/subscription_entity.dart';
import 'package:nomad_app/domain/repositories/payment_repository.dart';
import 'package:nomad_app/services/payment/stripe_payment_service.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final StripePaymentService _paymentService;

  PaymentRepositoryImpl(this._paymentService);

  @override
  Future<String> createPaymentIntent(double amount, String currency) async {
    final paymentIntent = await _paymentService.createPaymentIntent(amount, currency);
    return paymentIntent['client_secret'];
  }

  @override
  Future<bool> confirmPayment(String paymentIntentId, String paymentMethodId) async {
    return await _paymentService.confirmPayment(paymentIntentId);
  }

  @override
  Future<SubscriptionEntity> createSubscription(String userId, String planId) async {
    final subscription = await _paymentService.createSubscription(userId, planId);
    return SubscriptionModel.fromJson(subscription).toEntity();
  }

  @override
  Future<bool> cancelSubscription(String subscriptionId) async {
    return await _paymentService.cancelSubscription(subscriptionId);
  }

  @override
  Future<List<SubscriptionEntity>> getUserSubscriptions(String userId) async {
    // This would typically call a backend API to get subscriptions
    // For now, we'll return a mock subscription
    return [
      SubscriptionEntity(
        id: 'sub_123',
        userId: userId,
        planId: 'pro_plan',
        planName: 'Pro Plan',
        price: 79.0,
        startDate: DateTime.now(),
        isActive: true,
      ),
    ];
  }
}