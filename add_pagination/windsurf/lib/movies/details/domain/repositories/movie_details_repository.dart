import 'package:windsurf/movies/details/data/services/movie_details_local_service.dart';
import 'package:windsurf/movies/details/data/services/movie_details_remote_service.dart';
import 'package:windsurf/movies/details/domain/models/movie_details.dart';

class MovieDetailsRepository {
  final MovieDetailsLocalService _localService;
  final MovieDetailsRemoteService _remoteService;

  Stream<MovieDetails?> get stream => _localService.stream;

  MovieDetailsRepository({
    required MovieDetailsLocalService localService,
    required MovieDetailsRemoteService remoteService,
  })  : _localService = localService,
        _remoteService = remoteService;

  Future<void> fetchMovieDetails({required int movieId}) async {
    final details = await _remoteService.fetchMovieDetails(movieId);
    await _localService.saveMovieDetails(details);
  }
}
