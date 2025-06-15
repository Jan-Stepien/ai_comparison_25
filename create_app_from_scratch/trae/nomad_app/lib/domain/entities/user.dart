import 'package:equatable/equatable.dart';
import 'package:nomad_app/domain/entities/shipping_details.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String? photoUrl;
  final ShippingDetails? shippingDetails;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    this.photoUrl,
    this.shippingDetails,
  });

  @override
  List<Object?> get props => [id, email, name, surname, photoUrl, shippingDetails];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? surname,
    String? photoUrl,
    ShippingDetails? shippingDetails,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      photoUrl: photoUrl ?? this.photoUrl,
      shippingDetails: shippingDetails ?? this.shippingDetails,
    );
  }
}