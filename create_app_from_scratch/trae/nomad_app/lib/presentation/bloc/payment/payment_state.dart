import 'package:equatable/equatable.dart';
import 'package:nomad_app/domain/entities/payment_method.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentMethodsLoaded extends PaymentState {
  final List<PaymentMethod> paymentMethods;

  const PaymentMethodsLoaded({required this.paymentMethods});

  @override
  List<Object?> get props => [paymentMethods];
}

class PaymentIntentCreatedState extends PaymentState {
  final String clientSecret;

  const PaymentIntentCreatedState({required this.clientSecret});

  @override
  List<Object?> get props => [clientSecret];
}

class PaymentSuccess extends PaymentState {
  const PaymentSuccess();
}

class PaymentMethodAddedState extends PaymentState {
  const PaymentMethodAddedState();
}

class SubscriptionCreatedState extends PaymentState {
  final String subscriptionId;

  const SubscriptionCreatedState({required this.subscriptionId});

  @override
  List<Object?> get props => [subscriptionId];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}