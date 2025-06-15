import 'package:nomad_app/domain/entities/subscription_entity.dart';

class SubscriptionModel {
  final String id;
  final String userId;
  final String planId;
  final String planName;
  final double price;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.price,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      userId: json['userId'],
      planId: json['planId'],
      planName: json['planName'],
      price: json['price'].toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'],
    );
  }

  factory SubscriptionModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionModel(
      id: entity.id,
      userId: entity.userId,
      planId: entity.planId,
      planName: entity.planName,
      price: entity.price,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isActive: entity.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'planName': planName,
      'price': price,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
    };
  }

  SubscriptionEntity toEntity() {
    return SubscriptionEntity(
      id: id,
      userId: userId,
      planId: planId,
      planName: planName,
      price: price,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
    );
  }
}

class PlanModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> features;

  PlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      features: List<String>.from(json['features']),
    );
  }

  factory PlanModel.fromEntity(PlanEntity entity) {
    return PlanModel(
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

  PlanEntity toEntity() {
    return PlanEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      features: features,
    );
  }
}