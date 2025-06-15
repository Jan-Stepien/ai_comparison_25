import 'package:nomad_app/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? surname;
  final String? phone;
  final ShippingDetailsModel? shippingDetails;
  final bool hasActiveSubscription;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.surname,
    this.phone,
    this.shippingDetails,
    this.hasActiveSubscription = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      phone: json['phone'],
      shippingDetails: json['shippingDetails'] != null
          ? ShippingDetailsModel.fromJson(json['shippingDetails'])
          : null,
      hasActiveSubscription: json['hasActiveSubscription'] ?? false,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      surname: entity.surname,
      phone: entity.phone,
      shippingDetails: entity.shippingDetails != null
          ? ShippingDetailsModel.fromEntity(entity.shippingDetails!)
          : null,
      hasActiveSubscription: entity.hasActiveSubscription,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'phone': phone,
      'shippingDetails': shippingDetails?.toJson(),
      'hasActiveSubscription': hasActiveSubscription,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      surname: surname,
      phone: phone,
      shippingDetails: shippingDetails?.toEntity(),
      hasActiveSubscription: hasActiveSubscription,
    );
  }
}

class ShippingDetailsModel {
  final String? fullName;
  final String? address;
  final String? city;
  final String? region;
  final String? country;
  final String? postalCode;

  ShippingDetailsModel({
    this.fullName,
    this.address,
    this.city,
    this.region,
    this.country,
    this.postalCode,
  });

  factory ShippingDetailsModel.fromJson(Map<String, dynamic> json) {
    return ShippingDetailsModel(
      fullName: json['fullName'],
      address: json['address'],
      city: json['city'],
      region: json['region'],
      country: json['country'],
      postalCode: json['postalCode'],
    );
  }

  factory ShippingDetailsModel.fromEntity(ShippingDetails entity) {
    return ShippingDetailsModel(
      fullName: entity.fullName,
      address: entity.address,
      city: entity.city,
      region: entity.region,
      country: entity.country,
      postalCode: entity.postalCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'address': address,
      'city': city,
      'region': region,
      'country': country,
      'postalCode': postalCode,
    };
  }

  ShippingDetails toEntity() {
    return ShippingDetails(
      fullName: fullName,
      address: address,
      city: city,
      region: region,
      country: country,
      postalCode: postalCode,
    );
  }
}