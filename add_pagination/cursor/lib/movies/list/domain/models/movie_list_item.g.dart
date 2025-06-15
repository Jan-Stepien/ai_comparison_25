// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieListItem _$MovieListItemFromJson(Map<String, dynamic> json) =>
    MovieListItem(
      title: json['title'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$MovieListItemToJson(MovieListItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'vote_average': instance.voteAverage,
      'id': instance.id,
    };
