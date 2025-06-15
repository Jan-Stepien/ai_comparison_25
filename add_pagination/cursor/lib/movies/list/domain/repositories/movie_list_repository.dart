import 'package:cursor/movies/list/data/services/movie_list_local_service.dart';
import 'package:cursor/movies/list/data/services/movie_list_remote_service.dart';
import 'package:cursor/movies/list/domain/models/movie_list_item.dart';
import 'package:collection/collection.dart';

class MovieListRepository {
  final MovieListLocalService _localService;
  final MovieListRemoteService _remoteService;

  Stream<List<MovieListItem>> get stream => _localService.stream;

  MovieListRepository({
    required MovieListLocalService localService,
    required MovieListRemoteService remoteService,
  })  : _localService = localService,
        _remoteService = remoteService;

  Future<void> searchMovies({required String query}) async {
    final movieList = await _remoteService.searchMovies(query: query, page: 1);
    final sortedResults = movieList.results.sortedByCompare(
      (movie) => movie.voteAverage,
      (a, b) => b.compareTo(a),
    );

    await _localService.saveSearchResults(
      results: sortedResults,
      shouldReplace: true,
      query: query,
      currentPage: movieList.page,
      totalPages: movieList.totalPages,
    );
  }

  Future<void> loadMoreMovies() async {
    final currentQuery = _localService.getCurrentQuery();
    if (currentQuery == null || !_localService.hasMorePages) {
      return;
    }

    final nextPage = _localService.getCurrentPage() + 1;
    final movieList = await _remoteService.searchMovies(
      query: currentQuery,
      page: nextPage,
    );

    final sortedResults = movieList.results.sortedByCompare(
      (movie) => movie.voteAverage,
      (a, b) => b.compareTo(a),
    );

    await _localService.saveSearchResults(
      results: sortedResults,
      shouldReplace: false,
      query: currentQuery,
      currentPage: movieList.page,
      totalPages: movieList.totalPages,
    );
  }

  bool get hasMorePages => _localService.hasMorePages;
}
