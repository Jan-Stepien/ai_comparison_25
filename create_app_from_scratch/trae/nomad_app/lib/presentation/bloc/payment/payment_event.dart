import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentMethodRequested extends PaymentEvent {
  final String userId;

  const PaymentMethodRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class PaymentIntentCreated extends PaymentEvent {
  final double amount;
  final String currency;
  final String customerId;

  const PaymentIntentCreated({
    required this.amount,
    required this.currency,
    required this.customerId,
  });

  @override
  List<Object?> get props => [amount, currency, customerId];
}

class PaymentIntentConfirmed extends PaymentEvent {
  final String paymentIntentId;
  final String paymentMethodId;

  const PaymentIntentConfirmed({
    required this.paymentIntentId,
    required this.paymentMethodId,
  });

  @override
  List<Object?> get props => [paymentIntentId, paymentMethodId];
}

class SubscriptionCreated extends PaymentEvent {
  final String customerId;
  final String priceId;
  final String paymentMethodId;

  const SubscriptionCreated({
    required this.customerId,
    required this.priceId,
    required this.paymentMethodId,
  });

  @override
  List<Object?> get props => [customerId, priceId, paymentMethodId];
}

class PaymentMethodAdded extends PaymentEvent {
  final String userId;
  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final String cardHolderName;

  const PaymentMethodAdded({
    required this.userId,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.cardHolderName,
  });

  @override
  List<Object?> get props => [userId, cardNumber, expiryDate, cvc, cardHolderName];
}