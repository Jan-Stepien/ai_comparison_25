import 'package:windsurf/movies/list/domain/models/movie_list_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieList {
  final int totalResults;
  final List<MovieListItem> results;
  final int totalPages;
  final int page;

  MovieList({
    required this.totalResults,
    required this.results,
    required this.totalPages,
    required this.page,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) =>
      _$MovieListFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListToJson(this);
}
