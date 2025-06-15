import 'dart:async';
import 'dart:convert';

import 'package:trae/movies/details/domain/models/movie_details.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailsLocalService {
  static const _movieDetailsKey = 'k_movie_details';

  final SharedPreferences _storage;

  late final StreamController<MovieDetails?> _streamController =
      BehaviorSubject.seeded(_getMovieDetails());
  Stream<MovieDetails?> get stream => _streamController.stream;

  MovieDetailsLocalService({
    required SharedPreferences storage,
  }) : _storage = storage;

  Future<void> saveMovieDetails(MovieDetails details) async {
    await _storage.setString(_movieDetailsKey, jsonEncode(details.toJson()));
    _streamController.add(details);
  }

  MovieDetails? _getMovieDetails() {
    try {
      final detailsJson = _storage.getString(_movieDetailsKey);
      if (detailsJson == null) {
        return null;
      }

      final details = jsonDecode(detailsJson);
      return MovieDetails.fromJson(details);
    } catch (e) {
      _storage.remove(_movieDetailsKey);
      return null;
    }
  }

  Future<void> clear() async {
    await _storage.remove(_movieDetailsKey);
    _streamController.add(null);
  }
}
