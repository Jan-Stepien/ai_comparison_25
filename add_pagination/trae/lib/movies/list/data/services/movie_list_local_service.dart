import 'dart:async';
import 'dart:convert';

import 'package:trae/movies/list/domain/models/movie_list_item.dart';
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

  // Update the saveSearchResults method to handle appending results
  Future<void> saveSearchResults({
    required List<MovieListItem> results,
    required bool shouldReplace,
  }) async {
    final currentResults = _getResults();
    final newResults =
        shouldReplace ? results : [...currentResults, ...results];

    final jsonString = jsonEncode(newResults.map((e) => e.toJson()).toList());
    await _storage.setString(_searchHistoryKey, jsonString);
    _streamController.add(newResults);
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
