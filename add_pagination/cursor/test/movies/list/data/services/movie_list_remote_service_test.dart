import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:cursor/movies/list/data/models/movie_list.dart';
import 'package:cursor/movies/list/data/services/movie_list_remote_service.dart';
import 'package:cursor/movies/list/domain/models/movie_list_item.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MovieListRemoteService service;
  late MockHttpClient mockHttpClient;

  const apiKey = 'test_api_key';
  const baseUrl = 'api.themoviedb.org';
  const query = 'test query';

  final testMovies = [
    MovieListItem(id: 1, title: 'Test Movie 1', voteAverage: 8.5),
    MovieListItem(id: 2, title: 'Test Movie 2', voteAverage: 9.0),
  ];

  setUp(() {
    mockHttpClient = MockHttpClient();
    service = MovieListRemoteService(
      apiKey: apiKey,
      baseUrl: baseUrl,
      client: mockHttpClient,
    );
  });

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('MovieListRemoteService', () {
    group('searchMovies', () {
      test('returns MovieList when API call is successful', () async {
        final response = http.Response(
          jsonEncode({
            'page': 1,
            'total_pages': 2,
            'total_results': 4,
            'results': testMovies.map((movie) => movie.toJson()).toList(),
          }),
          200,
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final result = await service.searchMovies(query: query);

        expect(result, isA<MovieList>());
        expect(result.page, 1);
        expect(result.totalPages, 2);
        expect(result.totalResults, 4);
        expect(result.results, equals(testMovies));
        verify(
          () => mockHttpClient.get(
            Uri.https(
              baseUrl,
              '/3/search/movie',
              {'api_key': apiKey, 'query': query, 'page': '1'},
            ),
          ),
        ).called(1);
      });

      test('returns MovieList with custom page when page parameter is provided',
          () async {
        final response = http.Response(
          jsonEncode({
            'page': 2,
            'total_pages': 3,
            'total_results': 6,
            'results': testMovies.map((movie) => movie.toJson()).toList(),
          }),
          200,
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final result = await service.searchMovies(query: query, page: 2);

        expect(result.page, 2);
        expect(result.totalPages, 3);
        expect(result.totalResults, 6);
        verify(
          () => mockHttpClient.get(
            Uri.https(
              baseUrl,
              '/3/search/movie',
              {'api_key': apiKey, 'query': query, 'page': '2'},
            ),
          ),
        ).called(1);
      });
    });
  });
}
