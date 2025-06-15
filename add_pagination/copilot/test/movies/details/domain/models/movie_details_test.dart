import 'package:copilot/movies/details/domain/models/movie_details.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovieDetails', () {
    test('should create MovieDetails from JSON', () {
      final json = {
        'id': 123,
        'title': 'Test Movie',
        'budget': 1000000,
        'revenue': 2000000,
      };

      final movieDetails = MovieDetails.fromJson(json);

      expect(movieDetails.id, equals(123));
      expect(movieDetails.title, equals('Test Movie'));
      expect(movieDetails.budget, equals(1000000));
      expect(movieDetails.revenue, equals(2000000));
    });

    test('should create MovieDetails with null budget and revenue', () {
      final json = {
        'id': 123,
        'title': 'Test Movie',
        'budget': null,
        'revenue': null,
      };

      final movieDetails = MovieDetails.fromJson(json);

      expect(movieDetails.id, equals(123));
      expect(movieDetails.title, equals('Test Movie'));
      expect(movieDetails.budget, isNull);
      expect(movieDetails.revenue, isNull);
    });

    test('should convert MovieDetails to JSON', () {
      final movieDetails = MovieDetails(
        id: 123,
        title: 'Test Movie',
        budget: 1000000,
        revenue: 2000000,
      );

      final json = movieDetails.toJson();

      expect(json['id'], equals(123));
      expect(json['title'], equals('Test Movie'));
      expect(json['budget'], equals(1000000));
      expect(json['revenue'], equals(2000000));
    });

    test('should convert MovieDetails with null values to JSON', () {
      final movieDetails = MovieDetails(
        id: 123,
        title: 'Test Movie',
        budget: null,
        revenue: null,
      );

      final json = movieDetails.toJson();

      expect(json['id'], equals(123));
      expect(json['title'], equals('Test Movie'));
      expect(json['budget'], isNull);
      expect(json['revenue'], isNull);
    });
  });
}
