import 'dart:async';
import 'dart:convert';

import 'package:tabnine/movies/list/domain/models/movie_list_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieListLocalService {
  static const _searchHistoryKey = 'k_movie_search_history';

  final SharedPreferences _storage;

  late final StreamController<List<MovieListItem>> _streamController =
      BehaviorSubject.seeded(_getResults());
  Stream<List<MovieListItem>> get stream => _streamController.stream;

  MovieListLocalService({
    required SharedPreferences storage,
  }) : _storage = storage;

  Future<void> saveSearchResults({
    required List<MovieListItem> results,
    required bool shouldReplace,
  }) async {
    if (shouldReplace) {
      await _storage.remove(_searchHistoryKey);
    }
    final resultsJson = results.map((movie) => movie.toJson()).toList();
    await _storage.setString(_searchHistoryKey, jsonEncode(resultsJson));
    _streamController.add(results);
  }

  List<MovieListItem> _getResults() {
    try {
      final listJson = _storage.getString(_searchHistoryKey);
      if (listJson == null) return <MovieListItem>[];

      final results = jsonDecode(listJson);
      final mappedResults =
          results.map<MovieListItem>((json) => MovieListItem.fromJson(json));
      return mappedResults.toList();
    } catch (e) {
      _storage.remove(_searchHistoryKey);
      return <MovieListItem>[];
    }
  }

  Future<void> clear() async {
    await _storage.remove(_searchHistoryKey);
    _streamController.add(<MovieListItem>[]);
  }

  Future<MovieList?> getMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final key = _generateStorageKey(query, page);
      final jsonString = _storage.getString(key);
      
      if (jsonString != null) {
        return MovieList.fromJson(jsonDecode(jsonString));
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveMovies({
    required String query,
    required int page,
    required MovieList movies,
  }) async {
    try {
      final key = _generateStorageKey(query, page);
      await _storage.setString(key, jsonEncode(movies.toJson()));
    } catch (e) {
      // Handle error
    }
  }

  String _generateStorageKey(String query, int page) {
    return query.isEmpty 
        ? 'popular_movies_page_$page' 
        : 'search_movies_${query}_page_$page';
  }
}
