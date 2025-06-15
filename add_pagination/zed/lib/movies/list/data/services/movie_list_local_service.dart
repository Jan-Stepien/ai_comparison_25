import 'dart:async';
import 'dart:convert';

import 'package:zed/movies/list/domain/models/movie_list_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

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
    List<MovieListItem> updatedResults = [];

    if (shouldReplace) {
      updatedResults = List.from(results);
    } else {
      // Get current results and append new ones, avoiding duplicates
      final currentResults = _getResults();
      final existingIds = currentResults.map((movie) => movie.id).toSet();

      // Combine existing results with new ones, excluding duplicates
      updatedResults = [
        ...currentResults,
        ...results.where((movie) => !existingIds.contains(movie.id))
      ];

      // Sort by vote average (descending)
      updatedResults.sortByCompare(
        (movie) => movie.voteAverage,
        (a, b) => b.compareTo(a),
      );
    }

    final resultsJson = updatedResults.map((movie) => movie.toJson()).toList();
    await _storage.setString(_searchHistoryKey, jsonEncode(resultsJson));
    _streamController.add(updatedResults);
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
}
