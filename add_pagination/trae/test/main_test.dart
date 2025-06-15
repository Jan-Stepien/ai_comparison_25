import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trae/core/movie_app.dart';
import 'package:trae/movies/details/domain/models/movie_details.dart';
import 'package:trae/movies/details/domain/repositories/movie_details_repository.dart';
import 'package:trae/movies/details/presentation/pages/movie_details_page.dart';
import 'package:trae/movies/list/domain/models/movie_list_item.dart';
import 'package:trae/movies/list/domain/repositories/movie_list_repository.dart';
import 'package:trae/movies/list/presentation/pages/movie_list_page.dart';
import 'package:trae/movies/list/presentation/widgets/movie_list_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/repository_mocks.dart';

void main() {
  late MockMovieListRepository mockMovieListRepository;
  setUp(() {
    mockMovieListRepository = MockMovieListRepository();
    when(() => mockMovieListRepository.stream).thenAnswer(
      (_) => Stream<List<MovieListItem>>.value(
        [],
      ),
    );
  });
  group('Main App', () {
    testWidgets('initializes on home page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<MovieListRepository>(
              create: (context) => mockMovieListRepository,
            ),
          ],
          child: const MovieApp(),
        ),
      );

      expect(find.byType(MovieListPage), findsOneWidget);
    });

    testWidgets('push movie details page on movie item pressed',
        (WidgetTester tester) async {
      late MockMovieDetailsRepository mockMovieDetailsRepository =
          MockMovieDetailsRepository();
      when(() => mockMovieDetailsRepository.stream).thenAnswer(
        (_) => Stream<MovieDetails?>.value(null),
      );

      when(() => mockMovieListRepository.stream).thenAnswer(
        (_) => Stream<List<MovieListItem>>.value(
            [MovieListItem(id: 1, title: 'Test Movie', voteAverage: 8.5)]),
      );
      when(() =>
              mockMovieListRepository.searchMovies(query: any(named: 'query')))
          .thenAnswer((_) async {});
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<MovieListRepository>(
              create: (context) => mockMovieListRepository,
            ),
            RepositoryProvider<MovieDetailsRepository>(
              create: (context) => mockMovieDetailsRepository,
            ),
          ],
          child: const MovieApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MovieListCard));
      await tester.pumpAndSettle();

      expect(find.byType(MovieDetailsPage), findsOneWidget);
    });
  });
}
