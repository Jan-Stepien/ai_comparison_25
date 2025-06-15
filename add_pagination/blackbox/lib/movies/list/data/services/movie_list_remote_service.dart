import 'dart:convert';

import 'package:blackbox/movies/list/domain/models/movie_list_item.dart';
import 'package:blackbox/movies/list/data/models/movie_list.dart';
import 'package:http/http.dart' as http;

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

  Future<MovieList> searchMovies({
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
    return MovieList.fromJson(json);
  }
}
