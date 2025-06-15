import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieDetails with EquatableMixin {
  final int id;
  final String title;
  final int? budget;
  final int? revenue;

  MovieDetails({
    required this.id,
    required this.title,
    required this.budget,
    required this.revenue,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsToJson(this);

  @override
  List<Object?> get props => [id, title, budget, revenue];
}
