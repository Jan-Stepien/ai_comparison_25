import 'package:zed/movies/list/data/services/movie_list_local_service.dart';
import 'package:zed/movies/list/data/services/movie_list_remote_service.dart';
import 'package:zed/movies/list/domain/models/movie_list_item.dart';
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

  Future<bool> searchMovies({
    required String query,
    int page = 1,
    bool shouldReplace = true,
  }) async {
    final movieListResponse = await _remoteService.searchMovies(
      query: query,
      page: page,
    );

    final results = movieListResponse.results.sortedByCompare(
      (movie) => movie.voteAverage,
      (a, b) => b.compareTo(a),
    );

    await _localService.saveSearchResults(
      results: results,
      shouldReplace: shouldReplace,
    );

    // Return whether there are more pages to load
    return page < movieListResponse.totalPages;
  }
}
