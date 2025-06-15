import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class AccountRequested extends AccountEvent {
  final String userId;

  const AccountRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AccountUpdated extends AccountEvent {
  final String userId;
  final String name;
  final String surname;
  final String? phone;

  const AccountUpdated({
    required this.userId,
    required this.name,
    required this.surname,
    this.phone,
  });

  @override
  List<Object?> get props => [userId, name, surname, phone];
}

class ShippingDetailsUpdated extends AccountEvent {
  final String userId;
  final String name;
  final String surname;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String region;

  const ShippingDetailsUpdated({
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

class AccountPasswordChanged extends AccountEvent {
  final String userId;
  final String currentPassword;
  final String newPassword;

  const AccountPasswordChanged({
    required this.userId,
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, currentPassword, newPassword];
}

class AccountPhotoUpdated extends AccountEvent {
  final String userId;
  final String photoPath; // Local path to the photo file

  const AccountPhotoUpdated({
    required this.userId,
    required this.photoPath,
  });

  @override
  List<Object?> get props => [userId, photoPath];
}