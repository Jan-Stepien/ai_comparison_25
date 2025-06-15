import 'dart:convert';

import 'package:copilot/movies/list/domain/models/movie_list_item.dart';
import 'package:copilot/movies/list/data/models/movie_list.dart';
import 'package:http/http.dart' as http;

class MovieListRemoteService {
  final String _apiKey;
  final String _baseUrl;
  final http.Client _client;

  MovieListRemoteService({
    required String apiKey,
    required String baseUrl,
    required http.Client client,
  }) : _apiKey = apiKey,
       _baseUrl = baseUrl,
       _client = client;

  Future<List<MovieListItem>> searchMovies({required String query}) async {
    final parameters = {'api_key': _apiKey, 'query': query};

    final endpoint = Uri.https(_baseUrl, '/3/search/movie', parameters);

    final response = await _client.get(endpoint);

    final json = jsonDecode(response.body);
    final movieList = MovieList.fromJson(json);
    return movieList.results;
  }
}
