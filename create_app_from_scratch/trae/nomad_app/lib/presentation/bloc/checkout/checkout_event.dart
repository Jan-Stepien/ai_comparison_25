import 'package:equatable/equatable.dart';
import 'package:nomad_app/domain/entities/product_entity.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutStarted extends CheckoutEvent {
  final String userId;

  const CheckoutStarted({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ShippingDetailsSubmitted extends CheckoutEvent {
  final String userId;
  final String name;
  final String surname;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String region;

  const ShippingDetailsSubmitted({
    required this.userId,
    required this.name,
    required this.surname,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.region,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        surname,
        address,
        city,
        postalCode,
        country,
        region,
      ];
}

class CheckoutProductsSelected extends CheckoutEvent {
  final List<ProductEntity> selectedProducts;

  const CheckoutProductsSelected({required this.selectedProducts});

  @override
  List<Object?> get props => [selectedProducts];
}