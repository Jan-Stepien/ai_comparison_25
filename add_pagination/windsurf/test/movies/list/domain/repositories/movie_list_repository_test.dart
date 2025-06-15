import 'package:flutter_test/flutter_test.dart';
import 'package:windsurf/movies/list/domain/models/movie_list_item.dart';
import 'package:windsurf/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/service_mocks.dart';

void main() {
  late MovieListRepository repository;
  late MockMovieListLocalService mockLocalService;
  late MockMovieListRemoteService mockRemoteService;

  final mockMovieList = [
    MovieListItem(id: 1, title: 'Test Movie 1', voteAverage: 8.5),
    MovieListItem(id: 2, title: 'Test Movie 2', voteAverage: 7.5),
  ];

  setUp(() {
    mockLocalService = MockMovieListLocalService();
    mockRemoteService = MockMovieListRemoteService();
    repository = MovieListRepository(
      localService: mockLocalService,
      remoteService: mockRemoteService,
    );
  });

  setUpAll(() {
    registerFallbackValue(mockMovieList);
  });

  group('MovieListRepository', () {
    test('searchMovies should fetch from remote and save to local', () async {
      when(
        () => mockRemoteService.searchMovies(query: 'test'),
      ).thenAnswer((_) async => mockMovieList);
      when(
        () => mockLocalService.saveSearchResults(
          results: any(named: 'results'),
          shouldReplace: true,
        ),
      ).thenAnswer((_) async {});

      await repository.searchMovies(query: 'test');

      verify(() => mockRemoteService.searchMovies(query: 'test')).called(1);
      verify(
        () => mockLocalService.saveSearchResults(
          results: any(named: 'results'),
          shouldReplace: true,
        ),
      ).called(1);
    });

    test('stream should return local service stream', () {
      when(() => mockLocalService.stream).thenAnswer(
        (_) => Stream.fromIterable([mockMovieList, [], mockMovieList]),
      );

      expect(
        repository.stream,
        emitsInOrder([mockMovieList, [], mockMovieList]),
      );
    });
  });
}
