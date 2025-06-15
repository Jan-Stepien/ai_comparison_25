import 'package:cursor/movies/list/data/models/movie_list.dart';
import 'package:cursor/movies/list/domain/models/movie_list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovieList', () {
    group('fromJson', () {
      test('should create MovieList from JSON', () {
        const json = {
          'page': 1,
          'total_pages': 5,
          'total_results': 100,
          'results': [
            {
              'id': 123,
              'title': 'Test Movie',
              'vote_average': 8.5,
            },
          ],
        };

        final movieList = MovieList.fromJson(json);

        expect(movieList.page, 1);
        expect(movieList.totalPages, 5);
        expect(movieList.totalResults, 100);
        expect(movieList.results.length, 1);
        expect(movieList.results.first.id, 123);
        expect(movieList.results.first.title, 'Test Movie');
        expect(movieList.results.first.voteAverage, 8.5);
      });
    });

    group('toJson', () {
      test('should convert MovieList to JSON', () {
        final movieList = MovieList(
          page: 1,
          totalPages: 5,
          totalResults: 100,
          results: [
            MovieListItem(id: 123, title: 'Test Movie', voteAverage: 8.5),
          ],
        );

        final json = movieList.toJson();

        expect(json['page'], 1);
        expect(json['total_pages'], 5);
        expect(json['total_results'], 100);
        expect(json['results'], isA<List>());
        expect(json['results'].length, 1);
        expect(json['results'][0]['id'], 123);
        expect(json['results'][0]['title'], 'Test Movie');
        expect(json['results'][0]['vote_average'], 8.5);
      });
    });
  });
}
