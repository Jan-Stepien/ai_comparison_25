import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    this.id,
    this.email,
    this.name,
    this.surname,
    this.phone,
    this.country,
    this.region,
    this.city,
    this.postalCode,
    this.address,
    this.photoUrl,
    this.subscription,
    this.createdAt,
  });

  final String? id;
  final String? email;
  final String? name;
  final String? surname;
  final String? phone;
  final String? country;
  final String? region;
  final String? city;
  final String? postalCode;
  final String? address;
  final String? photoUrl;
  final SubscriptionModel? subscription;
  final DateTime? createdAt;

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? surname,
    String? phone,
    String? country,
    String? region,
    String? city,
    String? postalCode,
    String? address,
    String? photoUrl,
    SubscriptionModel? subscription,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      region: region ?? this.region,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      subscription: subscription ?? this.subscription,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'surname': surname,
      'phone': phone,
      'country': country,
      'region': region,
      'city': city,
      'postalCode': postalCode,
      'address': address,
      'photoUrl': photoUrl,
      'subscription': subscription?.toMap(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      surname: map['surname'],
      phone: map['phone'],
      country: map['country'],
      region: map['region'],
      city: map['city'],
      postalCode: map['postalCode'],
      address: map['address'],
      photoUrl: map['photoUrl'],
      subscription:
          map['subscription'] != null
              ? SubscriptionModel.fromMap(map['subscription'])
              : null,
      createdAt:
          map['createdAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
              : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    surname,
    phone,
    country,
    region,
    city,
    postalCode,
    address,
    photoUrl,
    subscription,
    createdAt,
  ];
}

class SubscriptionModel extends Equatable {
  const SubscriptionModel({
    this.id,
    this.planName,
    this.planPrice,
    this.devicePackage,
    this.devicePrice,
    this.totalPrice,
    this.status,
    this.stripeSubscriptionId,
    this.createdAt,
  });

  final String? id;
  final String? planName;
  final double? planPrice;
  final String? devicePackage;
  final double? devicePrice;
  final double? totalPrice;
  final String? status;
  final String? stripeSubscriptionId;
  final DateTime? createdAt;

  SubscriptionModel copyWith({
    String? id,
    String? planName,
    double? planPrice,
    String? devicePackage,
    double? devicePrice,
    double? totalPrice,
    String? status,
    String? stripeSubscriptionId,
    DateTime? createdAt,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      planName: planName ?? this.planName,
      planPrice: planPrice ?? this.planPrice,
      devicePackage: devicePackage ?? this.devicePackage,
      devicePrice: devicePrice ?? this.devicePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      stripeSubscriptionId: stripeSubscriptionId ?? this.stripeSubscriptionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'planName': planName,
      'planPrice': planPrice,
      'devicePackage': devicePackage,
      'devicePrice': devicePrice,
      'totalPrice': totalPrice,
      'status': status,
      'stripeSubscriptionId': stripeSubscriptionId,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'],
      planName: map['planName'],
      planPrice: map['planPrice']?.toDouble(),
      devicePackage: map['devicePackage'],
      devicePrice: map['devicePrice']?.toDouble(),
      totalPrice: map['totalPrice']?.toDouble(),
      status: map['status'],
      stripeSubscriptionId: map['stripeSubscriptionId'],
      createdAt:
          map['createdAt'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
              : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    planName,
    planPrice,
    devicePackage,
    devicePrice,
    totalPrice,
    status,
    stripeSubscriptionId,
    createdAt,
  ];
}
