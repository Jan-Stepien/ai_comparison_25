import 'package:tabnine/movies/list/domain/models/movie_list_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MovieList {
  final int totalResults;
  final List<MovieListItem> results;

  MovieList({
    required this.totalResults,
    required this.results,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) =>
      _$MovieListFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListToJson(this);
}
