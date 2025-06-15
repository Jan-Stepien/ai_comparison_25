import 'package:nomad_app/domain/entities/payment_method.dart';

class PaymentMethodModel {
  final String id;
  final String type;
  final String last4;
  final String brand;
  final String? expiryMonth;
  final String? expiryYear;
  final String? holderName;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.last4,
    required this.brand,
    this.expiryMonth,
    this.expiryYear,
    this.holderName,
    this.isDefault = false,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      type: json['type'] as String,
      last4: json['last4'] as String,
      brand: json['brand'] as String,
      expiryMonth: json['expiry_month'] as String?,
      expiryYear: json['expiry_year'] as String?,
      holderName: json['holder_name'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'last4': last4,
      'brand': brand,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'holder_name': holderName,
      'is_default': isDefault,
    };
  }

  PaymentMethod toEntity() {
    return PaymentMethod(
      id: id,
      type: type,
      last4: last4,
      brand: brand,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      holderName: holderName,
      isDefault: isDefault,
    );
  }

  factory PaymentMethodModel.fromEntity(PaymentMethod entity) {
    return PaymentMethodModel(
      id: entity.id,
      type: entity.type,
      last4: entity.last4,
      brand: entity.brand,
      expiryMonth: entity.expiryMonth,
      expiryYear: entity.expiryYear,
      holderName: entity.holderName,
      isDefault: entity.isDefault,
    );
  }
}