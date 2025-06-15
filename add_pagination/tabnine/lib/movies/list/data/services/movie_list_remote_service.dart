import 'dart:convert';

import 'package:tabnine/movies/list/domain/models/movie_list_item.dart';
import 'package:tabnine/movies/list/data/models/movie_list.dart';
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

  Future<List<MovieListItem>> searchMovies({required String query}) async {
    final parameters = {
      'api_key': _apiKey,
      'query': query,
    };

    final endpoint = Uri.https(_baseUrl, '/3/search/movie', parameters);

    final response = await _client.get(endpoint);

    final json = jsonDecode(response.body);
    final movieList = MovieList.fromJson(json);
    return movieList.results;
  }

  Future<MovieList> getMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final url = query.isEmpty
          ? '$_baseUrl/movie/popular?api_key=$_apiKey&page=$page'
          : '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&page=$page';

      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return MovieList.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      rethrow;
    }
  }
}
