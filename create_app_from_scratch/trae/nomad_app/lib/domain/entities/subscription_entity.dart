import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final String id;
  final String userId;
  final String planId;
  final String planName;
  final double price;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  const SubscriptionEntity({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.price,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        planId,
        planName,
        price,
        startDate,
        endDate,
        isActive,
      ];
}

class PlanEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> features;

  const PlanEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
  });

  @override
  List<Object?> get props => [id, name, description, price, features];
}