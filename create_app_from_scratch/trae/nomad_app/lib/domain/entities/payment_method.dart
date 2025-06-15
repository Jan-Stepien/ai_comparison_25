import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String type; // 'card', 'bank_account', etc.
  final String last4;
  final String brand; // 'visa', 'mastercard', etc.
  final String? expiryMonth;
  final String? expiryYear;
  final String? holderName;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.brand,
    this.expiryMonth,
    this.expiryYear,
    this.holderName,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        last4,
        brand,
        expiryMonth,
        expiryYear,
        holderName,
        isDefault,
      ];

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? last4,
    String? brand,
    String? expiryMonth,
    String? expiryYear,
    String? holderName,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      last4: last4 ?? this.last4,
      brand: brand ?? this.brand,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      holderName: holderName ?? this.holderName,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}