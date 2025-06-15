import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:windsurf/movies/details/presentation/state/movie_details_bloc/movie_details_event.dart';
import 'package:windsurf/movies/details/presentation/state/movie_details_bloc/movie_details_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:windsurf/movies/details/domain/models/movie_details.dart';
import 'package:windsurf/movies/details/presentation/state/movie_details_bloc/movie_details_bloc.dart';
import 'package:windsurf/shared/presentation/models/loading_status.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clock/clock.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../mocks/repository_mocks.dart';

void main() {
  late MockMovieDetailsRepository mockRepository;
  late StreamController<MovieDetails?> streamController;

  final movieDetails = MovieDetails(
    id: 1,
    title: 'Test Movie',
    budget: 1000000,
    revenue: 2000000,
  );

  setUp(() {
    mockRepository = MockMovieDetailsRepository();
    streamController = BehaviorSubject<MovieDetails?>.seeded(null);
    when(
      () => mockRepository.stream,
    ).thenAnswer((_) => streamController.stream);
  });
  group('FetchMovieDetails', () {
    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits loading and loaded states when fetch is successful',
      setUp: () {
        when(
          () =>
              mockRepository.fetchMovieDetails(movieId: any(named: 'movieId')),
        ).thenAnswer((_) async {});
        when(
          () => mockRepository.stream,
        ).thenAnswer((_) => Stream.value(movieDetails));
      },
      build:
          () => MovieDetailsBloc(
            movieId: 1,
            movieDetailsRepository: mockRepository,
          ),
      act: (bloc) => bloc.add(FetchMovieDetails(1)),
      expect:
          () => [
            const MovieDetailsState(
              loadingStatus: LoadingStatus.loading,
              details: null,
            ),
            MovieDetailsState(
              loadingStatus: LoadingStatus.loaded,
              details: movieDetails,
            ),
          ],
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits error state when fetch fails',
      setUp: () {
        when(
          () =>
              mockRepository.fetchMovieDetails(movieId: any(named: 'movieId')),
        ).thenThrow(Exception('Error'));
        when(() => mockRepository.stream).thenAnswer((_) => Stream.value(null));
      },
      skip: 2,
      build:
          () => MovieDetailsBloc(
            movieId: 1,
            movieDetailsRepository: mockRepository,
          ),
      act: (bloc) {
        bloc.add(FetchMovieDetails(1));
        return bloc;
      },
      expect:
          () => [
            const MovieDetailsState(
              loadingStatus: LoadingStatus.loading,
              details: null,
            ),
            const MovieDetailsState(
              loadingStatus: LoadingStatus.error,
              details: null,
              error: 'Exception: Error',
            ),
          ],
    );
  });

  group('DetailsChanged', () {
    final movieDetails = MovieDetails(
      id: 1,
      title: 'Test Movie',
      budget: 1000000,
      revenue: 2000000,
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits loaded state with new details',
      setUp: () {
        when(
          () =>
              mockRepository.fetchMovieDetails(movieId: any(named: 'movieId')),
        ).thenAnswer((_) async {});
        when(
          () => mockRepository.stream,
        ).thenAnswer((_) => Stream.value(movieDetails));
      },
      build:
          () => MovieDetailsBloc(
            movieId: 1,
            movieDetailsRepository: mockRepository,
          ),
      act: (bloc) => bloc.add(DetailsChanged(movieDetails)),
      expect:
          () => [
            const MovieDetailsState(
              loadingStatus: LoadingStatus.loading,
              details: null,
            ),
            MovieDetailsState(
              loadingStatus: LoadingStatus.loaded,
              details: movieDetails,
            ),
          ],
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits loaded state with null details',
      setUp: () {
        when(
          () =>
              mockRepository.fetchMovieDetails(movieId: any(named: 'movieId')),
        ).thenAnswer((_) async {});
        when(() => mockRepository.stream).thenAnswer((_) => Stream.value(null));
      },
      build:
          () => MovieDetailsBloc(
            movieId: 1,
            movieDetailsRepository: mockRepository,
          ),
      act: (bloc) => bloc.add(DetailsChanged(null)),
      expect:
          () => [
            const MovieDetailsState(
              loadingStatus: LoadingStatus.loading,
              details: null,
            ),
            const MovieDetailsState(
              loadingStatus: LoadingStatus.loaded,
              details: null,
            ),
          ],
    );
  });

  test(
    'shouldWatch returns true when revenue minus budget is greater than 1000000 on Sunday',
    () {
      final fixedDate = DateTime(2024, 3, 24);
      final fakeClock = Clock(() => fixedDate);
      withClock(fakeClock, () {
        fakeAsync((async) {
          when(
            () => mockRepository.fetchMovieDetails(
              movieId: any(named: 'movieId'),
            ),
          ).thenAnswer((_) async {});
          when(() => mockRepository.stream).thenAnswer(
            (_) => Stream.value(
              MovieDetails(
                id: 1,
                title: 'Test Movie',
                budget: 1000000,
                revenue: 2500000,
              ),
            ),
          );
          final bloc = MovieDetailsBloc(
            movieId: 1,
            movieDetailsRepository: mockRepository,
          );
          async.flushMicrotasks();
          expect(bloc.state.shouldWatch, isTrue);
        });
      });
    },
  );
}
