import 'dart:convert';

import 'package:blackbox/movies/details/domain/models/movie_details.dart';
import 'package:http/http.dart' as http;

class MovieDetailsRemoteService {
  final String _apiKey;
  final String _baseUrl;
  final http.Client _client;

  MovieDetailsRemoteService({
    required String apiKey,
    required String baseUrl,
    required http.Client client,
  })  : _apiKey = apiKey,
        _baseUrl = baseUrl,
        _client = client;

  Future<MovieDetails> fetchMovieDetails(int movieId) async {
    final parameters = {
      'api_key': _apiKey,
    };
    final endpoint = Uri.https(_baseUrl, '/3/movie/$movieId', parameters);
    final response = await _client.get(endpoint);
    final json = jsonDecode(response.body);
    return MovieDetails.fromJson(json);
  }
}
