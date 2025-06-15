import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import '../data/models/payment_model.dart';

class PaymentService {
  static const String _publishableKey =
      'pk_test_your_publishable_key_here'; // Replace with your Stripe publishable key

  Future<void> initialize() async {
    Stripe.publishableKey = _publishableKey;
  }

  Future<bool> processPayment({
    required PaymentModel paymentDetails,
    required double amount,
    required String currency,
  }) async {
    try {
      // Create payment intent
      final paymentIntent = await _createPaymentIntent(
        amount: (amount * 100).toInt(), // Convert to cents
        currency: currency,
      );

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Nomad',
          style: ThemeMode.light,
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      throw _handlePaymentError(e);
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    // In a real app, this would call your backend API to create a payment intent
    // For demo purposes, we'll simulate the response
    // You need to implement your backend endpoint that creates a Stripe PaymentIntent

    throw UnimplementedError(
      'You need to implement a backend endpoint to create PaymentIntent. '
      'See Stripe documentation for server-side implementation.',
    );

    // Example of what your backend should return:
    // return {
    //   'id': 'pi_example_payment_intent_id',
    //   'client_secret': 'pi_example_secret_key',
    //   'amount': amount,
    //   'currency': currency,
    // };
  }

  Future<bool> validateCard({
    required String cardNumber,
    required String expiryDate,
    required String cvc,
  }) async {
    try {
      // Basic validation
      if (cardNumber.length < 13 || cardNumber.length > 19) {
        return false;
      }

      if (expiryDate.length != 5 || !expiryDate.contains('/')) {
        return false;
      }

      if (cvc.length < 3 || cvc.length > 4) {
        return false;
      }

      // Validate expiry date
      final parts = expiryDate.split('/');
      if (parts.length != 2) return false;

      final month = int.tryParse(parts[0]);
      final year = int.tryParse('20${parts[1]}');

      if (month == null || year == null) return false;
      if (month < 1 || month > 12) return false;

      final now = DateTime.now();
      final expiry = DateTime(year, month);

      if (expiry.isBefore(DateTime(now.year, now.month))) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  String _handlePaymentError(dynamic error) {
    if (error is StripeException) {
      switch (error.error.code) {
        case FailureCode.Canceled:
          return 'Payment was cancelled';
        case FailureCode.Failed:
          return 'Payment failed';
        case FailureCode.Timeout:
          return 'Payment timed out';
        default:
          return 'Payment error: ${error.error.message}';
      }
    }
    return 'An unexpected error occurred during payment';
  }

  String formatCardNumber(String cardNumber) {
    // Remove all non-digits
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');

    // Add spaces every 4 digits
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  String formatExpiryDate(String expiryDate) {
    // Remove all non-digits
    final digits = expiryDate.replaceAll(RegExp(r'\D'), '');

    if (digits.length >= 2) {
      return '${digits.substring(0, 2)}/${digits.substring(2)}';
    }

    return digits;
  }
}
