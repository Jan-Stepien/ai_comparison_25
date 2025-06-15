import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomad_app/data/repositories/payment_repository_impl.dart';
import 'package:nomad_app/domain/entities/payment_method.dart';
import 'package:nomad_app/domain/repositories/payment_repository.dart';
import 'package:nomad_app/presentation/bloc/payment/payment_event.dart';
import 'package:nomad_app/presentation/bloc/payment/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentBloc({required PaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository,
      super(const PaymentInitial()) {
    on<PaymentMethodRequested>(_onPaymentMethodRequested);
    on<PaymentIntentCreated>(_onPaymentIntentCreated);
    on<PaymentIntentConfirmed>(_onPaymentIntentConfirmed);
    on<SubscriptionCreated>(_onSubscriptionCreated);
    on<PaymentMethodAdded>(_onPaymentMethodAdded);
  }

  Future<void> _onPaymentMethodRequested(
    PaymentMethodRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    try {
      final paymentMethods = await _paymentRepository.getPaymentMethods(
        event.userId,
      );
      emit(PaymentMethodsLoaded(paymentMethods: paymentMethods));
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onPaymentIntentCreated(
    PaymentIntentCreated event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    try {
      // final clientSecret = await _paymentRepository.createPaymentIntent(
      //   amount: event.amount,
      //   currency: event.currency,
      //   customerId: event.customerId,
      // );
      emit(PaymentIntentCreatedState(clientSecret: 'clientSecret'));
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onPaymentIntentConfirmed(
    PaymentIntentConfirmed event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    try {
      // final success = await _paymentRepository.confirmPaymentIntent(
      //   paymentIntentId: event.paymentIntentId,
      //   paymentMethodId: event.paymentMethodId,
      // );
      // if (success) {
      emit(const PaymentSuccess());
      // } else {
      //   emit(const PaymentError(message: 'Payment confirmation failed'));
      // }
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onSubscriptionCreated(
    SubscriptionCreated event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    try {
      // final subscriptionId = await _paymentRepository.createSubscription(
      //   customerId: event.customerId,
      //   priceId: event.priceId,
      //   paymentMethodId: event.paymentMethodId,
      // );
      emit(SubscriptionCreatedState(subscriptionId: 'subscriptionId'));
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> _onPaymentMethodAdded(
    PaymentMethodAdded event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    try {
      // In a real app, you would call a method to add a payment method
      // For now, we'll just simulate success
      await Future.delayed(const Duration(seconds: 1));
      emit(const PaymentMethodAddedState());
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }
}
