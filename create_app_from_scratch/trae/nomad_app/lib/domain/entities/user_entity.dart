import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? surname;
  final String? phone;
  final ShippingDetails? shippingDetails;
  final bool hasActiveSubscription;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.surname,
    this.phone,
    this.shippingDetails,
    this.hasActiveSubscription = false,
  });

  UserEntity copyWith({
    String? name,
    String? surname,
    String? phone,
    ShippingDetails? shippingDetails,
    bool? hasActiveSubscription,
  }) {
    return UserEntity(
      id: id,
      email: email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
      shippingDetails: shippingDetails ?? this.shippingDetails,
      hasActiveSubscription: hasActiveSubscription ?? this.hasActiveSubscription,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        surname,
        phone,
        shippingDetails,
        hasActiveSubscription,
      ];
}

class ShippingDetails extends Equatable {
  final String? fullName;
  final String? address;
  final String? city;
  final String? region;
  final String? country;
  final String? postalCode;

  const ShippingDetails({
    this.fullName,
    this.address,
    this.city,
    this.region,
    this.country,
    this.postalCode,
  });

  ShippingDetails copyWith({
    String? fullName,
    String? address,
    String? city,
    String? region,
    String? country,
    String? postalCode,
  }) {
    return ShippingDetails(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      city: city ?? this.city,
      region: region ?? this.region,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        address,
        city,
        region,
        country,
        postalCode,
      ];
}