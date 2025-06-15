import 'package:clock/clock.dart';
import 'package:windsurf/movies/details/domain/models/movie_details.dart';
import 'package:windsurf/movies/details/presentation/state/movie_details_bloc/movie_details_state.dart';
import 'package:windsurf/shared/presentation/models/loading_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovieDetailsState', () {
    test(
      'shouldWatch returns true when revenue minus budget is greater than 1000000 on Sunday',
      () {
        final fixedDate = DateTime(2024, 3, 24);
        final fakeClock = Clock(() => fixedDate);
        withClock(fakeClock, () {
          final state = MovieDetailsState(
            loadingStatus: LoadingStatus.loaded,
            details: MovieDetails(
              id: 1,
              title: 'Test Movie',
              budget: 1000000,
              revenue: 2500000,
            ),
          );

          expect(state.shouldWatch, isTrue);
        });
      },
    );

    group('copyWith', () {
      test('returns a new instance with the updated values', () {
        final state = MovieDetailsState(
          loadingStatus: LoadingStatus.initial,
          details: MovieDetails(
            id: 1,
            title: 'Test Movie',
            budget: 1000000,
            revenue: 2500000,
          ),
          error: null,
        );
        final newState = state.copyWith(
          loadingStatus: LoadingStatus.loading,
          details: MovieDetails(
            id: 1,
            title: 'New Movie',
            budget: 2000000,
            revenue: 3000000,
          ),
          error: 'Error',
        );
        expect(newState.loadingStatus, LoadingStatus.loading);
        expect(newState.details?.title, 'New Movie');
        expect(newState.error, 'Error');
      });

      test('returns a new instance with null values', () {
        final state = MovieDetailsState(
          loadingStatus: LoadingStatus.initial,
          details: MovieDetails(
            id: 1,
            title: 'Test Movie',
            budget: 1000000,
            revenue: 2500000,
          ),
          error: 'Error',
        );
        final newState = state.copyWith(
          details: null,
          error: null,
          loadingStatus: LoadingStatus.loaded,
        );
        expect(newState.loadingStatus, LoadingStatus.loaded);
        expect(newState.details, isNull);
        expect(newState.error, isNull);
      });
    });
  });
}
