import 'package:windsurf/movies/list/data/models/movie_list.dart';
import 'package:windsurf/movies/list/data/services/movie_list_local_service.dart';
import 'package:windsurf/movies/list/data/services/movie_list_remote_service.dart';
import 'package:windsurf/movies/list/domain/models/movie_list_item.dart';
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

  Future<MovieList> searchMovies(
      {required String query, int page = 1, bool shouldReplace = true}) async {
    final movieList =
        await _remoteService.searchMovies(query: query, page: page);
    await _localService.saveSearchResults(
      results: movieList.results,
      shouldReplace: shouldReplace,
    );
    return movieList;
  }
}
