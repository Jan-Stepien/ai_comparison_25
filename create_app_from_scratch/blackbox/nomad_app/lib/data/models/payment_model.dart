import 'package:equatable/equatable.dart';
import 'user_model.dart';
import 'package_model.dart';

class PaymentModel extends Equatable {
  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final String nameOnCard;

  const PaymentModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.nameOnCard,
  });

  Map<String, dynamic> toJson() => {
    'cardNumber': cardNumber,
    'expiryDate': expiryDate,
    'cvc': cvc,
    'nameOnCard': nameOnCard,
  };

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    cardNumber: json['cardNumber'] ?? '',
    expiryDate: json['expiryDate'] ?? '',
    cvc: json['cvc'] ?? '',
    nameOnCard: json['nameOnCard'] ?? '',
  );

  PaymentModel copyWith({
    String? cardNumber,
    String? expiryDate,
    String? cvc,
    String? nameOnCard,
  }) => PaymentModel(
    cardNumber: cardNumber ?? this.cardNumber,
    expiryDate: expiryDate ?? this.expiryDate,
    cvc: cvc ?? this.cvc,
    nameOnCard: nameOnCard ?? this.nameOnCard,
  );

  @override
  List<Object?> get props => [cardNumber, expiryDate, cvc, nameOnCard];
}

class OrderModel extends Equatable {
  final String id;
  final UserModel user;
  final List<PackageModel> packages;
  final PaymentModel payment;
  final double total;
  final DateTime createdAt;
  final String status;

  const OrderModel({
    required this.id,
    required this.user,
    required this.packages,
    required this.payment,
    required this.total,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user.toJson(),
    'packages': packages.map((p) => p.toJson()).toList(),
    'payment': payment.toJson(),
    'total': total,
    'createdAt': createdAt.toIso8601String(),
    'status': status,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'] ?? '',
    user: UserModel.fromJson(json['user'] ?? {}),
    packages:
        (json['packages'] as List<dynamic>?)
            ?.map((p) => PackageModel.fromJson(p))
            .toList() ??
        [],
    payment: PaymentModel.fromJson(json['payment'] ?? {}),
    total: (json['total'] ?? 0.0).toDouble(),
    createdAt: DateTime.parse(
      json['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
    status: json['status'] ?? 'pending',
  );

  OrderModel copyWith({
    String? id,
    UserModel? user,
    List<PackageModel>? packages,
    PaymentModel? payment,
    double? total,
    DateTime? createdAt,
    String? status,
  }) => OrderModel(
    id: id ?? this.id,
    user: user ?? this.user,
    packages: packages ?? this.packages,
    payment: payment ?? this.payment,
    total: total ?? this.total,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [
    id,
    user,
    packages,
    payment,
    total,
    createdAt,
    status,
  ];
}
