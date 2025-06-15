import 'package:equatable/equatable.dart';

class ShippingDetails extends Equatable {
  final String name;
  final String surname;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String region;
  final String? phoneNumber;
  final String email;

  const ShippingDetails({
    required this.name,
    required this.surname,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.region,
    this.phoneNumber,
    required this.email,
  });

  @override
  List<Object?> get props => [
        name,
        surname,
        address,
        city,
        postalCode,
        country,
        region,
        phoneNumber,
        email,
      ];

  ShippingDetails copyWith({
    String? name,
    String? surname,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    String? region,
    String? phoneNumber,
    String? email,
  }) {
    return ShippingDetails(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      region: region ?? this.region,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }
}