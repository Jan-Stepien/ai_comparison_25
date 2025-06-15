import 'package:trae/movies/list/domain/models/movie_list_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieList {
  final int totalResults;
  final List<MovieListItem> results;
  final int page;
  final int totalPages;

  MovieList({
    required this.totalResults,
    required this.results,
    required this.page,
    required this.totalPages,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) =>
      _$MovieListFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListToJson(this);
}
