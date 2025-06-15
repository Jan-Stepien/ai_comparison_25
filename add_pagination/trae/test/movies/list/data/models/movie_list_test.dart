import 'package:trae/movies/list/data/models/movie_list.dart';
import 'package:trae/movies/list/domain/models/movie_list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovieList', () {
    test('should create MovieList from JSON', () {
      final json = {
        'total_results': 100,
        'results': [
          {
            'title': 'Test Movie 1',
            'vote_average': 8.5,
            'id': 123,
          },
          {
            'title': 'Test Movie 2',
            'vote_average': 7.5,
            'id': 456,
          },
        ],
      };

      final movieList = MovieList.fromJson(json);

      expect(movieList.totalResults, equals(100));
      expect(movieList.results.length, equals(2));
      expect(movieList.results[0].title, equals('Test Movie 1'));
      expect(movieList.results[0].voteAverage, equals(8.5));
      expect(movieList.results[0].id, equals(123));
      expect(movieList.results[1].title, equals('Test Movie 2'));
      expect(movieList.results[1].voteAverage, equals(7.5));
      expect(movieList.results[1].id, equals(456));
    });

    test('should convert MovieList to JSON', () {
      final movieList = MovieList(
        totalResults: 100,
        results: [
          MovieListItem(
            title: 'Test Movie 1',
            voteAverage: 8.5,
            id: 123,
          ),
          MovieListItem(
            title: 'Test Movie 2',
            voteAverage: 7.5,
            id: 456,
          ),
        ],
      );

      final json = movieList.toJson();

      expect(json['total_results'], equals(100));
      expect(json['results'].length, equals(2));
    });
  });
}
