import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String? phone;
  final String country;
  final String region;
  final String city;
  final String postalCode;
  final String address;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    this.phone,
    required this.country,
    required this.region,
    required this.city,
    required this.postalCode,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
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
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    email: json['email'] ?? '',
    name: json['name'] ?? '',
    surname: json['surname'] ?? '',
    phone: json['phone'],
    country: json['country'] ?? '',
    region: json['region'] ?? '',
    city: json['city'] ?? '',
    postalCode: json['postalCode'] ?? '',
    address: json['address'] ?? '',
  );

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
  }) => UserModel(
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
  );

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
  ];
}
