import 'package:equatable/equatable.dart';
import 'package:nomad_app/domain/entities/product_entity.dart';
import 'package:nomad_app/domain/entities/user_entity.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

class CheckoutShippingDetailsForm extends CheckoutState {
  final ShippingDetails? shippingDetails;

  const CheckoutShippingDetailsForm({this.shippingDetails});

  @override
  List<Object?> get props => [shippingDetails];

  CheckoutShippingDetailsForm copyWith({
    ShippingDetails? shippingDetails,
  }) {
    return CheckoutShippingDetailsForm(
      shippingDetails: shippingDetails ?? this.shippingDetails,
    );
  }
}

class CheckoutProductSelection extends CheckoutState {
  final ShippingDetails shippingDetails;
  final List<ProductEntity> selectedProducts;
  final double totalAmount;

  const CheckoutProductSelection({
    required this.shippingDetails,
    required this.selectedProducts,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [shippingDetails, selectedProducts, totalAmount];

  CheckoutProductSelection copyWith({
    ShippingDetails? shippingDetails,
    List<ProductEntity>? selectedProducts,
    double? totalAmount,
  }) {
    return CheckoutProductSelection(
      shippingDetails: shippingDetails ?? this.shippingDetails,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}

class CheckoutPaymentForm extends CheckoutState {
  final ShippingDetails shippingDetails;
  final List<ProductEntity> selectedProducts;
  final double totalAmount;

  const CheckoutPaymentForm({
    required this.shippingDetails,
    required this.selectedProducts,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [shippingDetails, selectedProducts, totalAmount];
}

class CheckoutSuccess extends CheckoutState {
  final String orderId;

  const CheckoutSuccess({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError({required this.message});

  @override
  List<Object?> get props => [message];
}