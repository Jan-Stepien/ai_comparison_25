import 'package:flutter_test/flutter_test.dart';
import 'package:blackbox/movies/list/domain/models/movie_list_item.dart';
import 'package:blackbox/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:blackbox/movies/list/data/models/movie_list.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/service_mocks.dart';

void main() {
  late MovieListRepository repository;
  late MockMovieListLocalService mockLocalService;
  late MockMovieListRemoteService mockRemoteService;

  final mockMovieList = [
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

  final mockMovieListResponse = MovieList(
    totalResults: 4,
    results: mockMovieList,
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
    registerFallbackValue(mockMovieList);
  });

  group('MovieListRepository', () {
    group('searchMovies', () {
      test('should fetch from remote and save to local', () async {
        when(() => mockRemoteService.searchMovies(query: 'test', page: 1))
            .thenAnswer((_) async => mockMovieListResponse);
        when(() => mockLocalService.saveSearchResults(
              results: any(named: 'results'),
              shouldReplace: true,
            )).thenAnswer((_) async {});

        final hasReachedEnd = await repository.searchMovies(query: 'test');

        verify(() => mockRemoteService.searchMovies(query: 'test', page: 1))
            .called(1);
        verify(() => mockLocalService.saveSearchResults(
              results: any(named: 'results'),
              shouldReplace: true,
            )).called(1);

        // Since mockMovieList has 2 items (less than standard page size of 20)
        expect(hasReachedEnd, isTrue);
      });

      test('should return hasReachedEnd=false when full page received',
          () async {
        final fullPageList = List.generate(
          20,
          (i) => MovieListItem(
            id: i,
            title: 'Movie $i',
            voteAverage: 7.0,
          ),
        );

        when(() => mockRemoteService.searchMovies(query: 'test', page: 1))
            .thenAnswer((_) async => MovieList(
                  totalResults: 40,
                  results: fullPageList,
                ));
        when(() => mockLocalService.saveSearchResults(
              results: any(named: 'results'),
              shouldReplace: true,
            )).thenAnswer((_) async {});

        final hasReachedEnd = await repository.searchMovies(query: 'test');

        expect(hasReachedEnd, isFalse);
      });
    });

    group('loadMore', () {
      test('should fetch next page and append to local', () async {
        when(() => mockRemoteService.searchMovies(query: 'test', page: 2))
            .thenAnswer((_) async => mockMovieListResponse);
        when(() => mockLocalService.saveSearchResults(
              results: any(named: 'results'),
              shouldReplace: false,
            )).thenAnswer((_) async {});

        // First set the current query
        when(() => mockRemoteService.searchMovies(query: 'test', page: 1))
            .thenAnswer((_) async => mockMovieListResponse);
        await repository.searchMovies(query: 'test');

        final hasReachedEnd = await repository.loadMore(2);

        verify(() => mockRemoteService.searchMovies(query: 'test', page: 2))
            .called(1);
        verify(() => mockLocalService.saveSearchResults(
              results: any(named: 'results'),
              shouldReplace: false,
            )).called(1);

        expect(hasReachedEnd, isTrue);
      });

      test('should return true when no current query', () async {
        final hasReachedEnd = await repository.loadMore(2);
        expect(hasReachedEnd, isTrue);
      });
    });

    test('stream should return local service stream', () {
      when(() => mockLocalService.stream)
          .thenAnswer((_) => Stream.fromIterable([
                mockMovieList,
                [],
                mockMovieList,
              ]));

      expect(
        repository.stream,
        emitsInOrder([
          mockMovieList,
          [],
          mockMovieList,
        ]),
      );
    });
  });
}
