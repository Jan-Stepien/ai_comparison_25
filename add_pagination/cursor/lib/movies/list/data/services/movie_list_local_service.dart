import 'dart:async';
import 'dart:convert';

import 'package:cursor/movies/list/domain/models/movie_list_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieListLocalService {
  static const _searchHistoryKey = 'k_movie_search_history';
  static const _currentPageKey = 'k_current_page';
  static const _totalPagesKey = 'k_total_pages';
  static const _currentQueryKey = 'k_current_query';

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
    String? query,
    int? currentPage,
    int? totalPages,
  }) async {
    List<MovieListItem> finalResults;

    if (shouldReplace) {
      await _storage.remove(_searchHistoryKey);
      finalResults = results;
    } else {
      // Append new results to existing ones
      final existingResults = _getResults();
      final existingIds = existingResults.map((movie) => movie.id).toSet();
      final newResults =
          results.where((movie) => !existingIds.contains(movie.id)).toList();
      finalResults = [...existingResults, ...newResults];
    }

    final resultsJson = finalResults.map((movie) => movie.toJson()).toList();
    await _storage.setString(_searchHistoryKey, jsonEncode(resultsJson));

    // Save pagination state
    if (query != null) {
      await _storage.setString(_currentQueryKey, query);
    }
    if (currentPage != null) {
      await _storage.setInt(_currentPageKey, currentPage);
    }
    if (totalPages != null) {
      await _storage.setInt(_totalPagesKey, totalPages);
    }

    _streamController.add(finalResults);
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

  int getCurrentPage() {
    return _storage.getInt(_currentPageKey) ?? 1;
  }

  int getTotalPages() {
    return _storage.getInt(_totalPagesKey) ?? 1;
  }

  String? getCurrentQuery() {
    return _storage.getString(_currentQueryKey);
  }

  bool get hasMorePages {
    return getCurrentPage() < getTotalPages();
  }

  Future<void> clear() async {
    await _storage.remove(_searchHistoryKey);
    await _storage.remove(_currentPageKey);
    await _storage.remove(_totalPagesKey);
    await _storage.remove(_currentQueryKey);
    _streamController.add(<MovieListItem>[]);
  }
}
