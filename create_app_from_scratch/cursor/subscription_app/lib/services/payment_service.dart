import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

abstract class PaymentService {
  Future<void> initializePayment();
  Future<String> createPaymentIntent({
    required int amount,
    required String currency,
    required String customerId,
  });
  Future<String> createSubscription({
    required String customerId,
    required String priceId,
  });
  Future<void> confirmPayment(String clientSecret);
}

class StripePaymentService implements PaymentService {
  static const String _baseUrl = 'https://api.stripe.com/v1';
  final String _secretKey;

  StripePaymentService({required String secretKey}) : _secretKey = secretKey;

  @override
  Future<void> initializePayment() async {
    // Initialize Stripe with publishable key
    // Note: In production, get this from environment variables
    await Stripe.instance.applySettings();
  }

  @override
  Future<String> createPaymentIntent({
    required int amount,
    required String currency,
    required String customerId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amount.toString(),
          'currency': currency,
          'customer': customerId,
          'automatic_payment_methods[enabled]': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['client_secret'];
      } else {
        throw PaymentException('Failed to create payment intent');
      }
    } catch (e) {
      throw PaymentException('Payment error: ${e.toString()}');
    }
  }

  @override
  Future<String> createSubscription({
    required String customerId,
    required String priceId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/subscriptions'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'customer': customerId,
          'items[0][price]': priceId,
          'payment_behavior': 'default_incomplete',
          'payment_settings[save_default_payment_method]': 'on_subscription',
          'expand[]': 'latest_invoice.payment_intent',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['latest_invoice']['payment_intent']['client_secret'];
      } else {
        throw PaymentException('Failed to create subscription');
      }
    } catch (e) {
      throw PaymentException('Subscription error: ${e.toString()}');
    }
  }

  @override
  Future<void> confirmPayment(String clientSecret) async {
    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );
    } catch (e) {
      throw PaymentException('Payment confirmation failed: ${e.toString()}');
    }
  }

  Future<String> createCustomer({
    required String email,
    required String name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/customers'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'email': email, 'name': name},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['id'];
      } else {
        throw PaymentException('Failed to create customer');
      }
    } catch (e) {
      throw PaymentException('Customer creation error: ${e.toString()}');
    }
  }
}

class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);

  @override
  String toString() => 'PaymentException: $message';
}
