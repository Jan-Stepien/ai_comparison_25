import 'dart:convert';

import 'package:zed/movies/list/domain/models/movie_list_item.dart';
import 'package:zed/movies/list/data/models/movie_list.dart';
import 'package:http/http.dart' as http;

class MovieListResponse {
  final List<MovieListItem> results;
  final int page;
  final int totalPages;
  final int totalResults;

  MovieListResponse({
    required this.results,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });
}

class MovieListRemoteService {
  final String _apiKey;
  final String _baseUrl;
  final http.Client _client;

  MovieListRemoteService({
    required String apiKey,
    required String baseUrl,
    required http.Client client,
  })  : _apiKey = apiKey,
        _baseUrl = baseUrl,
        _client = client;

  Future<MovieListResponse> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final parameters = {
      'api_key': _apiKey,
      'query': query,
      'page': page.toString(),
    };

    final endpoint = Uri.https(_baseUrl, '/3/search/movie', parameters);

    final response = await _client.get(endpoint);

    final json = jsonDecode(response.body);
    final movieList = MovieList.fromJson(json);
    return MovieListResponse(
      results: movieList.results,
      page: json['page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
