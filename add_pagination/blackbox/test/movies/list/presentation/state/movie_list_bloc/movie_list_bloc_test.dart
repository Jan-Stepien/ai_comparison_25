import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:blackbox/movies/list/domain/models/movie_list_item.dart';
import 'package:blackbox/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:blackbox/shared/presentation/models/loading_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../mocks/repository_mocks.dart';

void main() {
  late MockMovieListRepository mockRepository;
  late StreamController<List<MovieListItem>> streamController;

  final testMovies = [
    MovieListItem(id: 1, title: 'Test Movie 1', voteAverage: 8.5),
    MovieListItem(id: 2, title: 'Test Movie 2', voteAverage: 9.0),
  ];

  setUp(() {
    mockRepository = MockMovieListRepository();
    streamController = BehaviorSubject<List<MovieListItem>>.seeded([]);
    when(() => mockRepository.stream)
        .thenAnswer((_) => streamController.stream);
  });

  tearDown(() {
    streamController.close();
  });

  group('SearchMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'emits loading and loaded states when search is successful',
      setUp: () {
        when(() => mockRepository.searchMovies(query: any(named: 'query')))
            .thenAnswer((_) async => false);
        when(() => mockRepository.stream)
            .thenAnswer((_) => Stream.value(testMovies));
      },
      build: () => MovieListBloc(
        movieListRepository: mockRepository,
      ),
      act: (bloc) => bloc.add(const SearchMovies('test')),
      expect: () => [
        const MovieListState(
          loadingStatus: LoadingStatus.loading,
          movies: [],
          currentQuery: 'test',
          currentPage: 1,
          hasReachedEnd: false,
        ),
        const MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: [],
          currentQuery: 'test',
          currentPage: 1,
          hasReachedEnd: false,
        ),
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: testMovies,
          currentQuery: 'test',
          currentPage: 1,
          hasReachedEnd: false,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'emits error state when search fails',
      setUp: () {
        when(() => mockRepository.stream).thenAnswer((_) => Stream.value([]));
        when(() => mockRepository.searchMovies(query: any(named: 'query')))
            .thenThrow(Exception('Error'));
      },
      build: () => MovieListBloc(
        movieListRepository: mockRepository,
      ),
      act: (bloc) => bloc.add(const SearchMovies('test')),
      expect: () => [
        const MovieListState(
          loadingStatus: LoadingStatus.loading,
          movies: [],
          currentQuery: 'test',
          currentPage: 1,
          hasReachedEnd: false,
        ),
        const MovieListState(
          loadingStatus: LoadingStatus.error,
          movies: [],
          error: 'Exception: Error',
          currentQuery: 'test',
          currentPage: 1,
          hasReachedEnd: false,
        ),
      ],
    );
  });

  group('LoadMoreMovies', () {
    blocTest<MovieListBloc, MovieListState>(
      'loads more movies when not at end',
      setUp: () {
        when(() => mockRepository.loadMore(any()))
            .thenAnswer((_) async => false);
        when(() => mockRepository.stream)
            .thenAnswer((_) => Stream.value([...testMovies, ...testMovies]));
      },
      build: () => MovieListBloc(
        movieListRepository: mockRepository,
      ),
      seed: () => MovieListState(
        loadingStatus: LoadingStatus.loaded,
        movies: testMovies,
        currentQuery: 'test',
        currentPage: 1,
        hasReachedEnd: false,
      ),
      act: (bloc) => bloc.add(const LoadMoreMovies()),
      expect: () => [
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: testMovies,
          currentQuery: 'test',
          currentPage: 1,
          hasReachedEnd: false,
          isLoadingMore: true,
        ),
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: testMovies,
          currentQuery: 'test',
          currentPage: 2,
          hasReachedEnd: false,
          isLoadingMore: false,
        ),
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: [...testMovies, ...testMovies],
          currentQuery: 'test',
          currentPage: 2,
          hasReachedEnd: false,
          isLoadingMore: false,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'does not load more when already loading',
      build: () => MovieListBloc(
        movieListRepository: mockRepository,
      ),
      seed: () => const MovieListState(
        loadingStatus: LoadingStatus.loaded,
        movies: [],
        isLoadingMore: true,
      ),
      act: (bloc) => bloc.add(const LoadMoreMovies()),
      expect: () => [],
    );

    blocTest<MovieListBloc, MovieListState>(
      'does not load more when reached end',
      build: () => MovieListBloc(
        movieListRepository: mockRepository,
      ),
      seed: () => const MovieListState(
        loadingStatus: LoadingStatus.loaded,
        movies: [],
        hasReachedEnd: true,
      ),
      act: (bloc) => bloc.add(const LoadMoreMovies()),
      expect: () => [],
    );
  });

  group('ResultChanged', () {
    blocTest<MovieListBloc, MovieListState>(
      'emits same state with new movies',
      setUp: () {
        when(() => mockRepository.stream).thenAnswer((_) => Stream.value([]));
      },
      build: () => MovieListBloc(
        movieListRepository: mockRepository,
      ),
      act: (bloc) => bloc.add(ResultChanged(testMovies)),
      expect: () => [
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: testMovies,
        ),
      ],
    );
  });

  group('CreateMovieRequested', () {
    blocTest<MovieListBloc, MovieListState>(
      'emits same state when create movie is requested',
      build: () => MovieListBloc(
        movieListRepository: mockRepository,
      ),
      act: (bloc) => bloc.add(const CreateMovieRequested()),
      expect: () => const [],
    );
  });
}
