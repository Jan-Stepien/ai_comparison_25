import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cursor/movies/list/domain/models/movie_list_item.dart';
import 'package:cursor/movies/list/presentation/widgets/movie_list_results_view.dart';
import 'package:cursor/movies/list/presentation/widgets/movie_list_search_box.dart';
import 'package:cursor/shared/presentation/models/loading_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cursor/movies/list/presentation/pages/movie_list_page.dart';
import 'package:cursor/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:cursor/movies/list/presentation/state/movie_list_bloc/movie_list_bloc.dart';
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
      when(() => mockRepository.stream).thenAnswer(
        (_) => Stream<List<MovieListItem>>.value(
          [],
        ),
      );
    });
    group('renders', () {
      testWidgets('MovieListView', (WidgetTester tester) async {
        await tester.pumpWidget(AppProvider(
          repositories: [
            RepositoryProvider<MovieListRepository>(
              create: (context) => mockRepository,
            ),
          ],
          child: const MovieListPage(),
        ));

        expect(find.byType(MovieListView), findsOneWidget);
      });
    });
  });

  group('MovieListView', () {
    late MovieListBloc movieListBloc;

    setUp(() {
      movieListBloc = MockMovieListBloc();
      when(() => movieListBloc.state).thenReturn(
        const MovieListState(
          movies: [],
          loadingStatus: LoadingStatus.initial,
          hasMorePages: false,
        ),
      );
    });

    group('renders', () {
      testWidgets('top, search and result sections',
          (WidgetTester tester) async {
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
            hasMorePages: false,
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

    group('actions', () {
      testWidgets('search for movies', (WidgetTester tester) async {
        await tester.pumpWidget(
          AppProvider(
            child: BlocProvider.value(
              value: movieListBloc,
              child: const MovieListView(),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Test Movie');
        await tester.testTextInput.receiveAction(TextInputAction.search);

        verify(() => movieListBloc.add(const SearchMovies('Test Movie')));
      });
    });
  });
}
