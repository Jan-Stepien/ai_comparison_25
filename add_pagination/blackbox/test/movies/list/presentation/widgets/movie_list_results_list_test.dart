import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blackbox/movies/list/domain/models/movie_list_item.dart';
import 'package:blackbox/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:blackbox/movies/list/presentation/widgets/movie_list_results_list.dart';
import 'package:blackbox/shared/presentation/models/loading_status.dart';

class MockMovieListBloc extends Mock implements MovieListBloc {}

void main() {
  late MockMovieListBloc mockBloc;

  final testMovies = [
    MovieListItem(id: 1, title: 'Test Movie 1', voteAverage: 8.5),
    MovieListItem(id: 2, title: 'Test Movie 2', voteAverage: 9.0),
  ];

  setUp(() {
    mockBloc = MockMovieListBloc();
  });

  Widget buildTestWidget({
    required List<MovieListItem> movies,
    bool isLoadingMore = false,
    bool hasReachedEnd = false,
  }) {
    return MaterialApp(
      home: BlocProvider<MovieListBloc>.value(
        value: mockBloc,
        child: Material(
          child: MovieListResultsList(movieList: movies),
        ),
      ),
    );
  }

  group('MovieListResultsList', () {
    testWidgets('renders list of movies', (tester) async {
      when(() => mockBloc.state).thenReturn(
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: testMovies,
        ),
      );

      await tester.pumpWidget(buildTestWidget(movies: testMovies));

      expect(find.text('Test Movie 1'), findsOneWidget);
      expect(find.text('Test Movie 2'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading more', (tester) async {
      when(() => mockBloc.state).thenReturn(
        const MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: [],
          isLoadingMore: true,
        ),
      );

      await tester.pumpWidget(buildTestWidget(
        movies: testMovies,
        isLoadingMore: true,
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('triggers load more when scrolled to bottom', (tester) async {
      when(() => mockBloc.state).thenReturn(
        MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: List.generate(
            20,
            (i) => MovieListItem(
              id: i,
              title: 'Movie $i',
              voteAverage: 7.0,
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          movies: List.generate(
            20,
            (i) => MovieListItem(
              id: i,
              title: 'Movie $i',
              voteAverage: 7.0,
            ),
          ),
        ),
      );

      await tester.dragFrom(
        tester.getCenter(find.byType(ListView)),
        const Offset(0, -500),
      );
      await tester.pump();

      verify(() => mockBloc.add(const LoadMoreMovies())).called(1);
    });

    testWidgets('does not show loading indicator when reached end',
        (tester) async {
      when(() => mockBloc.state).thenReturn(
        const MovieListState(
          loadingStatus: LoadingStatus.loaded,
          movies: [],
          hasReachedEnd: true,
        ),
      );

      await tester.pumpWidget(buildTestWidget(
        movies: testMovies,
        hasReachedEnd: true,
      ));

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
