import 'package:cursor/movies/details/data/services/movie_details_local_service.dart';
import 'package:cursor/movies/details/data/services/movie_details_remote_service.dart';
import 'package:cursor/movies/list/data/services/movie_list_local_service.dart';
import 'package:cursor/movies/list/data/services/movie_list_remote_service.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieDetailsLocalService extends Mock
    implements MovieDetailsLocalService {}

class MockMovieDetailsRemoteService extends Mock
    implements MovieDetailsRemoteService {}

class MockMovieListLocalService extends Mock implements MovieListLocalService {}

class MockMovieListRemoteService extends Mock
    implements MovieListRemoteService {}
