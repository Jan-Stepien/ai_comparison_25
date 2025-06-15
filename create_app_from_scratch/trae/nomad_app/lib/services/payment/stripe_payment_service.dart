import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePaymentService {
  // In a real app, this would be stored securely and accessed via environment variables
  // or a secure backend service. Never hardcode API keys in production code.
  static const String _apiUrl = 'https://api.stripe.com/v1';
  
  // This would be your backend API endpoint that securely communicates with Stripe
  static const String _backendApiUrl = 'https://your-backend-api.com/stripe';

  // Initialize Stripe
  Future<void> initStripe(String publishableKey) async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  // Create a payment intent via your backend
  Future<Map<String, dynamic>> createPaymentIntent(double amount, String currency) async {
    try {
      // In a real app, this would call your backend API which would create the payment intent
      // and return the client secret. Never call Stripe API directly from the client.
      final response = await http.post(
        Uri.parse('$_backendApiUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': (amount * 100).toInt(), // Convert to cents
          'currency': currency,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }

  // Confirm payment with the payment method
  Future<bool> confirmPayment(String paymentIntentClientSecret) async {
    try {
      // Confirm the payment with the client secret
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntentClientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      // Check if payment is successful
      return paymentIntent.status == PaymentIntentsStatus.Succeeded;
    } catch (e) {
      throw Exception('Error confirming payment: $e');
    }
  }

  // Create a subscription via your backend
  Future<Map<String, dynamic>> createSubscription(String customerId, String priceId) async {
    try {
      // In a real app, this would call your backend API
      final response = await http.post(
        Uri.parse('$_backendApiUrl/create-subscription'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customer': customerId,
          'price': priceId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating subscription: $e');
    }
  }

  // Cancel a subscription via your backend
  Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      // In a real app, this would call your backend API
      final response = await http.post(
        Uri.parse('$_backendApiUrl/cancel-subscription'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'subscription_id': subscriptionId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['success'] == true;
      } else {
        throw Exception('Failed to cancel subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error cancelling subscription: $e');
    }
  }

  // Get customer's payment methods
  Future<List<PaymentMethod>> getPaymentMethods(String customerId) async {
    try {
      // In a real app, this would call your backend API
      final response = await http.get(
        Uri.parse('$_backendApiUrl/payment-methods?customer=$customerId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Parse the response into PaymentMethod objects
        return (responseData['data'] as List)
            .map((data) => PaymentMethod.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to get payment methods: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting payment methods: $e');
    }
  }
}