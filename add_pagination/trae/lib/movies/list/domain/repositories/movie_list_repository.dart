import 'package:trae/movies/list/data/services/movie_list_local_service.dart';
import 'package:trae/movies/list/data/services/movie_list_remote_service.dart';
import 'package:trae/movies/list/domain/models/movie_list_item.dart';
import 'package:collection/collection.dart';

class MovieListRepository {
  final MovieListLocalService _localService;
  final MovieListRemoteService _remoteService;
  String _currentQuery = '';
  int _currentPage = 1;

  Stream<List<MovieListItem>> get stream => _localService.stream;

  MovieListRepository({
    required MovieListLocalService localService,
    required MovieListRemoteService remoteService,
  })  : _localService = localService,
        _remoteService = remoteService;

  Future<void> searchMovies({required String query}) async {
    _currentQuery = query;
    _currentPage = 1;
    final results = await _remoteService.searchMovies(query: query, page: _currentPage);
    await _localService.saveSearchResults(
      results: results.sortedByCompare(
        (movie) => movie.voteAverage,
        (a, b) => b.compareTo(a),
      ),
      shouldReplace: true,
    );
  }

  Future<void> loadMoreMovies() async {
    if (_currentQuery.isEmpty) return;
    
    _currentPage++;
    final results = await _remoteService.searchMovies(
      query: _currentQuery,
      page: _currentPage,
    );
    
    await _localService.saveSearchResults(
      results: results.sortedByCompare(
        (movie) => movie.voteAverage,
        (a, b) => b.compareTo(a),
      ),
      shouldReplace: false,
    );
  }
}
