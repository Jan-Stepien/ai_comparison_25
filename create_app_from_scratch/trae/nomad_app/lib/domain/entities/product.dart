import 'package:equatable/equatable.dart';

abstract class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, price, imageUrl];
}

class NomadPackage extends Product {
  final List<String> features;
  final bool isOneTime;

  const NomadPackage({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.imageUrl,
    required this.features,
    this.isOneTime = true,
  });

  @override
  List<Object?> get props => [...super.props, features, isOneTime];

  NomadPackage copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? features,
    bool? isOneTime,
  }) {
    return NomadPackage(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      features: features ?? this.features,
      isOneTime: isOneTime ?? this.isOneTime,
    );
  }
}

class ProPlan extends Product {
  final List<String> features;
  final String interval; // 'month', 'year', etc.
  final int intervalCount; // 1, 3, 6, 12, etc.

  const ProPlan({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.imageUrl,
    required this.features,
    required this.interval,
    this.intervalCount = 1,
  });

  @override
  List<Object?> get props => [...super.props, features, interval, intervalCount];

  ProPlan copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? features,
    String? interval,
    int? intervalCount,
  }) {
    return ProPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      features: features ?? this.features,
      interval: interval ?? this.interval,
      intervalCount: intervalCount ?? this.intervalCount,
    );
  }
}