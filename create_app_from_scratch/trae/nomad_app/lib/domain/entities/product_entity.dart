import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> features;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
  });

  @override
  List<Object?> get props => [id, name, description, price, features];
}

class NomadPackage extends ProductEntity {
  const NomadPackage({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.features,
  });

  factory NomadPackage.standard() {
    return const NomadPackage(
      id: 'nomad_package',
      name: 'Nomad package',
      description: 'Standard Nomad package with all the essentials',
      price: 120.0,
      features: [
        'One hub',
        'One plug',
        'Instruction manual',
      ],
    );
  }
}

class ProPlan extends ProductEntity {
  final double monthlyPrice;

  const ProPlan({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.features,
    required this.monthlyPrice,
  });

  factory ProPlan.standard() {
    return const ProPlan(
      id: 'pro_plan',
      name: 'Pro plan',
      description: 'Pro subscription with premium features',
      price: 79.0,
      monthlyPrice: 7.9,
      features: [
        'First feature',
        'Second feature',
        'Third feature',
      ],
    );
  }
}