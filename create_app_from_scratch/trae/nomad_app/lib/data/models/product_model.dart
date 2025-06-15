import 'package:nomad_app/domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> features;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      features: List<String>.from(json['features']),
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      features: entity.features,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'features': features,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      features: features,
    );
  }
}

class NomadPackageModel extends ProductModel {
  NomadPackageModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.features,
  });

  factory NomadPackageModel.fromJson(Map<String, dynamic> json) {
    return NomadPackageModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      features: List<String>.from(json['features']),
    );
  }

  factory NomadPackageModel.fromEntity(NomadPackage entity) {
    return NomadPackageModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      features: entity.features,
    );
  }

  @override
  NomadPackage toEntity() {
    return NomadPackage(
      id: id,
      name: name,
      description: description,
      price: price,
      features: features,
    );
  }
}

class ProPlanModel extends ProductModel {
  final double monthlyPrice;

  ProPlanModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.features,
    required this.monthlyPrice,
  });

  factory ProPlanModel.fromJson(Map<String, dynamic> json) {
    return ProPlanModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      features: List<String>.from(json['features']),
      monthlyPrice: json['monthlyPrice'].toDouble(),
    );
  }

  factory ProPlanModel.fromEntity(ProPlan entity) {
    return ProPlanModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      features: entity.features,
      monthlyPrice: entity.monthlyPrice,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['monthlyPrice'] = monthlyPrice;
    return json;
  }

  @override
  ProPlan toEntity() {
    return ProPlan(
      id: id,
      name: name,
      description: description,
      price: price,
      features: features,
      monthlyPrice: monthlyPrice,
    );
  }
}