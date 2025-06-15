import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tabnine/movies/list/data/services/movie_list_remote_service.dart';
import 'package:tabnine/movies/list/domain/models/movie_list_item.dart';
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
      test('returns list of movies when API call is successful', () async {
        final response = http.Response(
          jsonEncode({
            'total_results': 2,
            'results': testMovies.map((movie) => movie.toJson()).toList(),
          }),
          200,
        );

        when(() => mockHttpClient.get(any())).thenAnswer((_) async => response);

        final result = await service.searchMovies(query: query);

        expect(result, equals(testMovies));
        verify(
          () => mockHttpClient.get(
            Uri.https(
              baseUrl,
              '/3/search/movie',
              {'api_key': apiKey, 'query': query},
            ),
          ),
        ).called(1);
      });
    });
  });
}
