import 'package:equatable/equatable.dart';
import '../../core/models/user_model.dart';

enum CheckoutStatus { initial, loading, success, failure }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.currentStep = 1,
    this.personalDetails,
    this.paymentDetails,
    this.accountDetails,
    this.user,
    this.subscription,
    this.errorMessage,
  });

  final CheckoutStatus status;
  final int currentStep;
  final PersonalDetails? personalDetails;
  final PaymentDetails? paymentDetails;
  final AccountDetails? accountDetails;
  final UserModel? user;
  final SubscriptionModel? subscription;
  final String? errorMessage;

  CheckoutState copyWith({
    CheckoutStatus? status,
    int? currentStep,
    PersonalDetails? personalDetails,
    PaymentDetails? paymentDetails,
    AccountDetails? accountDetails,
    UserModel? user,
    SubscriptionModel? subscription,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      personalDetails: personalDetails ?? this.personalDetails,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      accountDetails: accountDetails ?? this.accountDetails,
      user: user ?? this.user,
      subscription: subscription ?? this.subscription,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentStep,
    personalDetails,
    paymentDetails,
    accountDetails,
    user,
    subscription,
    errorMessage,
  ];
}

class PersonalDetails extends Equatable {
  const PersonalDetails({
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

class PaymentDetails extends Equatable {
  const PaymentDetails({
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

class AccountDetails extends Equatable {
  const AccountDetails({
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
