import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:trae/movies/list/domain/models/movie_list_item.dart';
import 'package:trae/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:trae/shared/presentation/models/loading_status.dart';
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
            .thenAnswer((_) async {});
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
        ),
        const MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: [],
        ),
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: testMovies,
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
      act: (bloc) {
        Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const SearchMovies('test'));
      },
      expect: () => [
        const MovieListState(
          loadingStatus: LoadingStatus.loading,
          movies: [],
        ),
        const MovieListState(
          loadingStatus: LoadingStatus.error,
          movies: [],
          error: 'Exception: Error',
        ),
      ],
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
      act: (bloc) async {
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(ResultChanged(testMovies));
      },
      expect: () => [
        const MovieListState(
          loadingStatus: LoadingStatus.initial,
          movies: [],
        ),
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: testMovies,
        ),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'emits initial state with empty movies list',
      setUp: () {
        when(() => mockRepository.stream)
            .thenAnswer((_) => Stream.value(testMovies));
      },
      build: () => MovieListBloc(
        movieListRepository: mockRepository,
      ),
      act: (bloc) async {
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const ResultChanged([]));
      },
      expect: () => [
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: testMovies,
        ),
        const MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: [],
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
      expect: () => [
        const MovieListState(
          loadingStatus: LoadingStatus.initial,
          movies: [],
        ),
      ],
    );
  });
}
