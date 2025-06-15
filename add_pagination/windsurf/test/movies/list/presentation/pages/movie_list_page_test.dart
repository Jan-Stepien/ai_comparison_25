import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:windsurf/movies/list/domain/models/movie_list_item.dart';
import 'package:windsurf/movies/list/presentation/widgets/movie_list_results_view.dart';
import 'package:windsurf/movies/list/presentation/widgets/movie_list_search_box.dart';
import 'package:windsurf/shared/presentation/models/loading_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:windsurf/movies/list/presentation/pages/movie_list_page.dart';
import 'package:windsurf/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:windsurf/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../app_provider.dart';
import '../../../../mocks/repository_mocks.dart';

class MockMovieListBloc extends MockBloc<MovieListEvent, MovieListState>
    implements MovieListBloc {}

void main() {
  group('MovieListPage', () {
    late MockMovieListRepository mockRepository;

    setUp(() {
      mockRepository = MockMovieListRepository();
      when(
        () => mockRepository.stream,
      ).thenAnswer((_) => Stream<List<MovieListItem>>.value([]));
    });
    group('renders', () {
      testWidgets('MovieListView', (WidgetTester tester) async {
        await tester.pumpWidget(
          AppProvider(
            repositories: [
              RepositoryProvider<MovieListRepository>(
                create: (context) => mockRepository,
              ),
            ],
            child: const MovieListPage(),
          ),
        );

        expect(find.byType(MovieListView), findsOneWidget);
      });
    });
  });

  group('MovieListView', () {
    late MovieListBloc movieListBloc;

    setUp(() {
      movieListBloc = MockMovieListBloc();
      when(() => movieListBloc.state).thenReturn(
        const MovieListState(movies: [], loadingStatus: LoadingStatus.initial),
      );
    });

    group('renders', () {
      testWidgets('top, search and result sections', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          AppProvider(
            child: BlocProvider.value(
              value: movieListBloc,
              child: const MovieListView(),
            ),
          ),
        );

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(MovieListSearchBox), findsOneWidget);
        expect(find.byType(MovieListResultsView), findsOneWidget);
      });

      testWidgets('element in results view', (WidgetTester tester) async {
        when(() => movieListBloc.state).thenReturn(
          MovieListState(
            movies: [
              MovieListItem(id: 1, title: 'Test Movie', voteAverage: 8.5),
              MovieListItem(id: 2, title: 'Test Movie 2', voteAverage: 9),
            ],
            loadingStatus: LoadingStatus.loaded,
          ),
        );
        await tester.pumpWidget(
          AppProvider(
            child: BlocProvider.value(
              value: movieListBloc,
              child: const MovieListView(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Test Movie'), findsOneWidget);
        expect(find.text('Test Movie 2'), findsOneWidget);
      });
    });

    group('triggers', () {
      setUpAll(() {
        registerFallbackValue(SearchMovies(''));
      });
      testWidgets('search event on search box submit', (
        WidgetTester tester,
      ) async {
        const testQuery = 'test movie';
        when(
          () => movieListBloc.add(SearchMovies(testQuery)),
        ).thenAnswer((_) {});

        await tester.pumpWidget(
          AppProvider(
            child: BlocProvider.value(
              value: movieListBloc,
              child: const MovieListView(),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), testQuery);
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        verify(
          () => movieListBloc.add(any(that: isA<SearchMovies>())),
        ).called(1);
      });

      testWidgets('create movie event on create movie button pressed', (
        WidgetTester tester,
      ) async {
        when(
          () => movieListBloc.add(const CreateMovieRequested()),
        ).thenAnswer((_) {});

        await tester.pumpWidget(
          AppProvider(
            child: BlocProvider.value(
              value: movieListBloc,
              child: const MovieListView(),
            ),
          ),
        );
        await tester.tap(find.byIcon(Icons.movie_creation_outlined));
        await tester.pumpAndSettle();

        verify(
          () => movieListBloc.add(any(that: isA<CreateMovieRequested>())),
        ).called(1);
      });
    });
  });
}
