import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomad_app/domain/entities/user_entity.dart';
import 'package:nomad_app/domain/repositories/user_repository.dart';
import 'package:nomad_app/presentation/bloc/checkout/checkout_event.dart';
import 'package:nomad_app/presentation/bloc/checkout/checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final UserRepository _userRepository;

  CheckoutBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const CheckoutInitial()) {
    on<CheckoutStarted>(_onCheckoutStarted);
    on<ShippingDetailsSubmitted>(_onShippingDetailsSubmitted);
    on<CheckoutProductsSelected>(_onCheckoutProductsSelected);
  }

  Future<void> _onCheckoutStarted(CheckoutStarted event, Emitter<CheckoutState> emit) async {
    emit(const CheckoutLoading());
    try {
      final user = await _userRepository.getUser(event.userId);
      if (user != null) {
        emit(CheckoutShippingDetailsForm(shippingDetails: user.shippingDetails));
      } else {
        emit(const CheckoutShippingDetailsForm());
      }
    } catch (e) {
      emit(const CheckoutShippingDetailsForm());
    }
  }

  Future<void> _onShippingDetailsSubmitted(ShippingDetailsSubmitted event, Emitter<CheckoutState> emit) async {
    emit(const CheckoutLoading());
    try {
      final shippingDetails = ShippingDetails(
        fullName: '${event.name} ${event.surname}',
        address: event.address,
        city: event.city,
        postalCode: event.postalCode,
        country: event.country,
        region: event.region,
      );

      // Update shipping details in user profile if user is logged in
      if (event.userId.isNotEmpty) {
        await _userRepository.updateShippingDetails(event.userId, shippingDetails);
      }

      // Move to product selection state
      emit(CheckoutProductSelection(
        shippingDetails: shippingDetails,
        selectedProducts: const [],
        totalAmount: 0.0,
      ));
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }

  void _onCheckoutProductsSelected(CheckoutProductsSelected event, Emitter<CheckoutState> emit) {
    if (state is CheckoutProductSelection) {
      final currentState = state as CheckoutProductSelection;
      
      // Calculate total amount
      double totalAmount = 0.0;
      for (final product in event.selectedProducts) {
        totalAmount += product.price;
      }

      emit(CheckoutPaymentForm(
        shippingDetails: currentState.shippingDetails,
        selectedProducts: event.selectedProducts,
        totalAmount: totalAmount,
      ));
    }
  }
}