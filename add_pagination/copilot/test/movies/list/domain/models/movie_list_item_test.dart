import 'package:copilot/movies/list/domain/models/movie_list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovieListItem', () {
    test('should create MovieListItem from JSON', () {
      final json = {'title': 'Test Movie', 'vote_average': 8.5, 'id': 123};

      final movieListItem = MovieListItem.fromJson(json);

      expect(movieListItem.title, equals('Test Movie'));
      expect(movieListItem.voteAverage, equals(8.5));
      expect(movieListItem.id, equals(123));
    });

    test('should convert MovieListItem to JSON', () {
      final movieListItem = MovieListItem(
        title: 'Test Movie',
        voteAverage: 8.5,
        id: 123,
      );

      final json = movieListItem.toJson();

      expect(json['title'], equals('Test Movie'));
      expect(json['vote_average'], equals(8.5));
      expect(json['id'], equals(123));
    });
  });
}
