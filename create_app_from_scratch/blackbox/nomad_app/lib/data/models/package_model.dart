import 'package:equatable/equatable.dart';

class PackageModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final List<String> features;
  final bool isPro;

  const PackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.features,
    this.isPro = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'features': features,
    'isPro': isPro,
  };

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    price: (json['price'] ?? 0.0).toDouble(),
    features: List<String>.from(json['features'] ?? []),
    isPro: json['isPro'] ?? false,
  );

  PackageModel copyWith({
    String? id,
    String? name,
    double? price,
    List<String>? features,
    bool? isPro,
  }) => PackageModel(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    features: features ?? this.features,
    isPro: isPro ?? this.isPro,
  );

  @override
  List<Object?> get props => [id, name, price, features, isPro];

  // Predefined packages
  static PackageModel get nomadPackage => PackageModel(
    id: 'nomad_package',
    name: 'Nomad package',
    price: 120.0,
    features: ['One hub', 'One plug', 'Instruction manual'],
  );

  static PackageModel get proPackage => PackageModel(
    id: 'pro_package',
    name: 'Pro plan',
    price: 79.0,
    features: ['First feature', 'Second feature', 'Third feature'],
    isPro: true,
  );
}
