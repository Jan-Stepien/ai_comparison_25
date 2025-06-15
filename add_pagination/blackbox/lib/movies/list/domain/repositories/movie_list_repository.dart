import 'package:blackbox/movies/list/data/services/movie_list_local_service.dart';
import 'package:blackbox/movies/list/data/services/movie_list_remote_service.dart';
import 'package:blackbox/movies/list/domain/models/movie_list_item.dart';
import 'package:collection/collection.dart';

class MovieListRepository {
  final MovieListLocalService _localService;
  final MovieListRemoteService _remoteService;
  String _currentQuery = '';

  Stream<List<MovieListItem>> get stream => _localService.stream;

  MovieListRepository({
    required MovieListLocalService localService,
    required MovieListRemoteService remoteService,
  })  : _localService = localService,
        _remoteService = remoteService;

  Future<bool> searchMovies({
    required String query,
    int page = 1,
    bool shouldReplace = true,
  }) async {
    _currentQuery = query;
    final results = await _remoteService.searchMovies(query: query, page: page);
    final sortedResults = results.results.sortedByCompare(
      (movie) => movie.voteAverage,
      (a, b) => b.compareTo(a),
    );

    await _localService.saveSearchResults(
      results: sortedResults,
      shouldReplace: shouldReplace,
    );

    return results.results.length < 20; // Standard page size for TMDB API
  }

  Future<bool> loadMore(int page) async {
    if (_currentQuery.isEmpty) return true;
    return searchMovies(
      query: _currentQuery,
      page: page,
      shouldReplace: false,
    );
  }
}
