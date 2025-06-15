import 'package:cursor/movies/details/domain/repositories/movie_details_repository.dart';
import 'package:cursor/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieListRepository extends Mock implements MovieListRepository {
  @override
  bool get hasMorePages =>
      super.noSuchMethod(
        Invocation.getter(#hasMorePages),
      ) ??
      false;
}

class MockMovieDetailsRepository extends Mock
    implements MovieDetailsRepository {}
