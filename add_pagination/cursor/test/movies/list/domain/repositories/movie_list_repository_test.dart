import 'package:flutter_test/flutter_test.dart';
import 'package:cursor/movies/list/data/models/movie_list.dart';
import 'package:cursor/movies/list/domain/models/movie_list_item.dart';
import 'package:cursor/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/service_mocks.dart';

void main() {
  late MovieListRepository repository;
  late MockMovieListLocalService mockLocalService;
  late MockMovieListRemoteService mockRemoteService;

  final mockMovieListItems = [
    MovieListItem(
      id: 1,
      title: 'Test Movie 1',
      voteAverage: 8.5,
    ),
    MovieListItem(
      id: 2,
      title: 'Test Movie 2',
      voteAverage: 7.5,
    ),
  ];

  final mockMovieList = MovieList(
    page: 1,
    totalPages: 2,
    totalResults: 4,
    results: mockMovieListItems,
  );

  setUp(() {
    mockLocalService = MockMovieListLocalService();
    mockRemoteService = MockMovieListRemoteService();
    repository = MovieListRepository(
      localService: mockLocalService,
      remoteService: mockRemoteService,
    );
  });

  setUpAll(() {
    registerFallbackValue(mockMovieListItems);
  });

  group('MovieListRepository', () {
    test('searchMovies should fetch from remote and save to local', () async {
      when(() => mockRemoteService.searchMovies(query: 'test', page: 1))
          .thenAnswer((_) async => mockMovieList);
      when(() => mockLocalService.saveSearchResults(
            results: any(named: 'results'),
            shouldReplace: true,
            query: any(named: 'query'),
            currentPage: any(named: 'currentPage'),
            totalPages: any(named: 'totalPages'),
          )).thenAnswer((_) async {});

      await repository.searchMovies(query: 'test');

      verify(() => mockRemoteService.searchMovies(query: 'test', page: 1))
          .called(1);
      verify(() => mockLocalService.saveSearchResults(
            results: any(named: 'results'),
            shouldReplace: true,
            query: 'test',
            currentPage: 1,
            totalPages: 2,
          )).called(1);
    });

    test('stream should return local service stream', () {
      when(() => mockLocalService.stream)
          .thenAnswer((_) => Stream.fromIterable([
                mockMovieListItems,
                [],
                mockMovieListItems,
              ]));

      expect(
        repository.stream,
        emitsInOrder([
          mockMovieListItems,
          [],
          mockMovieListItems,
        ]),
      );
    });

    test('hasMorePages should return local service hasMorePages', () {
      when(() => mockLocalService.hasMorePages).thenReturn(true);

      expect(repository.hasMorePages, true);

      verify(() => mockLocalService.hasMorePages).called(1);
    });
  });
}
