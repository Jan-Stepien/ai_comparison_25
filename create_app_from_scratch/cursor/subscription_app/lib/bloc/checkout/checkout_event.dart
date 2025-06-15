import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutPersonalDetailsSubmitted extends CheckoutEvent {
  const CheckoutPersonalDetailsSubmitted({
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.country,
    required this.region,
    required this.city,
    required this.postalCode,
    required this.address,
  });

  final String name;
  final String surname;
  final String email;
  final String phone;
  final String country;
  final String region;
  final String city;
  final String postalCode;
  final String address;

  @override
  List<Object?> get props => [
    name,
    surname,
    email,
    phone,
    country,
    region,
    city,
    postalCode,
    address,
  ];
}

class CheckoutPaymentDetailsSubmitted extends CheckoutEvent {
  const CheckoutPaymentDetailsSubmitted({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.nameOnCard,
  });

  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final String nameOnCard;

  @override
  List<Object?> get props => [cardNumber, expiryDate, cvc, nameOnCard];
}

class CheckoutAccountDetailsSubmitted extends CheckoutEvent {
  const CheckoutAccountDetailsSubmitted({
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.country,
    required this.region,
    required this.city,
    required this.postalCode,
    required this.address,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.nameOnCard,
    this.photoUrl,
  });

  final String name;
  final String surname;
  final String email;
  final String phone;
  final String country;
  final String region;
  final String city;
  final String postalCode;
  final String address;
  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final String nameOnCard;
  final String? photoUrl;

  @override
  List<Object?> get props => [
    name,
    surname,
    email,
    phone,
    country,
    region,
    city,
    postalCode,
    address,
    cardNumber,
    expiryDate,
    cvc,
    nameOnCard,
    photoUrl,
  ];
}

class CheckoutAccountCreated extends CheckoutEvent {
  const CheckoutAccountCreated({
    required this.password,
    required this.confirmPassword,
  });

  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [password, confirmPassword];
}

class CheckoutStepChanged extends CheckoutEvent {
  const CheckoutStepChanged(this.step);

  final int step;

  @override
  List<Object?> get props => [step];
}

class CheckoutReset extends CheckoutEvent {
  const CheckoutReset();
}
