import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final String id;
  final String userId;
  final String planId;
  final String status; // 'active', 'canceled', 'past_due', etc.
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? canceledAt;
  final bool cancelAtPeriodEnd;
  final String? paymentMethodId;

  const Subscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    this.endDate,
    this.canceledAt,
    this.cancelAtPeriodEnd = false,
    this.paymentMethodId,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        planId,
        status,
        startDate,
        endDate,
        canceledAt,
        cancelAtPeriodEnd,
        paymentMethodId,
      ];

  Subscription copyWith({
    String? id,
    String? userId,
    String? planId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? canceledAt,
    bool? cancelAtPeriodEnd,
    String? paymentMethodId,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      canceledAt: canceledAt ?? this.canceledAt,
      cancelAtPeriodEnd: cancelAtPeriodEnd ?? this.cancelAtPeriodEnd,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    );
  }
}

class Plan extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String interval; // 'month', 'year', etc.
  final int intervalCount; // 1, 3, 6, 12, etc.
  final List<String> features;

  const Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.interval,
    this.intervalCount = 1,
    required this.features,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        currency,
        interval,
        intervalCount,
        features,
      ];

  Plan copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    String? interval,
    int? intervalCount,
    List<String>? features,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      interval: interval ?? this.interval,
      intervalCount: intervalCount ?? this.intervalCount,
      features: features ?? this.features,
    );
  }
}