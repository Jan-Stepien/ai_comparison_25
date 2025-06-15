import 'package:gemini/movies/list/data/services/movie_list_local_service.dart';
import 'package:gemini/movies/list/data/services/movie_list_remote_service.dart';
import 'package:gemini/movies/list/domain/models/movie_list_item.dart';
import 'package:collection/collection.dart';

class MovieListRepository {
  final MovieListLocalService _localService;
  final MovieListRemoteService _remoteService;

  Stream<List<MovieListItem>> get stream => _localService.stream;

  MovieListRepository({
    required MovieListLocalService localService,
    required MovieListRemoteService remoteService,
  }) : _localService = localService,
       _remoteService = remoteService;

  Future<void> searchMovies({required String query}) async {
    final results = await _remoteService.searchMovies(query: query);
    await _localService.saveSearchResults(
      results: results.sortedByCompare(
        (movie) => movie.voteAverage,
        (a, b) => b.compareTo(a),
      ),
      shouldReplace: true,
    );
  }
}
