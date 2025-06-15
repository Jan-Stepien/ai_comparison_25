// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieList _$MovieListFromJson(Map<String, dynamic> json) => MovieList(
      totalResults: (json['total_results'] as num).toInt(),
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieListToJson(MovieList instance) => <String, dynamic>{
      'total_results': instance.totalResults,
      'total_pages': instance.totalPages,
      'page': instance.page,
      'results': instance.results,
    };
