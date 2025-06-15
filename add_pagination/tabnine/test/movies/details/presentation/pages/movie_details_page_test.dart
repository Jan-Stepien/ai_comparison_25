import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabnine/movies/details/domain/models/movie_details.dart';
import 'package:tabnine/movies/details/presentation/state/movie_details_bloc/movie_details_event.dart';
import 'package:tabnine/movies/details/presentation/state/movie_details_bloc/movie_details_state.dart';
import 'package:tabnine/shared/presentation/models/loading_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabnine/movies/details/presentation/pages/movie_details_page.dart';
import 'package:tabnine/movies/details/domain/repositories/movie_details_repository.dart';
import 'package:tabnine/movies/details/presentation/state/movie_details_bloc/movie_details_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import '../../../../app_provider.dart';
import '../../../../mocks/repository_mocks.dart';

class MockMovieDetailsBloc
    extends MockBloc<MovieDetailsEvent, MovieDetailsState>
    implements MovieDetailsBloc {}

void main() {
  const testMovieId = 123;

  group('MovieDetailsPage', () {
    late MockMovieDetailsRepository mockRepository;
    setUp(() {
      mockRepository = MockMovieDetailsRepository();
      when(() => mockRepository.stream).thenAnswer(
        (_) => Stream<MovieDetails?>.value(null),
      );
    });
    group('renders', () {
      testWidgets('MovieDetailsView if movieId is not null',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          AppProvider(
            repositories: [
              RepositoryProvider<MovieDetailsRepository>(
                create: (context) => mockRepository,
              ),
            ],
            child: const MovieDetailsPage(movieId: testMovieId),
          ),
        );

        expect(find.byType(MovieDetailsView), findsOneWidget);
      });

      testWidgets('error message if movieId is null',
          (WidgetTester tester) async {
        final localized = AppLocalizationsEn();

        await tester.pumpWidget(
          AppProvider(
            child: const MovieDetailsPage(movieId: null),
          ),
        );

        expect(find.text(localized.error), findsOneWidget);
      });
    });
  });
  group('MovieDetailsView', () {
    late MovieDetailsBloc movieDetailsBloc;
    setUp(() {
      movieDetailsBloc = MockMovieDetailsBloc();
    });
    testWidgets('renders loading state correctly', (WidgetTester tester) async {
      when(() => movieDetailsBloc.state).thenReturn(
        const MovieDetailsState(
          loadingStatus: LoadingStatus.loading,
          details: null,
        ),
      );

      await tester.pumpWidget(
        AppProvider(
          child: BlocProvider.value(
            value: movieDetailsBloc,
            child: const MovieDetailsView(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders error state correctly', (WidgetTester tester) async {
      const errorMessage = 'Test error';
      when(() => movieDetailsBloc.state).thenReturn(
        const MovieDetailsState(
          loadingStatus: LoadingStatus.error,
          details: null,
          error: errorMessage,
        ),
      );

      await tester.pumpWidget(
        AppProvider(
          child: BlocProvider.value(
            value: movieDetailsBloc,
            child: const MovieDetailsView(),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('renders loaded state correctly', (WidgetTester tester) async {
      var movieDetails = MovieDetails(
        id: testMovieId,
        title: 'Test Movie',
        budget: 1000000,
        revenue: 2000000,
      );

      when(() => movieDetailsBloc.state).thenReturn(
        MovieDetailsState(
          loadingStatus: LoadingStatus.loaded,
          details: movieDetails,
        ),
      );

      await tester.pumpWidget(
        AppProvider(
          child: BlocProvider.value(
            value: movieDetailsBloc,
            child: const MovieDetailsView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(movieDetails.title), findsOneWidget);
      expect(find.text('\$${movieDetails.budget}'), findsOneWidget);
      expect(find.text('\$${movieDetails.revenue}'), findsOneWidget);
    });
  });
}
