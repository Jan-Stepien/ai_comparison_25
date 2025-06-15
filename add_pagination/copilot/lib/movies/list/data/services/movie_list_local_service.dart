import 'dart:async';
import 'dart:convert';

import 'package:copilot/movies/list/domain/models/movie_list_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginatedResults {
  final List<MovieListItem> movies;
  final int currentPage;
  final int totalItems;
  final int pageSize;
  final bool hasMorePages;

  const PaginatedResults({
    required this.movies,
    required this.currentPage,
    required this.totalItems,
    required this.pageSize,
    required this.hasMorePages,
  });
}

class MovieListLocalService {
  static const _searchHistoryKey = 'k_movie_search_history';
  static const int defaultPageSize = 10;

  final SharedPreferences _storage;

  late final StreamController<List<MovieListItem>> _streamController =
      BehaviorSubject.seeded(_getResults());
  Stream<List<MovieListItem>> get stream => _streamController.stream;

  late final StreamController<PaginatedResults> _paginatedController =
      BehaviorSubject.seeded(_getPaginatedResults(1, defaultPageSize));
  Stream<PaginatedResults> get paginatedStream => _paginatedController.stream;

  MovieListLocalService({required SharedPreferences storage})
      : _storage = storage;

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

    // Update paginated results with first page
    final paginatedResults = _getPaginatedResults(1, defaultPageSize);
    _paginatedController.add(paginatedResults);
  }

  List<MovieListItem> _getResults() {
    try {
      final listJson = _storage.getString(_searchHistoryKey);
      if (listJson == null) return <MovieListItem>[];

      final results = jsonDecode(listJson);
      final mappedResults = results.map<MovieListItem>(
        (json) => MovieListItem.fromJson(json),
      );
      return mappedResults.toList();
    } catch (e) {
      _storage.remove(_searchHistoryKey);
      return <MovieListItem>[];
    }
  }

  Future<void> clear() async {
    await _storage.remove(_searchHistoryKey);
    _streamController.add(<MovieListItem>[]);
    _paginatedController.add(PaginatedResults(
      movies: [],
      currentPage: 1,
      totalItems: 0,
      pageSize: defaultPageSize,
      hasMorePages: false,
    ));
  }

  PaginatedResults _getPaginatedResults(int page, int pageSize) {
    final allResults = _getResults();
    final totalItems = allResults.length;
    final totalPages = (totalItems / pageSize).ceil();

    // Ensure page is within valid range
    int validPage = page;
    if (validPage < 1) validPage = 1;
    if (validPage > totalPages && totalPages > 0) validPage = totalPages;

    final startIndex = (validPage - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalItems);

    final List<MovieListItem> pagedMovies =
        totalItems > 0 && startIndex < totalItems
            ? allResults.sublist(startIndex, endIndex)
            : [];

    return PaginatedResults(
      movies: pagedMovies,
      currentPage: validPage,
      totalItems: totalItems,
      pageSize: pageSize,
      hasMorePages: validPage < totalPages,
    );
  }

  Future<PaginatedResults> getPage(int page,
      {int pageSize = defaultPageSize}) async {
    final results = _getPaginatedResults(page, pageSize);
    _paginatedController.add(results);
    return results;
  }
}
